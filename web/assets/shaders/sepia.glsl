precision mediump float;

uniform sampler2D tex0;
varying vec2 tcoord;
varying vec4 color;

uniform vec3 greyscaleConversion;
uniform vec3 sepiaColor;
uniform float amount;

void main() {
	vec4 fragColor = color * texture2D(tex0, tcoord);

	/*vec4 sepia = vec4(fragColor.a);
	sepia.r = (fragColor.r * 0.393) + (fragColor.g * 0.769) + (fragColor.b * 0.189);
	sepia.g = (fragColor.r * 0.349) + (fragColor.g * 0.686) + (fragColor.b * 0.168);
	sepia.b = (fragColor.r * 0.272) + (fragColor.g * 0.534) + (fragColor.b * 0.131);

	gl_FragColor = sepia;*/

	float grey = dot(fragColor.rgb, greyscaleConversion);
	gl_FragColor = vec4(mix(fragColor.rgb, vec3(grey) * sepiaColor, amount), fragColor.a);
}
