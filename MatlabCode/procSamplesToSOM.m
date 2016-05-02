clear;
%% Process sound files so that they are capable of training SOM - need
% to take transpose, so that each sample is a row.  then, need to configure text
% file to have appropriate dense configuration, with the first column being a unique ID 
% (filename_sampleNumber) and the rest being the sample data.
%-- from somoclu github : 
%%file format
%	% n
%	% m   <don't count unique col here
%	% s1 s2 .. sm
%	% var_name1 var_name2 .. var_namem
%	x11 x12 .. x1m
%	x21 x22 .. x2m
%	. . . .
%	. . . .
%	xn1 xn2 .. xnm
% NOTE : do not count first column in column count
%Here n is the number of rows in the file, that is, the number of data instances. Parameter m
%defines the number of columns in the file. The next row defines the column mask: the value 
%1 for a column means the column should be used in the training. Note that the first column 
%in this format is always a unique key, so this should have the value 9 in the column mask. 
%The row with the variable names is ignore by Somoclu. The elements of the matrix follow -- 
%from here, the file is identical to the basic dense format, with the addition of the first 
%column as the unique key.

%HAVE TO NORMALIZE AUDIO TO BE 0 -> 1, and then denormalize results to be
%-1 -> 1
% load('output/sndSOM/somDataTxt.mat','tmpAra');
% tmpAra(:,2:end) = tmpAra(:,2:end) + 1;
% tmpAra(:,2:end) = tmpAra(:,2:end) * .5;
% save('output/sndSOM/normedSOMDataTxt.mat','tmpAra');

%denormalized
%tmpAra(:,2:end) = tmpAra(:,2:end) * 2.0;
%tmpAra(:,2:end) = tmpAra(:,2:end) - 1.0;

format shortg;
c = clock
outSOMTxtFile = 'output/sndSOM/somDataTxt.txt';
outSOMMatFile = 'output/sndSOM/somDataTxt.mat';
normedOutSOMMatFile = 'output/sndSOM/normedSOMDataTxt.mat';
%build lrn's from mat file

%buildSOM_LRNfile(10000,36,1);

%train som on range of lrn files
somDir = 'D:/somoclu/repo/src/Windows/somoclu/x64/Release';
fileDir = 'D:/LipReaderProject/listeningeye/MatlabCode/FaceDetectCrop/output/sndSOM';
%'-k #' means either cpu (0) or gpu (1)
%note - for some reason the cpu mpi method is faster than gpu.
runSomocluOnFiles(fileDir, somDir, 10000,6,36,'-k 0');

format shortg;
c = clock

%build initial file
% fileID = fopen(outSOMTxtFile,'w');
% fprintf(fileID,'# sound samples to be used to train SOM for building output class vector\n');
% fprintf(fileID,'# this is a dense array to use SOMs denseGPU capabilities\n');
% fprintf(fileID,'%% 633995\n');        %# of rows in txt file, with 0 rows gone
% fprintf(fileID,'%% 1765\n');          %# of columns, including unique id
% fprintf(fileID,'%% 9\t');             %set first column to be unique key
% for i = 1:1763                       %set columns to be on 
%     fprintf(fileID,'1\t');
% end
% fprintf(fileID,'1\n%% Seq\t ');
% %var name in format is ignored by som
% for i = 1:1763                       %set columns to be on 
%     fprintf(fileID,strcat('c',int2str(i),'\t'));
% end
% fprintf(fileID,strcat('c1765\n'));
% %get rid of last tab
% fclose(fileID);

% inSndFileDir = 'trainingVidsAndCaps\avi_vids\AVI\';
% vidList = dir(inSndFileDir);
% %destination array for aggregated audio data
% %already built as output\sndSOM\somDataTxt.mat
% tmpAra = zeros(668661,1765,'single');
% totRows = 1;
% iters = size(vidList,1);
% %parpool(6);
% %parfor incr = 1:iters
% for incr = 1:iters
%     if(vidList(incr).isdir == 1) 
%         continue;
%     end
%     baseFileName = vidList(incr).name;
%     [numCols, numRows,tmpAra] = procOneSmplMatToSOMtxt(baseFileName,inSndFileDir,tmpAra,totRows);
%     %totRows = totRows + numRows;
% end;
% %get rid of entire rows that have only 0 values
% tfCond2 = all(tmpAra(:,2:end)==0,2);
% tmpAra(tfCond2,:) = [];
% save(outSOMMatFile,'tmpAra');
% [totRows,totCols] = size(tmpAra);
% %dlmwrite is -SLOW-
% dlmwrite(outSOMTxtFile,tmpAra,'-append','delimiter','\t','precision','%.6f');
% save('output\sndSOM\framesWithSoundMask.txt','tfCond2');
% disp(strcat('Total rows to process in all sound mats : ', num2str(totRows)));
