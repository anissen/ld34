
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
    var numSegments :Int = 10;
    var segments :Array<Segment>;
    var segLength :Float = 30;
    var targetX :Float;
    var targetY :Float;

    public function new() {
        super({name: "Tree"});
        segments = [ for (i in 0 ... numSegments) { x: 0, y: 0, angle: 0 } ];
        var lastSegment = segments[numSegments-1];
        lastSegment.x = 0;
        lastSegment.y = 0;
        Luxe.draw.circle({ x: 200, y: -400, r: 80, color: new luxe.Color(0.8, 0.6, 0) });
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
            draw_segment(segments[i], (i+1)*2);
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

    function draw_segment(seg :Segment, sw :Float) {
        var rot_x = seg.x + Math.cos(seg.angle) * segLength;
        var rot_y = seg.y + Math.sin(seg.angle) * segLength;

        Luxe.draw.line({
            p0: new Vector(seg.x, seg.y),
            p1: new Vector(rot_x, rot_y),
            color0: new Color(0.2, 0, 0.5),
            color1: new Color(0.5, 0, 0.5),
            immediate: true
        });

        Luxe.draw.circle({ x: seg.x, y: seg.y, r: 5, color: new luxe.Color(0.5, 0, 0.2), immediate: true });
    }
}
