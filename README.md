# Image Labeler app

> [!NOTE]
> update:如果用户是使用COCO JSON、OpenLabel JSON类型的标注格式文件标注、交互，请分别使用`groundTruthFromOpenLabel`(R2024b)/`groundTruthToOpenLabel`(R2024a)、`groundTruthFromCOCO`(R2025a)等新型内置函数

本程序旨在标注图像文件简单交互式格式互转，支持拖曳矩形框，像素语义级别两种类型标注。<br>
共提供6个接口（函数），具体转换关系图如下：<br>
VOCxml<------->Matlab groundTruth，rectangle<br>
txt<------->Matlab groundTruth，rectangle<br>
png(pixel)<------->Matlab groundTruth，pixel<br>
其中Matlab table格式可以在MATLAB2017b（及以后新版本）中imageLabeler/trainingImageLabeler  APP中修改/查看等等操作，方便自由~<br><br>

注意：xml_io_tools_2010_11_05.zip为安装文件，解压加入到工作路径即可使用（文件已包含）。
下载链接：http://cn.mathworks.com/matlabcentral/fileexchange/12907-xml-io-tools

## 6个接口（额外1个配最新版本转gTruth）

VOCxml_to_matlab_main.m为批量VOC-xml转MATLAB table格式文件；<br>
matlab_to_VOCxml.m为MATLAB table转VOC-xml格式文件；<br>
txt_to_matlab.m为txt文本转MATLAB table格式文件；<br>
table_to_gTruth.m为table格式转换groundTruth格式；<br>
matlab_to_txt.m为MATLAB table转txt文本格式。<br>
pixel_to_matlab.m为png像素标注转MATLAB groundTruth格式文件；<br>
matlab_to_pixel.m为MATLAB groundTruth转png像素级别标注格式。<br>

## txt文本标记格式

比如文本内容打开如下，分别表示类别,x,y,width,height,四个缺省值0,txt和xml中像素是以0开始的索引：<br>
3 <br>
car     401 381 305 201    0   0   0   0<br>
car     149 377 234 143    0   0   0   0<br>
stop     858 318  39  43    0   0   0   0<br>

> [!TIP]
> MATLAB groundTruth格式文件由imageLabeler  APP导出/制作查看的格式,适合2017b及以后版本。<br>
> 原图像与标注文件要位于同一目录并且一一对应，文件名相同，后缀不同，参考“stopSignImages”标注样式。

