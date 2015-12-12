package states;

import luxe.States;
import luxe.Scene;
import luxe.Vector;
import luxe.Color;

import entities.Tree;
import entities.Drop;

class Play extends State {
	var lastStateScene:Scene;
	var stateScene:Scene;

	var tree :Tree;
	var drops :Array<Drop>;

	public function new() {
		super({ name: 'Play' });
		stateScene = new Scene('Play');
	}

	override function onenter<T>(_:T) {
		Luxe.camera.center = new Vector(0, -Luxe.screen.height / 2 + 50);
		lastStateScene = Luxe.scene;
		Luxe.scene = stateScene;

		drops = [];

		new luxe.Sprite({
			pos: new Vector(0, 0),
			texture: Luxe.resources.texture('assets/backgrounds/summer.png'),
			scale: new Vector(1.1, 1.1),
			depth: -1
		});

		Luxe.draw.circle({ x: 200, y: -400, r: 90, color: new luxe.Color(1.0, 0.8, 0) }); // sun
		Luxe.draw.circle({ x: 200, y: -400, r: 80, color: new luxe.Color(0.8, 0.6, 0) }); // sun

		tree = new Tree();

		Luxe.draw.box({
			x: -Luxe.screen.width,
			y: 0,
			w: Luxe.screen.width * 2,
			h: 200,
			color: new Color(0.1, 0.4, 0.1),
			depth: 2
		});

		Luxe.draw.box({
			x: -Luxe.screen.width,
			y: -10,
			w: Luxe.screen.width * 2,
			h: 200,
			color: new Color(0.2, 0.6, 0.1),
			depth: 2
		});
		// Luxe.draw.circle({ x: 100, y: 100, r: 100, color: new luxe.Color(1, 0, 0.5) });
		// Luxe.draw.circle({ x: 120, y: 120, r: 40, color: new luxe.Color(0, 1, 0.5) });
	}

	override function onleave<T>(_:T) {
		stateScene.empty();
		Luxe.scene = lastStateScene;
	}

	override public function update(dt :Float) {
		var pos = tree.get_top();
		for (drop in drops) {
			if (Vector.Subtract(drop.pos, pos).length < 30) {
				Luxe.events.fire('got_drop', { pos: drop.pos.clone() });
				drop.destroy();
				drops.remove(drop);
			}
		}
	}

	override public function onkeyup(event :luxe.Input.KeyEvent) {
        switch (event.keycode) {
			case luxe.Input.Key.key_l: tree.lock_segment();
		case luxe.Input.Key.key_d: var drop = new Drop(); drop.pos = new Vector(-Luxe.screen.width / 2 + Luxe.screen.width * Math.random(), -Luxe.screen.height); drops.push(drop);
		}
    }
}
