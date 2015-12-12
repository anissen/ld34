package effects;

import luxe.utils.Maths;
import luxe.Visual;
import luxe.Color;
import phoenix.Batcher;
import phoenix.Shader;
import luxe.Vector;
import phoenix.RenderTexture;

import effects.Effect;

class VignetteEffect extends Effect {
	var shader:Shader;

	var radius:Float = 0.75;
	var softness:Float = 0.45;

	public function new() {
		super('VignetteEffect');
	}

	override public function onload() {
		// load the shader
		shader = Luxe.resources.shader('vignette');
		shader.set_vector2('resolution', new Vector(Luxe.screen.w, Luxe.screen.h));
		shader.set_float('radius', radius);
		shader.set_float('softness', softness);

		setupVisuals();
		outputVisual.shader = shader;
	}
}
