roiManager("select", 0);
name = Roi.getName();

fileName = getTitle();
filePath = "/Users/thomah07/Desktop/local_copies_for_analysis/2026_08_02_slow_recovery_replicate_3/";
fileName_mod = split(fileName, ".");
roiManager("Save", filePath+"ROIs/"+fileName_mod[0]+"_"+name+"_ROIs.zip");



Stack.getDimensions(width, height, channels, slices, frames);
nTimepoints =  frames;

n = roiManager("count");
frames = newArray(n);

for (i = 0; i < n; i++) {
    roiManager("select", i);
    Roi.getPosition(c, z, t);   // fills c, z, t for this ROI
    frames[i] = t;              // frame position
}


order = Array.rankPositions(frames); // sort ROIs by frame order
run("Clear Results");

for (k = 0; k < n; k++) {
    i = order[k];
    startFrame = frames[i];

    if (k < n-1) {
        endFrame = frames[order[k+1]] - 1;
    } else {
        endFrame = nTimepoints;
    }

    for (f = startFrame; f <= endFrame; f++) {
        roiManager("select", i);
        Stack.setPosition(1, 1, f);   // actually moves display to channel 2, slice 1, frame 1
		run("Measure");
		Stack.setPosition(2, 1, f);   // actually moves display to channel 2, slice 1, frame 1
		run("Measure");
    }
}

saveAs("Results", filePath+"csv_measurements/"+fileName_mod[0]+"_"+name+"_results.csv");