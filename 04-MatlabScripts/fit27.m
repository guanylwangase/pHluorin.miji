global temppath resultpath homedir

filename='templist0.txt';
file=[temppath filename];
name=char(MIJ.getCurrentTitle);

datao=[];
data0=[];
data1=[];

% import data
%datao=MIJ.getResultsTable;
D=importdata(file);
datao=D(2:end,2:end);
[nslice,npoint]=size(datao);

datanorm='true';
switch datanorm
    case 'true'
        dmax=max(datao);
        dmin=min(datao);
        for j=1:npoint
            data0(:,j)=(((datao(:,j)-dmin(j))/(dmax(j)-dmin(j)))*100);
        end

    case 'false'
        data0=datao;
end

%filename=char(MIJ.getCurrentTitle);
%run SetFilesavepath
%file=[filesavepath filename];


%%

list=[];
dura=[];
thalf=[];
texo=[];
h = waitbar(0,'Fitting.Please wait...');

list2max=[];
listposmax=[];
listposend=[];
listsmallmax=[];
listshortppp=[];
listshortppp2=[];
listshortppp3=[];
listpostex=[];
listfitex=[];
listfiterr=[];

for j=1:npoint;
    %[num2str(j/npoint*100,3),'%']
    % computation here %
    waitbar(j/npoint,h);
   
    p=data0(:,j); 

%==================POSMAX EXCEPTION=========================
%==================PRE-EXCLUSION=========================
%==================Find the beginning================
    pd=zeros(nslice-1,1);
    
    for i=1:nslice-1;
        pd(i)=p(i+1)-p(i);
    end
    %plot(pd,'.')

    %find max diff
    posmaxd=find(pd==max(pd));
    posmax=posmaxd+1;



    %case 2 max==
    if size(posmax,1)>1
        list2max=[list2max,j];
        continue
    end
    
    %case close to the end 
    if posmax>=(nslice-3)
        listposmax=[listposmax,j];
        continue
    end
    
    
    
    %a big jump~ 
    %k= slices before posmax to compare
    k=3;
    
    if posmax<=k+1
        continue
    else       
        diff1=0;        
        %for i=posmaxd-1-(k-1):posmaxd-1
        for i=posmaxd-k:posmaxd-1
            diff1=diff1+abs(pd(i));
        end
                
        if diff1>pd(posmaxd)
            listsmallmax=[listsmallmax,j];
            continue
        end
    end
 
   %case max!=maxdiff

    
%==================Find the end================
% take the smaller one between mode and mean as end
    %ppr=point.max:end.rounded
    
    pp=p(posmax:nslice);
    
    %eliminate the pic=k slices
    k=4;
    ppk=p(posmax+4:nslice);
        
    ppmethod='smooth1';
    switch ppmethod
        case 'mode1'%mode post-max
            pr=round(p);
            ppr=round(pp);
            ppkr=round(ppk);    
            rmode=mode(ppkr);
            posmode=find(ppr<=rmode,1)+posmax-1;
            modemar=0.5;
            
            posend=posmode;
            pppmethod='mode';
            
        case'mode2' %mode all
            pr=round(p);
            ppr=round(pp);
            ppkr=round(ppk);
            rmode=mode(pr);
            posmode=find(ppr<=rmode,1)+posmax-1;
            
            posend=posmode;
            pppmethod='mode';
            
            
        case 'mode3' %mode all
            pm=mean(pp);
            pl=size(pp,1);
            pr=round(p);
            ppr=round(pp);
            ppkr=round(ppk);
            rmode=mode(pr);
           
            for i=2:pl-1
                ppm1=(pp(i-1)+pp(i)+pp(i+1))/3;                              
                ppmlim=prctile(ppk,75);
                if ppm1<=ppmlim
                    posend=i+posmax-1;
                    break
                end
            end
            
            pppmethod='mode';
            
        case 'mode4' %mode all
            %p10er=round(p/20);
            pp10er=round(pp/10);
            %p10xr=p10er*20;
            pp10xr=pp10er*10;
            modemar=0.5;
            %rmode=mode(p10xr)+modemar;
            rmode=mode(pp10xr)+modemar;
            posend=find(pp<=rmode,1)+posmax-1;
         
            pppmethod='mode';

        case 'mean1' %mean post-max
            pm=mean(pp);
            pl=size(pp,1);
            for i=2:(pl-2)
                ppm1=(pp(i-1)+pp(i)+pp(i+1))/3;
                ppm2=(pp(i)+pp(i+1)+pp(i+2))/3;
                ppmlim=prctile(ppk,75);
                if (ppm1<=ppmlim)&&(ppm2<=ppmlim)
                    posend=i+posmax-1;
                    break
                end
            end
            
            pppmethod='mean';
        
        case 'smooth1'  
            %%pps=smooth(pp,'lowess');
            pps=smooth(pp);
            ppl=size(pp,1);
            for i=2:(ppl-1)
                if pps(i)<pps(i-1) && pps(i)<pps(i+1)
                    posend1=i+posmax-1;
                    break
                end
            end
            

            pp10er=round(pp/10);
            pp10xr=pp10er*10;
            modemar=0.5;
            rmode=mode(pp10xr)+modemar;
            posend2=find(pp<=rmode,1)+posmax-1;
                     
            posend=min(posend1,posend2);
            
            pppmethod='mode';
            
    end
                                    
    %for the lasts frames (t=-15s)
    switch pppmethod
        case 'mode'
            if posmax>(nslice-(7.5/0.5));
        %if mode>mean take mean
                m=mean(p);
                if rmode>m
                    if find(pp<=m,1)>1
                        posend=find(pp<=m,1)+posmax-1;
                    end
                end
            end
        
        case 'mean'
                          
    end
   
        
    %ppp=array finally to fit
    %ppp=point.position_max.position_mode
    ppp=p(posmax:posend);
    ppx=p;
    ppx(posmax:posend)=[];



%==================POST-EXCLUSION=========================    
    if size(ppp,1)<3
        listshortppp=[listshortppp,j];
        continue
    end
    
    
    switch pppmethod
        case 'mode1'
            %lowlim=max(mean(ppk),rmode);
            lowlim=rmode;
            if abs(ppp(2)-lowlim)<=(abs(ppp(end)-lowlim));
                listshortppp2=[listshortppp2,j];
                continue
            end
        case ''        
    end
    
    switch pppmethod
        case 'mode'
            %there should not be bigger value than p2 in k slice after posend 
            %or no bigger value before posmax
            k=15;
            if posend+k<=nslice
                pppk=[];
                for i=1:k
                    pppk=[pppk,p(posend+i)+modemar];
                end
                if size(find(pppk>ppp(2)),2)>0
                    listshortppp3=[listshortppp3,j];
                    continue
                end
            else
                pppk=[];
                for i=1:k
                    pppk=[pppk,p(posmax-i)+modemar];
                end
                if size(find(pppk>ppp(2)),2)>0
                    listshortppp3=[listshortppp3,j];
                    continue
                end
            end
            
        case ''
    end

          

    pexmethod='var';
    
    %ppp should have bigger values
    switch pexmethod
        %compare to whole array
        case 'prctile'
            ppplim=prctile(ppp,25);
            %lim=1-(10/nslice);
            ppxlim=prctile(ppx,75);
    
            if ppplim<ppxlim
                listpostex=[listpostex,j];
                continue
            end
            
        %compare to an interval    
        case 'prctile2'
            %nbr of slices before and after posmax
            estval1=50;
            estval2=50;
            
            %val=estval1+estval2=abs100
            
            if estval1>=posmax
                estval1=posmax-1;
                estval2=estval2+(estval1-posmax+1);
            end
            
            if estval2>nslice-posend
                estval2=nslice-posend;
                estval1p=estval1+(nslice-posend);
                if estval1p<posmax
                    estval1=estval1p;
                else
                    estval1=posmax-1;
                end
            end
            
            ppxinf=p(posmax-estval1:posmax-1);
            ppxsup=p(posend+1:posend+estval2);
            ppx=[ppxinf;ppxsup];
            
            ppplim=prctile(ppp,25);
            %lim=1-(10/nslice);
            ppxlim=prctile(ppx,75);
            
            if ppplim<ppxlim
                listpostex=[listpostex,j];
                continue
            end
                        
        case 'var'
            estval1=25;
            estval2=25;
            
            %val=estval1+estval2=abs100
            
            if estval1>=posmax
                estval1=posmax-1;
                estval2=estval2+(estval1-posmax+1);
            end
            
            if estval2 > nslice-posend
                estval2=nslice-posend;
                estval1p=estval1+(nslice-posend);
                if estval1p<posmax
                    estval1=estval1p;
                else
                    estval1=posmax-1;
                end
            end
            
            ppxinf=p(posmax-estval1:posmax-1);
            ppxsup=p(posend+1:posend+estval2);
            ppx=[ppxinf;ppxsup];
            
            varppp=var(ppp);
            varppx=var(ppx);
            

            if varppx>(varppp/4)
                listpostex=[listpostex,j];
                continue
            end
        case 'none'
                      
    end
            
%==================FITTING========================== 
    fitmethod='exp';
    
    switch fitmethod
        
        case 'gauss'            
    try 
        [fitresult,gof]=PHLcurvefit2(ppp);
    catch exception
        try [fitresult,gof]=PHLcurvefit3(ppp);
        catch exception
            listfiterr=[listfiterr,j];
            continue 
        end
    end
  
        case 'exp'
        try [fitresult,gof]=PHLFitEXP(ppp);
        catch exception
            listfiterr=[listfiterr,j];
            continue 
        end
    end
    
     
           
    if (gof.rsquare<0.80)
        listfitex=[listfitex,j];
        continue
    end
    
    %exp: f(x)=a*exp(b*x)
    %f(y)= ln(y/a)/b

    lenppp=size(ppp,1);
    i0fit=fitresult(1);
    iendfit=fitresult(lenppp);
    yhalf=0.5*(i0fit+iendfit);    
    
    x=linspace(1,lenppp,lenppp);
    y=fitresult(x);
    
    tau=interp1(y,x,yhalf,'pchip');
    
    list=[list,j];
    dura=[dura,lenppp];
    thalf=[thalf,tau];
    texo=[texo,posmax];

end
close(h);


%%%%%==================save results========================================
l=size(list,2);

%dataname=[file,'-list.txt'];
%dlmwrite(dataname,list,'delimiter','\t');


temp_list=[temppath,'templist.txt'];
dlmwrite(temp_list,list,'delimiter','\t');
%temp_listm=strrep(temp_list,'\','\\');
%temp_listm=[char(34),temp_listm,char(34)];
%fid = fopen(temp_list, 'w');
%fwrite(fid, list);
%fclose(fid);

%%for i=1:l
%%    data1(:,i)=datao(:,list(i));
%%end
%%dataname=[file,'-results.txt'];
%%dlmwrite(dataname,data1,'delimiter','\t');


%%onesliceevent=sort([listshortppp,listshortppp2,listshortppp3]);
%%dataname=[file,'-1sliceevents.txt'];
%%dlmwrite(dataname,onesliceevent,'delimiter','\t');


%list2max 
%listposmax 
%listposend
%listshortppp
%listshortppp2
%listshortppp3
%listpostex
%listfitex
%listfiterr
%list
%size(list,2)