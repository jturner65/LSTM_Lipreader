%function will build image matrix name given a file index and a file info
%obj
function res = buildImgMatName(idx, fileInfo)
    strIdx = num2str(idx);
    if(idx < 10)
        strIdx = strcat('0',strIdx);
    end
    if(idx < 100)
        strIdx = strcat('0',strIdx);
    end   

    res = strcat(fileInfo.imgMatDir,fileInfo.imgMatNamePrefix,strIdx,'_xvid.mat');
end