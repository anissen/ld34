
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
    var locked_segments :Int = 0;
    var target :Vector;
    var points :Int = 0;

    public function new() {
        super({name: "Tree"});
        segments = [ for (i in 0 ... numSegments) { x: 0, y: 0, angle: 0 } ];
        var lastSegment = segments[numSegments-1];
        lastSegment.x = 0;
        lastSegment.y = 0;

        Luxe.events.listen('got_drop', function(data :{ pos :luxe.Vector }) {
            points++;
            if (points % 3 == 0) {
                add_segment();
            }
        });
    }

    function add_segment() {
        trace('add_segment');
        numSegments++;
        var pos = Luxe.camera.screen_point_to_world(Luxe.screen.cursor.pos);
        segments.push({ x: pos.x, y: pos.y, angle: 0 });
        // lock_segment();
    }

    override public function update(dt :Float) {
        target = Luxe.camera.screen_point_to_world(Luxe.screen.cursor.pos);
        for (i in 0 ... numSegments - locked_segments) {
            reach_segment(segments[i]);
        }
        for (i in 1 ... numSegments) {
            var index = numSegments - i;
            position_segment(segments[index], segments[index-1]);
        }
        var top = get_top();
        Luxe.draw.circle({
            x: top.x,
            y: top.y,
            r: 30,
            color: new Color(1, 1, 1, 0.2),
            immediate: true
        });
        for (i in 0 ... numSegments) {
            draw_segment(segments[i], i);
        }
    }

    function position_segment(a :Segment, b :Segment) {
        b.x = a.x + Math.cos(a.angle) * segLength;
        b.y = a.y + Math.sin(a.angle) * segLength;
    }

    function reach_segment(seg :Segment) {
        var dx :Float = target.x - seg.x;
        var dy :Float = target.y - seg.y;
        seg.angle = Math.atan2(dy, dx);
        target.x -= Math.cos(seg.angle) * segLength;
        target.y -= Math.sin(seg.angle) * segLength;
    }

    function draw_segment(seg :Segment, i :Int) {
        var rot_x = seg.x + Math.cos(seg.angle) * segLength;
        var rot_y = seg.y + Math.sin(seg.angle) * segLength;

        var p0 = new Vector(seg.x, seg.y);
        var p1 = new Vector(rot_x, rot_y);

        var width_increase = (max_width - min_width) / numSegments;

        var temp = Vector.Subtract(p1, p0).normalized;
        var tangent = new Vector(-temp.y, temp.x);

        var pt2 = Vector.Multiply(tangent, min_width + (i + 2) * width_increase);
        var pt3 = Vector.Multiply(tangent, min_width + (i + 1) * width_increase);

        var p2 = Vector.Multiply(tangent, min_width + (i + 1) * width_increase);
        var p3 = Vector.Multiply(tangent, min_width + i * width_increase);

        Luxe.draw.circle({
            x: seg.x,
            y: seg.y,
            r: min_width + (i + 2) * width_increase,
            color: new Color(1.0, 1.0, 1.0),
            immediate: true
        });

        Luxe.draw.poly({
            points: [
                Vector.Add(p0, pt2), Vector.Subtract(p0, pt2),
                Vector.Subtract(p1, pt3), Vector.Add(p1, pt3)
            ],
            color: new Color(1.0, 1.0, 1.0),
            immediate: true
        });

        Luxe.draw.circle({
            x: seg.x,
            y: seg.y,
            r: min_width + (i + 1) * width_increase,
            color: new Color(0.0, 0.5 - ((i + 1) / numSegments) * 0.5, 0.0),
            immediate: true
        });

        Luxe.draw.poly({
            points: [
                Vector.Add(p0, p2), Vector.Subtract(p0, p2),
                Vector.Subtract(p1, p3), Vector.Add(p1, p3)
            ],
            colors: [
                new Color(0.0, 0.5 - ((i + 1) / numSegments) * 0.5, 0.0),
                new Color(0.0, 0.5 - ((i + 1) / numSegments) * 0.5, 0.0),
                new Color(0.0, 0.5 - (i / numSegments) * 0.5, 0.0),
                new Color(0.0, 0.5 - (i / numSegments) * 0.5, 0.0)
            ],
            immediate: true
        });
    }

    public function lock_segment() :Void {
        locked_segments++;
        // rigidness -= 0.1;
    }

    public function get_top() :Vector {
        var top = segments[0];
        return new Vector(top.x + Math.cos(top.angle) * segLength, top.y + Math.sin(top.angle) * segLength);
    }
}
