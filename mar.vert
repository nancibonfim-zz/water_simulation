varying vec3 r;
varying vec3 normal;
uniform float tempo;
uniform int tipo_mar; // calmo (1), agitado (2) ou com ondas altas (3)

// duas sine waves em x
// duas sine waves em y
// duas cosine waves em x 
// duas cosine waves em y
// duas ripple waves

void main() {
  gl_TexCoord[0] = gl_MultiTexCoord0;  
  r = vec3(normalize(gl_ModelViewMatrix * gl_Vertex));
  normal = normalize(gl_NormalMatrix * gl_Normal);
  
  vec4 p = gl_Vertex;
  
  if ( tipo_mar == 1 ) {

    // funçoes seno em y
    p.y = p.y + pow( (0.40 * ( sin( p.x + tempo * 1.0 ) + sin( p.z + tempo ) ) ), 1.0);
    p.y = p.y + pow( (0.20 * ( sin( p.x + tempo * 2.0 ) + sin( p.z + tempo ) ) ), 2.0);
    // funçoes seno em x
    p.x = p.x + pow( (0.10 * ( sin( p.y + tempo * 1.5 ) + sin( p.z + tempo ) ) ), 5.0);
    p.x = p.x + pow( (0.05 * ( sin( p.y + tempo * 2.5 ) + sin( p.z + tempo ) ) ), 10.0) ;
    // funçoes cosseno em y
    p.y = p.y + pow( (0.40 * ( cos( p.x + tempo * 1.0 ) + cos( p.z + tempo ) ) ), 1.0);
    p.y = p.y + pow( (0.20 * ( cos( p.x + tempo * 2.0 ) + cos( p.z + tempo ) ) ), 2.0);
    // funçoes cosseno em x
    p.x = p.x + pow( (0.10 * ( cos( p.y + tempo * 1.5 ) + cos( p.z + tempo ) ) ), 5.0);
    p.x = p.x + pow( (0.05 * ( cos( p.y + tempo * 2.5 ) + cos( p.z + tempo ) ) ), 10.0) ;
        
  }
  if ( tipo_mar == 2 ) {
    // funçoes seno em y
    p.y = p.y + pow( (1.0 * ( sin( p.x + tempo * 1.0 ) + sin( p.z + tempo ) ) ), 1.0);
    p.y = p.y + pow( (0.50 * ( sin( p.x + tempo * 1.6 ) + sin( p.z + tempo ) ) ), 1.0);
    // funçoes seno em x
    p.x = p.x + pow( (0.30 * ( sin( p.y + tempo * 1.5 ) + sin( p.z + tempo ) ) ), 1.0);
    p.x = p.x + pow( (0.20 * ( sin( p.y + tempo * 2.5 ) + sin( p.z + tempo ) ) ), 10.0) ;
    // funçoes cosseno em y
    p.y = p.y + pow( (0.7 * ( cos( p.x + tempo * 1.0 ) + cos( p.z + tempo ) ) ), 1.0);
    p.y = p.y + pow( (0.3 * ( cos( p.x + tempo * 2.0 ) + cos( p.z + tempo ) ) ), 1.0);
    // funçoes cosseno em x
    p.x = p.x + pow( (0.10 * ( cos( p.y + tempo * 1.5 ) + cos( p.z + tempo ) ) ), 1.0);
    p.x = p.x + pow( (0.05 * ( cos( p.y + tempo * 2.5 ) + cos( p.z + tempo ) ) ), 10.0) ;
    
  }
  if ( tipo_mar == 3 ) {
    // funçoes seno em y
    p.y = p.y + pow( (0.9 * ( sin( p.x + tempo * 1.5 ) + sin( p.z + tempo ) ) ), 1.0);
    p.y = p.y + pow( (0.7 * ( sin( p.x + tempo * 1.8 ) + sin( p.z + tempo ) ) ), 2.0);
    // funçoes seno em x
    p.x = p.x + pow( (0.5 * ( sin( p.y + tempo * 1.5 ) + sin( p.z + tempo ) ) ), 5.0);
    p.x = p.x + pow( (0.3 * ( sin( p.y + tempo * 2.5 ) + sin( p.z + tempo ) ) ), 10.0) ;
    // funçoes cosseno em y
    p.y = p.y + pow( (0.9 * ( cos( p.x + tempo * 1.0 ) + cos( p.z + tempo ) ) ), 1.0);
    p.y = p.y + pow( (0.6 * ( cos( p.x + tempo * 2.0 ) + cos( p.z + tempo ) ) ), 2.0);
    // funçoes cosseno em x
    p.x = p.x + pow( (0.2 * ( cos( p.y + tempo * 1.5 ) + cos( p.z + tempo ) ) ), 5.0);
    p.x = p.x + pow( (0.1 * ( cos( p.y + tempo * 2.5 ) + cos( p.z + tempo ) ) ), 10.0) ;

 }

  // Set the position of the current vertex 
  gl_Position = gl_ModelViewProjectionMatrix * p + ftransform(); //gl_Vertex;
}

