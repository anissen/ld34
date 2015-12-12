
package entities;

import luxe.Entity;
import luxe.Vector;
import luxe.Color;

class Tree extends Entity {
    var numSegments :Int = 10;
    var x :Array<Float>; //[numSegments];
    var y :Array<Float>; //[numSegments];
    var angle :Array<Float>; //[numSegments];
    var segLength :Float = 30;
    var targetX :Float;
    var targetY :Float;

    public function new() {
        super({name: "Tree"});
        x = [ for (i in 0 ... numSegments) 0 ];
        y = [ for (i in 0 ... numSegments) 0 ];
        angle = [ for (i in 0 ... numSegments) 0 ];
        x[numSegments-1] = 0; //Luxe.screen.mid.x;     // Set base x-coordinate
        y[numSegments-1] = 0; //Luxe.screen.h;  // Set base y-coordinate
        Luxe.draw.circle({ x: 200, y: -200, r: 80, color: new luxe.Color(0.8, 0.6, 0) });
    }

    override public function update(dt :Float) {
        var pos = Luxe.camera.screen_point_to_world(Luxe.screen.cursor.pos);
        reach_segment(0, pos.x, pos.y);
        for(i in 1 ... numSegments) {
            reach_segment(i, targetX, targetY);
        }
        for(i in 1 ... numSegments) {
            var index = numSegments - i;
            position_segment(index, index-1);
        }
        for (i in 0 ... numSegments) {
            draw_segment(x[i], y[i], angle[i], (i+1)*2);
        }
    }

    function position_segment(a :Int, b :Int) {
        x[b] = x[a] + Math.cos(angle[a]) * segLength;
        y[b] = y[a] + Math.sin(angle[a]) * segLength;
    }

    function reach_segment(i :Int, xin :Float, yin :Float) {
        var dx :Float = xin - x[i];
        var dy :Float = yin - y[i];
        angle[i] = Math.atan2(dy, dx);
        targetX = xin - Math.cos(angle[i]) * segLength;
        targetY = yin - Math.sin(angle[i]) * segLength;
    }

    function draw_segment(x :Float, y :Float, a :Float, sw :Float) {
        var rot_x = x + Math.cos(a) * segLength;
        var rot_y = y + Math.sin(a) * segLength;

        trace('draw_segment: $x, $y');
        Luxe.draw.line({
            p0: new Vector(x, y),
            p1: new Vector(rot_x, rot_y),
            color0: new Color(0.5, 0, 0.5),
            color1: new Color(0.5, 0, 0.5),
            immediate: true
        });

        Luxe.draw.circle({ x: x, y: y, r: 5, color: new luxe.Color(0.5, 0, 0.5), immediate: true });
    }
}
