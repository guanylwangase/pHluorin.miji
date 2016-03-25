
%%Choose the folder containing "name-points.txt", this script will save the duration of each point into a matrix and a list.

%%inport data

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

%%initialisation
isprint=1;

setting=2;

switch setting
    case 1
        t0=10;
        t1=20;
        td=121;
    case 2
        t0=30;
        t1=30;
        td=241;
end
        
tin=td-t0-t1-1;

filenamelist={};
h = waitbar(0,'Please wait...');
j=0;
mat=[];

%%data construction
for i=1:len
    a=char(filelist(i));
    b='point';
    %%waitbar(i/len,h);
    
    if isempty(findstr(a, b))==0
        filepath=([batchdir '\' a]);
        datai = dlmread(filepath);
        datai_sort=sortrows(datai,3);  
        datai_in=datai_sort;
        
        for k=size(datai_in,1):-1:1
            if datai_in(k,3)<=t0 || datai_in(k,3)>td-t1
                datai_in(k,:)=[];
            end
        end

        datai_in(:,3)=datai_in(:,3)+j*tin-t0;
        j=j+1;
        mat=cat(1,mat,datai_in);
        %%filenamelist=[filenamelist,filelist(i)];
    end
end



%%result output

%%dlmwrite([batchdir '\' currentdirname '-mat.txt'],mat,'newline','pc');
dataexport=mat2dataset(mat,'VarNames',{'order number', 'roi number', 'slice number', 'lifetime', 'half life'});
export(dataexport,'file',[batchdir '\' currentdirname '_mat.txt']);

close(h);

    %%%number of exocytosis per n second
dt_output=60;    

for dt=1:60
    
    
    dtslice=0.5;
    %dt=5;
    %x = inputdlg('interval in second', 'define t interval',1,{'0.5'});
    %dt = str2num(x{:});
    %dt=30;
    

    dnslice=dt/dtslice;

    mat2=zeros(j*tin+1,2);
    %%col1=slicelist,col2=taulist
    for i=1:size(mat,1);
        mat2(mat(i,3),1)=mat2(mat(i,3),1)+1;
        mat2(mat(i,3),2)=mat2(mat(i,3),2)+mat(i,5);
    end
    
    len=size(mat2,1)-dnslice;
    matr=zeros(len,2);
    
    for i=1:len
        matr(i,1)=sum(mat2(i:i+dnslice-1,1));
        matr(i,2)=sum(mat2(i:i+dnslice-1,2))/matr(i,1);
    end

    
    %%%
    outputdir=[batchdir '\slope\'];
    outputdir2=[batchdir '\tau\'];
    
    if isprint==0;
        h1=figure('Name','slope','NumberTitle','off');
        plot(linspace(1,len*dtslice,len),matr(:,1)),grid on;
        xlabel('time(s)');
        ylabel(['events per ' num2str(dt) ' seconds']);
        if ~exist(outputdir, 'dir')
            mkdir(outputdir);
        end
        print(h1,[outputdir currentdirname '_slopeplot_dt=' num2str(dt) 's.png'],'-dpng');

        h2=figure('Name','tau','NumberTitle','off');
        plot(linspace(1,len*dtslice,len),matr(:,2)),grid on;
        xlabel('time(s)');
        ylabel(['mean tau per ' num2str(dt) ' seconds']);    

        if ~exist(outputdir2, 'dir')
            mkdir(outputdir2);
        end
        print(h2,[outputdir2 currentdirname '_tauplot_dt=' num2str(dt) 's.png'],'-dpng');

        close(h1);
        close(h2);
    end
    %%dlmwrite([outputdir '\' currentdirname '_dt=' num2str(dt) 's_slope_raw.txt'],matn(:,1),'newline','pc');
    %%dlmwrite([outputdir2 '\' currentdirname '_dt=' num2str(dt) 's_tau_raw.txt'],matn(:,2),'newline','pc');
    
   if dt==dt_output  
       dlmwrite([batchdir '\' currentdirname '_dt=' num2str(dt_output) 's_slope_raw.txt'],matr(:,1),'newline','pc');
       dlmwrite([batchdir '\' currentdirname '_dt=' num2str(dt_output) 's_tau_raw.txt'],matr(:,2),'newline','pc');
   end

   
   
   %%%%normolized results
	%%%nth slice
   t_norm=360;
   slope_norm=mean(matr(1:t_norm,1));
   tau_norm=mean(matr(1:t_norm,2));
   matn=zeros(len,2);
   matn(:,1)=matr(:,1)/slope_norm;
   matn(:,2)=matr(:,2)/tau_norm;
   
   
   %%dlmwrite([batchdir '\' currentdirname '_dt' num2str(dt_output) 's_slope_norm.txt'],matn(:,1),'newline','pc');
   %%dlmwrite([batchdir '\' currentdirname '_dt' num2str(dt_output) 's_tau_norm.txt'],matn(:,2),'newline','pc');
       
   if dt==dt_output  
       dlmwrite([batchdir '\' currentdirname '_dt' num2str(dt_output) 's_slope_norm.txt'],matn(:,1),'newline','pc');
       dlmwrite([batchdir '\' currentdirname '_dt' num2str(dt_output) 's_tau_norm.txt'],matn(:,2),'newline','pc');
   end
   %slices to normalize
    
   if isprint==0
    h3=figure('Name','slope_norm','NumberTitle','off');
    plot(linspace(1,len*dtslice,len),matn(:,1)),grid on;
    xlabel('time(s)');
    ylabel(['relative exocytoisis frequncy per ' num2str(dt) ' seconds']);
    print(h3,[outputdir currentdirname '_slopeplot_norm_dt=' num2str(dt) 's.png'],'-dpng');
    
    h4=figure('Name','tau_norm','NumberTitle','off');
    plot(linspace(1,len*dtslice,len),matn(:,2)),grid on;
    xlabel('time(s)');
    ylabel(['relative tau per ' num2str(dt) ' seconds']);    
    print(h4,[outputdir2 currentdirname '_tauplot_norm_dt=' num2str(dt) 's.png'],'-dpng');
    
    close(h3);
    close(h4);
   end
end

currentdirname
