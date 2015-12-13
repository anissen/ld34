package states;

import luxe.States;
import luxe.Scene;
import luxe.Vector;
import luxe.Color;
import luxe.Sprite;
import luxe.Text;

import entities.Tree;
import entities.Drop;

class Intro extends State {
	// var lastStateScene:Scene;
	var stateScene :Scene;

	var overlay :Sprite;
	var ending :Bool;

	public function new() {
		super({ name: 'Intro' });
		stateScene = new Scene('Intro');
		ending = false;
	}

	override function onenabled<T>(data :T) {
		// lastStateScene = Luxe.scene;
		// Luxe.scene = stateScene;
		Luxe.camera.center = new Vector(0, -Luxe.screen.height / 2 + 50);

		ending = false;

		overlay = new Sprite({
			pos: Luxe.camera.center,
            name: 'overlay',
            centered: true,
            // size: Luxe.screen.size.clone().multiplyScalar(1.1),
            color: new Color(1,1,1,0),
			texture: cast data,
            depth: 100,
			scene: stateScene
        });

		overlay.color.tween(1, { a: 1 });
	}

	override function onkeyup(event :luxe.Input.KeyEvent) {
		end_intro();
	}

	override function onmouseup(event :luxe.Input.MouseEvent) {
		end_intro();
	}

	function end_intro() {
		if (ending) return;

		ending = true;
		overlay.color.tween(2, { a: 0 }).onComplete(function(_) {
			stateScene.empty();
			Luxe.events.fire('end_intro', null);
		});
	}

	override function ondisabled<T>(_:T) {

		// Luxe.scene = lastStateScene;
	}
}
