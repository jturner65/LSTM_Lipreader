% %%%
% %this file will test the audio and video alignment
AudSOMDir = 'D:/LipReaderProject/listeningeye/MatlabCode/FaceDetectCrop/output/sndSOM/';
VidCropDir = 'D:/LipReaderProject/listeningeye/MatlabCode/FaceDetectCrop/output/alignedImgs/';
img96MatDir = 'D:/LipReaderProject/listeningeye/MatlabCode/FaceDetectCrop/output/img96Mat/';
img48MatDir = 'D:/LipReaderProject/listeningeye/MatlabCode/FaceDetectCrop/output/img48Mat/';
% %load in mask for which audio files were kept and which were tossed due to
% %being silent
% tmpLogVar = load(strcat(AudSOMDir,'framesWithSoundMask.mat'),'tfCond2');
% tfCond2 = tmpLogVar.tfCond2;
% clear tmpLogVar;
% 
% %load in normalized (0-1) sound sample files - 1st column is file-sample id
% %(unique), next columns are all audio data.  this is the data  used in the
% %SOM.
% normedAudTmp = load(strcat(AudSOMDir,'normedSOMDataTxt.mat'));
% normedAudioAra = normedAudTmp.tmpAra;
% clear normedAudTmp;
% 
% %build 2-col vector of file ids - video file + sample IDX - for each image
% %that corresponds to a particular audio sample
% vidIDCol = normedAudioAra(:,1);
% vidIDFileIdx = zeros(length(vidIDCol(:,1)),2);
% vidIDFileIdx(:,1) = round(vidIDCol(:,1));                                   %this is the file id (1-132)
% vidIDFileIdx(:,2) = round((vidIDCol(:,1) - vidIDFileIdx(:,1)) * 10000);     %sample idx 
% save(strcat(VidCropDir,'vidFileIDSmplIDX.mat'),'vidIDFileIdx');
% 
% clear vidIDCol;
videoPlayer  = vision.VideoPlayer('Position',...
    [100 100 [196, 196]+50]);
% 
%build matrix of video images
for (i = 2:10)           %for each original video file
    prefix = '';
    if(i<100)
        prefix = strcat(prefix,'0');
    end   
    if(i<10)
        prefix = strcat(prefix,'0');
    end    
    croppedVidFilePrfx = strcat(prefix,num2str(i),'_xvid');
    %this is array of sample idx's to use to build file name
    audAraSampleIDXList = find(vidIDFileIdx(:,1)==i);    
    %we have to build the image file names this way because if we just read
    %a list the list will be out of order 779 -> 78 -> 780) because i
    %didn't name the files with leading 0s
    %subtract 30 from end to make sure there's always an existing audio frame
    %corresponding to an existing video frame (i found discrepencies in
    %both at the end)
    sampleIDXList = vidIDFileIdx(audAraSampleIDXList(1:(end-30)),2);
    iters = size(sampleIDXList,1);
    %imgs are 96x96x3, 1 per row
    cropImgMat = zeros(iters, 9216, 'single');
    for incr = 1:(iters)
        croppedVidFileName = strcat(VidCropDir,croppedVidFilePrfx,'/out_',croppedVidFilePrfx,'_',num2str(sampleIDXList(incr)),'.png');       
        %disp(strcat('Img File : ',croppedVidFileName));      
        tmpImg = imresize(im2single(rgb2gray(imread(croppedVidFileName))),[48 48]);
        step(videoPlayer,tmpImg);
        %cropImgMat(incr,:) = tmpImg(:)';
    end  
    
    %by here we have cropped b&w image matrix, with every row == an image
    %sample (like audio matrix) for i'th video
    %dirName = strcat(img96MatDir,croppedVidFileDir);
%     dirName = strcat(img48MatDir,croppedVidFilePrfx);
%     mkdir(dirName);
%     save(strcat(dirName,'/out_',croppedVidFilePrfx,'.mat'),'cropImgMat');
%     
    
    
    
    
end
release(videoPlayer);

