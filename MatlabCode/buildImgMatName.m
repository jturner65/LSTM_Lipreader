%function will build image matrix name given a file index and a file info
%obj
function res = buildImgMatName(idx, fileInfo, isAudio)
    strIdx = num2str(idx);
    if(idx < 10)
        strIdx = strcat('0',strIdx);
    end
    if(idx < 100)
        strIdx = strcat('0',strIdx);
    end   
    if(isAudio == 1)
        res = strcat(fileInfo.imgMatDir,fileInfo.imgMatNamePrefix,strIdx,'_xvid.mat');
    else 
        res = strcat(fileInfo.imgMatDir,fileInfo.imgMatNamePrefix,strIdx,'_xvid.mat');
    end
end