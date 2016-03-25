xyo=MIJ.getResultsTable;
%name=char(MIJ.getCurrentTitle);
xyo(:,3)=[];
[npoint,dim]=size(xyo);

xy=xyo;
centroid=[mean(xy(:,1)),mean(xy(:,2))];
for i=1:npoint;
    %xy(i,3)=distance(xy(i,:),centroid);
    xy(i,3)=sqrt((xy(i,1)-centroid(1))^2+(xy(i,2)-centroid(2))^2);
end

distxy=xy(:,3);

h=figure('Name','xy','NumberTitle','off');
hist(distxy);
print(h,[resultpath name '.png'],'-dpng')



%%%%%%%%%%%%%%%%%%
xymo=[];

maxx=max(xy(:,1));
minx=min(xy(:,1));
maxy=max(xy(:,2));
miny=min(xy(:,2));

dimx=maxx-minx;
dimy=maxy-miny;
dimd=sqrt((dimx*dimy)/npoint);

d=xy(:,3);
%h2=figure('Name','ecdf','NumberTitle','off');
%ecdf(d);

lim1=prctile(d,0);
lim2=prctile(d,80);
d2=d;
d2(find(d2<lim1))=[];
d2(find(d2>lim2))=[];
d3=sort(d2);

%mean3=mean(d3);
max3=max(d3);
min3=min(d3);
%med3=median(d3)
mid3=(max3+min3)/2;
%ratiomean=(max3^2-mean3^2)/(mean3^2-min3^2);
%ratiomed=(max3^2-med3^2)/(med3^2-min3^2);
ratiomid=(max3^2-mid3^2)/(mid3^2-min3^2);
%ratio3=mean3/mid3;

d3inf=d3(find(d3<=mid3));
d3sup=d3(find(d3>=mid3));

ration=size(d3sup)/size(d3inf);
ratiod=ration/ratiomid;

h2=figure('Name','model_xy','NumberTitle','off');
hist(d3);
print(h2,[resultpath name '-ratiod=' num2str(ratiod,3)  '.png'],'-dpng')

xyimg=double(MIJ.getImage('Spot'));
imwrite(xyimg,[resultpath name '-Spots' '-ratiod=' num2str(ratiod,3) '.png'],'png')


close xy;
close model_xy;