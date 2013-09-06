varying vec3 r;

void main() {			
	gl_TexCoord[0] = gl_MultiTexCoord0;
	
	vec3 vert = normalize(vec3(gl_ModelViewMatrix * gl_Vertex));
	
	vec3 normal = normalize(vec3(gl_NormalMatrix * gl_Normal));
	
	r = reflect(vert, normal);

    // Set the position of the current vertex 
	gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
}
