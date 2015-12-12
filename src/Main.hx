import effects.GlitchEffect;
import luxe.Input;
import luxe.States;
import luxe.Parcel;
import luxe.ParcelProgress;

import effects.*;

class Main extends luxe.Game {
	private static var fsm:States;
	var effects:Effects = new Effects();
    var bloomEffect :BloomEffect;
	var shockwaveEffect :ShockwaveEffect;

    override function config(config:luxe.AppConfig) {
        config.preload.jsons.push({ id: 'assets/parcel.json' });
        return config;
    }

	override function ready() {
		var parcel = new Parcel();
		parcel.from_json(Luxe.resources.json('assets/parcel.json').asset.json);
		new ParcelProgress({
			parcel: parcel,
			oncomplete: assetsLoaded
		});
		parcel.load();
	}

	function assetsLoaded(_) {
		Luxe.renderer.clear_color = new luxe.Color(0.5, 0.6, 1.0, 1);

		// set up the VFX
		effects.onload();

        bloomEffect = new BloomEffect();
        effects.addEffect(bloomEffect);

        shockwaveEffect = new ShockwaveEffect();
        effects.addEffect(shockwaveEffect);

		effects.addEffect(new VignetteEffect());

		// set up the state machine
		fsm = new States();
		fsm.add(new states.Play());
		fsm.set('Play');

		Luxe.events.listen('got_drop', function(data :{ pos :luxe.Vector }) {
			shockwaveEffect.elapsed_effect_time = 0.0;
	        shockwaveEffect.effect_time = 3.0;
	        shockwaveEffect.mouse_pos = Luxe.camera.world_point_to_screen(data.pos);
		});
	}

	override function onkeyup( e:KeyEvent ) {
		if(e.keycode == Key.escape) {
			Luxe.shutdown();
		}
	}

    override function onmousedown(e :MouseEvent) {

    }

	override function update(dt:Float) {
		// if (bloomEffect != null) bloomEffect.radius = Math.abs(Math.sin(Luxe.time * 0.5)) * 5.0;
		effects.update(dt);
	}

	override function onprerender() {
		effects.onprerender();
	}

	override function onpostrender() {
		effects.onpostrender();
	}
}
