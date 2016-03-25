img=getTitle();
dir=getDirectory("image");
dirp=File.getParent(dir)+File.separator;

//t0=getNumber("nslices to ignore @ start", 10);
//t1=getNumber("nslices to ignore @ end", 30);
//td=getNumber("nslices of substack", 241);
t0=10;
t1=30;
td=241;

////1ST LOOP
ta=1;
tb=ta+td-1;
n=1;

selectWindow(img);
run("Make Substack...", "  slices="+ta+"-"+tb);
saveAs("Tiff", dirp+img+"-"+n+".tiff");
close();


///loop
while (tb+td<=nSlices){
	n=n+1;
	ta=tb-t0-t1;
	tb=ta+td-1;
	selectWindow(img);
	run("Make Substack...", "  slices="+ta+"-"+tb);
	saveAs("Tiff", dirp+img+"-"+n+".tiff");
	close();
}

close();
