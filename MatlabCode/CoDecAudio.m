%encode and decode audio samples
%dataInfo : struct holding data, information about the data, the original sample
%size, and other info
function res = CoDecAudio(dataInfo, encInfo)
    if(dataInfo.isEnc == 0)         %0 means rawm, encode from sample to smaller dim
        res = encodeAudio(dataInfo, encInfo);
    else
        res = decodeAudio(dataInfo, encInfo);
    end
end

%encode sample to diminish dimension in new audioSataStruct
function res = encodeAudio(sampleInfo, encInfo)
    data = sampleInfo.data;    
    newDataSz = encInfo.encSize;
    sampleInfo.encLen = newDataSz;
    
    
    
    res = bldCopyAudioDS(data, sampleInfo);   
end


%should never call this without previous raw data, so rawLen should be
%known
function res = decodeAudio(codedSampleInfo, encInfo)
    data = codedSampleInfo.data;
    
    res = bldCopyAudioDS(data, sampleInfo); 
end

