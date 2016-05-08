clear;
%% This file holds routines to parse images and sound sample matrices to be 
% in the appropriate format to train the somoclu SOM map.  Note you need to
% compile the map code via the github repository here : 
% https://github.com/peterwittek/somoclu

%% setup directories and such 
doAudio = 0;

%choose which subset of files to build som from
%outDir = 'output_2/'; 
outDir = 'output/';
%doing audio sample som or image som
baseDir = 'D:/LipReaderProject/LSTM_Lipreader/LSTM_Lipreader/MatlabCode/';

%# of SOM batches of data
numSOMLrnBatches = 36;
%# of samples in lrn file
sizeSOMLrnFiles = 10000;

if doAudio == 1
    outSomFileDir  = strcat(outDir,'sndSOM/');    
    SOMOutDir = strcat(baseDir,outSomFileDir);
    outSOMFilePrfx = strcat(outSomFileDir,'normedAudioSOMData');%used to build lrn files
    numSOMRows = 633995;    %for pre-allocating array, will end up somewhat smaller
    numSOMCols = 1765;      %# of sound samples per frame sample +1 for unique id col
else
    %use mouth image for SOM samples
    outSomFileDir = strcat(outDir,'imgSOM/');
    SOMOutDir = strcat(baseDir,outSomFileDir);
    outSOMFilePrfx = strcat(outSomFileDir,'imgSOMData');%used to build lrn files
    numSOMRows = 633995;        %for pre-allocating array, will end up somewhat smaller
    numSOMCols = 1601;      %# of mouth image samples per frame sample +1 for unique id col
end

outSOMTxtFile = strcat(SOMOutDir,'somDataTxt.txt');
outSOMMatFile = strcat(SOMOutDir,'somDataTxt.mat');
normedOutSOMMatFile = strcat(SOMOutDir,'normedSOMDataTxt.mat');
%train som on range of lrn files - directory where somoclu som lives
somDir = 'D:/somoclu/repo/src/Windows/somoclu/x64/Release';


format shortg;
c = clock
%% build initial mat file of sound or image samples in appropriate format to then build SOM training data
% convert to 1 sample per row, each column is a feature, with a unique key
% in first col - just 1 big matrix

%used to get list of videos' data to process (from which file names for
%each source file are built)
inFileDir = 'trainingVidsAndCaps\avi_vids\AVI\';
%for sound matrices : 
vidList = dir(inFileDir);
%destination array for aggregated audio data
%already built as output\sndSOM\somDataTxt.mat
tmpAra = zeros(numSOMRows,numSOMCols,'single');
iters = size(vidList,1);
%parpool(6);
%parfor incr = 1:iters
totRows = 1;
for incr = 1:iters
    if(vidList(incr).isdir == 1) 
        continue;
    end
    fileInfo  = fileDataWithOutputStruct(vidList(incr).name, outDir);
    %fileData, isAudio, resAra, stRow, colSize
    [numCols, numRows,tmpAra] = procOneSmplMatToSOMtxt(fileInfo,doAudio,tmpAra,totRows,numSOMCols-1);
    totRows = totRows + numRows;
end;
%get rid of entire rows that have only 0 values and save mat file
tfCond2 = all(tmpAra(:,2:end)==0,2);
tmpAra(tfCond2,:) = [];
save(outSOMMatFile,'tmpAra');



%% HAVE TO NORMALIZE AUDIO TO BE 0 -> 1, and then denormalize results to be
%-1 -> 1 (matlab audio samples saved as 'single' are -1 to 1
if doAudio == 1
    load(outSOMMatFile,'tmpAra');
    tmpAra(:,2:end) = tmpAra(:,2:end) + 1;
    tmpAra(:,2:end) = tmpAra(:,2:end) * .5;
    save(normedOutSOMMatFile,'tmpAra');
    %denormalized - to play audio samples
    %tmpAra(:,2:end) = tmpAra(:,2:end) * 2.0;
    %tmpAra(:,2:end) = tmpAra(:,2:end) - 1.0;
else
    %norming for video not necessary
end

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
buildSOM_LRNfile(10000,numSOMLrnBatches,1,outSOMFilePrfx);

%% Train somoclu map on .lrn files
%'-k #' means either cpu (0) or gpu (1)
%note - for some reason the cpu mpi method is faster than gpu.
format shortg;
c = clock
mapSize = 100;
somFormatStr = ['-x ' num2str(mapSize) ' -y ' num2str(mapSize) ' -m toroid -g hexagonal'];
numEpochs = 10;
stLrnRate = .1;
endLrnRate = .001;
runSomocluOnFiles(SOMOutDir, somDir,outSOMFilePrfx, mapSize, sizeSOMLrnFiles,1,numSOMLrnBatches,numEpochs, stLrnRate, endLrnRate, '-k 0',somFormatStr);

format shortg;
c = clock

