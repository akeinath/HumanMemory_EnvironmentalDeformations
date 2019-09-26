% data = addDemos(data,'Exp1');
% data = addLBA(data);
% mkObjPlaceFields(data,'Exp1');

close all
clc

%%%%% Experiment 1 ---- Full visual information
if exist('All_Stats_Exp1.txt','file')
    delete('All_Stats_Exp1.txt');
end
folder = ['Data/Exp1'];
data = getData(folder);
plotPaths(data,'Exp1');
data = plotVisShift(data,'Exp1');
data = plotLearning(data,'Exp1');
avgReplaceTest(data,'Exp1');
 
% %%%% Experiment 2 Fog with Border
if exist('All_Stats_Exp2.txt','file')
    delete('All_Stats_Exp2.txt');
end
folder = ['Data/Exp2'];
data = getData(folder);
plotPaths(data,'Exp2');
data = plotVisShift(data,'Exp2');
data = plotLearning(data,'Exp2');
avgReplaceTest(data,'Exp2');


%%%% Experiment 3 Vive Room!
if exist('All_Stats_Exp3.txt','file')
    delete('All_Stats_Exp3.txt');
end
folder = ['Data/Exp3'];
data = getDataVive2(folder);
plotPaths(data,'Exp3');
data = plotVisShift(data,'Exp3');
data = plotLearning(data,'Exp3');
avgReplaceTest(data,'Exp3');

