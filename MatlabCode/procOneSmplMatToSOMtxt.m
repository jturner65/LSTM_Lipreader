%%
%this function will convert all sound or video sample mats to somoclu - compatible
%format for dense data, the databionic esom .lrn file format, discussed : 
% https://github.com/peterwittek/somoclu

function [resCols,resRows, resAra] = procOneSmplMatToSOMtxt(fileData, isAudio, resAra, stRow, colSize)
    disp(strcat('Starting Sample Mat -> SOM txt processing on : ',fileData.baseFileName));
    %load file in as audioDataAra
    if isAudio == 1
        readSOMMatFileName = fileData.writeSndFileName;
        load(readSOMMatFileName, '-mat', 'audioDataAra');
        tmpAra = audioDataAra';
    else
        readSOMMatFileName = fileData.readSOMImgFileName;
        load(readSOMMatFileName, '-mat', 'imgSmallMat');
        tmpAra = imgSmallMat';        
    end
    %using transpose of data ara to build txt = want rows as cols, cols
    %as training examples
    [resRows, resCols] = size(tmpAra);
    resAra(stRow:(resRows+stRow-1),2:(resCols+1)) = tmpAra;
    strNumRows = num2str(resRows);
    if(resCols ~= colSize)
        disp(strcat('Error : Mat in ',{' '},readSOMMatFileName, ' needs to be ',{' '},colSize,' wide; is dim :',num2str(size(audioDataAra))));
    else
        disp(strcat('Mat in ',{' '},readSOMMatFileName, ' is : ',strNumRows, ' long, including blank samples'));
    end
    %write each row, including leading unique id
    %need to preallocate so we only write 1 time
    %build unique key for each row - integral part is movie file id,
    %decimal is sample # (from .00001 to .99999 (although we shouldn't ever
    %have to go this high)
    uniqueColData = ones(resRows,1);
    uniqueColData = uniqueColData * fileData.somUniqueKeyPrefix;
    uniqueColData = uniqueColData + ( .00001 * (1:resRows)');
    resAra(stRow:(resRows+stRow-1),1)=uniqueColData;

    disp(strcat('Finished processing ',fileData.baseFileName));
end

%trying to get parfor to work
% function [resCols, resRows, tmpAra] = procOneSmplMatToSOMtxt(baseFileName,inSndFileDir)
%     disp(strcat('Starting Sample Mat -> SOM txt processing on : ',baseFileName));
%     fileData = fileDataStruct(baseFileName,inSndFileDir);
%     sndMatFile = fileData.writeSndFileName;
%     %load file in as audioDataAra
%     load(sndMatFile, '-mat', 'audioDataAra');
%     [tmpCols, resRows] = size(audioDataAra);
%     resCols = tmpCols+1;
%     tmpAra = zeros(resRows, resCols,'single');
%     tmpAra(:,2:resCols) = audioDataAra';
%     %using transpose of audioDataAra to build txt = want rows as cols, cols
%     %as training examples
%     strNumRows = num2str(resRows);
%     if(resCols ~= 1764)
%         disp(strcat('Error : Sound mat in ',sndMatFile, ' is dim :',num2str(size(audioDataAra))));
%     else
%         disp(strcat('Sound mat in ',sndMatFile, ' is : ',strNumRows, ' long, including blank samples'));
%     end
%     %write each row, including leading unique id
%     %need to preallocate so we only write 1 time
%     %build unique key for each row - integral part is movie file id,
%     %decimal is sample # (from .00001 to 99999 (shouldn't ever go this
%     %high)
%     uniqueColData = ones(resRows,1);
%     uniqueColData = uniqueColData * fileData.somUniqueKeyPrefix;
%     uniqueColData = uniqueColData + ( .00001 * (1:resRows)');
%     tmpAra(:,1)=uniqueColData;
% 
%     disp(strcat('Finished processing ',baseFileName));
% end