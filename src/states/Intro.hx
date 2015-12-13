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
	var stateScene:Scene;

	var overlay :Sprite;

	public function new() {
		super({ name: 'Intro' });
		stateScene = new Scene('Intro');
	}

	override function onenter<T>(data :T) {
		// lastStateScene = Luxe.scene;
		// Luxe.scene = stateScene;

		overlay = new Sprite({
			pos: Luxe.camera.center,
            name: 'overlay',
            centered: true,
            // size: Luxe.screen.size, //clone().multiplyScalar(2),
            color: new Color(1,1,1,0),
			texture: cast data,
            depth: 10,
			scene: stateScene
        });

		overlay.color.tween(2, { a: 1 });

		spring_intro();
	}

	function spring_intro() {
		intro = true;
		Luxe.events.fire('start_intro', null);
	}

	override function onleave<T>(_:T) {
		stateScene.empty();
		// Luxe.scene = lastStateScene;
	}
}
