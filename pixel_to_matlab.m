function gTruth = pixel_to_matlab(pixelLabelDir,labelnames)
% 功能：多类别像素级语义分割标记导入,根据原图（jpg格式）和标记图（同名同大小的png格式，
% uint8类型,从1开始的类别标记矩阵,0为背景类），生成groundTruth类型对象，最后可导入到imageLabeler APP中,
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
arguments % arguments, Introduced in R2019b
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
dataSource = groundTruthDataSource(imds.Files);
lbds = imageDatastore(imagesLDir,'FileExtensions','.png');
labelData = table(lbds.Files,'VariableNames',{'PixelLabelData'});

if labelnames=="undefined" % 如果知道labelnames，直接输入参数省略下面判断，速度更快
    transformedObj = transform(lbds,@(x) unique(x));% transform, Introduced in R2019a
    labelVectors = [];
    while transformedObj.hasdata()
        labelVector = transformedObj.read();
        newIdx =  ~ismember(labelVector,labelVectors);
        labelVectors = [labelVectors;labelVector(newIdx)];
    end
    labelnames = strings(length(labelVectors)-1,1);% 去除背景类别
    for i = 1:length(labelnames)
        labelnames(i) = "undefined_"+string(i);
    end
end

assert(~isempty(imds.Files),'origin images(.jpg) must not empty!');
assert(length(imds.Files)==length(lbds.Files),'origin images(.jpg) must equal to label images(.png)!');
a1 = extractBefore(string(imds.Files),'.');
a2 = extractBefore(string(lbds.Files),'.');
assert(all(a1==a2),'origin images(.jpg) and label images(.png) must be the same name!');
isUint8 = all(cellfun(@(x)validImage(x),lbds.Files));
assert(isUint8,'label images(.png) must one channel,uint8 type!');

ldc = labelDefinitionCreator;
for i = 1:length(labelnames)
    addLabel(ldc,labelnames(i),labelType.PixelLabel);
end
labelDefs = create(ldc);

gTruth = groundTruth(dataSource,labelDefs,labelData);
imageLabeler % 自动打开app，Import Labels from workspace,手动导入gTruth即可

function isvalid = validImage(filename)
%功能：验证filename为uint8 单通道图像
 info = imfinfo(filename);
isvalid = info.BitDepth==8;
isvalid = isvalid & strcmp(info.ColorType,'grayscale');
end
end