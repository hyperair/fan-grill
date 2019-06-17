include <MCAD/units/metric.scad>
use <MCAD/array/along_curve.scad>
use <MCAD/shapes/2Dshapes.scad>
use <MCAD/general/utilities.scad>

fan_d = 144;
fan_hub_d = 65;

fan_width = 150;
screwhole_distance = 130;
screwhole_d = 3;

grill_h = 3;

corner_radius = 5;

fan_r = fan_d / 2;
fan_hub_r = fan_hub_d / 2;

$fs = 0.4;
$fa = 1;

module grill_shape ()
{

    /* spokes */
    begin_r = 0;
    end_r = fan_r + 20;

    function angle_at_r (r) = 20 / (end_r - begin_r) * r;
    function point (r) = [r, angle_at_r (r)];

    module basic_shape ()
    {
        offset (r = corner_radius)
        offset (r = -corner_radius)
        square (fan_width, center = true);
    }


    linear_extrude (height = grill_h) {
        difference () {
            basic_shape ();

            /* screwholes */
            for (x = [-0.5, 0.5] * screwhole_distance)
                for (y = [-0.5, 0.5] * screwhole_distance)
                    translate ([x, y])
                    circle (screwhole_d);

            circle (d = fan_d);
        }

        circle (d = fan_hub_d);

        intersection () {
            mcad_rotate_multiply (no = 30, angle = 360 / 30, axis = Z)
            translate ([0, -fan_hub_r])
            polygon (
                concat (
                    [
                        for (x = [0:200])
                            let (r = x / 200 * (end_r - begin_r))
                            conv2D_polar2cartesian (point (r))
                    ],
                    [
                        for (x = [0:200])
                            let (r = (200 - x) / 200 * (end_r - begin_r))
                            conv2D_polar2cartesian (point (r)) + [-1, 1] * 1.2
                    ]
                )
            );

            basic_shape ();
        }
    }
}

grill_shape ();
