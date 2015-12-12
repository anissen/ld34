package states;

import luxe.States;
import luxe.Scene;
import luxe.Vector;

class Play extends State {
	var lastStateScene:Scene;
	var stateScene:Scene;

	public function new() {
		super({ name: 'Play' });
		stateScene = new Scene('Play');
	}

	override function onenter<T>(_:T) {
		Luxe.camera.center = new Vector();
		lastStateScene = Luxe.scene;
		Luxe.scene = stateScene;

		Luxe.draw.circle({ x: 100, y: 100, r: 100, color: new luxe.Color(1, 0, 0.5) });
		Luxe.draw.circle({ x: 120, y: 120, r: 40, color: new luxe.Color(0, 1, 0.5) });
	}

	override function onleave<T>(_:T) {
		stateScene.empty();
		Luxe.scene = lastStateScene;
	}
}
