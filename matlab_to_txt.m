function matlab_to_txt(groundTruthData)
% ���ܣ���matlab imageLabeler APP�е�groundTruth����������txt�ı��У�
% ÿ��ͼ���Ӧһ��txt��������ѡ�񵼳��ļ��С�
%���룺
%      groundTruthData��groundTruth���ͻ�table���ͱ�ע�ļ�
%�������
%
%Example ; 
%            matlab_to_txt(groundTruthData)
%

if  ~istable(groundTruthData)&&~strcmpi(class(groundTruthData),'groundTruth')
    error('����matlab imageLabeler APP�е�����ע�������ݣ�');
end
if strcmpi(class(groundTruthData),'groundTruth')
    imageFilename = groundTruthData.DataSource.Source;
    classTable = groundTruthData.LabelData;
    mylabel = [cell2table(imageFilename),classTable];
else
    mylabel = groundTruthData;
end

folder_name = fileparts( mylabel.imageFilename{1});
imds = imageDatastore(folder_name,'FileExtensions',{'.jpg'});
imageNums = length(imds.Files);

numSamples = size(mylabel,1);
variableNames = mylabel.Properties.VariableNames;
numVariables = length(variableNames);

%% delete  unlabeled images and TXT
if imageNums>numSamples
    A = imds.Files;
    B = mylabel.imageFilename;
    Lia = ismember(A,B);
    removeFile = imds.Files(~Lia);
    for i = 1:size(removeFile,1)
        name = char(removeFile(i));
        name = name(1:end-4);
        delete([name,'.jpg']);
        delete([name,'.txt']);
    end
end

%% write
h = waitbar(0,'Please wait...');
steps = numSamples;
for i =1:numSamples
    rowTable = mylabel(i,:);
    [~,imagename,~] = fileparts(char(rowTable{1,1}));
    txtName = imagename;
    filename = fullfile(folder_name,[txtName,'.txt']);
    
    %%
    numROIs = 0;
    fid = fopen(filename,'w');
    fprintf(fid,'%2d\r\n',0);
    for j = 2:numVariables
        rects = [rowTable{1,j}];
        if iscell(rects)
            rects = cell2mat(rects);
        end
        for k = 1:size(rects,1)
            numROIs = numROIs+1;
            fprintf(fid,'%s %d %d %d %d  %d %d %d %d\r\n',variableNames{j},...
            round(rects(k,1:2)-1),round(rects(k,3:4)),zeros(1,4));
        end
    end
    fseek(fid, 0, 'bof');
    fprintf(fid,'%2d\r\n',numROIs); %д��ROI����
    fclose(fid);
    waitbar(i / steps);
end
close(h)
warndlg('�Ѹ��ǵ�ԭ�б�עtxt�ļ�');