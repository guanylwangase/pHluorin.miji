/////////////This line is IMPORTANT, DO NOT delete//////////////////
run("Clear Results"); 
////////////////////////////////////////////////////////////////////////
setBatchMode(true);

ID = getImageID();
title=getTitle();

dirtemp="D:/phl/"
name ="templist.txt";
namexy ="tempxy.txt";

diroutput="D:/phl/"


text = File.openAsString(dirtemp+name);
text2 = split(text,"\t");

roiManager("Save", diroutput+title+"-rois-o.zip");

roiManager("count");
indexes=newArray();

//for (i=0;i<text2.length;i++){
//	indexes = Array.concat(indexes,text2[i]);
//}
j=0;
indexesdel=newArray();
indexesdel2=newArray();
indexesj=newArray();

for (i=0;i<roiManager("count");i++){

	if (parseInt(text2[j]) != i+1)
	{
	indexesdel = Array.concat(indexesdel,i);
	indexesdel2 = Array.concat(indexesdel2,i+1);
	indexesj = Array.concat(indexesj,j);
	}
	else
	{
	if (j<text2.length-1){
	j=j+1;
	}
	}
}

//Array.print(indexesj);
//Array.print(indexesdel2);
roiManager("select", indexesdel);

roiManager("delete");

//roiManager("Save","");
roiManager("count");

selectWindow("Log"); run("Close");

if (roiManager("count") > 0 ){

	run("Set Measurements...", "  centroid redirect=None decimal=1");
	
	for (i=0;i<roiManager("count");i++){
		roiManager("select",i);
		roiManager("Measure");
	}
	
	saveAs("Results", dirtemp+namexy);
	
	//////////////////////////draw
	//selectWindow("MAX_Result of 2");
	selectImage(ID);
	getDimensions(width, height, channels, slices, frames);
	
	newImage("Spot", "8-bit White", width, height, 1);
	setForegroundColor(0,0,0);
	setBackgroundColor(255,255,255);
	
	for (i=0;i<roiManager("count");i++){
		selectWindow("Spot");
		roiManager("select",i);
		
		run("Draw");
	}
	setForegroundColor(255,255,255);
	setBackgroundColor(0,0,0);
	
	//////////////////////save rois
	roiManager("Save", diroutput+title+"-rois.zip");
}



//selectWindow("Results"); run("Close");

setBatchMode(false);

selectImage(ID);



