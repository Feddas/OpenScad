// Thingiverse link: TBD
// author: Shawn Featherly

// width of the panel in mm. This should be a multiple of 60. Because almost all wire shelves have a 60mm frequency for their zig-zag brace.
LabelWidth = 120;

// inner height of the shelf brim that the 4 pegs will snap inside in mm. minimum usable size is 6.5mm.
ClampHeight = 16;

/* [Hidden] */
// Remaining variables are hidden from Thingiverse

GapForPaper = 1; // mm
DepthForPaper = 4;
LabelDepth = 3.2;
LabelHeightOverClamp = 4;
LabelHeight = ClampHeight + LabelHeightOverClamp + LabelHeightOverClamp;

PinHeight = 6;
PinWidth = 5;
PinRadius = 2;

difference()
{
  LabelPanel();
  PaperGap();
}

FourPins();

module LabelPanel()
{
  widthInsidePins = LabelWidth-2*PinWidth;

  difference()
  {
    translate([0, -LabelHeight/2, 0])
      cube([LabelWidth,LabelHeight,LabelDepth]);

    // Cut away just enough between pin gap to give pins some spring
    translate([-1, -ClampHeight/2,1.2])
      cube([LabelWidth+2,ClampHeight,LabelDepth]);

    // center is single layer of filament, used only for bed adhesion
    translate([PinWidth, -(ClampHeight-PinRadius)/2, 0.2]) // 0.2 is typical layer of Prusa M4
      cube([widthInsidePins,ClampHeight-PinRadius,LabelDepth]);

    // slope above PaperGap()
    translate([PinWidth,(ClampHeight-PinRadius)/2,.4])
      rotate([35,0,0])
        cube([widthInsidePins,DepthForPaper+LabelHeightOverClamp,LabelDepth]);    
    translate([PinWidth,-(ClampHeight-PinRadius)/2,.4])
      rotate([-35,0,0])
        translate([0,-(DepthForPaper+LabelHeightOverClamp),0])
          cube([widthInsidePins,DepthForPaper+LabelHeightOverClamp,LabelDepth]);
  }

  // Label part by engraving its ClampHeight
  translate([LabelWidth/2,0,0.2])
    scale([-1,1,1]) //mirror
      linear_extrude(height=.2, convexity=4)
        text
        (
          str(ClampHeight), 
          size=0.8*ClampHeight,
          font="Bitstream Vera Sans",
          halign="center",
          valign="center"
        );
}

module PaperGap()
{
  translate([0,LabelHeight/2-1.2*DepthForPaper,0])
    rotate([35,0,0])
      translate([-1,0,-GapForPaper])
      {
        // paper gap
        cube([LabelWidth+2,DepthForPaper,GapForPaper]);

        // commented out to keep label flush with top of wire shelf
        // trim non-functional corner
        //translate([0,DepthForPaper+1,-(LabelDepth-GapForPaper)/2])
        //  cube([LabelWidth+2,LabelHeightOverClamp,LabelDepth]);
      }

  translate([0,-(LabelHeight/2-1.2*DepthForPaper),0])
    rotate([-35,0,0])
      translate([-1,-DepthForPaper,-GapForPaper])
      {
        // paper gap
        cube([LabelWidth+2,DepthForPaper,GapForPaper]);

        // trim non-functional corner
        translate([0,-DepthForPaper-1,-(LabelDepth-GapForPaper)/2])
          cube([LabelWidth+2,LabelHeightOverClamp,LabelDepth]);
      }
}

module FourPins()
{
  translate([PinWidth/2, ClampHeight / 2, 0])
    Pin();
  translate([PinWidth/2, -ClampHeight / 2, 0])
    rotate([0,0,180])
      Pin();

  translate([LabelWidth-PinWidth/2, ClampHeight / 2, 0])
    Pin();
  translate([LabelWidth-PinWidth/2, -ClampHeight / 2, 0])
    rotate([0,0,180])
      Pin();
}

module Pin()
{
  translate([-PinWidth/2,-1.5*PinRadius,LabelDepth])
  {
    translate([0, 0, -.8 * LabelDepth])
      cube([PinWidth, 1.5*PinRadius, PinHeight + .8 * LabelDepth]);

    translate([0, 0.98 * 2, 0.93 * PinHeight]) // 0.98 & 0.93 align the 7-segment of the circle with the cube
    {
      rotate([0,90,0])
      {
        cylinder(PinWidth, PinRadius, PinRadius);

        // wedge below cylinder
        rotate_extrude(angle=20, convexity=10)
          square([PinHeight, PinWidth]);
      }
    }
  }
}
