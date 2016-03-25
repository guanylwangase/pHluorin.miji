global temppath resultpath homedir

%set temp
[temppath]=uigetdir('D:\','Set Temporary Directory');
[resultpath]=uigetdir('D:\','Set Results Output Directory');

%Identify home directory
homedir = which('Launcher');
a=strfind(homedir,'\');
homedir=homedir(1:a(end));

%syncronize macro
MacroDir='02-Macro\';
macro=[homedir MacroDir 'SpotFinder.ijm'];
backup=[homedir MacroDir  'SpotFinder.ijm' '-' datestr(now) '.bak'];

fid = fopen(macro, 'r+');
fidbk = fopen(backup, 'r+');
fwrite(fidbk, fid);
fclose(fidbk);

movefile(macro,backup);
copyfile(macro,backup)