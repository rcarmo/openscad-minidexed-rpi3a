$incolor = (is_undef($incolor)) ? true : $incolor;


module pin_headers(cols, rows) {
    w = 2.54; h = 2.54; p = 0.65;
	pinc  = $incolor ? "gold"  : undef;
	basec = $incolor ? "black" : undef;
	
    for(x = [0 : (cols -1)]) {
        for(y = [0 : (rows  - 1)]) {
            translate([w * x, w * y, 0]) {
                union() {
                    color(basec) cube([w, w, h]);
                    color(pinc)  translate([(w - p) / 2, (w - p) / 2, -3]) cube([p, p, 11.54]);
                }
            }
        }
    }
}

module pin_right_angle_low(cols) {
    w = 2.54; p = 0.65;
	pinc  = $incolor ? "gold"  : undef;
	basec = $incolor ? "black" : undef;
    d = (w - p) / 2;
    for(x = [0 : (cols -1)]) {
        translate([w * x, 0, 0]) {
            color(basec) translate([0, d - 1, -2]) cube([w, w, w]);
            color(pinc)  translate([d, d, -4]) cube([p, p, 5 + w / 2]);
            color(pinc)  translate([d, d + 7 + w, d + 1]) rotate(a=90, v=[1, 0, 0]) cube([p, p, 5 + w + 2]);
        }
    }
}

module usb_connector(x, y, z) {
    f = 0.6; // Flange
	shieldc = $incolor ? "silver" : undef;
    color(shieldc) { 
		cube([x, y, z]);
		translate([-f, y - f, -f])
			cube([x + f * 2, f, z + f * 2]);
	}
}

module audio_jack() {
    x = 11.4; y = 12; z = 10.2;
    d = 6.7; h = 3.4;
    color("blue") cube([x, y, z]);
    translate([-h, y / 2, (d / 2) + 3])
        rotate(a=90, v=[0, 1, 0])
            color("blue") cylinder(r=(d / 2), h=h);
}

module hdmi_connector(x, y, z) {
	shieldc = $incolor ? "silver" : undef;
    color(shieldc) cube([x, y, z]);
}

module microusb_connector(x, y, z) {
	shieldc = $incolor ? "silver" : undef;
    color(shieldc) cube([x, y, z]);
}

module spi_connector() {
	basec = $incolor ? "beige" : undef;
	snapc = $incolor ? "black" : undef;
    color(basec) cube([20, 2.4, 3.5]);
    translate([-1, 0, 3.5])
        color(snapc) cube([22, 2.4, 1.4]);
}

module micro_sd_card() {
	shieldc = $incolor ? "silver" : undef;
	cardc = $incolor ? "black" : undef;
    color(shieldc) cube([12, 11.3, 1.5]);
    translate([0.5, -4,0.25])
    color(cardc) cube([11,4,1]);    
}

module audio_video(size_x) {
	avc = $incolor ? [58/255, 58/255, 58/255] : undef;
    color(avc) {
        cube([size_x, 7, 5.6]);
        translate([size_x, 7 / 2, 5.6 / 2]) rotate([0,90,0]) cylinder(d=5.6, h=2.6);
    }
}