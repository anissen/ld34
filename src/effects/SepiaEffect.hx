package effects;

import luxe.utils.Maths;
import luxe.Visual;
import luxe.Color;
import phoenix.Batcher;
import phoenix.Shader;
import luxe.Vector;
import phoenix.RenderTexture;

import effects.Effect;

class SepiaEffect extends Effect {
	var shader:Shader;

	var greyscaleConversion:Vector = new Vector(0.299, 0.587, 0.114);
	var sepiaColor:Vector = new Vector(1.3, 1.1, 0.9);

	@:isVar public var amount(default, set) :Float;

	public function new() {
		super('SepiaEffect');
	}

	override public function onload() {
		// load the shader
		shader = Luxe.resources.shader('sepia');
		shader.set_vector3('greyscaleConversion', greyscaleConversion);
		shader.set_vector3('sepiaColor', sepiaColor);

		setupVisuals();
		outputVisual.shader = shader;
	}

	function set_amount(_a :Float) {
		if(shader != null) {
			shader.set_float('amount', _a);
		}
		return amount = _a;
	}
}
