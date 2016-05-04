ftoread = 'wordScript_1000_xvid.csv';
fid = fopen(ftoread);

a = fgetl(fid);
n = 0;
tline = fgetl(fid);
c = strsplit(tline, ',');
disp(iscell(c(1)));
zzz = str2num(char(c(1)));
while ischar(tline)
  tline = fgetl(fid);
  n = n+1;
end
%M = textscan(fid, '%f', 'Delimiter','\,'); % you will need to change the number   of values to match your file %f for numbers and %s for strings.
fclose (fid)

disp(n);
disp (ischar(a));