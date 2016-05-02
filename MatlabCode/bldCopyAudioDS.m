%build a new audio data struct from a passed sample and an old DS, with new data and
%encoding based on an old sample (source of new one, either raw or encoded)
%audioSample is column vector
%uses many data vals of old struct, but new length and enc val. etc
%audioSample, isEnc, rawLen, encLen, index, fileName
function res = bldCopyAudioDS(audioSample, oldAudStrct)
    enc = mod(oldAudStrct.isEnc +1,2);                  %if old was encoded, new should not be, and vice versa
    res = audioDataStruct(audioSample, enc, ...
        oldAudStrct.rawLen, oldAudStrct.encLen,  ...
        oldAudStrct.index, oldAudStrct.fileName);
end