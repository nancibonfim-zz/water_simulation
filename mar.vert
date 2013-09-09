#version 120

varying vec3 r;
varying vec3 normal;
uniform float tempo;
uniform int tipo_mar; // calmo (1), agitado (2) ou com ondas altas (3)
varying float f;
varying float z;

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
 
  /* Funçoes de onda*/
  if ( tipo_mar == 1 ) {

    // funçoes seno em y
    p.y = p.y + pow( abs( (0.40 * ( sin( p.x + tempo * 1.0 ) + sin( p.z + tempo )))), 1.0);
    p.y = p.y + pow( abs( (0.20 * ( sin( p.x + tempo * 2.0 ) + sin( p.z + tempo )))), 2.0);
    // funçoes seno em x
    p.x = p.x + pow( abs( (0.10 * ( sin( p.y + tempo * 1.5 ) + sin( p.z + tempo )))), 4.0);
    p.x = p.x + pow( abs( (0.05 * ( sin( p.y + tempo * 2.5 ) + sin( p.z + tempo )))), 8.0) ;
    // funçoes cosseno em y
    p.y = p.y + pow( abs( (0.40 * ( cos( p.x + tempo * 1.0 ) + cos( p.z + tempo )))), 1.0);
    p.y = p.y + pow( abs( (0.20 * ( cos( p.x + tempo * 2.0 ) + cos( p.z + tempo )))), 2.0);
    // funçoes cosseno em x
    p.x = p.x + pow( abs( (0.10 * ( cos( p.y + tempo * 1.5 ) + cos( p.z + tempo )))), 4.0);
    p.x = p.x + pow( abs( (0.05 * ( cos( p.y + tempo * 2.5 ) + cos( p.z + tempo )))), 8.0);


    //    p.y = p.y + 1.01*((sin(p.z  + tempo)) +  (sin(p.x  + tempo)));
    p.x = p.x + 1.0 * (((sin(p.z  + tempo ))) +  (sin(p.y  + tempo * 0.5)));
  
  }
  if ( tipo_mar == 2 ) {
    // Variaveis:
    // v => vetor de direcao da onda
    // k => constante para o periodo = 2 PI / comprimento de onda XXX
    // w => potencia / speed = sqrt(10 * pi / freq ) XXX
    // tempo => tempo
    // A => amplitude
    // Restrição:
    // kA deve ser menor que 1

    float comp[2];
    comp[0] = 0.04; //XXX diminui, diminui a velocidade
    comp[1] = 0.02;
    float phase[2];
    phase[0] = 0.4;
    phase[1] = 1.0f;
    float amplitude[2];
    amplitude[0] = 0.3;
    amplitude[1] = 0.2;
    vec2 v[2];
    v[0] = vec2(0.2, 0.09);
    v[1] = vec2(1.10, 0.0);

    float k, pot;
    vec2 po = p.xz;
    float accz = 0.0;
    vec2 accxy = vec2(0.0, 0.0);

    for (int i = 0; i < 2; i++) {

      k = 2.0 * 3.141 / comp[i];
      pot = sqrt(31.14 / k);

      accxy = accxy + v[i]/k * amplitude[i] * sin(v[i] * po - pot * tempo + phase[i]);
      accz = accz + amplitude[i] * cos(v[i] * po - pot * tempo + phase[i]);

    }
    p.xz = po - accxy;
    p.y = accz;
    

    // funçoes seno em y
    p.y = p.y + pow( abs( (0.10 * ( sin( (p.x + tempo) / 8.0) + sin( p.z + tempo )))), 1.0);
    p.y = p.y + pow( abs( (0.05 * ( sin( (p.x + tempo) / 4.0 ) + sin( p.z + tempo )))), 2.0);
    // funçoes seno em x
    p.x = p.x + pow( abs( (0.05 * ( sin( (p.y + tempo) / 2.5 ) + sin( p.z + tempo )))), 4.0);
    p.x = p.x + pow( abs( (0.005 * ( sin( (p.y + tempo) / 3.5 ) + sin( p.z + tempo )))), 8.0) ;
    // funçoes cosseno em y
    p.y = p.y + pow( abs( (0.10 * ( cos( (p.x + tempo) / 2.0 ) + cos( p.z + tempo )))), 1.0);
    p.y = p.y + pow( abs( (0.05 * ( cos( (p.x + tempo )/ 2.0 ) + cos( p.z + tempo )))), 2.0);
    // funçoes cosseno em x
    p.x = p.x + pow( abs( (0.05 * ( cos( (p.y + tempo) / 2.5 ) + cos( p.z + tempo )))), 4.0);
    p.x = p.x + pow( abs( (0.005 * ( cos( (p.y + tempo) / 4.5 ) + cos( p.z + tempo )))), 8.0);

  }
  if ( tipo_mar == 3 ) {


    float comp[2];
    comp[0] = 0.2;
    comp[1] = 0.08;
    float phase[2];
    phase[0] = 1.4;
    phase[1] = 2.0f;
    float amplitude[2];
    amplitude[0] = 0.8;
    amplitude[1] = 0.4;
    vec2 v[2];
    v[0] = vec2(0.2, 0.9);
    v[1] = vec2(1.0, 0.0);

    float k, pot;
    vec2 po = p.xz;
    float accz = 0.0;
    vec2 accxy = vec2(0.0, 0.0);

    for (int i = 0; i < 2; i++) {

      k = 2.0 * 3.141 / comp[i];
      pot = sqrt(31.41 / k);

      accxy = accxy + v[i]/k * amplitude[i] * sin(v[i] * po - pot * tempo + phase[i]);
      accz = accz + amplitude[i] * cos(v[i] * po - pot * tempo + phase[i]);

    }
    p.xz = po - accxy;
    p.y = accz;

    // funçoes seno em y
    p.y = p.y + pow( abs( (0.3 * ( sin( (p.x + tempo) * 2.0 ) + sin( p.z + tempo )))), 1.0);
    p.y = p.y + pow( abs( (0.15 * ( sin( (p.x + tempo) * 4.0 ) + sin( p.z + tempo )))), 2.0);
    // funçoes seno em x
    p.x = p.x + pow( abs( (0.20 * ( sin( (p.y + tempo) * 1.5 ) + sin( p.z + tempo )))), 4.0);
    p.x = p.x + pow( abs( (0.1 * ( sin( (p.y + tempo) * 2.5 ) + sin( p.z + tempo )))), 8.0) ;
    // funçoes cosseno em y
    p.y = p.y + pow( abs( (0.25 * ( cos( (p.x + tempo) * 1.0 ) + cos( p.z + tempo )))), 1.0);
    p.y = p.y + pow( abs( (0.15 * ( cos( (p.x + tempo )* 2.0 ) + cos( p.z + tempo )))), 2.0);
    // funçoes cosseno em x
    p.x = p.x + pow( abs( (0.15 * ( cos( (p.y + tempo) * 1.5 ) + cos( p.z + tempo )))), 4.0);
    p.x = p.x + pow( abs( (0.08 * ( cos( (p.y + tempo) * 2.5 ) + cos( p.z + tempo )))), 8.0);

 }

  // Set the position of the current vertex 
  gl_Position = gl_ModelViewProjectionMatrix * p  + ftransform(); //gl_Vertex;
}
