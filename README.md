# VOC-xml-txt
本程序旨在标注图像文件格式互转，MATLAB转xml或者xml转MATLAB格式,或者txt转MATLAB或者MATLAB转txt，xml符合VOC标准。<br>
共提供4个接口（函数），具体转换关系图如下：<br>
VOCxml<------->Matlab table<br>
txt<------->Matlab table<br>
其中Matlab table格式可以在MATLAB2017（及以后新版本）中imageLabeler/trainingImageLabeler  APP中修改/查看等等操作，方便自由~<br><br>

注意：xml_io_tools_2010_11_05.zip为安装文件，解压加入到工作路径即可使用（文件已包含）。
下载链接：http://cn.mathworks.com/matlabcentral/fileexchange/12907-xml-io-tools

## 4个接口（额外1个配最新版本转gTruth）
VOCxml_to_matlab_main.m为批量VOC-xml转MATLAB table格式文件；<br>
matlab_to_VOCxml.m为MATLAB table转VOC-xml格式文件；<br>
txt_to_matlab.m为txt文本转MATLAB table格式文件；<br>
table_to_gTruth.m为table格式转换groundTruth格式；<br>
matlab_to_txt.m为MATLAB table转txt文本格式。<br>

## txt文本标记格式
比如文本内容打开如下，分别表示类别,x,y,width,height,四个缺省值0,txt和xml中像素是以0开始的索引：<br>
3 <br>
car     401 381 305 201    0   0   0   0<br>
car     149 377 234 143    0   0   0   0<br>
stop     858 318  39  43    0   0   0   0<br>

## Tips
MATLAB table格式文件由trainingImageLabeler/imageLabeler  APP导出/制作查看的格式,适合2017a及以后版本。
最好把一个图像的3个标注文件在同一路径下表示出来，分别为原图像，txt，xml；其中原图像和txt必须在同一路径下

