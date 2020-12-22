function matlab_to_pixel(groundTruthData)
% 功能：把matlab imageLabeler APP中的groundTruth变量导出到语义标记png中，
% 每个图像对应一个png标注图像。
%输入：
%      groundTruthData，groundTruth类型或table类型标注文件
%输出：无
%
%Example ; 
%            matlab_to_pixel(groundTruthData)
%

if  ~isa(groundTruthData,'groundTruth')
    error('请在matlab imageLabeler APP中导出标注变量数据！');
end

labelDatas = groundTruthData.LabelData.PixelLabelData;
oriDatas = groundTruthData.DataSource.Source;
if ~iscell(oriDatas)
    oriDatas = oriDatas.Files;
end

parfor i = 1:length(labelDatas)
    src = labelDatas{i};
    dstname = oriDatas{i};
    dst = [dstname(1:end-4),'.png'];
    movefile(src,dst);
end
[folder,~,~] = fileparts(labelDatas{1});
if exist(folder,'dir')
    rmdir(folder);
end
