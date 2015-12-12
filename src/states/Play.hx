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
	var next_drop :Float;

	public function new() {
		super({ name: 'Play' });
		stateScene = new Scene('Play');
	}

	override function onenter<T>(_:T) {
		Luxe.camera.center = new Vector(0, -Luxe.screen.height / 2 + 50);
		lastStateScene = Luxe.scene;
		Luxe.scene = stateScene;

		drops = [];
		next_drop = 0;

		new luxe.Sprite({
			pos: new Vector(0, 0),
			texture: Luxe.resources.texture('assets/backgrounds/summer.png'),
			scale: new Vector(1.1, 1.1),
			depth: -2
		});

		new luxe.Sprite({
			pos: new Vector(0, -220),
			texture: Luxe.resources.texture('assets/backgrounds/montains.png'),
			depth: -1
		});

		new luxe.Sprite({
			pos: new Vector(0, -220),
			texture: Luxe.resources.texture('assets/backgrounds/grass.png'),
			depth: 1
		});

		Luxe.draw.circle({ x: 200, y: -400, r: 90, color: new luxe.Color(1.0, 0.8, 0) }); // sun
		Luxe.draw.circle({ x: 200, y: -400, r: 80, color: new luxe.Color(0.8, 0.6, 0) }); // sun

		tree = new Tree();

		Luxe.events.listen('got_sun', function(_) {
            tree.highlight = 1.0;
        });
	}

	// override function onrender() {
	// 	Luxe.draw.circle({ x: 200, y: -400, r: 90, color: new luxe.Color(1.0, 0.8, 0), immediate: true }); // sun
	// 	Luxe.draw.circle({ x: 200, y: -400, r: 80, color: new luxe.Color(0.8, 0.6, 0), immediate: true }); // sun
	// }

	override function onleave<T>(_:T) {
		stateScene.empty();
		Luxe.scene = lastStateScene;
	}

	override public function update(dt :Float) {
		if (tree.highlight > 0) tree.highlight -= dt * 1.5;
		if (tree.highlight < 0) tree.highlight = 0;

		var pos = tree.get_top();
		for (drop in drops) {
			if (Vector.Subtract(drop.pos, pos).length < 30) {
				Luxe.events.fire('got_drop', drop);
				drop.destroy();
				drops.remove(drop);
			}
		}
		pos.x = Luxe.camera.center.x;
		pos.y = Math.min(pos.y, -Luxe.screen.height / 2 + 100);
		Luxe.camera.focus(pos, 0.2);

		next_drop -= dt;
		if (next_drop <= 0) {
			create_drop();
			next_drop = 3 * Math.random();
		}
	}

	override public function onkeyup(event :luxe.Input.KeyEvent) {
        switch (event.keycode) {
			case luxe.Input.Key.key_l: tree.lock_segment();
			case luxe.Input.Key.key_d: create_drop();
		}
    }

	function create_drop() {
		var random = Math.random();
		var drop = if (random < 0.1) {
			new TimeDrop();
		} else if (random < 0.3) {
			new RainDrop();
		} else {
			new SunDrop();
		}
		drop.pos = new Vector(-Luxe.screen.width / 2 + Luxe.screen.width * Math.random(), tree.get_top().y - Luxe.screen.height);
		drops.push(drop);
	}
}
