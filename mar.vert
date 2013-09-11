#version 120

varying vec3 r;
varying vec3 normal, binormal, tangente;
uniform float tempo;
uniform int tipo_mar; // calmo (1), agitado (2) ou com ondas altas (3)
//uniform vec3 worldCameraPos;
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
  
  p = gl_Vertex;



  
  r = vec3(normalize(gl_ModelViewMatrix * gl_Vertex)); //XXX remover


  float comp[10]; // coordenadas de mundo
  float phase[10]; // segundos * PI / comp
  float amplitude[10]; // coordenadas de mundo
  vec2 v[10];
  float sharpness[10]; // 1 - muito pontiaguda, 1000 é bem pouco
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
    
    nondas = 8;

    comp[0] = 16.0;
    comp[1] = 20.0;
    comp[2] = 2.0;
    comp[3] = 3.0;
    comp[4] = 2.0;
    comp[5] = 8.0;
    comp[6] = 15.0;
    comp[7] = 17.0;

    phase[0] = 3.14 / comp[0];
    phase[1] = 3.14 / (20 * comp[1]);
    phase[2] = 3.14 / ( 1.4 * comp[2]);
    phase[3] = 3.14 / (30 * comp[3]);
    phase[4] = 3.14 / (80 * comp[4]);
    phase[5] = 3.14 / (40 * comp[5]);
    phase[6] = 3.14 / (70 * comp[6]);
    phase[7] = 3.14 / (90 * comp[7]);

    amplitude[0] = 2.7; 
    amplitude[1] = 2.2;
    amplitude[2] = 0.21; 
    amplitude[3] = 0.23;
    amplitude[4] = 0.29;
    amplitude[5] = 0.15;
    amplitude[6] = 0.6;
    amplitude[7] = 0.4;

    v[0] = normalize(vec2(-1.0, 0.0));
    v[1] = normalize(vec2(-0.95, 0.1));
    v[2] = normalize(vec2(-0.05, -0.47));
    v[3] = normalize(vec2(1.1, 0.0));
    v[4] = normalize(vec2(-1.10, -0.45));
    v[5] = normalize(vec2(-1.009, -0.001));
    v[6] = normalize(vec2(-1.10, -0.45));
    v[7] = normalize(vec2(-1.009, -0.001));


    sharpness[0] = 10.0;
    sharpness[1] = 5.0;
    sharpness[2] = 10.0;
    sharpness[3] = 20.0;
    sharpness[4] = 8.0;
    sharpness[5] = 16.0;
    sharpness[6] = 4.0;
    sharpness[7] = 2.0;

  }
  if ( tipo_mar == 3 ) {
    nondas = 10;

    comp[0] = 4.0;
    comp[1] = 6.0;
    comp[2] = 16.0;
    comp[3] = 10.0;
    comp[4] = 2.0;
    comp[5] = 3.0;
    comp[6] = 2.0;
    comp[7] = 8.0;
    comp[8] = 19.0;
    comp[9] = 14.0;

    phase[0] = 3.14 / comp[0];
    phase[1] = 3.14 * 5.5/ ( comp[1]);
    phase[2] = 3.14 * 4.5 / ( comp[2]);
    phase[3] = 3.14 * 7 /  comp[3];
    phase[4] = 3.14 * 3/ (  comp[4]);
    phase[5] = 3.14 * 2/ ( comp[5]);
    phase[6] = 3.14 / (1.2 * comp[6]);
    phase[7] = 3.14 * 10.5/ (comp[7]);
    phase[8] = 3.14 * 5 / ( comp[8]);
    phase[9] = 3.14 * 3 / ( comp[8]);

    amplitude[0] = 0.4;
    amplitude[1] = 0.7;
    amplitude[2] = 1.2;
    amplitude[3] = 2.35;
    amplitude[4] = 0.21; 
    amplitude[5] = 0.23;
    amplitude[6] = 0.29;
    amplitude[7] = 0.15;
    amplitude[8] = 2.0;
    amplitude[9] = 2.1;

    v[0] = normalize(vec2(-1.0, -0.5));
    v[1] = normalize(vec2(-1.0, 0.1));
    v[2] = normalize(vec2(-1.2, 0.2));
    v[3] = normalize(vec2(-0.95, -0.1));
    v[4] = normalize(vec2(-0.05, -0.47));
    v[5] = normalize(vec2(1.1, 0.0));
    v[6] = normalize(vec2(-1.10, -0.45));
    v[7] = normalize(vec2(-1.009, -0.001));
    v[8] = normalize(vec2(-0.909, -0.101));
    v[9] = normalize(vec2(-0.909, -0.101));

    sharpness[0] = 5.0;
    sharpness[1] = 10.0;
    sharpness[2] = 10.0;
    sharpness[3] = 4.0;
    sharpness[4] = 10.0;
    sharpness[5] = 20.0;
    sharpness[6] = 8.0;
    sharpness[7] = 16.0;
    sharpness[8] = 100.0;
    sharpness[9] = 10.0;

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

    // // bitangente
    // B.x -= (Q * v[i].x * v[i].x * WA * S);
    // B.z -= (Q * v[i].x * v[i].y * WA * S);
    // B.y += (v[i].x * WA * C);

    // // tangente
    // T.x -= (Q * v[i].x * v[i].y * WA * S);
    // T.z -= (Q * v[i].y * v[i].y * WA * S);
    // T.y += (v[i].y * WA * C);

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



  //  r = vec3(normalize(gl_ModelViewMatrix * p));

  // Set the position of the current vertex 
  gl_Position = gl_ModelViewProjectionMatrix * p + ftransform();
}
