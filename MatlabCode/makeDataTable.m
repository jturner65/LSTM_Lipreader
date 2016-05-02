
function res = makeDataTable(stRow, endRow, numRows, numCols, outFileName,tmpAra)
    fileID = fopen(outFileName,'W');%cap W means no flushing between read/write
    numDataCols = (numCols-1);
    fprintf(fileID,'# sound samples to be used to train SOM for building output class vector\n');
    fprintf(fileID,'# this is a dense array to use SOMs denseGPU capabilities\n');
    fprintf(fileID,'%% %d\n', numRows);                  %# of rows in txt file, with 0 rows gone
    fprintf(fileID,'%% %d\n', numDataCols);         %# of columns, excluding unique id
    fprintf(fileID,'%% 9 ');             %set first column to be unique key
    for i = 1:numDataCols                       %set columns to be on 
        fprintf(fileID,'1 ');
    end
    fprintf(fileID,'\n%% SeqNum');
    %var name in format is ignored by som
    for i = 1:numDataCols                      %set columns to be on 
        fprintf(fileID,strcat(' c',int2str(i)));
    end
    fprintf(fileID,'\n');
    disp(strcat('strow : ',num2str(stRow),' endrow : ',num2str(endRow)));
    for i = 1:numRows
        tmpStr = num2str(tmpAra(i,:),'%.5f ');        
        fprintf(fileID,'%s \n', tmpStr);
    end
    fclose(fileID);
    res = 0;
end
