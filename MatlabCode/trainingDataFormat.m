function res = trainingDataFormat(basedir, seqSpan)
    fld1 = 'basedir';               val1 =  basedir;
    fld2 = 'trainingDir';           val2 = strcat(val1,'trainingData/');
    fld3 = 'imgMatDir';             val3 = strcat(val1,'trainingData/imgMats/');
    fld4 = 'imgMatNamePrefix';      val4 = 'imgMatSmall_';
    fld5 = 'trnWrdToVidFileName';   val5 = strcat(val2,'training_WordDict.csv');
    fld6 = 'trnNumericDataFileName';val6 = strcat(val2,'training_DataNumericDict.csv');
    fld7 = 'trnWordClassFileName';  val7 = strcat(val2,'training_ChosenWords.csv'); 
    
    fld8 = 'seqLen';                val8 = seqSpan;     %sequence length for LSTM training
    fld9 = 'trnDat_wrdIDX';         val9 = 1;           %column in trainingdata.csv with word
    %below all in training_DataNumericDict training data csv
    fld10 = 'trnNum_wrdClassIDX';       val10 = 9;          %column in training_DataNumericDict.csv with class of word
    fld11 = 'trnNum_FrameStIDX';        val11 = 1;          %column with caption-generated st idx
    fld12 = 'trnNum_FrameEndIDX';       val12 = 2;          %column with caption-generated end idx
    fld13 = 'trnNum_AudFrameStIDX';     val13 = 4;          %column with audio-data-assisted start idx
    fld14 = 'trnNum_AudFrameEndIDX';    val14 = 5;          %column with audio-data-assisted end idx 
    fld15 = 'trnNum_VidFileNameIDX';    val15 = 8;          %column in numericcsv with number of video file name
    
    res = struct(fld1,val1,fld2,val2,fld3,val3,fld4,val4, ...
        fld5,val5,fld6,val6,fld7,val7,fld8,val8,fld9,val9, ...
        fld10,val10,fld11,val11,fld12,val12,fld13,val13, ...
        fld14,val14, fld15, val15);
end