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
     '- circle selection (default) zoom'+#13,
     ' Space ',
     '- switch selection mode');
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

  SetLength(selit_doc_font_arr,4);

  selit_doc_font_arr[0]:=TFont.Create;
  with selit_doc_font_arr[0] do
    begin
      color  :=$00CEB860;
      charset:=ANSI_CHARSET;
      name   :='Gabriola';
      height :=18;
      style  :=[fsBold];
    end;

  selit_doc_font_arr[1]:=TFont.Create;
  selit_doc_font_arr[1]:=curve_doc_font_arr[1];

  selit_doc_font_arr[2]:=TFont.Create;
  selit_doc_font_arr[2]:=selit_doc_font_arr[0];

  selit_doc_font_arr[3]:=TFont.Create;
  selit_doc_font_arr[3]:=curve_doc_font_arr[1];

end; {$endregion}

end.
