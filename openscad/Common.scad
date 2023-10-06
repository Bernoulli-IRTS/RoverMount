/* Constants */
// HC49S
HC49S_BASE_X = 10.3; // mm
HC49S_BASE_Y = 4.6; // mm
HC49S_BASE_HEIGHT = 3.8; // mm
HC49S_CRYSTAL_Y = HC49S_BASE_Y - 0.8;

/* Crystal (HC49S) */
module Crystal_HC49S()
{
    CENTER_OFFSET = HC49S_BASE_X / 2 - HC49S_BASE_Y / 2;
    color("silver") union()
	{
		// Base
		hull()
		{
			translate([-CENTER_OFFSET, 0, 0]) cylinder(r=HC49S_BASE_Y/2, h=0.4, $fn=60);
			translate([CENTER_OFFSET, 0, 0]) cylinder(r=HC49S_BASE_Y/2, h=0.4, $fn=60);
		}
	
		// Crystal
		hull()
		{
			translate([-CENTER_OFFSET, 0, 0]) cylinder(r=HC49S_CRYSTAL_Y/2, h=HC49S_BASE_HEIGHT, $fn=60);
			translate([CENTER_OFFSET, 0, 0]) cylinder(r=HC49S_CRYSTAL_Y/2, h=HC49S_BASE_HEIGHT, $fn=60);
		}
	}
}

//Crystal_HC49S();
