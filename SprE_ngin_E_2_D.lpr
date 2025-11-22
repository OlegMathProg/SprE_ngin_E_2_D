program SprE_ngin_E_2_D;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  cmem,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, Fast_Main, lazopenglcontext, Hot_Keys, pkg_gifanim, Image_Editor,
  smnetgradientlaz;

{$R *.res}

begin
  Application.Title:='SprE_ngin_E_2_D';
  Application.Scaled:=True;
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(TF_MainForm    ,F_MainForm);
  Application.CreateForm(TF_Hot_Keys    ,F_Hot_Keys);
  Application.CreateForm(TF_Image_Editor,F_Image_Editor);
  Application.Run;
end.
