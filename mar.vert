varying vec3 r;

void main() {			
	gl_TexCoord[0] = gl_MultiTexCoord0;
	
    r = normalize(vec3(gl_ModelViewMatrix * gl_Vertex));
	
    // Set the position of the current vertex 
	gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
}

