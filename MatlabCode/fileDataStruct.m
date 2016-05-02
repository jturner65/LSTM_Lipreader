%return info pertaining to file locations
function res = fileDataStruct(fileName, inVidFileDir, outputDir)
    tmp = strsplit(fileName,'.');   %remove extension
    baseFileName = tmp(1,1);        %remove extension

    tmp2 = strsplit(char(baseFileName(1,1)),'_');
    somUniqueKey = tmp2(1,1);
    
    vidFileExt = '.avi';
    imgFileExt = '.jpg';

    fld0 = 'readFileName';          val0 = strcat(inVidFileDir,fileName);       %read the original base video files 
    fld1 = 'writeImgNamePrefix';    val1 = strcat('output_2\imgs\',baseFileName,'\out_',baseFileName);
    fld2 = 'writeImgNameExt';       val2 = imgFileExt;
    fld3 = 'writeSndFileName';      val3 = strcat('output_2\snd\',baseFileName,'\out_',baseFileName,'.mat');
    fld4 = 'writeVidFileName';      val4 = strcat('output_2\vids\out_',baseFileName,vidFileExt);
    fld5 = 'writeImgDir';           val5 = strcat('output_2\imgs\',baseFileName);
    fld6 = 'writeSndDir';           val6 = strcat('output_2\snd\',baseFileName);
    fld7 = 'audFileOutDataTyp';     val7 = 'single';
    fld8 = 'somUniqueKeyPrefix';    val8 = str2num(char(somUniqueKey));        %%video file ID
    res = struct(fld0,val0,fld1,val1,fld2,val2,fld3,val3,fld4,val4, ...
        fld5,val5,fld6,val6,fld7,val7,fld8,val8);
     
end