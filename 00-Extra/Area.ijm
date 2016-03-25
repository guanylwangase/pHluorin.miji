dir=getDirectory("Choose a Directory");
list=getFileList(dir);
//print(dir);
//Array.print(list);
run("Set Measurements...", "area display redirect=None decimal=3");

for(i=0;i<list.length;i+=1){
	open(dir+list[i]);
	img=getTitle();
	getDimensions(width, height, channels, slices, frames);
	
	waitForUser("Click OK to Run AutoThreshold");
	selectWindow(img);
	run("Threshold...");
	setAutoThreshold("Li dark");
	doWand(round(width/2), round(height/2));
	resetThreshold();

	waitForUser("Manually Adjust ROI");
	run("Measure");
	close();
}
saveAs("Results", dir+"area.txt");