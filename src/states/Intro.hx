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

	public function new() {
		super({ name: 'Intro' });
		stateScene = new Scene('Intro');
	}

	override function onenabled<T>(data :T) {
		// lastStateScene = Luxe.scene;
		// Luxe.scene = stateScene;
		// Luxe.camera.center = new Vector();

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

		overlay.color.tween(2, { a: 1 });

		spring_intro();
	}

	function spring_intro() {
		// intro = true;
		// Luxe.events.fire('start_intro', null);
	}

	override function onkeyup(event :luxe.Input.KeyEvent) {
		Luxe.events.fire('end_intro', null);
	}

	override function onmouseup(event :luxe.Input.MouseEvent) {
		Luxe.events.fire('end_intro', null);
	}

	override function ondisabled<T>(_:T) {
		overlay.color.tween(2, { a: 0 }).onComplete(function(_) {
			stateScene.empty();
		});
		// Luxe.scene = lastStateScene;
	}
}
