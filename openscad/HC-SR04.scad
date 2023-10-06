/*
    Dimensions taken from:
    - https://cdn.sparkfun.com/datasheets/Sensors/Proximity/HCSR04.pdf
    - https://howtomechatronics.com/wp-content/uploads/2022/02/HC-SR04-Ultrasonic-Sensor-Dimensions.png
*/

include <Common.scad>

/* Constants */
// PCB
HC_SR04_PCB_COLOR = "#00467E";
HC_SR04_PCB_X = 45; // mm
HC_SR04_PCB_Y = 20; // mm
HC_SR04_PCB_Z = 1.6; // mm (thickness)
// Sensor
HC_SR04_SENSOR_HEIGHT = 12.0; // mm
HC_SR04_SENSOR_DIAMETER = 16.0; // mm
HC_SR04_SENSOR_INNER_DIAMETER = HC_SR04_SENSOR_DIAMETER - 2.0; // (Estimate, does not matter)
// Pin header
HC_SR04_PIN_PITCH = 2.54; // mm
HC_SR04_PIN_SIZE = 0.6; // mm
HC_SR04_PIN_BASE = HC_SR04_PIN_PITCH;
HC_SR04_PIN_TURN_LENGTH = 8; // mm

// Ultrasonic sensor
module HC_SR04_Sensor()
{
   	union()
	{
		color("silver") difference()
		{
			// Main part
			cylinder(r=HC_SR04_SENSOR_DIAMETER/2, h=HC_SR04_SENSOR_HEIGHT, $fn=80);
			// Remove the inner part
			cylinder(r=HC_SR04_SENSOR_INNER_DIAMETER/2, h=HC_SR04_SENSOR_HEIGHT+0.1, $fn=80);
		}

		// The sensor mesh
		color("grey") cylinder(r=HC_SR04_SENSOR_INNER_DIAMETER/2, h=HC_SR04_SENSOR_HEIGHT - 0.2, $fn=80);
	}
}

module HC_SR04_Sensor_Pin()
{

    // Pin through PCB
	color("silver") translate([HC_SR04_PIN_PITCH/2-HC_SR04_PIN_SIZE/2,HC_SR04_PIN_PITCH/2-HC_SR04_PIN_SIZE/2,-3]) cube([HC_SR04_PIN_SIZE,HC_SR04_PIN_SIZE, 5]);
    
    // Pin 90-degree
	color("silver") translate([HC_SR04_PIN_PITCH/2-HC_SR04_PIN_SIZE/2,HC_SR04_PIN_PITCH/2-HC_SR04_PIN_SIZE/2 - HC_SR04_PIN_TURN_LENGTH,-3]) cube([HC_SR04_PIN_SIZE, HC_SR04_PIN_TURN_LENGTH, HC_SR04_PIN_SIZE]);
    
    // Plastic base
	color("black") translate([0,0,-1]) cube([HC_SR04_PIN_PITCH, HC_SR04_PIN_PITCH, 1]);
}


// Main PCB + components
module HC_SR04(up=false, center_x=false)
{
    rotate([up ? 90 : 0, 0, 0]) translate([center_x ? -HC_SR04_PCB_X/2 : 0,0,0]) union()
    {
        // PCB
        color(HC_SR04_PCB_COLOR) cube([HC_SR04_PCB_X,HC_SR04_PCB_Y,HC_SR04_PCB_Z]);
        // Ultrasonic sensors
        translate([HC_SR04_PCB_Y/2 - 0.6, HC_SR04_PCB_Y/2, HC_SR04_PCB_Z]) HC_SR04_Sensor();
        translate([HC_SR04_PCB_X - HC_SR04_PCB_Y/2 + 0.6, HC_SR04_PCB_Y/2, HC_SR04_PCB_Z]) HC_SR04_Sensor();
        // Crystal
        translate([HC_SR04_PCB_X/2, HC_SR04_PCB_Y-HC49S_BASE_Y, HC_SR04_PCB_Z]) Crystal_HC49S();
        // Pins
        
        for (i = [-1:2])
        {
            translate([(HC_SR04_PCB_X/2) - (HC_SR04_PIN_PITCH*i),2, 0]) HC_SR04_Sensor_Pin();
        }
        
    }
}

//HC_SR04();

