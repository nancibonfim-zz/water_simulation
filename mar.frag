varying vec3 r;
uniform sampler2D text;
varying vec3 normal, binormal, tangente;


void main() {
	
  vec4 texel = texture2D(text, r.st);
 
  //  mat3 TBN = mat3(tangente, binormal, normal);

  /* Iluminaçao*/
  vec3 light = normalize(gl_LightSource[0].position.xyz - r);   
  vec3 eye = normalize(-r); // we are in Eye Coordinates, so EyePos is (0,0,0)
  
  vec3 reflexao = normalize(-reflect(light, normal));  

  // componente ambiente
  vec4 l_amb = gl_FrontLightProduct[0].ambient;
  // componente difusa
  vec4 l_difusa = gl_FrontLightProduct[0].diffuse * max(dot(normal,light), 0.0);    
  // componente especular
  vec4 l_espec = gl_FrontLightProduct[0].specular * 
    pow(max(dot(reflexao, eye),0.0),0.3*gl_FrontMaterial.shininess);
   
  // cor final
  gl_FragColor = (gl_FrontLightModelProduct.sceneColor + l_amb + l_difusa + l_espec) * texel;
  //  gl_FragColor.rgb = normal.xzy;
    gl_FragColor.a = 0.5;
}
