varying vec3 r;
varying vec3 normal;
uniform float tempo;
uniform int tipo_mar; // calmo (1), agitado (2) ou com ondas altas (3)

// duas sine waves em x
// duas sine waves em y
// duas cosine waves em x 
// duas cosine waves em y
// duas ripple waves

float onda_seno(float x) { 
  float f = 0.0f;
  for (int i = 0; i < 4; ++i) {
    //
    f = f + pow(float((5.0f - float(i)) * sin(x - 0.4f * float(i))), 20.0f);
  }
  f = f / float(10);
  return f;
}


void main() {
  gl_TexCoord[0] = gl_MultiTexCoord0;  
  r = vec3(normalize(gl_ModelViewMatrix * gl_Vertex));
  normal = normalize(gl_NormalMatrix * gl_Normal);
  
  vec4 p = gl_Vertex;
  
  if (tipo_mar == 1) {
    p.z = p.z + onda_seno(p.x) + onda_seno(p.y);
  }

	
    // Set the position of the current vertex 
	gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
}

