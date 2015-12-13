
package entities;

import luxe.Sprite;
import luxe.Vector;
import luxe.Color;

enum DropType {
    Sun;
    Rain;
    Time;
    Poison;
}

class Drop extends Sprite {
    public var dropType :DropType;
    var dropSpeed :Float = 200;

    public function new(options :luxe.options.SpriteOptions) {
        if (options.name == null) options.name = "Drop." + Luxe.utils.uniqueid();
        super(options);
    }

    override public function update(dt :Float) {
        pos.y += dt * dropSpeed;
        pos.x += dt * (-10 + 20 * Math.random());

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
    var randomRotation :Float;

    public function new() {
        var rndScale = 0.3 + 0.1 * Math.random();
        super({
            name: "Drop.Sun." + Luxe.utils.uniqueid(),
            texture: Luxe.resources.texture('assets/sprites/sun.png'),
            scale: new Vector(rndScale, rndScale),
            rotation_z: 360 * Math.random()
        });
        randomRotation = 1 - 2 * Math.random();
        dropType = Sun;
    }

    override public function update(dt :Float) {
        super.update(dt);
        rotation_z += randomRotation * dt * 100;
    }
}

class RainDrop extends Drop {
    public function new() {
        var rndScale = 0.3 + 0.1 * Math.random();
        super({
            name: "Drop.Rain." + Luxe.utils.uniqueid(),
            texture: Luxe.resources.texture('assets/sprites/rain.png'),
            scale: new Vector(rndScale, rndScale)
        });
        dropType = Rain;
    }
}

class TimeDrop extends Drop {
    public function new() {
        var rndScale = 0.3 + 0.1 * Math.random();
        super({
            name: "Drop.Time." + Luxe.utils.uniqueid(),
            texture: Luxe.resources.texture('assets/sprites/hourglass.png'),
            scale: new Vector(Luxe.utils.random.bool() ? rndScale : -rndScale, rndScale)
        });
        dropType = Time;
    }
}

class PoisonDrop extends Drop {
    public function new() {
        var rndScale = 0.3 + 0.1 * Math.random();
        super({
            name: "Drop.Poison." + Luxe.utils.uniqueid(),
            texture: Luxe.resources.texture('assets/sprites/poison.png'),
            scale: new Vector(rndScale, rndScale)
        });
        dropType = Poison;
        dropSpeed = 100;
    }
}
