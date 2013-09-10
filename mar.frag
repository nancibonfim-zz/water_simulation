varying vec3 r;
uniform sampler2D text;
varying vec3 normal, binormal, tangente;

const float r0 = 0.1;		// Fresnel reflectance at zero angle
varying vec4 p;

void main() {
	
  vec4 texel = texture2D(text, r.st);
 
  mat3 TBN = mat3(tangente, binormal, normal);

  /* Iluminaçao*/
  vec3 lightVec = gl_LightSource[0].position.xyz - r;
  float attenuation = 40.0 / length(lightVec);
  vec3 light = normalize(lightVec); 
  vec3 eye = normalize(-r); // we are in Eye Coordinates, so EyePos is (0,0,0)
  
  vec3 reflexao = normalize(reflect(-light, normal));  

  // componente ambiente
  vec4 l_amb = gl_FrontLightProduct[0].ambient;
  // componente difusa
  vec4 l_difusa = gl_FrontLightProduct[0].diffuse * max(dot(normal,light), 0.0);

  // componente especular
  vec4 l_espec = attenuation * gl_FrontLightProduct[0].specular * 
    pow(max(dot(reflexao, eye),0.0), 0.3 * gl_FrontMaterial.shininess);
   
  /* Spotlight */
  //vec3 Ln = normalize(gl_LightSource[0].spotDirection);
  vec3 Ln = normalize(vec3(-5.0, 20.0, 5.0));

  vec3 fakeNormal = gl_NormalMatrix * vec3(0, 1, 0);
  vec4 E = vec4(eye, 0.0);
  // lighting vectors
  vec3 In = normalize(p.xzy * E.w - E.xyz * p.w); // -view
  vec3 Hn = normalize(Ln - In);	// half way between view & light
  
  vec3 R = reflect(In, fakeNormal);
  vec3 RH = normalize(R - In);
  float fresnel = r0 + (1.0 - r0) * pow(1.0 + dot(In, RH), 5.0);
  // try B and T bellow
  vec4 env = texture2D(text, 0.5 +0.5 * normalize(R + vec3(0, 0, 1)).xy);

  float diff = max(0.0, dot(fakeNormal, Ln));
  float spec = pow(max(0.0, dot(fakeNormal, Hn)), 16.0);
  vec4 test_diff = gl_FrontLightProduct[0].diffuse;
  // if (dot(fakeNormal,Hn) < 0.0)
  //   test_diff = vec4(1.0, 0.0, 0.0, 0.0);

  vec4 col = gl_FrontLightProduct[0].ambient + test_diff * diff
    + attenuation * gl_FrontLightProduct[0].specular * spec;

  
   gl_FragColor = mix(env ,col,0.9) * 0.5;
  //  gl_FragColor.rgb = vec3(0.0, 0.0, 0.0);

  // cor final
     gl_FragColor += (gl_FrontLightModelProduct.sceneColor + l_amb + l_difusa + l_espec)  * 0.5;
  gl_FragColor *= texel;
  //  gl_FragColor.rgb = normal.xzy;
  gl_FragColor.a = 0.5;
}
