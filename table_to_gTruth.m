function gTruth = table_to_gTruth(mytable)
% 功能：把imageLabeler标记工具导出的table格式转换为groundTruth对象(17b及以后版本适用)
% 17b版本只能这种格式才能显示，配合txt_to_matlab函数，显示到matlab中，方便二次编辑调整。
% 输入：mytable，标注好的文件，rectangle画框标注的table
% 输出：gTruth,转换后的gTruth类型，意义同等mytalbe
%
% step1
source = mytable.imageFilename;
gtSource = groundTruthDataSource(source);
% step2
names = (mytable.Properties.VariableNames(2:end))';
types = repmat(labelType('Rectangle'),length(names),1);
labelDefs = table(names,types,'VariableNames',{'Name','Type'});
% step3
labelData = mytable(:,2:end);

% last convert to "groundTruth" objects
gTruth = groundTruth(gtSource,labelDefs,labelData);
