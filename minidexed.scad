use <roundedcube.scad>
use <boards.scad>

$incolor = 1;
$knobs = 1; 
$cases = 1; // render cases
$pcbs = 1; // render pcbs
$alpha = 1;
$mounts = 1; // render PCB mounts
depth = 70;
width = 90; 
thickness = 1.5; // wall thickness
radius = 2; // corner radius
lod = 64;
$top = 0; // top half or bottom half
$fs = 0.01;


module wedge(thickness, depth, sx=1, sy=1) {
   linear_extrude(thickness) {
        scale([sx, sy])
            polygon([[0,0], [0,depth], [0.4, depth], [depth,0]]);
   }
}

module case_envelope() {
    translate([0,0,-2])
        roundedcube([depth, width, 34], radius=radius*2);
}

module sd_card_inset(depth=11) {
    $fn = lod*2;
    radius = 30;
    rotate([0, 0, -90])
        translate([0, 0, -radius+thickness*2])
            intersection() {
                translate([0,-depth-thickness*2,radius-5])
                    cube(depth*2);
                 rotate([90,0,0]) {
                difference() {
                    cylinder(depth+thickness*2,radius+thickness,radius+thickness);
                    translate([0,0,thickness])
                        cylinder(depth,radius,radius);
                }
            } 
        }
}

module bottom_case() {
	difference() {
		intersection() {
			case_envelope();
            translate([0,0,-2])
			  cube([100,100,22]);
		}
		translate([thickness, thickness, thickness-2]) {
			roundedcube([depth-(thickness*2), width-(thickness*2), 40], radius=radius);
		}
        // Holes
        union() {
            $fn=lod;
            // HDMI
            translate([depth-thickness*2-1, 29.2, 4.5])
                roundedcube([thickness*2+2,8.8,3.5], radius=1);
            // micro-USB
            translate([depth-thickness*2-1, 47.1, 4.5])
                roundedcube([thickness*2+2,16,7.4], radius=1);
            // USB
            translate([28.6, 87.1, 4.6])
                roundedcube([16,16,8.6], radius=1);
            // LED
            translate([depth-thickness*2-1, 24, 6])
                rotate([0,90,0])
                    cylinder(thickness*2+2, 1, 1);
            // DAC audio
            translate([depth-thickness*2-1, 14, 7.9])
                rotate([0,90,0])
                    cylinder(thickness*2+2, 3, 5);
            // PWM audio
            translate([depth-thickness*2-1, 76.5, 7.9])
                rotate([0,90,0])
                    cylinder(thickness*2+2, 3, 5);
            // MIDI IN protoboard
            translate([9, 88.1, 9.6])
                rotate([0,90,90])
                    cylinder(thickness*2+2, 3, 5);
        }
        // SD card cutout
        translate([31.5,10,-2])
            cube([14,16,4]);
        // bottom grill
        for(y=[23: 6: 75])
            translate([6, y, -3])
                rotate([0,0,45])
                    roundedcube([12,2.5,8], radius=1);
	}
    // DAC supports
    union() {
        translate([43, 7, thickness/2]) {
            translate([0,0,-2])
            cube([25.5,2.5,11.5]);
            translate([0,0,9.5])
                cube([25.5,1.5,3]);
            translate([0,1.5,9.5])
                cube([1.5,4.0,3]);
        }
        translate([43,9.5,10.3])
            rotate([90,90,90])
                wedge(8,3);
        translate([68.5,37,10.6]) {
            union() {
                translate([-2.5,3.5,0])
                    cube([2.5,2.5,2.5]);
                rotate([0,90,90])
                    wedge(6,2.5);
            }
        }
    }
    // Encoder support
    translate([3,20,thickness-2]) {
        cube([25, 2, 4]);
    }

    // SD Card Inset
    translate([47,22,1.5])
        sd_card_inset(14);
    // Snap fit
    snap_fit();
}

module snap_fit(diameter=0.5) {
    for(x=[thickness,68.5]) {
        translate([x,9,17])
            rotate([-90,0,0])
                cylinder(width-18, diameter, diameter);
    }
    for(y=[thickness,88.5]) {
        translate([9,y,17])
            rotate([90,0,90])
                cylinder(depth-18, diameter, diameter);
    }
}

module top_case() {
    difference() {
        difference() {
            intersection() {
                roundedcube([depth, width, 32], radius=radius*2);
                translate([0,0,20])
                    cube([100,100,20]);
            }
            translate([thickness, thickness, thickness]) {
                roundedcube([depth-(thickness*2), width-(thickness*2), 29], radius=radius);
            }
        }
        top_case_holes();        
        // top grill
        for(y=[32: 5: 80])
            translate([20, y, 30])
                rotate([0,0,-45])
                    roundedcube([22,1,8], radius=0.5);
        translate([25, 77, 30])
            rotate([0,0,-45])
                roundedcube([15,1,8], radius=0.5);
        translate([30, 77, 30])
            rotate([0,0,-45])
                roundedcube([8,1,8], radius=0.5);
        
        // knob cutaway
        translate([15, 15, 25]) 
           cylinder(12, 14, 14);
        translate([-1, -1, 20]) {
               cube([15,30,12]);
               cube([30,15,12]);
        }
    }
    // knob inset
    difference() {
        intersection() {
          case_envelope();
          translate([14,14,20])
            top_case_inset(15,12,14);
        }
        translate([13.5,13.5,18]) {
            cylinder(20, 4, 4);
        }
    }
    // friction grips
    difference() {
        union() {
            translate([thickness,10,20]) {
                rotate([-90,0,0])
                    wedge(10,3,sy=2);
            }
            translate([10,thickness,20]) {
                rotate([0,90,0])
                    wedge(10,3,sx=2);
            }
            for(o=[20: 20: 60]) {
              translate([o-10,width-thickness,20]) {
                rotate([900,-90,0]) {
                    wedge(10,3);
                    rotate([0,0,90])
                        wedge(10,3,sy=2);
                  }
              }
              if(o<50)
                  translate([o+20,thickness,20]) {
                    rotate([0,-90,0]) {
                        wedge(10,3);
                        rotate([0,0,90])
                            wedge(10,3,sy=2);
                      }
                  }     
              translate([thickness,o+10,20]) {
                rotate([-90,-90,0]) {
                    wedge(10,3);
                    rotate([0,0,90])
                        wedge(10,3,sy=2);
                  }
              }
              translate([depth-thickness,o+10,20]) {
                rotate([90,-90,0]) {
                    wedge(10,3);
                    rotate([0,0,90])
                        wedge(10,3,sy=2);
                  }
              }
            }
      }
      snap_fit(0.8);
    }
}

module top_case_inset(radius=15, width=7, padding=4) {
    $fn=lod;
    intersection() {
        cube(radius+thickness);
        difference() {
            cylinder(r=radius+thickness,width);
            translate([0,0,thickness])
                cylinder(r=radius,width);
        }
    }
    translate([-padding,radius,0]) {
        cube([padding,thickness,width]);
        translate([0,-radius-padding,0])
            cube([padding,radius+padding,thickness]);
    }
    translate([radius,-padding,0]) {
        cube([thickness,padding,width]);
        translate([-radius,0,0])
           cube([radius,padding,thickness]);
    }
}

module top_case_holes() {
    translate([58.5,13.5,25])
        rotate([0,0,90]) {
            // Viewing slot
            roundedcube([63, 16.4, 8], radius=2);
            // LCD slot
            translate([-5, -6, -1.5])
                cube([71, 26, 7.5]);
        }
}

translate([12,23,thickness-2]) {
    if($pcbs) 
        translate([0,0,4]) pi_3a();
    if($mounts && !$top)
        pi_3a_mounts(4,4,1.5);
}

translate([68,5,22.1])
  rotate([0,0,90]) {
    if($pcbs)
        lcd_1602a();
    if($mounts && $top &&!$knobs)
        translate([0,0,1.8])
            lcd_1602a_mounts(7,4,1.5);
  }
  
  
if($pcbs)
  translate([4.5,88,15])
    rotate([90,180,90])
      midi_in_protoboard();
  
if($pcbs) 
    translate([68.5,8.5,12.2])
      rotate([0,180,0])
        cjmcu_5102();

translate([3, 3, thickness-2]) {
    if($pcbs)
        translate([0,0,4])
            encoder_hw_040();
    if($mounts && !$top)
        encoder_hw_040_mounts(4,3,1);
}

if($knobs) {
    $fn = lod;
    color("dimgray")
    translate([14, 14, 27])
      difference() {
        translate([0,0,-4])
        rotate_extrude() {
            square([14.5-2,9]);
            translate([14.5-2,7,0])
                circle(2);
            square([14.5,7]);
        }
        translate([5.5, 5.5, 10.5])
            sphere(7);
        translate([0,0,-11]) 
            difference() {
                cylinder(14, 3, 3);
                translate([-3, 1.5, 3.5]) cube([6, 5, 12]);
            }
    }
}
 
 if($cases && $top) 
color("dimgray",$alpha) {
 difference() {
       top_case();
        // top stripes
        for(y=[2: 5: 190])
            translate([0, y, 31.5])
                rotate([0,0,-45])
                    roundedcube([70,1,2], radius=0.8);
  }
  
}

if($cases && !$top) 
   color("teal")
      bottom_case();
