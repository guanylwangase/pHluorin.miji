///ver20140410 for vm-ibidi hullbackground
////////////////////////////////////

ID = getImageID();
title=getTitle();
path=getInfo("image.directory");
run("Select None");
getDimensions(width, height, channels, slices, frames);
run("Clear Results"); 
roiManager("reset")

dir="D:/phl/"
name ="templist0.txt"; 

setBatchMode(true);

corprctint(title,4);

//////ID2-measurement
selectImage(ID);
run("Duplicate...", "title="+title+"-dup2 duplicate range=1-"+nSlices);
ID2 = getImageID();
title2=getTitle();

/////ID1-hullkground
selectImage(ID);

run("Duplicate...", "title="+title+"-dup1 duplicate range=1-"+nSlices);
ID1 = getImageID();
title1=getTitle();
//run("Subtract Background...", "rolling=10 stack");
run("Hullkground ", "nb=0 strictly return");
selectWindow("background");close();
selectWindow("objects");rename(title1);
+

ID1 = getImageID();
title1=getTitle();



selectImage(ID);
close();



selectImage(ID1);
//run("Bandpass Filter...", "filter_large=10 filter_small=2 suppress=None tolerance=0 process");


//////
for (i=1;i<slices;i++){
	selectImage(ID1);
	setSlice(i);
	run("Duplicate...", "title=" + i);
	selectImage(ID1);
	setSlice(i+1);
	run("Duplicate...", "title=" + (i+1));
	imageCalculator("Subtract create 32-bit", ""+ (i+1) +"",""+ i +"");

	selectWindow(i);
	close();
	selectWindow(i+1);
	close();
	
	if (i>1){
	selectWindow("Result of " + (i+1));
	run("Select All");
	run("Copy");
	close();
	selectWindow("Result of 2");
	run("Add Slice");
	run("Paste");
	}
}

run("Z Project...", "projection=[Max Intensity]");
//selectWindow("MAX_Result of 2");
//run("Fire");



//set noise level
selectWindow("MAX_Result of 2");
setAutoThreshold("Default dark");
getThreshold(lower, upper);
resetThreshold();

noiselevel=lower;
//noiselevel=getNumber("Delta=", lower);

run("Find Maxima...", "noise="+noiselevel+" output=[Point Selection]");

//setBatchMode(false);
newImage("Mask", "8-bit Black", width, height, 1);
newImage("MaskTemp", "8-bit Black", width, height, 1);

selectWindow("Mask");
run("Restore Selection");

setOption("BlackBackground", true)
setForegroundColor(255,255,255)
setBackgroundColor(0,0,0)

run("Draw");
setThreshold(1, 255);
run("Convert to Mask");
run("Select None");
run("Analyze Particles...", "size=0-Infinity circularity=0.00-1.00 show=Nothing add");

run("Clear Results"); 
roiManager("Show None");
run("Set Measurements...", "  mean redirect=None decimal=3");
for (i=0;i<roiManager("count");i++){
	selectWindow("MaskTemp");
	roiManager("select",i);
	
	run("Fill", "slice");
	run("Select None");
	run("Dilate");
	run("Create Selection");
	run("Clear", "slice");
	selectImage(ID2);
	run("Restore Selection");

	for (j=1;j<=slices;j++){
		selectImage(ID2);
		setSlice(j);
		getStatistics(area,mean);
		setResult(i+1, j-1, mean);
	}
}

//selectImage(ID);

//dir = getDirectory("image"); 
//dir = getDirectory(ID);

//SAVE RESULTS
//dir="C:/Users/Guan/Desktop/"
//name = getTitle; 
//index = lastIndexOf(name, "."); 
//if (index!=-1) name = substring(name, 0, index); 
//name = name + "-measure.txt"; 
//saveAs("Measurements", dir+name); 

saveAs("Measurements", dir+name); 

selectWindow("Mask");close();
selectWindow("MaskTemp");close();
selectWindow("MAX_Result of 2");close();
selectImage(ID1);close();
selectImage(ID2);
setBatchMode(false);
selectImage(ID2);












////////////////////////////////////
/////       GET PERCENTILE   //////
///////////////////////////////////
function getpercentile(imagetitle,percentile){
	selectWindow(imagetitle);
	nBins=256;
	getStatistics(area, mean, min, max, std);
	getHistogram(values, counts, 256); 
	
	//create a cumulative histogram 
	cumHist=newArray(nBins); 
	cumHist[0]=counts[0]; 
	for (i=1; i<nBins; i++){ cumHist[i]=counts[i]+cumHist[i-1]; } 
	
	//normalize the cumulative histogram 
	normCumHist = newArray(nBins); 
	for (i=0; i<nBins; i++){ normCumHist[i]=cumHist[i]/cumHist[nBins-1]; } 
	
	// find the percentile
	i=0; 
	while (normCumHist[i]<percentile) {i=i+1;}
	prctilevalue=values[i];
	
	return prctilevalue;
}
/////End of function

///////////////////////////////////////////////////////
/////    PERCENTILE BASED INTENSITY CORRECTION   //////
///////////////////////////////////////////////////////

function getprctintmean(imagetitle,lowpercentile,highpercentile,nBins){
	selectWindow(imagetitle);
	//nBins=256;
	getStatistics(area, mean, min, max, std);
	getHistogram(values, counts, nBins); 
	
	//create a cumulative histogram 
	cumHist=newArray(nBins); 
	cumHist[0]=counts[0]; 
	for (i=1; i<nBins;i++){ cumHist[i]=counts[i]+cumHist[i-1]; } 
	
	//normalize the cumulative histogram 
	normCumHist = newArray(nBins); 
	for (i=0; i<nBins;i++){ normCumHist[i]=cumHist[i]/cumHist[nBins-1]; } 
	
	// find the percentile
	i=0; 
	while (normCumHist[i]<lowpercentile) {i=i+1;}
	j=0;
	while (normCumHist[j]<highpercentile) {j=j+1;}

	//find the mean of selected interval
	sumvalue=0;sumcount=0;
	for (l=i;l<j+1;l++){
		sumvalue=sumvalue+values[l]*counts[l];
		sumcount=sumcount+counts[l];
	}
	mean=sumvalue/sumcount;

	return mean;
}



//////////////////////////////////////////////////
/////     Convex hull background remover    //////
//////////////////////////////////////////////////
function hullbk(imagetitle){
selectWindow(imagetitle);
img=getTitle();
getDimensions(width, height, channels, slices, frames);
run("Duplicate...", "title=HULL duplicate range=1-"+nSlices);
run("Duplicate...", "title=FOREGROUND duplicate range=1-"+nSlices);

for (x=0;x<width;x++){
	for(y=0;y<height;y++){

showProgress(x/width);

////enter x,y loop
//get intensity of each pixel
int=newArray(slices);
hullx=newArray(0);
hully=newArray(0);

selectWindow(img);
for(s=0;s<slices;s++){
	setZCoordinate(s);
	int[s]=getPixel(x,y);}

s0=0;
hullx=Array.concat(hullx,0);
hully=Array.concat(hully,int[0]);

while(s0<slices-1){
dint=newArray(slices-1-s0);
for(s=s0+1;s<slices;s++){
	dint[s-s0-1]=(int[s]-int[s0])/(s-s0);}
	
dintr=Array.rankPositions(dint);
k=dintr[0];
s0=k+s0+1;

hullx=Array.concat(hullx,s0);
hully=Array.concat(hully,int[s0]);
}
	

//interpolation
selectWindow("HULL");
setZCoordinate(0);;
setPixel(x,y,hully[0]);

selectWindow("FOREGROUND");
setZCoordinate(0);;
setPixel(x,y,int[0]-hully[0]);

for(i=1;i<hullx.length;i++){
	for(j=hullx[i-1];j<=hullx[i];j++){
		selectWindow("HULL");
		setZCoordinate(j);
		bk=hully[i-1]+(hully[i]-hully[i-1])*(j-hullx[i-1])/(hullx[i]-hullx[i-1]);
		setPixel(x,y,bk);

		selectWindow("FOREGROUND");
		setZCoordinate(j);
		fg=int[j]-bk;
		setPixel(x,y,fg);
	}
}

selectWindow("HULL");
selectWindow("FOREGROUND");
//end of x ,y loop		
}}

}

//////////////////////////////////////////////////
/////     correct fluorescence fluctuation   //////
//////////////////////////////////////////////////
function corprctint(image2cor,corbaseslices){
selectWindow(image2cor);
prctintmean=newArray(nSlices);
for (i=1;i<nSlices+1;i++){
	selectWindow(image2cor);
	setSlice(i);
	prctintmean[i-1]=getprctintmean(image2cor,0.4,0.9,256);
}


for (i=1+corbaseslices;i<nSlices+1-corbaseslices;i++){
	selectWindow(image2cor);
	setSlice(i);
	cummean=0;
	for(j=1;j<corbaseslices+1;j++){
		cummean=cummean+prctintmean[i-j-1];
		cummean=cummean+prctintmean[i+j-1];
	}
	cormean=cummean/corbaseslices/2;
	corvalue=cormean/prctintmean[i-1];
	run("Multiply...", "value="+corvalue+" slice");}
}