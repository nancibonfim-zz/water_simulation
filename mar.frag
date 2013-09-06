varying vec3 r;
uniform sampler2D envMapText;

void main() {
	
	float m = 2.0 * sqrt( r.x*r.x + r.y*r.y + (r.z+1.0)*(r.z+1.0) );
	
	vec2 coord = vec2(r.x/m + 0.5, r.y/m + 0.5);
	
	vec4 texel = texture2D(envMapText, coord.st);
	
    // Set the output color of our current pixel
	gl_FragColor = texel;
}

