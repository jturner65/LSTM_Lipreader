%define an audio data struct around the passed sample 
%(which is a column vector of data)
function res = audioDataStruct(audioSample, isEnc, rawLen, encLen, index, fileName)
    fld0 = 'data';          val0 = audioSample;                  %the sample data - either encoded or raw
    fld1 = 'isEnc';         val1 = isEnc;                        %0 if raw, 1 if encoded
    fld2 = 'dataSZ';        val2 = size(audioSample,1);          %length of audio data (# of values)
    fld3 = 'encLen';        val3 = encLen;                       %length of encoded audio data (# of values)
    fld4 = 'rawLen';        val4 = rawLen;                       %length of raw audio data behind this data (corresponds to sampling rate)
    fld5 = 'index';         val5 = index;                        %index in sequence of audio data
    fld6 = 'fileName';      val6 = fileName;                     %fileName of source of data
    
    res = struct(fld0,val0,fld1,val1,fld2,val2,fld3,val3,fld4,val4,fld5,val5,fld6,val6);
end