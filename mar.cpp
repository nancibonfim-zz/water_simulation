/*
  Trabalho de MATA65 - Computaçao Grafica
  Anna Barbosa e Nanci Bonfim
*/

/*
  TODO:
  1) Simular a movimentaçao da superficie do mar usando shaders
  2) Determinar 3 conjuntos de parametros que permitam simular um mar calmo,
  agitado e em situaçao de tempestade com ondas altas
  3) Implementar tecnicas basicas de ilumicaçao usando shaders
  4) Escolher um efeito extra de iluminacao, tambem usando shaders. 
*/

/* =======================================================================
   Includes
   ======================================================================= */

#include <stdbool.h>
#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <GL/glew.h>

#if defined(__APPLE__) || defined(MACOSX)
  #include <GLUT/glut.h>
 #include <opencv.hpp>
#else
  #include <GL/glut.h>
  #include <opencv2/opencv.hpp> 
#endif

#include "shader.h"

/* =======================================================================
   Declaraçao de variaveis globais
   =======================================================================*/
GLuint ProgramObject = 0;
GLuint VertexShaderObject = 0;
GLuint FragmentShaderObject = 0;

GLuint shaderVS, shaderFS, shaderProg; 
GLint  linked;

bool shader = false;
bool run = false;

GLuint	texName[1];

int res = 40; // resoluçao

float delta = 0.01;

float t, amplitude, frequencia;

/* =======================================================================
   init
   =======================================================================*/
void init(void) {

  GLfloat KaLig[4] = { 0.3, 0.3, 0.3, 1.0}; 
  GLfloat KdLig[4] = { 1.0, 1.0, 1.0, 1.0}; 
  GLfloat KeLig[4] = { 1.0, 1.0, 1.0, 1.0}; 
  GLfloat pos[4] 	 = { 0.0, 3.0, 0.0, 1.0}; 

  glClearColor(0.0, 0.0, 0.0, 0.0);
	
  glEnable(GL_CULL_FACE);
  glCullFace(GL_BACK);

  glEnable(GL_DEPTH_TEST);

  glShadeModel(GL_SMOOTH);
	
  glEnable(GL_LIGHTING);
  glEnable(GL_LIGHT0);
	
  glLightfv(GL_LIGHT0, GL_POSITION, 	pos);
  glLightfv(GL_LIGHT0, GL_DIFFUSE, 	KdLig);
  glLightfv(GL_LIGHT0, GL_AMBIENT, 	KaLig);
  glLightfv(GL_LIGHT0, GL_SPECULAR, 	KeLig);

  //  glDepthFunc(GL_LESS);

}


/* =======================================================================
   DesenhaEixos
=======================================================================*/
void DesenhaEixos() {

  glDisable(GL_LIGHTING);
  
  glBegin(GL_LINES);
    glColor3f(1.0, 0.0, 0.0);
    glVertex3f(0.0, 0.0, 0.0);
    glVertex3f(1.0, 0.0, 0.0);

    glColor3f(0.0, 1.0, 0.0);
    glVertex3f(0.0, 0.0, 0.0);
    glVertex3f(0.0, 1.0, 0.0);

    glColor3f(0.0, 0.0, 1.0);
    glVertex3f(0.0, 0.0, 0.0);
    glVertex3f(0.0, 0.0, 1.0);
  glEnd();
  
  glEnable(GL_LIGHTING);
}

/* =======================================================================
   DesenhaBase
=======================================================================*/
void DesenhaBase(int res) {
    
  float d = 20.0 / (float)res;

  for (float x = -50.0 ; x < 50.0 ; x+=d) {
    glBegin(GL_QUAD_STRIP);
    for (float z = 50.0 ; z >= -50.0 ; z-=d) {
      glVertex3f(x, 0.0, z);
      glVertex3f(x+d, 0.0, z);
    }
    glEnd();
  }
}

/* =======================================================================
   display
   =======================================================================*/
static void display(void) {
  

  GLfloat KaMat[4] 	= { 0.3, 0.3, 0.3, 1.0}; 
  GLfloat KdMat[4] 	= { 0.3, 0.3, 1.0, 1.0}; 
  GLfloat KeMat[4] 	= { 0.0, 1.0, 0.0, 1.0}; 
  GLfloat Shine[1] 	= { 10.0}; 

  glClearColor (0.0,0.0,0.0,1.0);
  glClear (GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);


  glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT, 	KaMat);
  glMaterialfv(GL_FRONT_AND_BACK, GL_DIFFUSE, 	KdMat);
  glMaterialfv(GL_FRONT_AND_BACK, GL_SPECULAR, 	KeMat);
  glMaterialfv(GL_FRONT_AND_BACK, GL_SHININESS, 	Shine);



  glMatrixMode (GL_MODELVIEW);
  glLoadIdentity();  
  gluLookAt (10.0, 10.0, 10.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0);
    
  DesenhaEixos();

  glActiveTexture(GL_TEXTURE0); //xxx
  glEnable(GL_TEXTURE_2D);

  glBindTexture(GL_TEXTURE_2D, texName[0]);

  if (shader) {
    glUseProgram(shaderProg);
    //    glUniform1fv(getUniLoc(shaderProg, "diffuse"), KdMat);

    //xxx  
    // GLint texture_location = glGetUniformLocation(shaderProg, "texture_color");
    // glUniform1i(texture_location, 0);
  }

  DesenhaBase(res);

    
  if (shader)
    glUseProgram(0);

  glDisable(GL_TEXTURE_2D);
  
  glutSwapBuffers();
}

/* =======================================================================

   =======================================================================*/
void animation() {
  
  amplitude += delta;
  if (amplitude > 0.4)
    delta = -0.01;
  if (amplitude < 0.001)
    delta = 0.01;

  amplitude = 0.4f;

  if (frequencia > 2.0)
    frequencia = -0.1;
  if (frequencia < 0.01)
    frequencia = 0.1;

  t += 0.02;
      
  glutPostRedisplay();
}

/* =======================================================================
   Comandos do teclado
   =======================================================================*/
static void key(unsigned char keyPressed, int x, int y) {  
  switch(keyPressed) {
  case 'q':
  case 27 : exit(0);
    break;
  case '+': res++;
    printf("Resolution = %d\n", res);
    break;
  case '-': res > 1 ? res-- : 1;
    printf("Resolution = %d\n", res);
    break;
  case 'r': run = !run;
    if (run)
      glutIdleFunc(animation);
    else
      glutIdleFunc(NULL);
    break;
  case 'S': 
  case 's': shader = !shader;
    if (shader)
      printf("Shader ON\n");
    else
      printf("Shader OFF\n");
    break;
  default:
    break;
  }
  glutPostRedisplay();

}

/* =======================================================================
   reshape
   =======================================================================*/
static void reshape(int wid, int ht) {
  GLfloat aspect = (GLfloat) wid / (GLfloat) ht;

  glViewport (0, 0, wid, ht);
  glMatrixMode (GL_PROJECTION);
  glLoadIdentity();
  gluPerspective (60, aspect, 1.0, 100.0);
  glMatrixMode (GL_MODELVIEW);
  glLoadIdentity();

}

/* =======================================================================
   initTexture
   =======================================================================*/
void initTexture(IplImage*  img) {  
  glGenTextures(1, texName); //gera a textura com os dados carregados
  glBindTexture(GL_TEXTURE_2D, texName[0]); // faz o bind da textura com seu array
  glTexEnvf( GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE ); // set texture environment parameters
  
  glTexParameterf( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST); //xxx near
  glTexParameterf( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);

  // Setando parametros que repetem a textura
  glTexParameterf( GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT );
  glTexParameterf( GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT );

  // Gera a texture
  glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, img->width, img->height, 0, GL_RGB, 
               GL_UNSIGNED_BYTE, img->imageData);
}


/* =======================================================================
   main
   =======================================================================*/
int main( int argc, char **argv) {
  
  char *filename = (char*)"water.jpg"; // imagem da textura
  char *shaderFile = (char*)"mar"; // arquivo do shader
  IplImage*   img     = NULL; // instancia para armazenar arquivo da textura

  /* Tratamento de argumentos passados pelo usuario */
  if (argc > 1)
    filename = argv[1];

  img = cvLoadImage( filename ); // inicializando arquivo de textura

  if (img == NULL) {
    printf("ERROR: can not open file %s\n", filename);
    return -1;
  }
  if (argc > 2)
    shaderFile = argv[2];

  /* Inicializando funçoes de OpenGL */
  glutInit( &argc, argv );
  glutInitDisplayMode( GLUT_RGB | GLUT_DEPTH | GLUT_DOUBLE);
  glutInitWindowSize(500, 500);

  glutCreateWindow( "Simula mar"); // titulo da janela 
  glutDisplayFunc(display); 
  glutKeyboardFunc(key);
  glutReshapeFunc(reshape);
  glewInit();
  
  init();
  initTexture(img);
  initShader(shaderFile);
  
  glutMainLoop();

  return EXIT_SUCCESS;
}
