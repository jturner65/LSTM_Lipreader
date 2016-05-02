%create a new audio data structure from a raw audio sample
%at this stage we don't know what the encoded lenght will be so -1
function res = createNewAudioDSFromRaw(audioSample, index, fileName)
    res = audioDataStruct(audioSample, 0, ...
        size(audioSample,1), -1,  ...
        index, fileName);
end