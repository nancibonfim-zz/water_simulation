#version 120

varying vec3 r;
varying vec3 normal, binormal, tangente;
uniform float tempo;
uniform int tipo_mar; // calmo (1), agitado (2) ou com ondas altas (3)
varying float f;
varying float z;
varying vec4 p;

// duas sine waves em x
// duas sine waves em y
// duas cosine waves em x 
// duas cosine waves em y
// duas ripple waves

void main() {
  gl_TexCoord[0] = gl_MultiTexCoord0;  
  r = vec3(normalize(gl_ModelViewMatrix * gl_Vertex));
  
  p = gl_Vertex;


  float comp[8]; // coordenadas de mundo
  float phase[8]; // segundos * PI / comp
  float amplitude[8]; // coordenadas de mundo
  vec2 v[8];
  float sharpness[8]; // 1 - muito pontiaguda, 1000 é bem pouco
  float nondas;

  float k;
  float accy = 0.0;
  vec2 accxz = vec2(0.0, 0.0);

  vec3 B = vec3(1.0, 0.0, 0.0),
    T = vec3(0.0, 1.0, 0.0),
    N = vec3(0.0, 0.0, 1.0);
 
  /* Funçoes de onda*/
  if ( tipo_mar == 1 ) {
    nondas = 8 ;

    comp[0] = 1.5; //XXX diminui, diminui a velocidade
    comp[1] = 1.2;
    comp[2] = 0.75;
    comp[3] = 0.38;
    comp[4] = 4.0;
    comp[5] = 8.0;
    comp[6] = 15.0;
    comp[7] = 17.0;


    phase[0] = 3.14 / (3 * comp[0]);
    phase[1] = 3.14 / (5 * comp[1]);
    phase[2] = 3.14 / (10 * comp[2]);
    phase[3] = 3.14 / (60 * comp[3]);
    phase[4] = 3.14 / (8 * comp[4]);
    phase[5] = 3.14 / (4 * comp[5]);
    phase[6] = 3.14 / (7 * comp[6]);
    phase[7] = 3.14 / (9 * comp[7]);


    amplitude[0] = 0.15;
    amplitude[1] = 0.14;
    amplitude[2] = 0.1;
    amplitude[3] = 0.05;
    amplitude[4] = 0.3;
    amplitude[5] = 0.15;
    amplitude[6] = 0.6;
    amplitude[7] = 0.4;


    v[0] = normalize(vec2(-0.2, -0.45));
    v[1] = normalize(vec2(-1.10, -0.45));
    v[2] = normalize(vec2(-1.10, -0.45));
    v[3] = normalize(vec2(-1.10, -0.01));
    v[4] = normalize(vec2(-1.10, -0.45));
    v[5] = normalize(vec2(-1.009, -0.001));
    v[6] = normalize(vec2(-1.10, -0.45));
    v[7] = normalize(vec2(-1.009, -0.001));

    sharpness[0] = 8.0;
    sharpness[1] = 16.0;
    sharpness[2] = 3.0;
    sharpness[3] = 5.0;
    sharpness[4] = 80.0;
    sharpness[5] = 160.0;
    sharpness[6] = 8.0;
    sharpness[7] = 10.0;


  }
  if ( tipo_mar == 2 ) {
    
    nondas = 4;

    comp[0] = 4.0;
    comp[1] = 3.0;
    comp[2] = 1.0;
    comp[3] = 0.7;

    phase[0] = 3.14 / comp[0];
    phase[1] = 3.14 / (2 * comp[1]);
    phase[2] = 3.14 / comp[2];
    phase[3] = 3.14 / (2 * comp[3]);

    amplitude[0] = 0.9; 
    amplitude[1] = 1.6;
    amplitude[2] = 0.5; 
    amplitude[3] = 0.4;

    v[0] = normalize(vec2(-1.0, 0.0));
    v[1] = normalize(vec2(-0.95, 0.0));
    v[2] = normalize(vec2(-1.05, 0.0));
    v[3] = normalize(vec2(-0.8, 0.0));

    sharpness[0] = 10.0;
    sharpness[1] = 5.0;
    sharpness[2] = 10.0;
    sharpness[3] = 50.0;

  }
  if ( tipo_mar == 3 ) {
    nondas = 6;

    comp[0] = 4.0;
    comp[1] = 8.0;
    comp[2] = 16.0;
    comp[3] = 2.0;
    comp[4] = 1.0;
    comp[5] = 32.0;

    phase[0] = 3.14 / comp[0];
    phase[1] = 3.14 / (3 * comp[1]);
    phase[2] = 3.14 / (3 * comp[2]);
    phase[3] = 3.14 / comp[3];
    phase[4] = 3.14 / (0.5 *comp[4]);
    phase[5] = 3.14 / ( 0.3*comp[5]);

    amplitude[0] = 0.4;
    amplitude[1] = 0.7;
    amplitude[2] = 1.0;
    amplitude[0] = 0.35;
    amplitude[1] = 0.8;
    amplitude[2] = 0.95;

    v[0] = normalize(vec2(-1.0, -0.5));
    v[1] = normalize(vec2(-1.0, 0.0));
    v[2] = normalize(vec2(-1.0, 0.0));
    v[3] = normalize(vec2(-0.95, -0.5));
    v[4] = normalize(vec2(-1.0, 0.5));
    v[5] = normalize(vec2(0.90, 0.0));

    sharpness[0] = 5.0;
    sharpness[1] = 10.0;
    sharpness[2] = 10.0;
    sharpness[3] = 4.0;
    sharpness[4] = 3.0;
    sharpness[5] = 7.0;
 }


  for (int i = 0; i < nondas; i++) {
    k = 2.0 * 3.141 / comp[i];

    accxz = accxz + (1 / (sharpness[i] * k)) * v[i] * cos(dot(v[i], p.xz) * k + tempo * sqrt(phase[i]));
    accy = accy + amplitude[i] * sin(dot(v[i], p.xz) * k + tempo * sqrt(phase[i]));

  }
  p.y = p.y - accy;
  p.xz = p.xz - accxz;

  for (int i = 0; i < nondas; i++) {
    k = 2.0 * 3.141 / comp[i];
    // bitangente, tangente, normal
    float WA, S, C, Q;
    WA = k * amplitude[i];
    S = sin(k*dot(v[i], p.xz) + sqrt(phase[i]) * tempo); //XXX verificar se precisa do y
    C = cos(k*dot(v[i], p.xz) + sqrt(phase[i]) * tempo); //XXX verificar se precisa do y
    Q = (1 / (k * sharpness[i] * amplitude[i]));

    // bitangente
    B.x -= (Q * v[i].x * v[i].x * WA * S);
    B.z -= (Q * v[i].x * v[i].y * WA * S);
    B.y += (v[i].x * WA * C);

    // tangente
    T.x -= (Q * v[i].x * v[i].y * WA * S);
    T.z -= (Q * v[i].y * v[i].y * WA * S);
    T.y += (v[i].y * WA * C);

    // normal
    N.x -= (v[i].x * WA * C);
    N.z -= (v[i].y * WA * C);
    N.y -= (Q * WA * S);

  }
  normal = normalize(N);

  // normal = gl_NormalMatrix *
  //                    gl_Normal;

  binormal = normalize(B);
  tangente = normalize(T);



  // Set the position of the current vertex 
  gl_Position = gl_ModelViewProjectionMatrix * p + ftransform(); //gl_Vertex;
}
