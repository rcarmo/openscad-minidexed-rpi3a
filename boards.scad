include <connectors.scad>

interf = 0.1;
$incolor = (is_undef($incolor)) ? true : $incolor;
$alpha = (is_undef($alpha)) ? 1 : $alpha;

//------------------------------------------------------------------------
// m25_standard_hole Standard fit M2.5 hole size definition
//------------------------------------------------------------------------
module m25_standard_hole() {
	circle(r=(2.75 / 2), $fn=16);
}

//------------------------------------------------------------------------
// Move copies of children to positions in passed array
//------------------------------------------------------------------------
module array_holes(pos) {
	for (pos=pos) {			
		translate(pos) children();
	}
}

//------------------------------------------------------------------------
// Raspberry Pi Model A+ rev.1.1
//------------------------------------------------------------------------
module pi_3a(heatsink=true) {

    $fn = 32;
    x  = 56;     y = 65;    z = 1.60;  // Measured PCB size
    hx = 11.40; hy = 15.1; hz = 6.15;  // Measured HDMI connector size
    ux = 13.25; uy = 13.8; uz = 6.0;   // Measured USB connector size
    mx =  5.60; my =  7.6; mz = 2.40;  // Measured micro USB power connector size
    boardc = $incolor ? "green" : undef;
    heatc  = $incolor ? "black" : undef;
    cpuc   = $incolor ? "lightgrey" : undef;

    // The origin is the lower face of PCB.
    translate([0, 0, z]) {
        translate([1.0, 7.1, 0])                    pin_headers(2, 20);
        translate([x - hx + 1, 32.0 - (hy / 2), 0]) hdmi_connector(hx, hy, hz);
        translate([x - mx + 1, 10.6 - (my / 2), 0]) microusb_connector(mx, my, mz);
        translate([18, y - 12, 0.8])                usb_connector(ux, uy, uz);
        translate([20.5, 1.4, -z*2])                micro_sd_card();
        translate([17.5, 2.5, 0])                   spi_connector();
        translate([35.5, 44, 0])                    spi_connector();
        
        translate([x - 12.8, 50, 0])                audio_video(12.8);
        translate([x + 2.2, 10.55, 1.2])            rotate(a=270, v=[0, 0, 1]);
        translate([16, 19, 0]) {
            color(cpuc) cube([14.5, 14.5, 1.5]);
            if(heatsink)
                translate([0,0,1.5]) color(heatc) {
                    cube([14.5, 14.5, 1.5]);
                    translate([0,0,1.5]) 
                    for(x=[0: 4.1: 14.5], y=[0: 3.3: 14]) {
                        translate([x,y,0]) cube([2.2, 1.2, 6.5]);
                    }
                }
        }
        translate([0, 0, -z]) {
            color(boardc) linear_extrude(height=z)
                difference() {
                    hull() {
                        translate([  3,   3]) circle(r=3);
                        translate([x-3,   3]) circle(r=3);
                        translate([x-3, y-3]) circle(r=3);
                        translate([  3, y-3]) circle(r=3);
                    }
                    pi_3a_holes();
                }
        }
    }
}

module pi_3a_holes() {
 	off=3.5;
	x=49 + off;
	y=58 + off;
	holes=[
		[off,off], [x, off],
		[off, y],  [x, y]
	];
	
	if ($children > 0) {
		array_holes(pos=holes) children();
	} else {
		array_holes(pos=holes) m25_standard_hole();		
	}
}

module pi_3a_mounts(height=2, hole=2, thickness=2) {
    $fn = 32;
	mountc  = $incolor ? "grey"  : undef;
    pi_3a_holes() {
        color(mountc) linear_extrude(height) difference() {
            circle(r=hole/2 + thickness);
            circle(r=hole/2);
        }
    }
}


//------------------------------------------------------------------------
// 1602A LCD panel 16x2 characters.
//------------------------------------------------------------------------
module lcd_1602a() {
    $fn = 32;
	boardc  = $incolor ? "green"  : undef;
	metalc  = $incolor ? "black"  : undef;
	lcdc  = $incolor ? [64/255, 64/255, 128/255] : undef;

    translate([4.5, 5.5, 1.8])  
        difference() {
            color(metalc) cube([71, 24, 7]);
            translate([3.2, 4.8, 6.5])
                color(lcdc) cube([64.4, 14.4, 8]);
        }
    color(boardc) linear_extrude(height = 1.8) difference() {
        square(size=[80, 36]);
        lcd_1602a_holes() {
            circle(r=3/2);
        }
    }
    translate([33, 3, 4]) 
        rotate([180,0,0]) pin_headers(16,1);
}

module lcd_1602a_holes() {
    holes = [
        [3, 3], [80 - 3, 3],
        [80 - 3, 36 - 3], [3, 36 - 3]
    ];
	
	if ($children > 0) {
		array_holes(pos=holes) children();
	} else {
		array_holes(pos=holes) m25_standard_hole();		
	}
}

module lcd_1602a_mounts(height=2, hole=2.5, thickness=2) {
    $fn = 32;
	mountc  = $incolor ? "grey"  : undef;
    lcd_1602a_holes() {
        color(mountc) linear_extrude(height=height) difference() {
            circle(r=hole/2 + thickness);
            circle(r=hole/2);
        }
    }
}



//------------------------------------------------------------------------
// HW-040 Rotary Encoder
//------------------------------------------------------------------------

module encoder_hw_040() {
    $fn = 32;
	boardc  = $incolor ? "green"  : undef;
	metalc  = $incolor ? "grey"  : undef;
    color(boardc) linear_extrude(height = 1.4) difference() {
        square(size=[26, 18.5]);
        encoder_hw_040_holes() {
            circle(r=2.5/2);
        }
    }
    color(metalc) union() {
        translate([4.5, 4.5, 1.4]) cube([12, 12, 4.5]);
        translate([10.5, 10.5, 8.9]) cylinder(7, 3.5, 3.5, true);
        translate([10.5, 10.5, 12]) cylinder(7, 2, 2, true);
        translate([10.5, 10.5, 13]) difference() {
            cylinder(14, 3, 3);
            translate([-3, 1.5, 3.5]) cube([6, 5, 12]);
        }
    }
    translate([22.5, 17, 3.4]) rotate([0, 0, -90]) pin_right_angle_low(5);
}

module encoder_hw_040_holes() {
    holes = [
        [4.5, 1.7], [19.0, 1.7]
    ];
	
	if ($children > 0) {
		array_holes(pos=holes) children();
	} else {
		array_holes(pos=holes) m25_standard_hole();		
	}
}

module encoder_hw_040_mounts(height=2, hole=2, thickness=2) {
    $fn = 32;
	mountc  = $incolor ? "grey"  : undef;
    encoder_hw_040_holes() {
        color(mountc) linear_extrude(height) difference() {
            circle(r=hole/2 + thickness);
            circle(r=hole/2);
        }
    }
}



//------------------------------------------------------------------------
// HW-575 Dual Linear Pot
//------------------------------------------------------------------------

module fader_hw_575() {
    $fn = 32;
	boardc  = $incolor ? "lightblue"  : undef;
	metalc  = $incolor ? "silver"  : undef;
	feltc   = $incolor ? "black"  : undef;
    color(boardc) linear_extrude(height = 1.4) difference() {
        square(size=[38.8, 117.3]);
        fader_hw_575_holes() {
            circle(r=3.7/2);
        }
    }
    color(metalc) union() {
        translate([3, 20, 1.4]) 
            cube([12.3, 88, 12.3]);
        translate([23.5, 20, 1.4]) 
            cube([12.3, 88, 12.3]);
        translate([8.5, 25, 13.7]) 
            cube([1.4, 6, 10]);
        translate([29, 95, 13.7]) 
            cube([1.4, 6, 10]);
    }
    color(feltc) union() {
        translate([3.2, 20, 13.6]) 
            cube([11.8, 88, 0.2]);
        translate([23.7, 20, 13.6]) 
            cube([11.8, 88, 0.2]);        
    }
    translate([28.3, 14.5, 3.4]) 
       rotate([0,0,180]) {
          pin_right_angle_low(3);
          translate([10,0,0])
              pin_right_angle_low(3);
       }    
}


module fader_hw_575_holes() {
    w = 38.8;
    l = 117.3;
    x = 3.2;
    y = 3.7;
    holes = [
        [x, y], [w-x, y],
        [x, l-y], [w-x, l-y],
    ];
	
	if ($children > 0) {
		array_holes(pos=holes) children();
	} else {
		array_holes(pos=holes) m25_standard_hole();		
	}
}


module fader_hw_575_mounts(height=2, hole=2, thickness=2) {
    $fn = 32;
	mountc  = $incolor ? "grey"  : undef;
    fader_hw_575_holes() {
        color(mountc) linear_extrude(height) difference() {
            circle(r=hole/2 + thickness);
            circle(r=hole/2);
        }
    }
}

//------------------------------------------------------------------------
// CJMCU-5102 DAC
//------------------------------------------------------------------------


module cjmcu_5102() {
    $fn = 32;
	boardc  = $incolor ? "purple"  : undef;
	chipc   = $incolor ? "black"  : undef;
    color(boardc) linear_extrude(height = 1.6) 
        square(size=[23.6, 31.6]);
    translate([14.7,9,1.6])
        rotate([0,0,180])
            audio_video(12);
    color(chipc)
        translate([4.5, 23.2, 1.6]) 
            cube([6.5, 4.3, 1]);
    //translate([21, 28.4, 3.4]) 
    //   rotate([0,0,-90])
    //      pin_right_angle_low(10);
}

//------------------------------------------------------------------------
// Custom protoboard for MIDI In
//------------------------------------------------------------------------

module midi_in_protoboard() {
    $fn = 32;
	boardc  = $incolor ? "green"  : undef;
	chipc   = $incolor ? "beige"  : undef;
    color(boardc) linear_extrude(height = 1.6) 
        square(size=[28, 12]);
    translate([12.7,9,1.6])
        rotate([0,0,180])
            audio_video(12);
    color(chipc)
        translate([17, 2.5, 1.6]) 
            cube([4.5, 6.3, 2]);
}

midi_in_protoboard();