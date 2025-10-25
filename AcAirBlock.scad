// Goal: AC unit window mount for vertical sliding gap. Holds a piece of cardboard above an AC unit to block airflow out the window.
// Result: Abandoned. Needed to print too many of these to test. Seemed unresonable compared to getting a piece of wood cut to size.

// distance the window is opened for the AC to fit inside
WidthOfAcGap = 14.5 * 25; // inches times 2.5 = mm

// depth of the window frame. How wide the opening is that the window slides into.
WidthOfFrame = 1.25 * 25;

// thickness of the edge of the sliding window. This fits inside of WidthOfFrame.
WidthOfWindow = 1 * 25;

// How deep the window slides into the frame
DepthFrame = 1.125 * 25;

// How thick the rectangular sheet of cardboard or wood is that will be inserted into the couplers.
ThicknessFillerMaterial = 4;

/* [Hidden] */
// Remaining variables are hidden from Thingiverse

// height of stackable blocks
BlockHeight = 20; // mm

// thickness of snap to above
SnapDepth = 4;

// Height of snap to above
SnapHeight = 10;

//
// End of variables - Start of shapes
//

// The side meant to go into the frame of the window
translate([0, 2*WidthOfFrame, 0])
  Male();

// the side meant to recieve the window edge
Female();

//StackableBlock(WidthOfWindow);

// https://youtu.be/c1LKQaFIPNA use cornerRadius of 0.1 for sharp corners
module rightTriangle(side1, side2, extrudeHeight, cornerRadius){
  translate([cornerRadius,cornerRadius,0])
    hull(){
      cylinder(r=cornerRadius,h=extrudeHeight);
      translate([side1-cornerRadius*2,0,0]) cylinder(r=cornerRadius, h=extrudeHeight);
      translate([0,side2-cornerRadius*2,0]) cylinder(r=cornerRadius, h=extrudeHeight);
    }
}

module Male(){
  difference(){
    rotate([0,0,180])
      translate([-(WidthOfAcGap), -WidthOfWindow/2, 0])
        StackableBlock(WidthOfWindow);
    translate([DepthFrame, 0, -SnapHeight/2])
      FillerMaterial();
  }
}

module Female(){
  difference(){
    translate([0,-WidthOfFrame/2,0])
      StackableBlock(WidthOfFrame);
    translate([DepthFrame, 0, -SnapHeight/2])
      FillerMaterial();
  }
}

// build coupler to receieve sheet of cardboard or wood to be inserted.
//  inspiration: https://www.thingiverse.com/thing:4404861
module FillerMaterial() {
  difference(){
    translate([0,-WidthOfWindow,0])
      cube([2*WidthOfAcGap, 2 * WidthOfWindow, 2 * BlockHeight]);
    MaterialSnap();
  }
}


module MaterialSnap(){
  translate([-SnapHeight/2, ThicknessFillerMaterial/2, -BlockHeight/2])
    cube([1.5*SnapHeight, SnapDepth, 3*BlockHeight]);
  translate([-SnapHeight/2, -(ThicknessFillerMaterial/2 + SnapDepth), -BlockHeight/2])
    cube([1.5*SnapHeight, SnapDepth, 3*BlockHeight]);
}

module StackableBlock(blockWidth) {
  // snap to block above
  translate([0, -SnapDepth, BlockHeight - SnapHeight/2])
    difference(){
      cube([WidthOfAcGap, SnapDepth, SnapHeight]);
      translate([WidthOfAcGap+1,-SnapDepth,0])
        rotate([0, -90, 0])
          rightTriangle(2*SnapDepth,2*SnapDepth,WidthOfAcGap+2,0.1);
    }
  translate([0, blockWidth, BlockHeight - SnapHeight/2])
    difference(){
      cube([WidthOfAcGap, SnapDepth, SnapHeight]);
      translate([-1,2*SnapDepth,0])
        rotate([0, -90, 180])
          rightTriangle(2*SnapDepth,2*SnapDepth,WidthOfAcGap+2,0.1);
    }
  
  // snap to sliding window
  translate([-SnapHeight/2, -SnapDepth, SnapHeight/2])
    cube([SnapHeight, SnapDepth, BlockHeight]);
  translate([-SnapHeight/2, blockWidth, SnapHeight/2])
    cube([SnapHeight, SnapDepth, BlockHeight]);

  // main block
  cube([WidthOfAcGap + DepthFrame, blockWidth, BlockHeight]);
}
