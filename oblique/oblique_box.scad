use <roundedcube.scad>
use <boards.scad>

$incolor = 1;
$knob = 0;
$cases = 1;
$boards = 1;
$alpha = 0.5;
$mounts = 0;
depth = 70;
width = 90;
height = 50;
bottom_height = 15;
thickness = 1.5;
radius = 2;
bottom_height = 15;
lod = 64;
$fs = 0.01;


module case_envelope(depth, width, radius) {
    roundedcube([depth, width, 90], false, radius=radius, "z");
}

module case_bottom() {
    intersection() {
        difference() {
            case_envelope(depth, width, radius);
            translate([thickness, thickness, thickness])
                case_envelope(depth-thickness*2, width-thickness*2, radius/thickness);
        }
        cube([depth, width, bottom_height]);
    }
}

module top_lcd_cutout() {
    translate([14.4,10.5,-thickness/2])
        roundedcube([61, 14.4, thickness*2], radius=2);
}

 module top_button_panel() {
     cube([depth+20, width, thickness]);
 }
 
 module fillet(r) {
   offset(r = -r) {
     offset(delta = r) {
       children();
     }
   }
}


module case_assembly() {
    // top section
    intersection() {
        case_envelope(depth, width, radius);
        union() {
            translate([0,0,57])
                rotate([0,45,0])
                    top_lcd_panel();
            translate([0,0,34])
                rotate([0,15,0])
                    top_button_panel();
        }
    }   
    case_bottom();
}


module base_outline() {
        union() {
            fillet(-radius)
              fillet(radius)
                polygon([[0,0], [0,20], [40,30], [60,50], [70,50], [70,0], [0,0]]);
            square([depth, 10]);
        }
}

module side_section() {
    rotate([90,0,0])
    linear_extrude(width)
        difference() {
            base_outline();
            offset(-thickness) base_outline();
        }
}


module outer_case_hull() {
    union() {
        hull()
            for(x = [0: width-radius*2: width])
                translate([x+radius, 0, 0])
                    for(pos = [[0,0], [0,20], [35,30], [35,0]])
                        translate([0, pos[0]+radius, pos[1]+radius])
                            sphere(radius);                    
        hull()
            for(x = [0: width-radius*2: width])
                translate([x+radius, 0, 0])
                    for(pos = [[35,30], [55,50], [depth-radius*2,50], [depth-radius*2,0], [35,0]])
                        translate([0, pos[0]+radius, pos[1]+radius])
                            sphere(radius);
        roundedcube([width, depth, 10], false, radius=radius, "z");
    }
}

module inner_case_hull() {
    union() {
        hull()
            for(x = [thickness: width-radius-thickness*2: width])
                translate([x+radius/2, 0, 0])
                    for(pos = [[0,0], [0,20-thickness/2], [35,30-thickness/2], [35,0]])
                        translate([0, pos[0]+radius/2+thickness, pos[1]+radius/2+thickness])
                            sphere(radius/2);                    
        hull()
            for(x = [thickness: width-radius-thickness*2: width])
                translate([x+radius/2, 0, 0])
                    for(pos = [[35,30-thickness/2], [55,50-thickness/2], [depth-radius*2-thickness/2,50-thickness/2], [depth-radius*2-thickness/2,0], [35,0]])
                        translate([0, pos[0]+radius/2+thickness, pos[1]+radius/2+thickness])
                            sphere(radius/2);
    }
}

module case_hull() {
    difference() {
        difference() {
            outer_case_hull();
            inner_case_hull();
        }
    }
}

module case_bottom() {
    intersection() {
        case_hull();
        cube([width, depth, bottom_height]);
    }
}

module position_lcd() {
    translate([0,35,30])
        rotate([45,0,0])
            children();
}

module case_top() {
    difference() {
        intersection() {
            case_hull();
            translate([0, 0, bottom_height])
                cube([width, depth, height]);
        }
        union() {
            position_lcd()
                    top_lcd_cutout();
        }
    }
    if($boards)
        position_lcd()
            translate([85,35,-8])
                rotate([0,0,180])
                    lcd_1602a();
}
//case_bottom();


intersection() {
    case_top();
}
