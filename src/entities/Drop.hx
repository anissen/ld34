
package entities;

import luxe.Sprite;
import luxe.Vector;
import luxe.Color;

enum DropType {
    Sun;
    Rain;
    Time;
}

class Drop extends Sprite {
    public var dropType :DropType;

    public function new(options :luxe.options.SpriteOptions) {
        if (options.name == null) options.name = "Drop." + Luxe.utils.uniqueid();
        super(options);
    }

    override public function update(dt :Float) {
        pos.y += dt * 150;

        // TODO: Tween this

        // Luxe.draw.circle({
        //     x: pos.x,
        //     y: pos.y,
        //     r: 10,
        //     color: new Color(1, 1, 0),
        //     depth: 1,
        //     immediate: true
        // });
    }
}

class SunDrop extends Drop {
    public function new() {
        super({
            name: "Drop.Sun." + Luxe.utils.uniqueid(),
            texture: Luxe.resources.texture('assets/sprites/sun.png'),
            scale: new Vector(0.4, 0.4),
            rotation_z: 360 * Math.random()
        });
        dropType = Sun;
    }
}

class RainDrop extends Drop {
    var randomRotation :Float;

    public function new() {
        super({
            name: "Drop.Rain." + Luxe.utils.uniqueid(),
            texture: Luxe.resources.texture('assets/sprites/rain.png'),
            scale: new Vector(0.4, 0.4)
        });
        dropType = Rain;
        randomRotation = 1 - 2 * Math.random();
    }

    override public function update(dt :Float) {
        super.update(dt);
        rotation_z += randomRotation * dt;
    }
}

class TimeDrop extends Drop {
    public function new() {
        super({
            name: "Drop.Time." + Luxe.utils.uniqueid(),
            texture: Luxe.resources.texture('assets/sprites/hourglass.png'),
            scale: new Vector(Luxe.utils.random.bool() ? 0.4 : -0.4, 0.4)
        });
        dropType = Time;
    }
}
