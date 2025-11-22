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
    ('  Spline Factory ',
     'is a powerful module for creating curves/splines. Allows you to draw edges and points, various drawing modes are available. There are also various settings for optimizing rendering, physics and saving separate splines in their own compressed .sif (Spline Image Format) format or .svg (Scalable Vector Graphics).'+#13+
     '  Now let''s take a closer look at the capabilities of this module.');
  selit_doc_str_arr: TStringArr;
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

  procedure HintsFontArrInit; inline;



implementation



procedure HintsFontArrInit; inline; {$region -fold}
begin

  SetLength(fdesc_doc_font_arr,1);

  fdesc_doc_font_arr[0]:=TFont.Create;

  with fdesc_doc_font_arr[0] do
    begin
      Color  :=clRed;
      CharSet:=ANSI_CHARSET;
      Name   :='Gabriola';
      Height :=16;
    //Size   :=18;
    end;

  SetLength(curve_doc_font_arr,2);

  curve_doc_font_arr[0]:=TFont.Create;
  with curve_doc_font_arr[0] do
    begin
      Color  :=$00B65A66;
      Highlight1(@Color,80);
      CharSet:=ANSI_CHARSET;
      Name   :='Gabriola';
      Height :=16;
    //Size   :=14;
    end;

  curve_doc_font_arr[1]:=TFont.Create;
  with curve_doc_font_arr[1] do
    begin
      Color  :=$00394F28;
      Highlight1(@Color,80);
      CharSet:=ANSI_CHARSET;
      Name   :='Gentium Basic';
      Height :=14;
    //Size   :=12;
    end;

end; {$endregion}

end.
