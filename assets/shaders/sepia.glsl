precision mediump float;

uniform sampler2D tex0;
varying vec2 tcoord;
varying vec4 color;

uniform vec3 greyscaleConversion;
uniform vec3 sepiaColour;

void main() {
	vec4 fragColour = color * texture2D(tex0, tcoord);

	/*vec4 sepia = vec4(fragColour.a);
	sepia.r = (fragColour.r * 0.393) + (fragColour.g * 0.769) + (fragColour.b * 0.189);
	sepia.g = (fragColour.r * 0.349) + (fragColour.g * 0.686) + (fragColour.b * 0.168);
	sepia.b = (fragColour.r * 0.272) + (fragColour.g * 0.534) + (fragColour.b * 0.131);

	gl_FragColor = sepia;*/

	float grey = dot(fragColour.rgb, greyscaleConversion);
	gl_FragColor = vec4(vec3(grey) * sepiaColour, fragColour.a);
}
