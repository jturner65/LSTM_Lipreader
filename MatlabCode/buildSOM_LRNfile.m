%%this function will build an appropriately structured lrn file
% of passed size from the given array.
function res = buildSOM_LRNfile(numRows, numFiles, firstRow)
    disp('loading huge tmpAra');
    %need to use normed data
    outSOMFilePrfx = 'output\sndSOM\normedSOMData';
    tmp = load(strcat(outSOMFilePrfx,'Txt.mat'),'tmpAra');
    tmpAra = tmp.tmpAra;
    disp('huge tmpAra loaded');
    %first column is unique ID - skip this in counts, but not in file
    %construction
    [totRows,totCols] = size(tmpAra);           
    totFileIters = round(totRows/numRows);
    iters = min(numFiles, totFileIters);
    if (iters == totFileIters)
        lastRowLen = mod(totRows,numRows);
    else
        lastRowLen = 0;
    end
    
    tmpArgAra = zeros(numRows,totCols,iters);
    for i = 1:iters
        stRow = firstRow + (numRows * (i-1));
        endRow = stRow + numRows - 1;
        tmpArgAra(:,:,i) = tmpAra(stRow:endRow,:);
    end
    
    %get rid of pre-existing pool if any
    delete(gcp('nocreate'));
    parpool(12);    
    parfor i=1:iters
        stRow = firstRow + (numRows * (i-1));
        endRow = stRow + numRows - 1;
        tmpSmAra = tmpArgAra(:,:,i);
        makeDataTable(stRow,endRow,numRows,totCols,strcat(outSOMFilePrfx,'_Iter_',num2str(i),'_len_',num2str(numRows),'.lrn'),tmpSmAra);
    end
    if(lastRowLen > 0 )
        stRow = firstRow + (numRows * iters); 
        endRow = stRow + lastRowLen - 1;
        %last partial row
        i = iters+1;
        makeDataTable(stRow,endRow,lastRowLen,totCols,strcat(outSOMFilePrfx,'_Iter_',num2str(i),'_len_',num2str(lastRowLen),'.lrn'),tmpAra);
    end
    res = 0;
end
