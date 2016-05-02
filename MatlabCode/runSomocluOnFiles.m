%%run somoclu on all the files, via command line.  preload wts from last
%%iteration on next iteration
%somTypStr : '-k 0' for cpu, '-k 1' for gpu
function res = runSomocluOnFiles(fileDir, somDir, lrnLen, lrnSt, lrnEnd, somTypStr)
    %%somData_Iter_0_len_10000
    somExe = strcat(somDir,'/somoclu.exe',{' '},somTypStr,{' '},'-x 100 -y 100 -m toroid -g hexagonal');
    for i=lrnSt:lrnEnd
        format shortg;
        c = clock
        inFile = strcat('"',fileDir,'/normedSOMData_Iter_',num2str(i),'_len_',num2str(lrnLen),'.lrn','"');
        outputFile = strcat('"',fileDir,'/SOM_output/SOM_out_',num2str(i),'_len_',num2str(lrnLen),'"');
        command = '';
        %first one we want random weights
        if(i == 1)
            command = strcat(somExe,{' '},inFile,{' '},outputFile);
        else
            codeBk = strcat('"',fileDir,'/SOM_output/SOM_out_',num2str(i-1),'_len_',num2str(lrnLen),'.wts"');
            command = strcat(somExe,' -c',{' '},codeBk,{' '},inFile,{' '},outputFile);
        end
        cmd = char(command);
        disp(cmd);
        [status,cmdout] = system(cmd,'-echo');
        
    end
    res = 0;
end