varying vec3 r;
varying vec3 normal;

void main() {			
	gl_TexCoord[0] = gl_MultiTexCoord0;
	
    r = vec3(normalize(gl_ModelViewMatrix * gl_Vertex));

    normal = normalize(gl_NormalMatrix * gl_Normal);
	
    // Set the position of the current vertex 
	gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
}

