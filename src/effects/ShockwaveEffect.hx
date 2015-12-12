package effects;

import luxe.utils.Maths;
import luxe.Visual;
import luxe.Color;
import phoenix.Batcher;
import phoenix.Shader;
import luxe.Vector;
import phoenix.RenderTexture;

import effects.Effect;

class ShockwaveEffect extends Effect {
    var shader :Shader;

    // var greyscaleConversion :Vector = new Vector(0.299, 0.587, 0.114);
    // var sepiaColour :Vector = new Vector(1.3, 1.1, 0.9);
    public var effect_time :Float = 0;
    public var elapsed_effect_time :Float = 0;
    public var mouse_pos :Vector;

    public function new() {
        super('ShockwaveEffect');
    }

    override public function onload() {
        // load the shader
        shader = Luxe.resources.shader('shockwave');
        shader.set_vector2('u_resolution', new Vector(Luxe.screen.w, Luxe.screen.h));
        shader.set_float('u_effect_time', 0.0);
        shader.set_vector2('u_mouse', new Vector());
        shader.set_float('u_amplitude', 5.0);
        shader.set_float('u_refraction', 0.8);
        shader.set_float('u_width', 0.05);

        setupVisuals();
        outputVisual.shader = shader;
    }

    override public function update(dt :Float) {
        if (elapsed_effect_time < effect_time) elapsed_effect_time += dt;
        if (elapsed_effect_time > effect_time) elapsed_effect_time = effect_time;
        shader.set_float('u_effect_time', elapsed_effect_time);
        if (mouse_pos != null) shader.set_vector2('u_mouse', mouse_pos);
    }
}
