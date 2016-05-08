%return info pertaining to file locations
%outputDir
function res = fileDataWithOutputStruct(fileName, outputDirTmp)
    tmp = strsplit(fileName,'.');   %remove extension
    baseFileName = tmp(1,1);        %remove extension
    %file name #
    tmp2 = strsplit(char(baseFileName(1,1)),'_');
    somUniqueKey = tmp2(1,size(tmp2,2)-1);%2nd to last is idx
    %remove final slash, if present
    outputDirAra = strsplit(char(outputDirTmp),'/');
    outputDir = outputDirAra(1,1);
    
    vidFileExt = '.avi';
    imgFileExt = '.jpg';
    fld0 = 'baseFileName';          val0 = baseFileName;
    fld1 = 'writeImgNamePrefix';    val1 = strcat(outputDir,'/imgs/',baseFileName,'/out_',baseFileName);
    fld2 = 'writeImgNameExt';       val2 = imgFileExt;
    fld3 = 'writeSndFileName';      val3 = strcat(outputDir,'/snd/',baseFileName,'/out_',baseFileName,'.mat');
    fld4 = 'writeVidFileName';      val4 = strcat(outputDir,'/vids/out_',baseFileName,vidFileExt);
    fld5 = 'writeImgDir';           val5 = strcat(outputDir,'/imgs/',baseFileName);
    fld6 = 'writeSndDir';           val6 = strcat(outputDir,'/snd/',baseFileName);
    fld7 = 'audFileOutDataTyp';     val7 = 'single';
    fld8 = 'somUniqueKeyPrefix';    val8 = str2num(char(somUniqueKey));        %%video file ID
    fld9 = 'readCapCSVFileName';    val9 = strcat(outputDir,'/snd/',baseFileName,'/wordScript_',baseFileName,'.csv');
    fld10 = 'audioBndsCapCSVFileName';    val10 = strcat(outputDir,'/snd/',baseFileName,'/audioBounds_',baseFileName,'.csv');
    fld11 = 'alignImgDir';  
    val11 = '';
    if (strcmp(outputDir, 'output_2'))
        val11 = strcat('output_2/alignedImgs/',baseFileName);
    elseif(strcmp(outputDir, 'output'))
        val11 = strcat('output/alignedImgs/',baseFileName);
    end
    
    fld12 = 'algnImgFileNameBase';      val12 = strcat(val11,'/out_',baseFileName,'_');
    fld13 = 'algnImgSavMatBig';         val13 = strcat(outputDir,'/alignedImgs/imgMatBig_',baseFileName,'.mat');
    fld14 = 'algnImgSavMatSmall';       val14 = strcat(outputDir,'/alignedImgs/imgMatSmall_',baseFileName,'.mat'); 
    fld15 = 'altAlignImgFileNameBase';  val15 = strcat(val11,'/',baseFileName,'/out_',baseFileName,'_');
    fld16 = 'altAlignImgDir';           val16 = strcat(val11,'/',baseFileName);
    fld17 = 'readSOMImgFileName';       val17 = strcat(outputDir,'/imgSOM/imgSrc/imgMatSmall_',baseFileName,'.mat');
    res = struct(fld0,val0,fld1,val1,fld2,val2,fld3,val3,fld4,val4, ...
        fld5,val5,fld6,val6,fld7,val7,fld8,val8,fld9,val9,fld10,val10, ...
        fld11,val11, fld12, val12, fld13, val13, fld14, val14, fld15, val15, ...
        fld16, val16, fld17, val17);
     
end