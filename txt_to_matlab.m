function gTruth = txt_to_matlab()
% 功能：把txt标注信息转换为matlab table标注格式,用于二次查看/编辑等操作，一个txt对应一个同名的图片名。
%      注意，txt和同名的图像文件必须在同一路径位置。MATLAB2017b以上版本适用！
% 输入：
%       无，交互式选择，选择包含txt标记文本的文件夹即可。该文件夹下一张图片对应一个txt，文本名字为图像名字。
%       文本里面格式要求见截图图片。
% 输出：
%      gTruth: groundTruth类型标注信息文件，可直接导入到matlab imageLabeler APP中查看
%
% Example:
%        gTruth = txt_to_matlab()
%
%
folder_name = uigetdir('','请选择导入的txt/图像标记文件路径(文件夹)！');
if ~ischar(folder_name)
    warndlg('当前并没选择任何文件！','警告')
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
        error(['请检查是否存在',txt_filename,'文件！']);
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
imageLabeler % 自动打开app，导入gTruth即可

