package effects;

import effects.Effect;

import luxe.Vector;
import luxe.Visual;

import phoenix.RenderTexture;
import phoenix.Batcher;
import phoenix.geometry.QuadGeometry;

typedef EffectData = {
	var effect:Effect;
	var postTexture:RenderTexture;
}

class Effects {
	public static var screenTextureSize(default, null):Int = 512;
	var effects:Array<EffectData> = new Array<EffectData>();

	var preEffectTexture:RenderTexture;
	var screenBatcher:Batcher;
	var screenVisual:Visual;

	var loaded:Bool = false;

	public function new() {}

	public function onload() {
        // nextLargestPowerOf2(Math.max(Luxe.screen.w, Luxe.screen.h));
		// screenTextureSize = Math.floor(Math.max(Luxe.screen.w, Luxe.screen.h));
        // var screenSize = Luxe.screen.size;

		//preEffectTexture = new RenderTexture(Luxe.resources, new Vector(screenTextureSize, screenTextureSize));
		preEffectTexture = new RenderTexture({
			id: "__effects_pre_texture",
			width: Luxe.screen.w,
			height: Luxe.screen.h
		});

		screenBatcher = Luxe.renderer.create_batcher({
			name: 'screenBatcher',
			no_add: true
		});
		screenBatcher.view.viewport = Luxe.camera.viewport;

		screenVisual = new Visual({
			pos: new Vector(),
			size: Luxe.screen.size,
			batcher: screenBatcher,
		});

		for(e in effects) {
			e.effect.onload();
		}

		loaded = true;
	}

	public function setFlip(flip:Bool) {
		// if(flip) {
		// 	screenVisual.pos.y = Luxe.screen.h - screenTextureSize;
		// 	cast(screenVisual.geometry, QuadGeometry).flipy = true;
		// }
		// else {
		// 	screenVisual.pos.y = 0;
		// 	cast(screenVisual.geometry, QuadGeometry).flipy = false;
		// }
	}

	public function addEffect(effect:Effect) {
		effects.push({
			effect: effect,
			postTexture: new RenderTexture({
				id: "__effects_post_texture." + effects.length,
				width: Luxe.screen.w,
				height: Luxe.screen.h
			})
		});

		if(loaded) {
			effect.onload();
			setFlip(effects.length % 2 == 0);
		}
	}

	public static function nextLargestPowerOf2(dimen:Float):Int {
		var y:Float = Math.floor(Math.log(dimen)/Math.log(2));
		return Std.int(Math.pow(2, y + 1));
	}

	public function update(dt:Float) {
		if(!loaded) return;

		for(e in effects) {
			e.effect.update(dt);
		}
	}

	public function onprerender() {
		if(!loaded) return;

		Luxe.renderer.target = preEffectTexture;
	}

	public function onpostrender() {
		if(!loaded) return;

		var lastTexture:RenderTexture = preEffectTexture;
		for(e in effects) {
			e.effect.apply(lastTexture, e.postTexture);
			lastTexture = e.postTexture;
		}

		Luxe.renderer.target = null;
		screenVisual.texture = lastTexture;
		screenBatcher.draw();
	}
}
