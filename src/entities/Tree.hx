
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
    var numSegments :Int = 5;
    var segments :Array<Segment>;
    var segLength :Float = 60;
    var max_width :Float = 10;
    var min_width :Float = 1;
    var locked_segments :Int = 0;
    var target :Vector;
    var points :Int = 0;
    var lock_countdown :Float;
    public var highlight :Float;
    public var poison :Float;
    var move_speed :Float;
    var intro :Bool = false;

    var cursor :Vector;

    public function new() {
        super({name: "Tree"});

        cursor = new Vector();
        segments = [ for (i in 0 ... numSegments) { x: 0, y: 0, angle: 0 } ];
        var lastSegment = segments[numSegments-1];
        lastSegment.x = 0;
        lastSegment.y = 0;

        lock_countdown = 10;
        highlight = 0.0;
        poison = 0.0;

        Luxe.events.listen('got_sun', function(drop :Drop) {
            points++;
            if (points % 5 == 0) {
                add_segment();
            }
        });

        Luxe.events.listen('got_rain', function(drop :Drop) {
            lock_countdown += 3;
            move_speed = Math.min(move_speed + 100, 1000);
        });

        Luxe.events.listen('got_time', function(drop :Drop) {
            move_speed = Math.min(move_speed + 50, 1000);
        });

        Luxe.events.listen('got_poison', function(drop :Drop) {
            lock_segment();
            remove_segment();
        });

        Luxe.events.listen('start_into', function(_) {
            intro = true;
        });

        Luxe.events.listen('end_into', function(_) {
            intro = false;
        });

        move_speed = 1000;
    }

    function add_segment() {
        numSegments++;
        segments.unshift({ x: 0, y: 0, angle: 0 });
        max_width++;
        calc_tree();
    }

    function remove_segment() {
        numSegments--;
        segments.shift();
        max_width--;
        calc_tree();
    }

    override public function update(dt :Float) {
        if (intro) dt = 0;
        // if (cursor == null) return;

        move_speed = Math.max(move_speed - dt * 20, 100);
        var cursorDiff = Vector.Subtract(Luxe.screen.cursor.pos, cursor);
        if (cursorDiff.length > 10) {
            cursor = Vector.Add(cursor, cursorDiff.normalized.multiplyScalar(dt * move_speed));
        } else {
            cursor = Vector.Add(cursor, cursorDiff.normalized.multiplyScalar(dt * move_speed * 0.1));
        }
        lock_countdown -= dt;
        if (lock_countdown <= 0) {
            if (locked_segments < numSegments) lock_segment();
            lock_countdown = get_lock_countdown();
        }
        calc_tree();
        draw_tree();
    }

    function get_lock_countdown() {
        return Math.max(4, 20 - numSegments);
    }

    function calc_tree() {
        target = Luxe.camera.screen_point_to_world(cursor);
        // var pos = Luxe.camera.screen_point_to_world(Luxe.screen.cursor.pos);
        // var blah = new Vector(segments[0].x, segments[0].y);
        // target = new Vector((blah.x + pos.x) / 2, (blah.y + pos.y) / 2);
        for (i in 0 ... numSegments - locked_segments) {
            reach_segment(segments[i]);
        }
        for (i in 1 ... numSegments) {
            var index = numSegments - i;
            position_segment(segments[index], segments[index-1]);
        }
    }

    function draw_tree() {
        // var top = get_top();
        // Luxe.draw.circle({
        //     x: top.x,
        //     y: top.y,
        //     r: 30,
        //     color: new Color(1, 1, 1, 0.2),
        //     immediate: true
        // });
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

        if (i < numSegments - locked_segments) { // draw outline
            var pt2 = Vector.Multiply(tangent, min_width + (i + 1.5 + highlight) * width_increase);
            var pt3 = Vector.Multiply(tangent, min_width + (i + 0.5 + highlight) * width_increase);

            Luxe.draw.circle({
                x: seg.x,
                y: seg.y,
                r: min_width + (i + 1.8 + highlight) * width_increase,
                color: get_highlight_color(),
                immediate: true
            });

            Luxe.draw.poly({
                points: [
                    Vector.Add(p0, pt2), Vector.Subtract(p0, pt2),
                    Vector.Subtract(p1, pt3), Vector.Add(p1, pt3)
                ],
                color: get_highlight_color(),
                immediate: true
            });
        }

        var p2 = Vector.Multiply(tangent, min_width + (i + 1) * width_increase);
        var p3 = Vector.Multiply(tangent, min_width + i * width_increase);

        Luxe.draw.circle({
            x: seg.x,
            y: seg.y,
            r: min_width + (i + 1) * width_increase,
            color: get_color(i + 1),
            immediate: true
        });

        Luxe.draw.poly({
            points: [
                Vector.Add(p0, p2), Vector.Subtract(p0, p2),
                Vector.Subtract(p1, p3), Vector.Add(p1, p3)
            ],
            colors: [
                get_color(i + 1),
                get_color(i + 1),
                get_color(i),
                get_color(i)
            ],
            immediate: true
        });
    }

    function get_highlight_color() {
        return new Color(1.0 - highlight, 1.0, 1.0 - highlight);
    }

    function get_color(i :Int) {
        var highlight_value = highlight * 0.5 - (i / numSegments) * 0.5;
        var poison_value = poison * 0.5 - (i / numSegments) * 0.5;
        return new Color(poison_value, 0.6 - (i / numSegments) * 0.4, highlight_value);
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
