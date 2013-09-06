varying vec3 r;
//varying vec4 diffuse;
uniform sampler2D text;

void main() {
	
	vec4 texel = texture2D(text, r.st);

    vec3 L = normalize(gl_LightSource[0].position.xyz - r);   

	
    // Set the output color of our current pixel
    //gl_LightSource[0]
    gl_FragColor = (gl_FrontMaterial.ambient + gl_FrontMaterial.diffuse) * texel;
}
