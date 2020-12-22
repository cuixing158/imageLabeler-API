function gTruth = pixel_to_matlab(pixelLabelDir,labelnames)
% 功能：多类别像素级语义分割标记导入,根据原图（jpg格式）和标记图（同名同大小的png格式，
% uint8类型,从1开始的类别标记矩阵），生成groundTruth类型对象，最后可导入到imageLabeler APP中,
% 原图和标记图要位于同一目录下
%
% 输入：
%       pixelLabelDir: 原图和标记图根目录，一副jpg原图对应一副png标记图
%       labelnames: 标记类型标签，cell array或者string数组类型
% 输出：
%      gTruth: groundTruth类型标注信息文件，可直接导入到matlab imageLabeler APP中查看
%
% Example:
%        gTruth = pixel_to_matlab()
%
arguments
    pixelLabelDir (1,:) char = ''
    labelnames (1,:) string = "undefined"
end

if isempty(pixelLabelDir)
    pixelLabelDir = uigetdir('','请选择导入的pixel标记/图像标记文件路径(文件夹)！');
    if ~ischar(pixelLabelDir)
        warndlg('当前并没选择任何文件！','警告')
        return;
    end
end

imagesDir = pixelLabelDir;
imagesLDir = pixelLabelDir;

imds = imageDatastore(imagesDir,'FileExtensions','.jpg');
dataSource = groundTruthDataSource(imds);

lbds = imageDatastore(imagesLDir,'FileExtensions','.png');
labelData = table(lbds.Files,'VariableNames',{'PixelLabelData'});

assert(~isempty(imds.Files),'origin images must not empty!');
assert(length(imds.Files)==length(lbds.Files),'origin images must equal to label images!');
a1 = extractBefore(string(imds.Files),'.');
a2 = extractBefore(string(lbds.Files),'.');
assert(all(a1==a2),'origin images and label images must be the same name!');

ldc = labelDefinitionCreator;
for i = 1:length(labelnames)
    addLabel(ldc,labelnames(i),labelType.PixelLabel);
end
labelDefs = create(ldc);

gTruth = groundTruth(dataSource,labelDefs,labelData);
imageLabeler % 自动打开app，导入gTruth即可

