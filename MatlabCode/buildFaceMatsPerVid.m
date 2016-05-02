lear%%this program will build matlab arrays holding an entire video's worth of
%%isolated face images, 1 per column

baseDir =  'D:/LipReaderProject/listeningeye/MatlabCode/FaceDetectCrop/';
outputDir = {'output','output_2'};
%note : output directory vids have single layer of file name, but 
%output_2 directory vids have 2x layer of file name directories
dirIDX = 2;
%for dirIDX = 1:2 
    alnImgDirStr = char(strcat(baseDir,outputDir(dirIDX),'/alignedImgs'));
    %alnImgDirList is list of all directories in alignedImgs dir
    alnImgDirList = dir(alnImgDirStr);   
    iters = size(alnImgDirList,1);
    parpool(12);
    parfor incr = 1:iters    
%    for incr = 1:iters%skip first two - . and ..
        if(alnImgDirList(incr).isdir ~= 1) %if not a dir skip
            continue;
        end

        fileInfo = fileDataWithOutputStruct(strcat(alnImgDirList(incr).name,'.abc'), outputDir(dirIDX));
        smMatName = strcat(baseDir,fileInfo.algnImgSavMatSmall);
        if exist(smMatName, 'file') == 2
            disp(strcat('Skip matrix for ',{' '},smMatName));
            continue;
        end
        %disp(strcat('aligned img dir : ', fileInfo.alignImgDir, ' with outputdir : ',outputDir(dirIDX)));
        %put all images into single matrix
        %check if done first
        if(size(fileInfo.baseFileName,2) < 4) 
            disp(strcat('Small name ',{' '},fileInfo.baseFileName));  
            continue;
        end
        disp(strcat('Build matrix for ',{' '},fileInfo.baseFileName));  
        buildAndSaveFaceMat(fileInfo, dirIDX-1);
    end
    delete(gcp('nocreate'));
%end