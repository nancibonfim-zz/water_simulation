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
#include <cstdlib>
#include <cstdio>
#include <cmath>
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

float t = 0.0;

int situacao_mar = 1; // calmo (1), agitado (2) ou com ondas altas (3)

float posx = 25.0, posy = 50.0, posz = 25.0;
float eyex = 0.0, eyey = 0.0, eyez = 0.0;


/* =======================================================================
   init
   =======================================================================*/
void init(void) {
  GLfloat KaLig[4] = { 0.3, 0.3, 0.3, 1.0 };
  GLfloat KdLig[4] = { 1.0, 1.0, 1.0, 1.0 }; 
  GLfloat KeLig[4] = { 1.0, 1.0, 1.0, 1.0 }; 
  GLfloat pos[4]   = { 0.0, 0.0, 2.0, 1.0 }; 

  //  glClearColor(0.0, 0.7, 1.0, 0.0);
	
  glClearColor(0.0, 0.0, 0.3, 0.0);
  

  glEnable(GL_CULL_FACE);
  glCullFace(GL_BACK);

  glEnable(GL_DEPTH_TEST);

  glShadeModel(GL_SMOOTH);
	
  glEnable(GL_LIGHTING);

  GLfloat pos1[4]   = { 0.0, 60.0, 40.0, 1.0 }; 
  GLfloat light_direction[] = {0.0, -1.0, -0.4, 0.0};
  glEnable(GL_LIGHT0);

  glLightfv(GL_LIGHT0, GL_POSITION, pos1);
  glLightfv(GL_LIGHT0, GL_DIFFUSE, 	KdLig);
  glLightfv(GL_LIGHT0, GL_AMBIENT, 	KdLig);
  glLightfv(GL_LIGHT0, GL_SPECULAR, KeLig);
  glLightfv(GL_LIGHT0, GL_SPOT_DIRECTION, light_direction);
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
  //  glPolygonMode(GL_FRONT, GL_LINE);
  for (float x = -50.0 ; x < 50.0 ; x+=d) {
    glBegin(GL_QUAD_STRIP);
    glNormal3f(0.0f, 1.0f, 0.0f);
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

  GLfloat KaMat[4] 	= { 0.01, 0.33, 0.6, 1.0 };
  GLfloat KdMat[4] 	= { 0.2, 0.35, 0.5, 1.0 }; 
  GLfloat KeMat[4] 	= { 0.8, 0.9, 1.0, 1.0 }; 

  GLfloat Shine[1] 	= { 30.0 }; 

  glClear (GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

  glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT, 	KaMat);
  glMaterialfv(GL_FRONT_AND_BACK, GL_DIFFUSE, 	KdMat);
  glMaterialfv(GL_FRONT_AND_BACK, GL_SPECULAR, 	KeMat);
  glMaterialfv(GL_FRONT_AND_BACK, GL_SHININESS, 	Shine);



  glMatrixMode (GL_MODELVIEW);
  glLoadIdentity();  
  gluLookAt (posx, posy, posz, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0);
    
  DesenhaEixos();

  glActiveTexture(GL_TEXTURE0);

  glEnable(GL_TEXTURE_2D);

  glBindTexture(GL_TEXTURE_2D, texName[0]);

  if (shader) {
    glUseProgram(shaderProg);

    glUniform1i(getUniLoc(shaderProg, "tipo_mar"), situacao_mar);
    
    glUniform1f(getUniLoc(shaderProg, "tempo"), t);
    glUniform3f(getUniLoc(shaderProg, "worldCameraPos"),  posx, posy, posz);

  }

  DesenhaBase(res);

    
  if (shader)
    glUseProgram(0);

  glDisable(GL_TEXTURE_2D);
  
  glutSwapBuffers();
}

/* =======================================================================

   =======================================================================*/
void animation(int x) {

  if(run) {
    t += 0.05;

    glutTimerFunc(20, animation, NULL);
    glutPostRedisplay();
  }
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
  case 'r':
    run = !run;
    if (run)
      glutTimerFunc(20, animation, NULL);
    break;

  case 'S': 
  case 's': shader = !shader;
    if (shader)
      printf("Shader ON\n");
    else
      printf("Shader OFF\n");
    break;
  case '1':
    situacao_mar = 1;
    printf("Mar calmo\n");
    break;
  case '2':
    situacao_mar = 2;
    printf("Mar agitado\n");
    break;
  case '3':
    situacao_mar = 3;
    printf("Tempestade com ondas altas\n");
    break;
  case 'u':
  case 'U':
    posx -= 1.0;
    posz -= 1.0;
    break;

  case 'o':
  case 'O':
    posx += 1.0;
    posz += 1.0;
    break;

  case 'j':
  case 'J':
    posx -= 1.0;
    break;


  case 'l':
  case 'L':
    posx += 1.0;
    break;

  case 'i':
  case 'I':
    posy += 1.0;
    printf("posicao: %f %f %f\n", posx, posy, posz);
    
    break;
  case 'k':
  case 'K':
    posy -= 1.0;
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

  // Gera a textura
  glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, img->width, img->height, 0, GL_RGB, 
               GL_UNSIGNED_BYTE, img->imageData);
}


/* =======================================================================
   main
   =======================================================================*/
int main( int argc, char **argv) {
  
  char *filename = (char*)"tex5.jpg"; // imagem da textura
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
  glutTimerFunc(10, animation, NULL);


  return EXIT_SUCCESS;
}
