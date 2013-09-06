varying vec3 r;
uniform sampler2D envMapText;

void main() {
	
	vec2 coord = vec2(r.x, r.y);
	
	vec4 texel = texture2D(envMapText, coord.st);
	
    // Set the output color of our current pixel
	gl_FragColor = texel;
}
