%%Choose the folder containing "name-points.txt", this script will save the duration of each point into a matrix and a list.


global libdir
if exist('libdir')==0||isempty(libdir)==1
    batchdir=uigetdir('Set Folder');
else
    batchdir=uigetdir(libdir);
end

nslash=findstr(batchdir,'\');
libdir=batchdir(1:nslash(end));
currentdirname=batchdir(nslash(end)+1:end);

filelist=dir(batchdir);
filelist={filelist.name};
len=size(filelist,2);



kinelist=[];
taulist=[];
mat=[];
mat2=[];
filenamelist={};
h = waitbar(0,'Please wait...');

for i=1:len
    a=char(filelist(i));
    b='point';
    waitbar(i/len,h);
    
    if isempty(findstr(a, b))==0
        filepath=([batchdir '\' a]);
        datai = dlmread(filepath);
        
        lenmat=size(mat,1);
        leni=size(datai,1);
        if lenmat<=leni
            matexp=NaN(leni,size(mat,2)+1);
            matexp(1:lenmat,1:size(mat,2))=mat;
            
            matexp2=NaN(leni,size(mat,2)+1);
            matexp2(1:lenmat,1:size(mat,2))=mat2;
            
            
        else
            matexp=NaN(lenmat,size(mat,2)+1);
            matexp(1:lenmat,1:size(mat,2))=mat;
            
            matexp2=NaN(lenmat,size(mat,2)+1);
            matexp2(1:lenmat,1:size(mat,2))=mat2;
            
            
        end
        matexp(1:leni,end)=datai(1:end,4);
        kinelist=cat(1,kinelist,datai(1:end,4));
        
        matexp2(1:leni,end)=datai(1:end,5);
        taulist=cat(1,taulist,datai(1:end,5));
        
        
        mat=matexp;
        mat2=matexp2;
        filenamelist=[filenamelist,filelist(i)];
    end
    
end


dataexport=mat2dataset(mat,'VarNames',filenamelist);
dataexport2=mat2dataset(mat2,'VarNames',filenamelist);
%dlmwrite([batchdir '\' 'tlist.txt'],tlist,'newline','pc');
dlmwrite([batchdir '\' currentdirname '-kinelist.txt'],kinelist,'newline','pc');
export(dataexport,'file',[batchdir '\' currentdirname '-kinemat.txt']);

dlmwrite([batchdir '\' currentdirname '-taulist.txt'],taulist,'newline','pc');
export(dataexport2,'file',[batchdir '\' currentdirname '-taumat.txt']);

close(h);