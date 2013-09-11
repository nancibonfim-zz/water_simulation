varying vec3 r;
uniform sampler2D text;
uniform vec3 worldCameraPos;
varying vec3 normal, binormal, tangente;

const float r0 = 0.1;		// Fresnel reflectance at zero angle
varying vec4 p;

void main() {
	
  vec4 texel = texture2D(text, r.st);

  mat3 TBN = mat3(tangente, binormal, normal);

  /* Iluminaçao - Phong*/
  vec3 lightVec = gl_LightSource[0].position.xyz - p.xyz;
  float attenuation = 200.0 / length(lightVec);

  vec3 light = normalize(lightVec); 

  vec3 eye = normalize(worldCameraPos - p.xyz);
  
  vec3 reflexao = normalize(reflect(-light, normal));  

  // componente ambiente
  vec4 l_amb = gl_FrontLightProduct[0].ambient;
  // componente difusa

  vec4 l_difusa = attenuation * gl_FrontLightProduct[0].diffuse * max(dot(normal,light), 0.0); 

  vec3 meio = normalize(light - eye);
  float w = pow(1.0 - max(0.0, dot(meio, eye)), 5.0);

  vec4 l_espec = attenuation * gl_LightSource[0].specular * 
                mix(gl_FrontMaterial.specular, vec4(1.0), w) *
                pow(max(dot(reflexao, eye), 0.0),  0.3 * gl_FrontMaterial.shininess);


  /* Spotlight */
  vec3 Ln = light;

  vec3 fakeNormal = gl_NormalMatrix * vec3(0, 1, 0);
  // lighting vectors
  vec3 In = -eye;

  vec3 Hn = normalize(Ln - In);	// half way between view & light
  
  vec3 R = reflect(In, fakeNormal);
  vec3 RH = normalize(R - In);
  float fresnel = r0 + (1.0 - r0) * pow(1.0 + dot(In, RH), 5.0);

  vec4 env = texture2D(text, 0.5 +0.5 * normalize(R + vec3(0, 0, 1)).xy);

  float diff = max(0.0, dot(fakeNormal, Ln));
  float spec = pow(max(0.0, dot(fakeNormal, Hn)), 16.0);
  vec4 test_diff = attenuation * gl_FrontLightProduct[0].diffuse;

  vec4 col = gl_FrontLightProduct[0].ambient + test_diff * diff
    + attenuation * gl_FrontLightProduct[0].specular * spec;
  
  gl_FragColor = mix(env ,col,0.9) * 0.5;
  //gl_FragColor.rgbw = vec4(0.0, 0.0, 0.0, 0.0);

  // cor final
     gl_FragColor += (gl_FrontLightModelProduct.sceneColor + l_amb + l_difusa + l_espec) * 0.5;
      gl_FragColor *= texel;
  gl_FragColor.w = 0.5;

}
