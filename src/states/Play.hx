package states;

import luxe.States;
import luxe.Scene;
import luxe.Vector;
import luxe.Color;
import luxe.Sprite;
import luxe.Text;

import entities.Tree;
import entities.Drop;

class Play extends State {
	var lastStateScene:Scene;
	var stateScene:Scene;

	var tree :Tree;
	var drops :Array<Drop>;
	var next_drop :Float;

	var overlay :Sprite;
	var intro :Bool;
	var intro_number :Int = 0;
	var time_left :Float = 0;
	var background :Sprite;
	// var fade_amount :Float = 1;

	var screen_title = 1;
	var screen_instructions = 2;
	var screen_spring = 3;
	var screen_summer = 4;
	var screen_fall = 5;
	var screen_winter = 6;
	var screen_spring_end1 = 7;
	var screen_spring_end2 = 8;
	var screen_spring_end3 = 9;

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

		background = new luxe.Sprite({
			pos: new Vector(0, -1000),
			texture: Luxe.resources.texture('assets/backgrounds/fall.png'),
			scale: new Vector(1.1, 1.1),
			depth: -2
		});

		// new luxe.Sprite({
		// 	pos: new Vector(0, -640),
		// 	size: new Vector(800, 2560),
		// 	color: new Color(0, 0, 0, 0.3),
		// 	depth: -1
		// });

		new luxe.Sprite({
			pos: new Vector(0, -220),
			texture: Luxe.resources.texture('assets/backgrounds/montains.png'),
			scale: new Vector(1.1, 1.1),
			depth: -1
		});

		new luxe.Sprite({
			pos: new Vector(0, -220),
			texture: Luxe.resources.texture('assets/backgrounds/grass.png'),
			scale: new Vector(1.1, 1.0),
			depth: 1
		});

		tree = new Tree();

		Luxe.events.listen('got_sun', function(_) {
            tree.highlight = 1.0;
        });

		Luxe.events.listen('got_poison', function(_) {
            tree.poison = 1.0;
        });

		overlay = new Sprite({
			pos: Luxe.camera.center,
            name: 'overlay',
            centered: true,
            size: Luxe.screen.size.clone().multiplyScalar(4),
            color: new Color(0.85, 0.65, 0.1, 1),
            depth: 10
        });

		Luxe.events.listen('end_intro', function(_) {
			intro = false;
			if (intro_number > screen_winter) return;

			if (intro_number == screen_summer) {
				// background.texture = Luxe.resources.texture('assets/backgrounds/summer.png');
			} else if (intro_number == screen_fall) {
				// background.texture = Luxe.resources.texture('assets/backgrounds/fall.png');
				background.texture = Luxe.resources.texture('assets/backgrounds/winter.png');
			} else if (intro_number == screen_winter) {
				background.texture = Luxe.resources.texture('assets/backgrounds/winter.png');
			}
			// background.color.a = 1;

			// overlay.color.tween(2, { a: 0 }, true);
			if (intro_number >= screen_spring && intro_number <= screen_winter) time_left = 40;
		});
	}

	override function onrender() {
		Luxe.draw.circle({ x: 200, y: Luxe.camera.pos.y + 130, r: 90, color: new luxe.Color(0.8, 0.6, 0), immediate: true }); // sun
		Luxe.draw.circle({ x: 200, y: Luxe.camera.pos.y + 130, r: 80 + tree.highlight * 10, color: new luxe.Color(1.0, 0.9, 0.2), immediate: true }); // sun
	}

	override function onleave<T>(_:T) {
		stateScene.empty();
		Luxe.scene = lastStateScene;
	}

	function start_intro() {
		if (intro_number == screen_spring_end3) return;
		intro_number++;
		intro = true;
		//overlay.color.tween(2, { a: 1 }, true);
		Luxe.events.fire('start_intro', intro_number);
	}

	override public function update(dt :Float) {
		time_left -= dt;
		if (!intro && time_left <= 0) {
			start_intro();
			return;
		}

		if (intro) {
			overlay.color.a = Math.min(overlay.color.a + dt, 1);
		} else {
			overlay.color.a = Math.max(overlay.color.a - dt, 0);
		}

		// background.color.a = Math.max(background.color.a - dt * 0.001, 0);

		if (intro) dt = 0;

		if (tree.highlight > 0) tree.highlight -= dt * 1.5;
		if (tree.highlight < 0) tree.highlight = 0;
		if (tree.poison > 0) tree.poison -= dt * 1.5;
		if (tree.poison < 0) tree.poison = 0;

		var pos = tree.get_top();
		for (drop in drops) {
			drop.move(dt);
			if (drop.dropType == Poison) {
				drop.pos.x += Vector.Subtract(pos, drop.pos).normalized.multiplyScalar(dt * 70).x;
			}
			if (Vector.Subtract(drop.pos, pos).length < 30) {
				Luxe.events.fire('got_drop', drop);
				drop.destroy();
				drops.remove(drop);
			}
		}
		if (!intro) {
			pos.x = 0;
			pos.y = Math.min(pos.y, -Luxe.screen.height / 2 + 100);
			Luxe.camera.focus(pos, 0.2);
		}

		next_drop -= dt;
		if (next_drop <= 0) {
			create_drop();
			next_drop = 2.5 * Math.random();
		}
	}

	// override public function onkeyup(event :luxe.Input.KeyEvent) {
    //     switch (event.keycode) {
	// 		case luxe.Input.Key.key_l: tree.lock_segment();
	// 		case luxe.Input.Key.key_d: create_drop();
	// 		case luxe.Input.Key.key_n: time_left = 0;
	// 	}
    // }

	function get_drop(random :Float) :Drop {
		if (intro_number == screen_spring) { // spring
			if (random < 0.1) return new PoisonDrop();
			return (random < 0.5 ? new RainDrop() : new SunDrop());
		} else if (intro_number == screen_summer) { // summer
			if (random < 0.2) return new PoisonDrop();
			return (random < 0.5 ? new RainDrop() : new SunDrop());
		} else if (intro_number == screen_fall) { // fall
			if (random < 0.3) return new PoisonDrop();
			if (random < 0.4) return new TimeDrop();
			return (random < 0.6 ? new RainDrop() : new SunDrop());
		} else if (intro_number == screen_winter) { // winter
			if (random < 0.4) return new PoisonDrop();
			if (random < 0.5) return new TimeDrop();
			return (random < 0.7 ? new RainDrop() : new SunDrop());
		} else {
			return new SunDrop();
		}
	}

	function create_drop() {
		var drop = get_drop(Math.random());
		drop.pos = new Vector(-Luxe.screen.width / 2 + Luxe.screen.width * Math.random(), tree.get_top().y - Luxe.screen.height);
		drops.push(drop);
	}
}
