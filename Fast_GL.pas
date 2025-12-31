unit Fast_GL;

{This file contains some routines for initializing GLSL shaders}

{$mode objfpc}
{$H+,INLINE+}

interface

uses

  Controls, oglContext, oglShader, oglMatrix, OpenGLContext, GL, GLU, GLEXT,
  dglOpenGL, Graphics;



type

  TShaderObject=class;

  TVertex3f    =array[0..2] of GLfloat;
  PVertex3f    =^TVertex3f;

  TFace        =array[0..2] of TVertex3f;
  PFace        =^TFace;

  TVB          =record {$region -fold}
    VAO,VBO: GLuint;
  end; {$endregion}
  PVB          =^TVB;

  TShaderObject=class  {$region -fold}
    public
      RotMatrix  : TMatrix;
      matrix_id  : GLint;
      color_id   : GLint;
      c___       : single;
      VBQuad     : TVB;
      shader     : TShader;
      gl_canvas  : TContext;
      use_shaders: boolean;
      constructor Create(sender:TWinControl);
      destructor  Destroy;                    override;
      procedure   CreateGLContext;            inline;
      procedure   InitGLContext;              inline;
      procedure   DoneGLContext;              inline;
      procedure   DrawShaders;                inline;
  end; {$endregion}
  PShaderObject=^TShaderObject;

  PInteger     =PLongWord;
  TColor       = longword;
  PColor       =^TColor;


const

  quad      : array[0..1] of TFace=(((-0.8,-0.8, 0.0),
                                     (-0.8, 0.8, 0.0),
                                     ( 0.8, 0.8, 0.0)),
                                    ((-0.8,-0.8, 0.0),
                                     ( 0.8,-0.8, 0.0),
                                     ( 0.8, 0.8, 0.0)));
  step      : GLfloat             =0.01;
  GLUT_DOUBLE                     =02;
  GLUT_RGB                        =00;
  GLUT_DEPTH                      =16;



// Texture binding:
procedure GLBitmapInit          (      tex_id        :TColor;
                                       bmp           :Graphics.TBitmap;
                                       b             :boolean);         inline;
// Drawing of GL canvas:
procedure CnvDraw0              (      left,
                                       top,
                                       right,
                                       bottom        :GLfloat;
                                 const bmp_dst_ptr   :PInteger;
                                 const bmp_dst_width,
                                       bmp_dst_height:integer);         inline;
procedure CnvDraw1              (const bmp_dst_ptr   :PInteger;
                                 const bmp_dst_width,
                                       bmp_dst_height:integer);         inline;
procedure CnvDraw2              (const bmp_dst_ptr   :PInteger;
                                 const bmp_dst_width,
                                       bmp_dst_height:integer;
                                 const alpha_pow     :single=1.0;
                                 const pixel_format  :GLInt=GL_RGBA);   inline;
// GL camera pos.:
procedure GLCameraSetPos        (      x,y           :GLfloat;
                                 const bmp_dst_width,
                                       bmp_dst_height:integer);         inline;



var

  shader_var: TShaderObject;



implementation

constructor TShaderObject.Create(sender:TWinControl);         {$region -fold}
begin
  use_shaders:=False;
  InitOpenGL;

  //gl_canvas:=TContext.Create(sender);
  //(gl_canvas as TOpenGLControl).MakeCurrent;

  (sender as TOpenGLControl).MakeCurrent;

  ReadExtensions;
  ReadOpenGLCore;
  ReadImplementationProperties;

  if use_shaders then
    begin
      CreateGLContext;
      InitGLContext;
    end;
end; {$endregion}
destructor  TShaderObject.Destroy;                            {$region -fold}
begin
  DoneGLContext;
end; {$endregion}
procedure   TShaderObject.CreateGLContext;            inline; {$region -fold}
begin
  shader   :=TShader.Create([FileToStr('Vertexshader.glsl'),FileToStr('Fragmentshader.glsl')]);
  shader.UseProgram;
  color_iD :=Shader.UniformLocation('col');
  matrix_iD:=Shader.UniformLocation('mat');
  RotMatrix.Identity;
  glGenVertexArrays(1,@VBQuad.VAO);
  glGenBuffers     (1,@VBQuad.VBO);
end; {$endregion}
procedure   TShaderObject.InitGLContext;              inline; {$region -fold}
begin
  glClearColor(0.6,0.6,0.4,1.0);
  glBindVertexArray(VBQuad.VAO);
  glBindBuffer(GL_ARRAY_BUFFER,VBQuad.VBO);
  glBufferData(GL_ARRAY_BUFFER,sizeof(quad),@quad,GL_STATIC_DRAW);
  glEnableVertexAttribArray(10);
  glVertexAttribPointer(10,3,GL_FLOAT,False,0,Nil);
end; {$endregion}
procedure   TShaderObject.DoneGLContext;              inline; {$region -fold}
begin
  shader.Free;
  glDeleteVertexArrays(1,@VBQuad.VAO);
  glDeleteBuffers     (1,@VBQuad.VBO);
end; {$endregion}
procedure   TShaderObject.DrawShaders;                inline; {$region -fold}
begin

      c___:=c___+0.1;
  if (c___>=10.0) then
      c___:=c___-10.0;

  RotMatrix.RotateC(step);

  glClear(GL_COLOR_BUFFER_BIT);
  Shader.UseProgram;
  RotMatrix.Uniform(matrix_id);
  glUniform1f(color_id,c___);
  glBindVertexArray(VBQuad.VAO);
  glDrawArrays(GL_TRIANGLES,0,Length(quad)*3);
end; {$endregion}
// Texture binding:
procedure GLBitmapInit  (tex_id:TColor; bmp:Graphics.TBitmap; b:boolean); inline; {$region -fold}
begin
  if (not b) then
    glDisable(GL_TEXTURE_2D)
  else
    begin
      glEnable     (GL_TEXTURE_2D);
      glGenTextures(1,@tex_id);
      glBindTexture(GL_TEXTURE_2D,tex_id);
    end;
end; {$endregion}
// Drawing of GL canvas:
procedure CnvDraw0      (left,top,right,bottom:GLfloat; const bmp_dst_ptr:PInteger; const bmp_dst_width,bmp_dst_height:integer                               ); inline; {$region -fold}
begin
  glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);
  glTexImage2D   (GL_TEXTURE_2D,0,GL_RGBA,bmp_dst_width,bmp_dst_height,0,32993,GL_UNSIGNED_BYTE,bmp_dst_ptr);
    glBegin      (GL_QUADS);
      glTexCoord2f(0.0,0.0); glVertex2f(left ,top   );
      glTexCoord2f(1.0,0.0); glVertex2f(right,top   );
      glTexCoord2f(1.0,1.0); glVertex2f(right,bottom);
      glTexCoord2f(0.0,1.0); glVertex2f(left ,bottom);
    glEnd;
end; {$endregion}
procedure CnvDraw1      (const bmp_dst_ptr:PInteger; const bmp_dst_width,bmp_dst_height:integer                                                              ); inline; {$region -fold}
var
  i    : integer;
  d0,d1: double;
begin

//glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);
//glLoadIdentity;
//glDrawPixels(bmp_dst_width,bmp_dst_height,32993{swap channels: GL_RGBA=$1908 to GL_BGRA=32993},GL_UNSIGNED_BYTE,bmp_dst_ptr);
//glEnable       (GL_TEXTURE_2D);
//glTexImage2D   (GL_TEXTURE_2D,0,GL_RGBA{3},bmp_dst_width,bmp_dst_height,0,32993{swap channels: GL_RGBA=$1908 to GL_BGRA=32993},GL_UNSIGNED_BYTE,bmp_dst_ptr);
  glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);
 {glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_NEAREST{GL_LINEAR});
  glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_S    ,GL_CLAMP  {GL_REPEAT});
  glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_T    ,GL_CLAMP  {GL_REPEAT});}
 {glEnable       (GL_COLOR_LOGIC_OP);
  glLogicOp      (GL_COPY_INVERTED);}
 {glEnable       (GL_BLEND);
  glBlendFunc    (GL_ONE_MINUS_DST_COLOR,GL_ZERO);}
  glTexImage2D   (GL_TEXTURE_2D,0,GL_RGBA{3},bmp_dst_width,bmp_dst_height,0,32993{swap channels: GL_RGBA=$1908 to GL_BGRA=32993},GL_UNSIGNED_BYTE,bmp_dst_ptr);
//glEnable       (GL_COLOR_LOGIC_OP);
//glLogicOp      (GL_COPY_INVERTED);
    glBegin      (GL_QUADS);

      //          ( rct_left , rct_top   )
      glTexCoord2f( 0.0      , 0.0       );
      glVertex2f  (-1.0      , 1.0       );

      //          ( rct_right, rct_top   )
      glTexCoord2f( 1.0      , 0.0       );
      glVertex2f  ( 1.0      , 1.0       );

      //          ( rct_right, rct_bottom)
      glTexCoord2f( 1.0      , 1.0       );
      glVertex2f  ( 1.0      ,-1.0       );

      //          ( rct_left , rct_bottom)
      glTexCoord2f( 0.0      , 1.0       );
      glVertex2f  (-1.0      ,-1.0       );

    glEnd;

  {glBegin(GL_LINES);
  Randomize;
  for i:=0 to 100000-1 do
    begin
      glVertex2f(-Random(100),-Random(100));
      glVertex2f( Random(100), Random(100));
    end;
  glEnd;}

  {Randomize;
  glBegin(GL_QUADS);
    for i:=0 to 100000-1 do
      begin
        glTexCoord2f ( 0.0 , 0.0      );
        glVertex3f   (-1/(Random(100)+1), 1/(Random(100)+1), 0.0);
        glTexCoord2f ( 1.0 , 0.0      );
        glVertex3f   ( 1/(Random(100)+1), 1/(Random(100)+1), 0.0);
        glTexCoord2f ( 1.0 , 1.0      );
        glVertex3f   ( 1/(Random(100)+1),-1/(Random(100)+1), 0.0);
        glTexCoord2f ( 0.0 , 1.0      );
        glVertex3f   (-1/(Random(100)+1),-1/(Random(100)+1), 0.0);
      end;
  glEnd;}

end; {$endregion}
procedure CnvDraw2      (const bmp_dst_ptr:PInteger; const bmp_dst_width,bmp_dst_height:integer; const alpha_pow:single=1.0; const pixel_format:GLInt=GL_RGBA); inline; {$region -fold}
begin
  glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);
  glTexImage2D   (GL_TEXTURE_2D,0,pixel_format,bmp_dst_width,bmp_dst_height,0,32993{swap channels: GL_RGBA=$1908 to GL_BGRA=32993},GL_UNSIGNED_BYTE,bmp_dst_ptr);
  glEnable (GL_BLEND);
  glColor4f(1.0,1.0,1.0,alpha_pow);
  glBlendFunc(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);
  glBegin(GL_QUADS);
    glTexCoord2f ( 0.0, 0.0);
    glVertex2f   (-1.0, 1.0);
    glTexCoord2f ( 1.0, 0.0);
    glVertex2f   ( 1.0, 1.0);
    glTexCoord2f ( 1.0, 1.0);
    glVertex2f   ( 1.0,-1.0);
    glTexCoord2f ( 0.0, 1.0);
    glVertex2f   (-1.0,-1.0);
  glEnd;
  glDisable(GL_BLEND);
end; {$endregion}
// GL camera pos.:
procedure GLCameraSetPos(x,y:GLfloat; const bmp_dst_width,bmp_dst_height:integer); inline; {$region -fold}
begin
  //glClear(GL_COLOR_BUFFER_BIT);

  // Включаем матрицу проекции
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity;

  // Ортографическая проекция
  gluOrtho2D(0,bmp_dst_width,0,bmp_dst_height);

  // Включаем матрицу модели
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity;

  // Смещение камеры
  glTranslatef(x,y,0);
end; {$endregion}

end.
