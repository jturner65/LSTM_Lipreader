%%run somoclu on all the files, via command line.  preload wts from last
%%iteration on next iteration
%somTypStr : '-k 0' for cpu, '-k 1' for gpu
function res = runSomocluOnFiles(fileDir, somDir,outSOMFilePrfx, mapSize, lrnLen, lrnSt, lrnEnd, numEpochs, maxLrn, minLrn, somTypStr, somFormat)
    firstTime = 1;
    
    somExe = [somDir '/somoclu.exe ' somTypStr ' ' somFormat];
    %build coefficients for function to determine learning rate nonlinear
    %decay
    xVec = [1 .5 1.0/numEpochs];
    yVec = [maxLrn .5*maxLrn minLrn]';
    A = vander(xVec);    
    coefs = A\yVec;
    %initial codebook and st epoch - change back to 1
    stEpoch = 1;
    %continue training with last code book
    %codeBk = '"D:/LipReaderProject/LSTM_Lipreader/LSTM_Lipreader/MatlabCode/output/imgSOM/SOM_output/SOM_out_36_len_10000.wts"';
    for epoch = stEpoch:numEpochs
        xVal = 1.0/epoch;
        lrnRate = coefs(1,1) * xVal * xVal + coefs(2,1) * xVal + coefs(3,1);
        endLrnRate = .1 * lrnRate;
        stRad = round(5 * lrnRate * mapSize + 1);
        endRad = 1;
        learnStr = [' -e 4 -l ' num2str(lrnRate) ' -L ' num2str(endLrnRate) ' -r ' num2str(stRad) ' -R ' num2str(endRad)];
        disp(strcat('at epoch:',num2str(epoch),learnStr));
        for i=lrnSt:lrnEnd
            inFile = strcat('"',outSOMFilePrfx,'_Iter_',num2str(i),'_len_',num2str(lrnLen),'.lrn','"');
            %inFile = strcat('"',fileDir,'/normedSOMData_Iter_',num2str(i),'_len_',num2str(lrnLen),'.lrn','"');
            outputFile = strcat('"',fileDir,'SOM_output/SOM_out_',num2str(i),'_len_',num2str(lrnLen));
            command = '';
            %first one we want random weights
            if(firstTime == 1)
                firstTime = 0;
                command = [somExe ' ' learnStr ' ' inFile ' ' outputFile '"'];
            else
                command = [somExe ' ' learnStr ' -c ' codeBk ' ' inFile ' ' outputFile '"'];
            end
            cmd = char(command);
            disp(cmd);
            [status,cmdout] = system(cmd,'-echo');
            codeBk = strcat(outputFile,'.wts"');
            disp(strcat('next code book : ',codeBk));
        end
    end
    res = 0;
end


