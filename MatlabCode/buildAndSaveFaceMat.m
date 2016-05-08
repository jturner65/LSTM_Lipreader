%function will load images, and build a matrix of the images, where column
%corresponds to frame #
function buildAndSaveFaceMat(fileInfo,useZeros)
%     try
%         alnImgDirList = dir(fileInfo.altAlignImgDir);
%     catch ME
%         alnImgDirList = dir(fileInfo.alignImgDir);
%     end
    alnImgDirList = dir(fileInfo.altAlignImgDir);
    useImgDir = fileInfo.altAlignImgFileNameBase;
   	if size(alnImgDirList,1) == 0
        alnImgDirList = dir(fileInfo.alignImgDir);
        useImgDir = fileInfo.algnImgFileNameBase;
    end

    disp(size(alnImgDirList));
    iters = size(alnImgDirList,1);
    imgBigMat = zeros(9216,iters);
    imgSmallMat = zeros(1600,iters);
    imgIDXList = zeros(iters-2,1);
    i = 1;
    %need to build appropriate list of img idxs
    for incr = 1:iters
        if(alnImgDirList(incr).isdir == 1) %if a dir skip
            continue;
        end
        imageName = alnImgDirList(incr).name;
        tmpImgName = textscan(imageName, '%s', 'delimiter', '.'); 
        tmpName = char(tmpImgName{1}(1));
        tokens = textscan(tmpName, '%s', 'delimiter', '_');    
        lastTkIDX = size(tokens{1},1);
        idx = str2num(char(tokens{1}(lastTkIDX)));
        
        imgIDXList(i) = idx;
        i = i+1;
    end
    %sort imgIDXList
    sortedImgIDXList = sort(imgIDXList);
    iters = size(sortedImgIDXList,1);
    stX = 29;stY = 55; endX = 68; endY = 94;wd = 40; ht = 40;
    image1 = zeros(96,96,3);
    for incr = 1:iters
        strIDX = num2str(sortedImgIDXList(incr));
        if(1==useZeros)
            if sortedImgIDXList(incr) < 10
                strIDX = strcat('0',strIDX);
            end
            if sortedImgIDXList(incr) < 100
                strIDX = strcat('0',strIDX);
            end
            if sortedImgIDXList(incr) < 1000
                strIDX = strcat('0',strIDX);
            end        
        end
        
        imageName = strcat(useImgDir,strIDX,'.png');
        try
            oldImage = image1;
            image1 = rgb2gray(im2single(imread(imageName)));  
            %image1 = imread(imageName);  
        catch ME
            %sysCmd = strcat('del ',{' '},imageName);
            disp(strcat('error with image name : ',imageName));
%             try
%                 retCode = system(sysCmd);
%                 disp(strcat('file deleted with retcode:',retCode));
%             
%             catch ME2
%                 disp(strcat('unable to del via :',sysCmd));
%             end
            image1 = oldImage;
            continue;
        end

%         %put in big matrix
         imgBigMat(:,sortedImgIDXList(incr))= image1(:);
%         %imageSmall = imresize(imcrop(image1,[25 48 48 48]),[40 40]);
%         %imageSmall = imcrop(image1,[29 55 39 39]);
         imageSmall = image1(stY:endY,stX:endX);
%         %imshow(imageSmall);
         imgSmallMat(:,sortedImgIDXList(incr)) = imageSmall(:);        
    end
    save(fileInfo.algnImgSavMatBig,'imgBigMat');
    save(fileInfo.algnImgSavMatSmall,'imgSmallMat');    
end