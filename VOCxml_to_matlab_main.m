function  outputTable = VOCxml_to_matlab_main()
% 功能：批量导入VOC-xml格式文件到matlab中
% 输入：无: 交互式选择xml路径。
% 输出：outputTable: 可以导入到MATLAB app预览/修改的table类型数据。
%
% Example: 
%        outputTable = VOCxml_to_matlab_main('F:\imagesData\stopSignImages\*.xml')
%
% if nargin<1
%     error('输入参数太少！')
% end
global folder_name;
folder_name = uigetdir('','请选择导入的VOC-xml标记文件路径(文件夹)！');
if ~folder_name
    warndlg('当前并没选择任何文件！','警告')
    return;
end
xmls_path = fullfile(folder_name,'*.xml');
s = dir(xmls_path);
numSamples = length(s);

waitbar(0,'Please wait...');
steps = numSamples;
for i =1:numSamples
    xml_path = fullfile(folder_name,s(i).name);
    rowTable = xml_to_matlab(xml_path);
    structTem = table2struct(rowTable);
    if i == 1
        ss(1) = structTem;
        prevNames = fieldnames(structTem);
        continue;
    else
        currentNames = fieldnames(structTem);
        index = ismember(currentNames,prevNames);
        
        for j = 1:length(index)
            ss(i).(currentNames{j}) = structTem.(currentNames{j});
        end
        prevNames = fieldnames(ss);
    end
    waitbar(i / steps);
end
outputTable = struct2table(ss);

function output = xml_to_matlab(xmlName)
% 功能：读取VOC-xml标准格式文件，转化为MATLAB table类型数据，导入到APP中，
% 用于预览标记或进行二次标记修改,此函数只能对单张图片进行处理,批量处理见xml_to_matlab_main.m函数
%
% 输入：xmlName，输入xml的标注文件
% 输出：Output,输出为table类型数据,可直接加载到App标注工具中查看
%
% example:
%       output = xml_to_matlab('image001.xml')
% 
global folder_name;
if nargin<1
    error('输入参数过少！');
end

structLabel = xml_read(xmlName);
if isfield(structLabel,'path')
    imageFilenames = structLabel.path;
elseif isfield(structLabel,'filename')
    imageFilenames = fullfile(folder_name,structLabel.filename);
else
    error('请检查图像xml的路径名是否正确！')
end
outputStu.imageFilename = imageFilenames;%获取绝对路径

if ~isfield(structLabel,'object')
    output = struct2table(outputStu);
    return;
end
labelNum = length(structLabel.object);
names = cell(labelNum,1);
rects = cell(labelNum,1);

for i = 1:labelNum
    stuCON = structLabel.object(i);   
    names{i} = stuCON.name;
    rects{i} = [stuCON.bndbox.xmin,stuCON.bndbox.ymin,...
        stuCON.bndbox.xmax-stuCON.bndbox.xmin,...
        stuCON.bndbox.ymax-stuCON.bndbox.ymin];   
end

%
variableNames = unique(names);%cell
variableNum = length(variableNames);

varRect = cell(1,variableNum);
for i = 1:length(names)
    index = strcmp(names{i},variableNames);
    varRect{index} = [varRect{index};rects{i}]; 
end
for i = 1:variableNum
    field = variableNames{i};
    outputStu.(field) = varRect(i);
end
output = struct2table(outputStu);
