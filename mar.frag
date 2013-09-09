varying vec3 r;
uniform sampler2D textura;
varying vec3 normal;
varying vec4 p;
varying vec4 E;
// direcao do ponto luminoso
const vec3 Ln = vec3(0.913, 0.365, 0.183);
const float r0 = 0.1;  // reflexão de Fresnel para ângulo 0
vec3 reflectDiff;
uniform sampler2D env;
uniform sampler2D normalM;

mat3 cotangent_frame( vec3 N, vec3 p, vec2 uv ) {
    // get edge vectors of the pixel triangle
    vec3 dp1 = dFdx( p );
    vec3 dp2 = dFdy( p );
    vec2 duv1 = dFdx( uv );
    vec2 duv2 = dFdy( uv );
 
    // solve the linear system
    vec3 dp2perp = cross( dp2, N );
    vec3 dp1perp = cross( N, dp1 );
    vec3 T = dp2perp * duv1.x + dp1perp * duv2.x;
    vec3 B = dp2perp * duv1.y + dp1perp * duv2.y;
 
    // construct a scale-invariant frame 
    float invmax = inversesqrt( max( dot(T,T), dot(B,B) ) );
    return mat3( T * invmax, B * invmax, N );
}
vec3 perturb_normal( vec3 N, vec3 V, vec2 texcoord ) {
  // V, the view vector (vertex to eye)
  vec3 map = texture2D(textura, texcoord ).xyz;
  map = map * 255./127. - 128./127.;
  mat3 TBN = cotangent_frame(N, -V, texcoord);
  return normalize(TBN * map);
}

void main() {
	
  vec4 texel = texture2D(textura, r.st);
  vec2 uv = r.st;//gl_TexCoord[0].xy;

  /* Iluminaçao e cor - simples */

  vec3 light = normalize(gl_LightSource[0].position.xyz - r); // direcao da luz
  vec3 eye = normalize(-r);
  vec3 reflexao = normalize(-reflect(light, normal));  
  // componente ambiente
  vec4 l_amb = gl_FrontLightProduct[0].ambient;
  // componente difusa
  vec4 l_difusa = gl_FrontLightProduct[0].diffuse * max(dot(normal,light), 0.0);   
      l_difusa = clamp(l_difusa, 0.0, 1.0);
  // componente especular
  vec4 l_espec = gl_FrontLightProduct[0].specular * 
    pow(max(dot(reflexao, eye),0.0), 0.3 * gl_FrontMaterial.shininess);
    l_espec = clamp(l_espec, 0.0, 1.0);

  /* Aplicando normal perturbada */
  
  vec3 PN = perturb_normal( normal, eye, uv ); // normal mapping  
  vec4 cor_textura = texture2D(textura, uv).rgba;
  vec4 cor_final = vec4(0.0, 0.5, 1.0, 1.0);
  
  
  float lambertTerm = dot(PN, light);
  if (lambertTerm > 0.0) {
    cor_final += cor_textura * gl_LightSource[0].diffuse * gl_FrontMaterial.diffuse * lambertTerm;
    float spec = pow(max(dot(reflexao, eye),0.0), 0.3 * gl_FrontMaterial.shininess);
    cor_final += spec * gl_FrontMaterial.specular * gl_LightSource[0].specular;
  } 
  else {
    //     cor_final +=  pow(max(dot(reflexao, eye),0.0), 0.3 * gl_FrontMaterial.shininess) * gl_FrontMaterial.specular * gl_LightSource[0].specular;
  }

  /* Refletividade e transmissividade de Fresnel */
  vec4 specularReflection;
  if (dot(normal, light) < 0.0) {
    // light source on the wrong side? 
    specularReflection = vec4(0.0, 0.0, 0.0, 0.0); 
    // no specular reflection
  }
  else { // light source on the right side
    vec3 halfwayDirection = normalize(light + eye);
    float w = pow(1.0 - max(0.0, dot(halfwayDirection, eye)), 5.0);
    // definindo attenuation como 0.5
    specularReflection = 0.5 * vec4(gl_LightSource[0].diffuse) * mix(vec4(gl_LightSource[0].specular), vec4(1.0), w)
      * pow(max(0.0, dot(reflect(-light, normal), eye)), gl_FrontMaterial.shininess);
  }



  /* Adicionando spotlight */

  vec4 xi = vec4(r, 0.0);
  vec4 E = normalize(-xi); 
  vec3 In = normalize(p.xyz * E.w - E.xyz * p.w); // view
  vec3 diff_luz_eye = normalize(Ln - In); // diferença entre a luz e a visão
  // cor
  float diff = max(0.0, dot(normal,Ln));
  float spot_especular = pow(max(0.0 ,dot(normal, diff_luz_eye)), 16.0);  

  vec3 reflectSpot = reflect(In, normal);
  vec3 reflectDiff = normalize(reflectSpot - In);

  float fresnel = r0 + (1.0 - r0) * pow(1.0 + dot(In, reflectDiff), 5.0);
  vec4 env = texture2D(textura, 0.5 + 0.5 * normalize(reflectSpot + vec3(0, 0, 1)).xy);
  vec4 cor_spot = gl_LightSource[0].ambient + gl_LightSource[0].diffuse * diff + gl_LightSource[0].specular * spot_especular;
  //  vec4 cor_spot = l_amb + l_difusa + l_espec;
  
  
  /* Compondo as componentes cores */
  gl_FragColor.rgb = vec3(0.0, 0.0, 0.0);
  //gl_FragColor += mix(env, cor_spot, fresnel);
  
  gl_FragColor = (gl_FrontLightModelProduct.sceneColor + l_amb + l_difusa + l_espec ) * texel;  
  //gl_FragColor.rgb += cor_final.rgb;
  //gl_FragColor.rgb += PN.rgb ;//+ cor_final.rgb;
  //gl_FragColor.rgb = normal.rgb;
  //gl_FragColor.a = texel.a;
  //gl_FragColor *= texel;
 
}
