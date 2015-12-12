
package entities;

import luxe.Entity;
import luxe.Vector;
import luxe.Color;

typedef Segment = {
    x :Float,
    y :Float,
    angle :Float
};

class Tree extends Entity {
    var numSegments :Int = 8;
    var segments :Array<Segment>;
    var segLength :Float = 40;
    var max_width :Float = 20;
    var min_width :Float = 1;
    var targetX :Float;
    var targetY :Float;

    public function new() {
        super({name: "Tree"});
        segments = [ for (i in 0 ... numSegments) { x: 0, y: 0, angle: 0 } ];
        var lastSegment = segments[numSegments-1];
        lastSegment.x = 0;
        lastSegment.y = 0;
    }

    override public function update(dt :Float) {
        var pos = Luxe.camera.screen_point_to_world(Luxe.screen.cursor.pos);
        reach_segment(segments[0], pos.x, pos.y);
        for(i in 1 ... numSegments) {
            reach_segment(segments[i], targetX, targetY);
        }
        for(i in 1 ... numSegments) {
            var index = numSegments - i;
            position_segment(segments[index], segments[index-1]);
        }
        for (i in 0 ... numSegments) {
            draw_segment(segments[i], i);
        }
    }

    function position_segment(a :Segment, b :Segment) {
        b.x = a.x + Math.cos(a.angle) * segLength;
        b.y = a.y + Math.sin(a.angle) * segLength;
    }

    function reach_segment(seg :Segment, xin :Float, yin :Float) {
        var dx :Float = xin - seg.x;
        var dy :Float = yin - seg.y;
        seg.angle = Math.atan2(dy, dx);
        targetX = xin - Math.cos(seg.angle) * segLength;
        targetY = yin - Math.sin(seg.angle) * segLength;
    }

    function draw_segment(seg :Segment, i :Int) {
        var rot_x = seg.x + Math.cos(seg.angle) * segLength;
        var rot_y = seg.y + Math.sin(seg.angle) * segLength;

        var p0 = new Vector(seg.x, seg.y);
        var p1 = new Vector(rot_x, rot_y);

        var width_increase = (max_width - min_width) / numSegments;
        // trace((i + 2) * width_increase);

        var temp = Vector.Subtract(p1, p0).normalized;
        var tangent = new Vector(-temp.y, temp.x);

        var p2 = Vector.Multiply(tangent, min_width + (i + 1) * width_increase);
        var p3 = Vector.Multiply(tangent, min_width + i * width_increase);
        // var p2 = new Vector(-p0.y, p0.x);
        // p2.normalize().multiplyScalar(min_width + (i + 1) * width_increase);
        // var p3 = new Vector(-p1.y, p1.x);
        // p3.normalize().multiplyScalar(min_width + i * width_increase);
        Luxe.draw.circle({
            x: seg.x,
            y: seg.y,
            r: min_width + (i + 1) * width_increase,
            color: new Color((i + 1) / numSegments, 0.5 - ((i + 1) / numSegments) * 0.5, 0.0), immediate: true
        });

        Luxe.draw.poly({
            points: [
                Vector.Add(p0, p2), Vector.Subtract(p0, p2),
                Vector.Subtract(p1, p3), Vector.Add(p1, p3)
            ],
            colors: [
                new Color((i + 1) / numSegments, 0.5 - ((i + 1) / numSegments) * 0.5, 0.0),
                new Color((i + 1) / numSegments, 0.5 - ((i + 1) / numSegments) * 0.5, 0.0),
                new Color(i / numSegments, 0.5 - (i / numSegments) * 0.5, 0.0),
                new Color(i / numSegments, 0.5 - (i / numSegments) * 0.5, 0.0)
            ],
            immediate: true
        });

        // Luxe.draw.line({
        //     p0: p0,
        //     p1: p1,
        //     color0: new Color(0.2, 0, 0.5),
        //     color1: new Color(0.5, 0, 0.5),
        //     immediate: true,
        //     depth: 2
        // });

    }
}
