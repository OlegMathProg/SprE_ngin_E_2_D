unit Fast_UI;

{$mode objfpc}{$H+}

interface

uses //

  SysUtils, Types, LCLIntf, Fast_Graphics, Graphics, ExtCtrls, LCLType;



type

  TUIObjManager   =class;
  TUIImgScrollBox =class;

  TUIObjType      =(uiImgScrollBox,uiList);

  {Selection grid}
  TUISelectionGrid=class {$region -fold}
    ui_sel_grid_bmp0: T1Byte1Arr;
    ui_sel_grid_bmp1: TWordArr;
    ui_sel_grid_bmp2: TLWordArr;
    constructor Create        (w,h:integer;
                               b  :byte=0);
    destructor  Destroy;                     override;
    procedure   GetUIItemPos2D(x,y:integer); inline;
  end; {$endregion}
  PUISelectionGrid=^TUISelectionGrid;

  {UI object manager}
  TUIObjManager   =class  {$region -fold}
    public
      ui_obj_arr: array of pointer;
      constructor Create;
      destructor  Destroy; override;
      procedure   AddUIObj(const ui_obj_type:TUIObjType);
  end; {$endregion}
  PFUIObjManager  =^TUIObjManager;

  {Image ScrollBox}
  TUIImgScrollBox =class  {$region -fold}
    public

      // Items color scheme:
      item_col_arr                 : TColorArr;

      {Object(ScrollBox) canvas bmp.} {$region -fold}
      img_ptr                      : ^TImage;
      // Img. width:
      img_w                        : integer;
      // Img. height:
      img_h                        : integer;
      // ...:
      oc_bmp_ptr0                  : ^Graphics.TBitmap;
      // Pointer to object canvas bmp.:
      oc_bmp_ptr                   : PInteger;
      // Object canvas bmp. width:
      oc_w                         : TColor;
      // Object canvas bmp. height:
      oc_h                         : TColor;
      // Object canvas bmp. inner clipped rectangle:
      oc_rct                       : TPtRect; {$endregion}

      {Main              canvas bmp.} {$region -fold}
      // Pointer to main canvas bmp.:
      mc_bmp_ptr                   : PInteger;
      // Main canvas bmp. width:
      mc_w                         : TColor;
      // Main canvas bmp. height:
      mc_h                         : TColor;
      // Main canvas bmp. inner clipped rectangle:
      mc_rct                       : TPtRect; {$endregion}

      ui_sel_grid_bmp0_ptr         : PByte;
      ui_sel_grid_bmp1_ptr         : PWord;
      ui_sel_grid_bmp2_ptr         : PDWord;
      library_images_inds_arr_ptr  : PWord;
      library_images_label_arr0_ptr: PString;
      library_images_label_arr1_ptr: PString;
      sprite_arr_ptr               : PFastImageItem;
      txt_prop                     : TFTextProp;
      txt_label_default            : string;
      inner_items_cnt              : integer;
      item_rct_size_inc            : integer;
      item_rct                     : TPtRect;
      mrg_rct                      : TPtRect;
      low_rct_size_limit0          : TPtPos;
      low_rct_size_limit1          : TPtPos;
      pos_shift                    : TPtPosF;
      pos_shift_size               : TPtPosF;
    public
      constructor Create;
      destructor  Destroy; override;
      procedure   Repaint;
      procedure   SetPosShiftSize;
  end; {$endregion}
  PUIImgScrollBox =^TUIImgScrollBox;



var

  ui_obj_mgr: TUIObjManager;



implementation

{uses

  Main; //Fast_Graphics{, Main};}

(******************************* Selection grid *******************************) {$region -fold}

constructor TUISelectionGrid.Create        (w,h:integer; b:byte=0);         {$region -fold}
begin
  case b of
    0: SetLength(ui_sel_grid_bmp0,w*h);
    1: SetLength(ui_sel_grid_bmp1,w*h);
    2: SetLength(ui_sel_grid_bmp2,w*h);
  end;
end; {$endregion}
destructor  TUISelectionGrid.Destroy;                                       {$region -fold}
begin
  inherited Destroy;
end; {$endregion}
procedure   TUISelectionGrid.GetUIItemPos2D(x,y:integer          ); inline; {$region -fold}
begin
end; {$endregion}

{$endregion}



(****************************** UI object manager *****************************) {$region -fold}

constructor TUIObjManager.Create;                                 {$region -fold}
begin
end; {$endregion}
destructor  TUIObjManager.Destroy;                                {$region -fold}
begin
  inherited Destroy;
end; {$endregion}
procedure   TUIObjManager.AddUIObj(const ui_obj_type:TUIObjType); {$region -fold}
begin
  SetLength(ui_obj_arr,Length(ui_obj_arr)+1);
  case ui_obj_type of
    (uiImgScrollBox): ui_obj_arr[Length(ui_obj_arr)-1]:=TUIImgScrollBox.Create;
  end;
end; {$endregion}

{$endregion}



(******************************* Image ScrollBox ******************************) {$region -fold}

constructor TUIImgScrollBox.Create;          {$region -fold}
begin
  SetLength(item_col_arr,7);
  item_col_arr[0]    :=$00665F4D;
  item_col_arr[1]    :=$00858585;
  item_col_arr[2]    :=$003C422F;
  item_col_arr[3]    :=$00C8AE9B;
  item_col_arr[4]    :=$00DDCDC1;
  item_col_arr[5]    :=clLtGray;
  item_col_arr[6]    :=clWhite;
  item_rct_size_inc  :=16;
  item_rct           :=PtBounds(0,0,100,100);
  mrg_rct            :=PtBounds(4,4,004,024);
  low_rct_size_limit0:=PtPos   (048,048);
  low_rct_size_limit1:=PtPos   (100,100);
  {txt_prop           :=ftext_default_prop;
  with txt_prop do
    begin
      bkgnd_draw0    :=False;
      bkgnd_draw1    :=False;
      bkgnd_draw2    :=False;
    end;}
  txt_label_default  :='Import Image or Drag''n''Drop right here';
  SetPosShiftSize;
end; {$endregion}
destructor  TUIImgScrollBox.Destroy;         {$region -fold}
begin
  inherited Destroy;
end; {$endregion}
procedure   TUIImgScrollBox.Repaint;         {$region -fold}
var
  color_info : TColorInfo;
  rct0       : TPtRect;
  rct1       : TPtRect;
  rct2       : TPtRect;
  rct3       : TRect;
  i          : integer;
  x0         : integer=02;
  y0         : integer=02;
  pt         : double;
  text_height: integer;
  offset     : integer;
  ui_sel_grid: byte=0;
begin
  rct0:=PtBounds(0,0,img_w  ,img_h  );
  rct1:=PtBounds(2,2,img_w-2,img_h-2);
  SetColorInfo(item_col_arr[0],color_info);

  {Fill selection grid} {$region -fold}
  if         (ui_sel_grid_bmp0_ptr<>Nil) then
    begin
      ArrClrB(ui_sel_grid_bmp0_ptr,rct0,img_w,MAXBYTE);
              ui_sel_grid:=0;
    end
  else
  if         (ui_sel_grid_bmp1_ptr<>Nil) then
    begin
      ArrClrW(ui_sel_grid_bmp1_ptr,rct0,img_w,MAXWORD);
              ui_sel_grid:=1;
    end
  else
  if         (ui_sel_grid_bmp2_ptr<>Nil) then
    begin
      ArrClrL(ui_sel_grid_bmp2_ptr,rct0,img_w,MAXDWORD);
              ui_sel_grid:=2;
    end; {$endregion}

//F_MainForm.M_Test_Log.Lines.Text:=IntToStr(ui_sel_grid);

  PPFloodFill(oc_bmp_ptr,
              oc_w,
              rct0,
              color_info.pix_col);
  x0:=Trunc(pos_shift.x)+mrg_rct.left+2;
  y0:=Trunc(pos_shift.y)+mrg_rct.top +2;
  if (inner_items_cnt<>0) then
    for i:=0 to inner_items_cnt-1 do
    //with (sprite_arr_ptr+(library_images_inds_arr_ptr+i)^)^,fast_image_data,fast_image_proc_var do
      with  sprite_arr    [(library_images_inds_arr_ptr+i)^] ,fast_image_data,fast_image_proc_var do
        begin
          if (x0+item_rct.width+mrg_rct.left+2>img_w) then
            begin
              x0:=mrg_rct.left+2;
              Inc(y0,item_rct.height+mrg_rct.bottom);
            end;

          {Image background-------------} {$region -fold}
          rct2:=ClippedRct(rct1,
                           PtRct(x0,
                                 y0,
                                 x0+item_rct.width,
                                 y0+item_rct.height));
          SetColorInfo(item_col_arr[1],color_info);
          PPFloodFill (oc_bmp_ptr,
                       oc_w,
                       rct2,
                       color_info.pix_col); {$endregion}

          {Image selection grid fill----} {$region -fold}
          if (rct2.width <=0) or
             (rct2.height<=0) then
            case ui_sel_grid of
              0: ArrClrB(ui_sel_grid_bmp0_ptr+rct2.left+oc_w*rct2.top,rct2,oc_w,MAXBYTE );
              1: ArrClrW(ui_sel_grid_bmp1_ptr+rct2.left+oc_w*rct2.top,rct2,oc_w,MAXWORD );
              2: ArrClrL(ui_sel_grid_bmp2_ptr+rct2.left+oc_w*rct2.top,rct2,oc_w,MAXDWORD);
            end; {$endregion}

          {Image icon drawing-----------} {$region -fold}
          fast_image_data_ptr0:=@fast_image_data;

          {Set sprites background params:scrollbox canvas(surface)}
          SetBkgnd(oc_bmp_ptr,
                   oc_w,
                   oc_h,
                   rct1);

          if    (bmp_ftimg_height_origin/
                 bmp_ftimg_width_origin >=item_rct.height/
                                          item_rct.width ) then
             pt:=                        (item_rct.height-2)/
                 bmp_ftimg_height_origin
           else
             pt:=                        (item_rct.width -2)/
                 bmp_ftimg_width_origin;
          if    (bmp_ftimg_width_origin <=item_rct.width ) and
                (bmp_ftimg_height_origin<=item_rct.height) then
            begin
              fast_image_data_arr[0].scl_mul   :=PtPosF(1.0,1.0);
              fast_image_data_arr[0].pvt0_shift:=PtPosF(bmp_ftimg_width_origin /2,
                                                        bmp_ftimg_height_origin/2);
              SdrProc[sdr_proc_ind](x0+(item_rct.width -bmp_ftimg_width_origin )>>1,
                                    y0+(item_rct.height-bmp_ftimg_height_origin)>>1,
                                    fast_image_data_ptr0);
            end
          else
            begin
              fast_image_data_arr[0].scl_mul:=PtPosF(pt,pt);

              {
              SetRctPos(x0+(item_rct.width -Trunc(bmp_ftimg_width_origin *pt))>>1,
                        y0+(item_rct.height-Trunc(bmp_ftimg_height_origin*pt))>>1);
              SetRctDst2;
              SetRctSrc;
              if (nt_pix_cnt<>0) then
                GenNTBeginProc[1](fast_image_data_ptr0,
                                  fast_image_data_ptr0^);
              if (pt_pix_cnt<>0) then
                begin
                  GenPTBeginProc[1](fast_image_data_ptr0,
                                    fast_image_data_ptr0^);
                  FilPTValueArrG;
                end;
              if (nt_pix_cnt<>0) then
                RSDNTColorA04(fast_image_data_ptr0,
                              fast_image_data_ptr0^);
              if (pt_pix_cnt<>0) then
                begin
                  RSDPTColorA04(fast_image_data_ptr0,
                                fast_image_data_ptr0^);
                  FilPTValueArrH;
                end;
              }

              fast_image_data_arr[0].pvt0_shift:=PtPosF(bmp_ftimg_width_origin /2,
                                                        bmp_ftimg_height_origin/2);
              SdrProc[sdr_proc_ind](x0+(item_rct.width -bmp_ftimg_width_origin )>>1,
                                    y0+(item_rct.height-bmp_ftimg_height_origin)>>1,
                                    fast_image_data_ptr0);
            end;
          fast_image_data_arr[0].scl_mul   :=PtPosF(1.0,1.0);
          fast_image_data_arr[0].pvt0_shift:=PtPosF(0.0,0.0);

          {if i in [2..4] then
            begin
              PPHighlightLimit(library_images_bmp_ptr1,
                               library_images_bmp_ptr0^.width,
                               rct2,
                               32);
              SetColorInfo(item_col_arr[3],color_info);
              Rectangle(x0-1,
                        y0-1,
                        x0+item_rct.width+1,
                        y0+item_rct.height+mrg_rct.bottom-3,
                        library_images_bmp_ptr,
                        library_images_bmp.width,
                        rct1,
                        color_info.pix_col);
              SetColorInfo(item_col_arr[4],color_info);
              Rectangle(x0-2,
                        y0-2,
                        x0+item_rct.width+2,
                        y0+item_rct.height+mrg_rct.bottom-2,
                        library_images_bmp_ptr,
                        library_images_bmp.width,
                        rct1,
                        color_info.pix_col);
              rct2:=ClippedRct(rct1,
                               PtRct(x0,
                                     y0+item_rct.height,
                                     x0+item_rct.width,
                                     y0+item_rct.height+mrg_rct.bottom-4));
              PPFloodFill(library_images_bmp_ptr1,
                          library_images_bmp_ptr0^.width,
                          rct2,
                          color_info.pix_col);
              with library_images_bmp do
                begin
                  SetTextInfo   (Canvas,16,clBlack);
                  Canvas.TextOut(x0+4,
                                 y0+item_rct.height+4,
                                 'Img '+IntToStr(i));
                end;
            end
          else
            with library_images_bmp do
              begin
                SetTextInfo   (Canvas,16,clWhite);
                Canvas.TextOut(x0+4,
                               y0+item_rct.height+4,
                               'Img '+IntToStr(i));
              end;}

          {Reset sprites background params:main canvas(surface)}
          SetBkgnd(mc_bmp_ptr,
                   mc_w,
                   mc_h,
                   mc_rct); {$endregion}

          {Image icon bounding rectangle} {$region -fold}
          SetColorInfo(item_col_arr[2],color_info);
          Rectangle(x0,
                    y0,
                    x0+item_rct.width -1,
                    y0+item_rct.height-1,
                    oc_bmp_ptr,
                    oc_w,
                    rct1,
                    color_info.pix_col); {$endregion}

          {Image icon label-------------} {$region -fold}
          with txt_prop do
            begin
              txt_content:=(library_images_label_arr1_ptr+i)^;{'Img '+IntToStr(i)};
              if (item_rct.width <=low_rct_size_limit1.x) or
                 (item_rct.height<=low_rct_size_limit1.y) then
                txt_size:=Trunc(item_rct.height*txt_size_max/low_rct_size_limit1.y);
              Text(x0+1,
                   y0+item_rct.height+4,
                   oc_bmp_ptr,
                   oc_w,
                   @rct1,
                   oc_bmp_ptr0^.Canvas,
                   txt_prop);

              {F_MainForm.M_Test_Log.Lines.Text:=IntToStr(oc_bmp_ptr0^.Canvas.TextWidth (txt_content))+#13+
                                                IntToStr(oc_bmp_ptr0^.Canvas.TextHeight(txt_content));}
            end; {$endregion}

          Inc(x0,item_rct.width+mrg_rct.left);
        end
  else
    with txt_prop do
      begin
        txt_content:=txt_label_default;
        txt_align  :=DT_WORDBREAK or DT_CENTER or DT_NOPREFIX;
        rct3       :=Rect(rct0.left +10,
                          rct0.top,
                          rct0.right-10,
                          rct0.bottom);
        DrawText(oc_bmp_ptr0^.Canvas.Handle,
                 PChar (txt_content),
                 Length(txt_content),
                 rct3,
                 DT_WORDBREAK or DT_CALCRECT);
        text_height:=  rct3.bottom-rct3.top;
        offset     :=((rct0.bottom-rct0.top)-text_height)>>1;
        rct3       :=Rect(rct0.left +10,
                          rct0.top,
                          rct0.right-10,
                          rct0.bottom);
        Inc(rct3.top,offset);
        rct_mrg0   :=PtRct(  0,0,rct0    .width   ,rct0.height);
        rct_mrg1   :=PtRct(-10,0,rct_mrg0.width-10,text_height);
        Text(0,
             rct3.top,
             oc_bmp_ptr,
             oc_w,
             @rct1,
             oc_bmp_ptr0^.Canvas,
             txt_prop);
       {rct_mrg0   :=rct0;
        rct_mrg1   :=rct0;
        Text(0,
             0,
             oc_bmp_ptr,
             oc_w,
             @rct1,
             oc_bmp_ptr0^.Canvas,
             txt_prop);}
      end;

  with oc_bmp_ptr0^,Canvas do
    begin
      Brush.Style:=bsClear;
      Pen  .Width:=1;
      Pen  .Mode :=pmCopy;
      Pen  .Color:=item_col_arr[5];
      Rectangle(0,0,img_w  ,img_h  );
      Pen  .Color:=item_col_arr[6];
      Rectangle(1,1,img_w-1,img_h-1);
    end;

  CnvToCnv(rct0,
           img_ptr^    .Canvas,
           oc_bmp_ptr0^.Canvas,
           SRCCOPY);
  img_ptr^.Invalidate;
end; {$endregion}
procedure   TUIImgScrollBox.SetPosShiftSize; {$region -fold}
begin
  pos_shift_size:=PtPosF(item_rct.height+mrg_rct.bottom,
                         item_rct.height+mrg_rct.bottom);
end; {$endregion}

{$endregion}

end.
