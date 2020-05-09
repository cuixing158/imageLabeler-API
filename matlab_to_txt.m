function matlab_to_txt(mylabel)
% 功能：把matlab trainingImageLabel
% APP中标记好的table文件转换为txt。每个图像对应一个txt。请自行选择导出文件夹。
%输入：mylabel，table类型标注文件
%输出：无
%
%Example ; 
%            matlab_to_txt(mylabel)
%
if nargin<1 || ~istable(mylabel)
    error('请导入trainingImageLabel APP文件的table数据！');
end
folder_name = uigetdir('','请选择导出txt的文件夹(包含原同名图像jpg)！');
if ~folder_name
   warndlg('当前并没选择任何文件！','警告')
   return;
end

imds = imageDatastore(folder_name,'FileExtensions',{'.jpg','.png'});
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
    fprintf(fid,'%2d\r\n',numROIs); %写入ROI个数
    fclose(fid);
    waitbar(i / steps);
end
close(h);