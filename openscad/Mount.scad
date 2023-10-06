include <HC-SR04.scad>

/* Constants */
// Mount
MOUNT_THICCNESS = 1.1; // mm
MOUNT_HOLDEXTRA = 0.8; // mm (Amount held around sensor)

HC_SR04_SCALE = 1.03; // 3% bigger sensor for 3d-print tolerances I guess?

MOUNT_S = MOUNT_THICCNESS + MOUNT_HOLDEXTRA;
SENSOR_X = HC_SR04_PCB_X * HC_SR04_SCALE;
SENSOR_Y = HC_SR04_PCB_Z * HC_SR04_SCALE;
SENSOR_Z = HC_SR04_PCB_Y * HC_SR04_SCALE;
MOUNT_W = SENSOR_X + MOUNT_S;

MOUNT_SENSOR_ANGLE = -14; // Degrees from center (15 should be "ideal" in theory, but use 14 for tolerances)

BASE_S = 2; // mm
BASE_IN = 20; // mm
BASE_BACK_HEIGHT = 20;

module HC_SR04_Mount()
{   
    difference()
    {
        union()
        {
            // Left
            cube([MOUNT_S, MOUNT_S + SENSOR_Y, SENSOR_Z]);
            // Right
            translate([SENSOR_X, 0, 0]) cube([MOUNT_S, MOUNT_S + SENSOR_Y, SENSOR_Z]);
            // Bottom
            cube([MOUNT_S + SENSOR_X, MOUNT_S + SENSOR_Y, MOUNT_S]);
        }
        
        // HC-SR04 used for difference
        translate([SENSOR_X + MOUNT_THICCNESS, HC_SR04_PCB_Z + MOUNT_S / 2, HC_SR04_PCB_Y + MOUNT_THICCNESS]) rotate([90, 180, 0]) scale([HC_SR04_SCALE, HC_SR04_SCALE, HC_SR04_SCALE]) # HC_SR04();
    }
}

// Right angled extruded triangle
module HC_SR04_Mount_Support(angle)
{
    linear_extrude(height=1, center=true)
    {
        polygon(points=[[0, 0], [1, 0], [0, tan(angle) * 1]], paths=[[0, 1, 2]]);
    }
}

module Mount_Hole()
{
    translate([0, 0, 0]) cylinder(h=12, r=5/2, center=true);
    translate([0, 5, 6]) rotate([90, 0, 0]) cylinder(h=10, r=5/2, center=true);
}

union()
{
    // Sensor mount right
    translate([0, 0, BASE_S]) mirror([1,0,0]) rotate([0,0, -MOUNT_SENSOR_ANGLE]) HC_SR04_Mount();
    // Sensor mount left
    translate([0, 0, BASE_S]) rotate([0,0, -MOUNT_SENSOR_ANGLE])  HC_SR04_Mount();
    
    // Sensor base
    hull()
    {
       rotate([0,0, -MOUNT_SENSOR_ANGLE]) cube([MOUNT_W, MOUNT_S + SENSOR_Y, BASE_S]);
       mirror([1,0,0]) rotate([0,0, -MOUNT_SENSOR_ANGLE]) cube([MOUNT_W, MOUNT_S + SENSOR_Y, BASE_S]);
    }
    
    // Base
    ROTATED_SENSOR_X = cos(MOUNT_SENSOR_ANGLE) * (MOUNT_S + SENSOR_X);
    ROTATED_SENSOR_Y = cos(MOUNT_SENSOR_ANGLE) * (MOUNT_S + SENSOR_Y) - sin(MOUNT_SENSOR_ANGLE) * (MOUNT_S + SENSOR_X) - (MOUNT_S + SENSOR_Y);

    difference()
    {
        union()
        {
            // Bottom
            translate([-ROTATED_SENSOR_X,ROTATED_SENSOR_Y, 0]) cube([ROTATED_SENSOR_X * 2, BASE_IN, BASE_S]);   
            // Back
            translate([-ROTATED_SENSOR_X,ROTATED_SENSOR_Y + BASE_IN - BASE_S, BASE_S]) cube([ROTATED_SENSOR_X * 2, BASE_S, BASE_BACK_HEIGHT]);  
        }
        
        // Middle hole
        translate([0, ROTATED_SENSOR_Y + BASE_IN - 5, 3]) Mount_Hole();
        // Left hole
        translate([10, ROTATED_SENSOR_Y + BASE_IN - 5, 3]) Mount_Hole();
        // Right hole
        translate([-10, ROTATED_SENSOR_Y + BASE_IN - 5, 3]) Mount_Hole();
        
        // Left hole 2
        translate([10 + 25, ROTATED_SENSOR_Y + BASE_IN - 5, -1]) Mount_Hole();
        // Right hole 2
        translate([-10 - 25, ROTATED_SENSOR_Y + BASE_IN- 5, -1]) Mount_Hole();
        
        // Remove right for clip?
        translate([-23, ROTATED_SENSOR_Y + BASE_IN - 4.5, -1]) cube([10, 5, BASE_S + 4.1], center=true);
        // Remove left for clip?
        translate([23, ROTATED_SENSOR_Y + BASE_IN - 4.5, -1]) cube([10, 5, BASE_S + 4.1], center=true);
    }
    
    // Middle sensor support
    translate([0, 3.5, BASE_S]) rotate([90, 0, 90]) scale([8, 11, 2.5]) HC_SR04_Mount_Support(60);
    
    // Left sensor support
    rotate([90, 0, 90-MOUNT_SENSOR_ANGLE]) translate([3.5, BASE_S, SENSOR_X + MOUNT_S/2])  scale([6, 11, MOUNT_S]) HC_SR04_Mount_Support(60);
    
    // Right sensor support
    mirror([1,0,0]) rotate([90, 0, 90-MOUNT_SENSOR_ANGLE]) translate([3.5, BASE_S, SENSOR_X + MOUNT_S/2])  scale([6, 11, MOUNT_S]) HC_SR04_Mount_Support(60); 
}