[nslice,npoint]=size(datao);
%hf=100*npoint;
dataf=datao;

%m row and ncol
m=8;n=3;
npage=ceil(npoint/m/n);

for page=1:npage;
    h=figure('Position', [10, 10, 1000, 1000]);
    for i=1:m*n;
        k=m*n*(page-1)+i;
        if k<=npoint;
            subplot(m,n,i);
            if isempty(find(list==k))==0;
                plot(dataf(:,k),'-ro','MarkerSize',3);
            else
                plot(dataf(:,k),'-bo', 'MarkerSize',3);
            end  
            ylabel(num2str(k),'rot',0);
            axis([0 nslice min(dataf(:,k)) max(dataf(:,k))]);
        end
    end
    set(gcf,'PaperUnits','inches','PaperPosition',[0 0 16 9])
    print(h,[resultpath name '-rp-'  num2str(page) '.png'],'-dpng');
    close(h);
end



