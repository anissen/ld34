precision mediump float;

uniform sampler2D tex0;
varying vec2 tcoord;
varying vec4 color;

uniform vec2 resolution;
uniform float radius;
uniform float softness;

void main() {
	vec4 fragColour = color * texture2D(tex0, tcoord);
	vec2 position = (gl_FragCoord.xy / resolution.xy) - vec2(0.5);
	float len = length(position);
	float vignette = smoothstep(radius, radius - softness, len);
	gl_FragColor = vec4(mix(fragColour.rgb, fragColour.rgb * vignette, 0.5), fragColour.a);
}
