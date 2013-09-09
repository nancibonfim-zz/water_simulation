/* Implementação do fragment shader  */

//uniform sampler2D textura;
uniform samplerCube textura;
varying vec4 v;

varying vec3 reflexao;

varying vec3 refracao;

varying float ratio;
varying vec3 i;
varying vec3 normal;

varying float lightIntensity;

void main() {
  
  // pagina 408

  // 149
  vec3 corRefratada = vec3(textureCube(textura, refracao));

  vec3 corRefletida = vec3(textureCube(textura, reflexao));
    
  vec3 base = vec3(gl_FrontLightModelProduct.sceneColor * lightIntensity);
  vec3 cor =  mix(corRefletida, corRefratada, ratio);




  vec4 texel = textureCube(textura, i);
  
  /* Phong */
  vec3 light = normalize(gl_LightSource[0].position.xyz - i); // direcao da luz
  vec3 eye = normalize(-i);

  // componente ambiente
  vec4 l_amb = gl_FrontLightProduct[0].ambient;
  // componente difusa
  vec4 l_difusa = gl_FrontLightProduct[0].diffuse * max(dot(normal,light), 0.0);   
  // componente especular
  vec4 l_espec = gl_FrontLightProduct[0].specular * 
    pow(max(dot(reflexao, eye),0.0), 0.3 * gl_FrontMaterial.shininess);

  //  gl_FragColor = (gl_FrontLightModelProduct.sceneColor + l_amb + l_difusa + l_espec) + vec4(cor, 1.0);// * vec4(0.2, 0.3, 0.8, 1.0);
  
  gl_FragColor = vec4(cor, 1.0) * texel;
  //  gl_FragColor = texel;
}
