// This code is from https://www.thingiverse.com/thing:6026672
// https://openscad.org/documentation.html#language-reference
// Puzzle Design: John Featherly
// OpenSCAD code: Shawn Featherly 20230718

// width of the unit square in mm
size_of_unit = 30;

// height of all pieces in mm
height_of_pieces = 2.4;

// mm size the 3D slicer will be set at for its print layers. This value is used for spacing between pieces that are meant to slide into one another.
layer_print_size = .3;

/* [Hidden] */
// Remaining variables are hidden from Thingiverse

// thickness of the case
case_size = height_of_pieces;

// shorthand for the size_of_unit variable
unt = size_of_unit;

// shorthand literal for square root of 3
rt3 = sqrt(3);

// how far from the edge most connection pegs will be placed. simplified ((2-(2/SQRT(3))) - 1/SQRT(3))/2
peg_offset = (2*unt-unt*rt3)/2;

// faces on a cylinder https://www.openscad.info/index.php/2020/05/14/cylinder/
$fn=8;

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
module build(pts, rotation) {
translate([.5 * unt, .5 * unt, 0]) // remove from pivot
    rotate([0,0,rotation])
        translate([-.5 * unt, -.5 * unt, 0]) // move to pivot
            linear_extrude(height = height_of_pieces) polygon(points=pts);
}

// a dovetail. tail is width deepest in. neck is opening width along edge.
module dove(tail, neck) {
    dove = [[tail,tail],[tail,-tail],[0,-neck],[-tail,-tail],[-tail,tail],[0,neck]];
    linear_extrude(height = 2*tail, center = true) polygon(points = dove);
}

module pegMale(x, y, rotation) {
    translate([x, y, height_of_pieces/2])
        rotate([0,0,rotation])
            dove(height_of_pieces/2, 3*(height_of_pieces/2)/4);
//          cube([height_of_pieces,height_of_pieces,height_of_pieces], center = true);
}

module pegFemale(x, y, rotation) {
    translate([x, y, height_of_pieces/2])
        rotate([0,0,rotation])
            dove(height_of_pieces/2 + layer_print_size, 3*(height_of_pieces/2)/4 + layer_print_size);
//          cube([height_of_pieces + 2*layer_print_size,height_of_pieces,height_of_pieces + 2*layer_print_size], center = true);
}

module polygon2n4() {
    union() {
        difference() {
            build(polygon2, 0);
    
            pegFemale(unt/rt3-peg_offset,0,90);
            pegFemale(poly3hypotnuseMale*cos(60),unt-(poly3hypotnuseMale*sin(60)),30);
        }

        pegMale(0,peg_offset,0);
        pegMale(0,unt-peg_offset,0);
        // SOH CAH TOA https://youtu.be/l5VbdqRjTXc
        pegMale((unt/rt3)-(peg_offset*cos(60)),peg_offset*sin(60),30);
        pegMale((unt/rt3)-((unt-peg_offset)*cos(60)),((unt-peg_offset)*sin(60)),30);
    }
}

// unit square build & move
translate([-1.1 * unt, 2.4 * unt, 0])
    difference() {
        linear_extrude(height = height_of_pieces)
            square(size_of_unit);
        
        // symetrically place peg females all around unit square
        pegFemale(0,peg_offset,0);
        pegFemale(0,unt-peg_offset,0);
        pegFemale(unt,peg_offset,0);
        pegFemale(unt,unt-peg_offset,0);
        pegFemale(peg_offset,0,90);
        pegFemale(unt-peg_offset,0,90);
        pegFemale(peg_offset,unt,90);
        pegFemale(unt-peg_offset,unt,90);
    }
    
// polygon2 build & move
translate([-1.1 * unt, 1.2 * unt, 0])
    polygon2n4();
    
// polygon3 build & move
translate([-1.05 * unt, 1.3 * unt, 0])
    union() {
        difference() {
            build(polygon3, 180);
    
            pegFemale((unt/rt3)-(peg_offset*cos(60)),peg_offset*sin(60),30);
            pegFemale((unt/rt3)-((unt-peg_offset)*cos(60)),((unt-peg_offset)*sin(60)),30);
        }

        pegMale(unt-peg_offset,0,90);
        // SOH CAH TOA
        pegMale(poly3hypotnuseMale*cos(60),unt-(poly3hypotnuseMale*sin(60)),30);
    }

// polygon4 is the same as polygon2
translate([-.05 * unt, 0, 0])
    mirror([1,0,0])
        polygon2n4();

// polygon5 build & (guesstimate) move
translate([-.3 * unt, .72 * unt, 0])
    rotate([0,0,60])
        union() {
            difference() {
                build(polygon5, 0);
    
                pegFemale((unt - unt/rt3)-(2*unt/rt3-(unt-peg_offset)),0,90);
            }
            pegMale(0,peg_offset,0);
            pegMale(0,(unt*rt3 - unt) - peg_offset,0);
            pegMale((unt - unt/rt3)-(peg_offset*cos(60)),peg_offset*sin(60),30);
            pegMale(peg_offset*cos(60),(unt*rt3 - unt)-(peg_offset*sin(60)),30);
        }

// polygon6 build & move
translate([-1.2 * unt, .05 * unt, 0])
    union() {
        difference() {
            build(polygon6, 0);
            
            // 2 females to mate polygon5
            pegFemale((2*unt/rt3 - unt)+(peg_offset*sin(60)),unt-(peg_offset*cos(60)),60);
            pegFemale(poly6width-(peg_offset*sin(60)),(3*unt - unt*rt3)/2+(peg_offset*cos(60)),60);
            
            // 1 female to mate polygon2or4
            pegFemale((unt - unt/rt3)+(peg_offset*cos(60)),peg_offset*sin(60),-30);
        }
        
        // pegs going into polygon1 (unit square)
        pegMale(0,peg_offset,0);
        pegMale(0,unt-peg_offset,0);
        pegMale(0,unt-peg_offset,0);
        
        // peg going into polygon3
        pegMale((unt - unt/rt3)-(2*unt/rt3-(unt-peg_offset)),0,90);
        
        // 1 male to mate polygon2or4
        pegMale(unt-poly3hypotnuseMale*cos(60),unt-(poly3hypotnuseMale*sin(60)),-30);
    }

// Dead code to Test: length of poly2&4 slim corner
//translate([0,30,0])
//    rotate([90,0,30])
//        cylinder(h=2*unt/rt3-(unt-peg_offset),r=1); // length of poly2&4 slim corner
//        cylinder(h=poly3hypotnuseMale,r=2); // length of the hypotnuse along polygon3's male so that it can be recieved by polygon1(unit square)
    