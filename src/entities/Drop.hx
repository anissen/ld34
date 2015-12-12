
package entities;

import luxe.Entity;
import luxe.Vector;
import luxe.Color;

class Drop extends Entity {
    public function new() {
        super({ name: "Drop." + Luxe.utils.uniqueid() });
    }

    override public function update(dt :Float) {
        pos.y += dt * 200;

        Luxe.draw.circle({
            x: pos.x,
            y: pos.y,
            r: 10,
            color: new Color(1, 1, 0),
            depth: 1,
            immediate: true
        });
    }
}
