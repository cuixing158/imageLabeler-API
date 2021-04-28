function gTruth = txt_to_matlab()
% ���ܣ���txt��ע��Ϣת��Ϊmatlab table��ע��ʽ,���ڶ��β鿴/�༭�Ȳ�����һ��txt��Ӧһ��ͬ����ͼƬ����
%      ע�⣬txt��ͬ����ͼ���ļ�������ͬһ·��λ�á�MATLAB2017b���ϰ汾���ã�
% ���룺
%       �ޣ�����ʽѡ��ѡ�����txt����ı����ļ��м��ɡ����ļ�����һ��ͼƬ��Ӧһ��txt���ı�����Ϊͼ�����֡�
%       �ı������ʽҪ�����ͼͼƬ��
% �����
%      gTruth: groundTruth���ͱ�ע��Ϣ�ļ�����ֱ�ӵ��뵽matlab imageLabeler APP�в鿴
%
% Example:
%        gTruth = txt_to_matlab()
%
%
folder_name = uigetdir('','��ѡ�����txt/ͼ�����ļ�·��(�ļ���)��');
if ~ischar(folder_name)
    warndlg('��ǰ��ûѡ���κ��ļ���','����')
    return;
end

imds = imageDatastore(folder_name,'IncludeSubFolders',true,...
    'FileExtensions',{'.jpg','.jpeg','.png','.JPG','.JPEG','.PNG'});
numImages = length(imds.Files);
h = waitbar(0,'Please wait...');
steps = numImages;
for i = 1:numImages
    s(i).imageFilename = imds.Files{i};
    [path ,name,~] = fileparts(imds.Files{i});
    txt_filename = fullfile(path,[name,'.txt']);
    fid = fopen(txt_filename,'r');
    if fid==-1
        error(['�����Ƿ����',txt_filename,'�ļ���']);
    end
    try
        tline = fgetl(fid);
        variableNames = cell(0,0);
        while ischar(tline)
            tline = fgetl(fid);
            if ~ischar(tline) || isempty(tline)
                break;
            end
            variableNames = unique(variableNames);
            
            A = strip(split(tline,' '));
            emptyCells = cellfun('isempty', A);
            A(emptyCells) = [];
            tag = A(1); % cell
            numerical = str2double(A(2:end));
            currentRect = [numerical(1)+1,numerical(2)+1,numerical(3),numerical(4)];
            index = ismember(tag,variableNames);
            if index
                s(i).(char(A(1))) = [s(i).(char(A(1)));currentRect];
            else
                s(i).(char(A(1))) = currentRect;
            end
            
            variableNames = [variableNames,tag];
        end
    catch
        error('Error. \nThis file: %s read error!', txt_filename);
    end
    fclose(fid);
    waitbar(i / steps,h);
end
if length(s) == 1
    fields = fieldnames(s);
    outputTable = table();
    for k = 1:length(fields)
        outputTable.(fields{k}) =num2cell( s.(fields{k}),[1,2] );
    end
else
    outputTable = struct2table(s);
end
gTruth = table_to_gTruth(outputTable);
close(h)
imageLabeler % �Զ���app������gTruth����

