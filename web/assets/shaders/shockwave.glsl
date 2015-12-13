precision mediump float;

uniform sampler2D tex0;
varying vec2 tcoord;

// http://empire-defense.crystalin.fr/blog/2d_shock_wave_texture_with_shader
// http://www.geeks3d.com/20091116/shader-library-2d-shockwave-post-processing-filter-glsl/

uniform vec2 u_resolution;

uniform vec2 u_mouse; // Mouse position
uniform float u_effect_time; // effect elapsed time. Multiply this to affect speed.

// Amplitude?, Refraction?, Width?  e.g. 10.0, 0.8, 0.1
uniform float u_amplitude;
uniform float u_refraction;
uniform float u_width;

void main() {
    vec2 uv = tcoord;
    vec2 texCoord = uv;
    vec2 center = u_mouse / u_resolution; //vec2(u_mouse.x / u_resolution.x, (u_resolution.y - u_mouse.y) / u_resolution.y);
  	float distance = distance(uv, center);
    if ((distance <= (u_effect_time + u_width)) && (distance >= (u_effect_time - u_width))) {
        float diff = (distance - u_effect_time);
        float powDiff = 1.0 - pow(abs(diff * u_amplitude), u_refraction);
        float diffTime = diff  * powDiff;
        vec2 diffUV = normalize(uv - center);
        texCoord = uv + (diffUV * diffTime);
    }
	gl_FragColor = texture2D(tex0, texCoord);
}
