// Thingiverse link: TBD
// author: Shawn Featherly

// width of the panel in mm
LabelWidth = 120;//6 * 25; // inches * 25 = mm

// inner height of the shelf brim that the pegs will snap inside
ClampHeight = 15; // inces * 25 = mm

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

module LabelPanel()
{
  hollowRadius = ClampHeight/2;
  difference()
  {
    translate([0, -LabelHeight/2, 0])
      cube([LabelWidth,LabelHeight,LabelDepth]);
  
    // elliptical cut-out from the back of the panel to save filament
    translate([-1,0,LabelDepth])
      rotate([0,90,0])
        scale([.3,1,1])
          cylinder(LabelWidth+2,hollowRadius,hollowRadius);
    
    // center is single layer of filament, used only for bed adhesion
    translate([PinWidth, -(ClampHeight-PinRadius)/2, 0.2]) // 0.2 is typical layer of Prusa M4
      cube([LabelWidth-2*PinWidth,ClampHeight-PinRadius,LabelDepth]);
  }
}

module PaperGap()
{
  translate([0,LabelHeight/2-1.2*DepthForPaper,0])
    rotate([35,0,0])
      translate([-1,0,-GapForPaper])
        cube([LabelWidth+2,DepthForPaper,GapForPaper]);
    
  translate([0,-(LabelHeight/2-1.2*DepthForPaper),0])
    rotate([-35,0,0])
      translate([-1,-DepthForPaper,-GapForPaper])
        cube([LabelWidth+2,DepthForPaper,GapForPaper]);
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
