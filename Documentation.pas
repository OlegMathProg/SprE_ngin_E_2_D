unit Documentation;

{This file contains description of tools from Draw, AnimK, File}

{$mode objfpc}
{$H+,INLINE+}

interface

uses

  Graphics, Windows, Fast_Graphics;



var

  {Text}
  fdesc_doc_str_arr: TStringArr;
  ftext_doc_str_arr: TStringArr;
  brush_doc_str_arr: TStringArr;
  spray_doc_str_arr: TStringArr;
  curve_doc_str_arr: TStringArr=
    (' Space ',
     '- switch spline drawing mode in settings(if type is freehand)');
   {('  Spline Factory ',
     'is a powerful module for creating curves/splines. Allows you to draw edges and points, various drawing modes are available. There are also various settings for optimizing rendering, physics and saving separate splines in their own compressed .sif (Spline Image Format) format or .svg (Scalable Vector Graphics).'+#13+
     '  Now let''s take a closer look at the capabilities of this module...');}
  selit_doc_str_arr: TStringArr=
    (' CTRL+MMB ',
     '- circle selection (default) zoom;'+#13,
     ' Space ',
     '- switch selection mode'+#13+' hold',
     ' SHIFT ',
     '(while moving mouse) - align the pivot on axis Y;'+#13+' hold',
     ' CTRL ',
     '(while moving mouse) - align the pivot on axis X'+#13,
     ' RMB ',
     '(after selection) - align the pivot on points;'+#13,
     ' MMB ',
     'on the spline object in a scene tree - selecting the object in the editor window;');
  txrgn_doc_str_arr: TStringArr;
  rgrid_doc_str_arr: TStringArr;
  sgrid_doc_str_arr: TStringArr;
  actor_doc_str_arr: TStringArr;
  tlmap_doc_str_arr: TStringArr;
  // TODO

  {Font}
  fdesc_doc_font_arr: TFontArr;
  ftext_doc_font_arr: TFontArr;
  brush_doc_font_arr: TFontArr;
  spray_doc_font_arr: TFontArr;
  curve_doc_font_arr: TFontArr;
  selit_doc_font_arr: TFontArr;
  txrgn_doc_font_arr: TFontArr;
  rgrid_doc_font_arr: TFontArr;
  sgrid_doc_font_arr: TFontArr;
  actor_doc_font_arr: TFontArr;
  tlmap_doc_font_arr: TFontArr;
  // TODO

  procedure HintsFontArrInit;



implementation



procedure HintsFontArrInit; {$region -fold}
begin

  SetLength(fdesc_doc_font_arr,1);

  fdesc_doc_font_arr[0]:=TFont.Create;
  with fdesc_doc_font_arr[0] do
    begin
      color  :=clRed;
      charset:=ANSI_CHARSET;
      name   :='Gabriola';
      height :=18;
      style  :=[fsBold];
    end;

  SetLength(curve_doc_font_arr,2);

  curve_doc_font_arr[0]:=TFont.Create;
  with curve_doc_font_arr[0] do
    begin
      color  :=$00CEB860;//$00B65A66;
      //Highlight1(@Color,80);
      charset:=ANSI_CHARSET;
      name   :='Gabriola';
      height :=18;
      style  :=[fsBold];
    end;

  curve_doc_font_arr[1]:=TFont.Create;
  with curve_doc_font_arr[1] do
    begin
      color  :=$00394F28;
      Highlight1(@Color,80);
      charset:=ANSI_CHARSET;
      name   :='Gentium Basic';
      height :=14;
    end;

  SetLength(selit_doc_font_arr,12);

  selit_doc_font_arr[0]:=TFont.Create;
  with selit_doc_font_arr[0] do
    begin
      color  :=$00CEB860;
      charset:=ANSI_CHARSET;
      name   :='Gabriola';
      height :=18;
      style  :=[fsBold];
    end;

  selit_doc_font_arr[01]:=TFont.Create;
  selit_doc_font_arr[01]:=curve_doc_font_arr[1];

  selit_doc_font_arr[02]:=TFont.Create;
  selit_doc_font_arr[02]:=selit_doc_font_arr[0];

  selit_doc_font_arr[03]:=TFont.Create;
  selit_doc_font_arr[03]:=curve_doc_font_arr[1];

  selit_doc_font_arr[04]:=TFont.Create;
  selit_doc_font_arr[04]:=selit_doc_font_arr[0];

  selit_doc_font_arr[05]:=TFont.Create;
  selit_doc_font_arr[05]:=curve_doc_font_arr[1];

  selit_doc_font_arr[06]:=TFont.Create;
  selit_doc_font_arr[06]:=selit_doc_font_arr[0];

  selit_doc_font_arr[07]:=TFont.Create;
  selit_doc_font_arr[07]:=curve_doc_font_arr[1];

  selit_doc_font_arr[08]:=TFont.Create;
  selit_doc_font_arr[08]:=selit_doc_font_arr[0];

  selit_doc_font_arr[09]:=TFont.Create;
  selit_doc_font_arr[09]:=curve_doc_font_arr[1];



  selit_doc_font_arr[10]:=TFont.Create;
  selit_doc_font_arr[10]:=selit_doc_font_arr[0];

  selit_doc_font_arr[11]:=TFont.Create;
  selit_doc_font_arr[11]:=curve_doc_font_arr[1];


end; {$endregion}

end.
