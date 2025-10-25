// This code remixes https://www.thingiverse.com/thing:6026672 to create a 2D laser cut template. result found in PuzzleRootieTootie2D.svg
// https://openscad.org/documentation.html#language-reference
// Puzzle Design: John Featherly
// OpenSCAD code: Shawn Featherly 20230718

// width of the unit square in mm
size_of_unit = 30;

/* [Hidden] */
// Remaining variables are hidden from Thingiverse

// shorthand for the size_of_unit variable
unt = size_of_unit;

// relative size of dovetail joint
doveSize = unt/20;

// shorthand literal for square root of 3
rt3 = sqrt(3);

// how far from the edge most connection pegs will be placed. simplified ((2-(2/SQRT(3))) - 1/SQRT(3))/2
peg_offset = (2*unt-unt*rt3)/2;

// size all polygons
polygon2 = [[0,0],[0,unt],[unt/rt3,0]];
polygon3 = [[0,0],[0,unt],[unt-unt/rt3,unt],[unt,0]];
polygon5 = [[0,0],[0,unt*rt3 - unt],[unt - unt/rt3,0]];
polygon6 = [[0,0],[0,unt],[2*unt/rt3 - unt,unt],[(unt + unt/rt3)/2,(3*unt - unt*rt3)/2],[unt - unt/rt3,0]];

// distance from acute angle of polygon3 to center of peg to be recieved by polygon1(unit square)
poly3hypotnuseMale = peg_offset + (unt - unt/rt3);

// largest width of polygon6
poly6width = ((unt + unt/rt3)/2);

// builds a set of points (pts) as a polygon and rotates them around pivot unt/2
module buildPoly(pts, rotation) {
translate([.5 * unt, .5 * unt, 0]) // remove from pivot
    rotate([0,0,rotation])
        translate([-.5 * unt, -.5 * unt, 0]) // move to pivot
            linear_extrude(height = doveSize) polygon(points=pts);
}

// a dovetail joint
module doveTail(x, y, rotation) {
    tail = doveSize; // tail is depth and half of its width deepest in.
    neck = 3*(doveSize)/4; // neck is opening width along edge.
    dove = [[tail,tail],[tail,-tail],[0,-neck],[-tail,-tail],[-tail,tail],[0,neck]];
    translate([x, y, 0])
        rotate([0,0,rotation])
            linear_extrude(height = 1.1*doveSize, center = false) polygon(points = dove);
}

// polygon1 unit square build & move
module piece1() {
    translate([unt, 0, 0])
        difference() {
            linear_extrude(height = doveSize)
                square(unt);
        
            // symetrically place peg females all around unit square
            doveTail(0,peg_offset,0);
            doveTail(0,unt-peg_offset,0);
            doveTail(unt,peg_offset,0);
            doveTail(unt,unt-peg_offset,0);
            doveTail(peg_offset,0,90);
            doveTail(unt-peg_offset,0,90);
            doveTail(peg_offset,unt,90);
            doveTail(unt-peg_offset,unt,90);
        }
}

module piece2n4hole() {
    union() {
        translate([0, -2*doveSize, 0])
            cube([polygon2[2][0], 2*doveSize, doveSize]);
        doveTail(unt/rt3-peg_offset,0,90);
    }
}

module piece2hole() {
    translate([2*unt, 0, 0])
        piece2n4hole();
}

// polygon3 build & move
module piece3() {
    translate([2 * unt, 0, 0])
        union() {
            difference() {
                buildPoly(polygon3, 180);
    
                doveTail((unt/rt3)-(peg_offset*cos(60)),peg_offset*sin(60),30);
                doveTail((unt/rt3)-((unt-peg_offset)*cos(60)),((unt-peg_offset)*sin(60)),30);
            }

            doveTail(unt-peg_offset,0,90);
            // SOH CAH TOA
            doveTail(poly3hypotnuseMale*cos(60),unt-(poly3hypotnuseMale*sin(60)),30);
        }
}

// polygon4 is the same as polygon2
module piece4hole() {
translate([unt, 0, 0])
    mirror([1,0,0])
        piece2n4hole();
}

// polygon5 build & (guesstimate) move
module piece5() {
//translate([unt, unt, 0])
//    rotate([0,0,60])
  //  translate([-unt+unt/rt3,0,0]) // move pivot to bottom right corner
        union() {
            difference() {
                buildPoly(polygon5, 0);
    
                doveTail((unt - unt/rt3)-(2*unt/rt3-(unt-peg_offset)),0,90);
            }
            doveTail(0,peg_offset,0);
            doveTail(0,(unt*rt3 - unt) - peg_offset,0);
            doveTail((unt - unt/rt3)-(peg_offset*cos(60)),peg_offset*sin(60),30);
            doveTail(peg_offset*cos(60),(unt*rt3 - unt)-(peg_offset*sin(60)),30);
        }
}

module piece5holeLg() {
translate([unt, unt, 0])
    rotate([0,0,60])
        translate([-unt+unt/rt3,0,0]) // move pivot to bottom right corner
            difference() {
                translate([unt-unt/rt3,0,0])
                    rotate([0,0,120])
                        translate([0,-2*doveSize,0])
                            cube([2*unt - 2*unt/rt3, 2*doveSize, doveSize]);
                doveTail((unt - unt/rt3)-(peg_offset*cos(60)),peg_offset*sin(60),30);
                doveTail(peg_offset*cos(60),(unt*rt3 - unt)-(peg_offset*sin(60)),30);
            }
}

module piece5holeSm() {
    polygon5insideDoveX = (unt - unt/rt3)-(2*unt/rt3-(unt-peg_offset));
    polygon5insidePiece = [[0,0],[polygon5insideDoveX,-2*doveSize],[unt - unt/rt3,0]];
    
translate([unt, unt, 0])
    rotate([0,0,60])
        translate([-unt+unt/rt3,0,0]) // move pivot to bottom right corner
            union() {
                buildPoly(polygon5insidePiece, 0);
                doveTail(polygon5insideDoveX,0,90);
            }
}

// polygon6 build & move
module piece6 () {
translate([0, 0, 0])
    union() {
        difference() {
            buildPoly(polygon6, 0);
            
            // 2 females to mate polygon5
            doveTail((2*unt/rt3 - unt)+(peg_offset*sin(60)),unt-(peg_offset*cos(60)),60);
            doveTail(poly6width-(peg_offset*sin(60)),(3*unt - unt*rt3)/2+(peg_offset*cos(60)),60);
            
            // 1 female to mate polygon2or4
            doveTail((unt - unt/rt3)+(peg_offset*cos(60)),peg_offset*sin(60),-30);
        }
        
        // pegs going into polygon1 (unit square)
        doveTail(0,peg_offset,0);
        doveTail(0,unt-peg_offset,0);
        doveTail(0,unt-peg_offset,0);
        
        // peg going into polygon3
        doveTail((unt - unt/rt3)-(2*unt/rt3-(unt-peg_offset)),0,90);
        
        // 1 male to mate polygon2or4
        doveTail(unt-poly3hypotnuseMale*cos(60),unt-(poly3hypotnuseMale*sin(60)),-30);
    }
}

module puzzle2d() {
    piece1();
    piece2hole();
    piece3();
    piece4hole();
    piece5holeSm();
    piece5holeLg();
    piece6();
}

// prepare shape for laser cutter
projection()
    translate([doveSize,doveSize,0])
        puzzle2d();
    