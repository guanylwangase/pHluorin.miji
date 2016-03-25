global temppath resultpath homedir
%%log
%%logname=[resultpath 'log-' datestr(now,0) '.txt'];
logname=[resultpath 'log-' datestr(now,'yyyymmdd-HH') '.txt'];
log=[name, char(9), num2str(size(datao,1)),char(9),num2str(size(datao,2)),char(9),num2str(size(xyo,1)),char(9),num2str(ratiod),char(9),num2str(mean(dura)),char(9),num2str(mean(thalf)),char(10)];
fid = fopen(logname, 'a+');
fwrite(fid, log);
fclose(fid);


p_resume=zeros(l,5);
for i=1:l
    p_resume(i,1)=i;%%the number of exocytosis
    p_resume(i,2)=list(i);%%the number in roi list
    p_resume(i,3)=texo(i);%%the slice where exocytosis occurs
    p_resume(i,4)=dura(i);%%duration of exocytosis
    p_resume(i,5)=thalf(i);%%half-life of excytosis signal
end
rdataname=[resultpath name,'-points.txt'];
dlmwrite(rdataname,p_resume,'delimiter','\t');