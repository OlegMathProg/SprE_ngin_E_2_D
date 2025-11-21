unit Fast_UI;

{This file contains some routines for working with UI/UX elements}

{$mode objfpc}
{$modeswitch nestedprocvars}
{$H+,INLINE+}

interface

uses

  SysUtils, Classes, Types, LCLIntf, LCLType, Graphics, Controls, Fast_Graphics,
  Performance_Time;



type

  TSelectionGrid  =class;
  TUIObjManager   =class;
  TUIScrollBar    =class;
  TUIImgScrollBox =class;

  PCursor         =^TCursor;

  TShiftStateEnum2=(ss2Ctrl,
                    ss2Shift,
                    ss2Empty);

  TUIObjType      =(uiImgScrollBox,
                    uiList);

  TScrollBarType  =(sbtVertical,
                    sbtHorizontal);

  {Selection grid}
  TSelectionGrid  =class {$region -fold}
    sel_grid_bmp0: T1Byte1Arr;
    sel_grid_bmp1: TWordArr;
    sel_grid_bmp2: TLWordArr;
    constructor Create        (w,h:integer;
                               b  :byte=0);
    destructor  Destroy;                     override;
    procedure   GetUIItemPos2D(x,y:integer); inline;
  end; {$endregion}
  PSelectionGrid  =^TSelectionGrid;

  {UI object manager}
  TUIObjManager   =class {$region -fold}
    public
      ui_obj_arr  : array of pointer;
      // For using some gradient properties:
      ui_grad_prop: TFastImageData;
      constructor Create;
      destructor  Destroy; override;
      procedure   AddUIObj(const ui_obj_type:TUIObjType);
  end; {$endregion}
  PFUIObjManager  =^TUIObjManager;

  {ScrollBar}
  TUIScrollBar    =class {$region -fold}
    public

      // Sprite sheet scale multipliers(x=scl_mul_x, y=scl_mul_y):
      sprite_sheet_scl_arr     : TPtPosFArr;

      // Sprite sheet inner margins(x=margin_top, y=margin_bottom):
      sprite_sheet_mrg_arr     : TPtPosArr;

      // Sprite sheet position(x=pos_x, y=pos_y):
      sprite_sheet_pos_arr     : TPtPosArr;

      // Sprite sheet width array(img_inv_type):
      sprite_sheet_w_arr       : TWordArr;

      // Sprite sheet height array(img_inv_type):
      sprite_sheet_h_arr       : TWordArr;

      // Sprite sheet inv. types(img_inv_type):
      sprite_sheet_inv_arr     : T1Byte1Arr;

      // Sprite sheet visibility array(img_inv_type):
      sprite_sheet_vis_arr     : TBool1Arr;

      sel_grid_bmp0_ptr        : PByte;
      sel_grid_bmp1_ptr        : PWord;
      sel_grid_bmp2_ptr        : PDWord;

      sprite_sheet_ind_        : integer;

      sprite_sheet_cnt         : integer;

      // ScrollBar bounding rectangle:
      scr_bar_rct              : TPtRect;
      scr_bar_rct_default_color: TColor;
      scr_bar_rct_focused_color: TColor;
      scr_bar_rct_focused_bnd  : boolean;
      scr_bar_rct_default_draw : boolean;
      scr_bar_rct_focused_draw : boolean;
      scr_bar_rct_pp_fx_0_draw : boolean;
      scr_bar_rct_pp_fx_1_draw : boolean;

      sel_grid                 : byte;

      // ...:
      oc_bmp_ptr_              : ^Graphics.TBitmap;
      // Pointer to object canvas bmp.:
      oc_bmp_ptr0              : PInteger;
      oc_bmp_ptr1              : PInteger;
      // Object canvas bmp. width:
      oc_w                     : TColor;
      // Object canvas bmp. height:
      oc_h                     : TColor;

      // Pointer to main canvas bmp.:
      mc_bmp_ptr               : PInteger;
      // Main canvas bmp. width:
      mc_w                     : TColor;
      // Main canvas bmp. height:
      mc_h                     : TColor;
      // Main canvas bmp. inner clipped rectangle:
      mc_rct                   : TPtRect;

      item_selected_ind        : TColor;
      item_focused_ind         : TColor;
      set_default_pos          : boolean;
      bkgnd_draw               : boolean;
      scr_bar_visible          : boolean;
      scr_bar_draw             : boolean;
      scr_bar_type             : TScrollBarType;

      constructor Create;
      destructor  Destroy;                                   override;
      function    GetSelectedItemInd: TColor;                inline;
      procedure   Draw              (const rct_clp:TPtRect);
  end; {$endregion}
  PUIScrollBar    =^TUIScrollBar;

  {Image ScrollBox}
  TUIImgScrollBox =class(TUIObjManager) {$region -fold}
    public

      // Vertical   scrollbar:
      scr_bar_v               : TUIScrollBar;

      // Horizontal scrollbar:
      scr_bar_h               : TUIScrollBar;

      // Items color scheme:
      item_col_arr            : TColorArr;

      // UI sprite sheet inner margins(x=margin_top, y=margin_bottom):
      sprite_sheet_mrg_arr    : TPtPosArr;

      {Object(ScrollBox) canvas bmp.} {$region -fold}
      // Img. width:
      img_w                   : integer;
      // Img. height:
      img_h                   : integer;
      // ...:
      oc_bmp_ptr_             : ^Graphics.TBitmap;
      // Pointer to object canvas bmp.:
      oc_bmp_ptr0             : PInteger;
      oc_bmp_ptr1             : PInteger;
      // Object canvas bmp. width:
      oc_w                    : TColor;
      // Object canvas bmp. height:
      oc_h                    : TColor;
      // Object canvas bmp. inner clipped rectangle:
      oc_rct                  : TPtRect; {$endregion}

      {Main              canvas bmp.} {$region -fold}
      // Pointer to main canvas bmp.:
      mc_bmp_ptr              : PInteger;
      // Main canvas bmp. width:
      mc_w                    : TColor;
      // Main canvas bmp. height:
      mc_h                    : TColor;
      // Main canvas bmp. inner clipped rectangle:
      mc_rct                  : TPtRect; {$endregion}

      rct_clp                 : TPtRect;
      sel_grid_bmp0_ptr       : PByte;
      sel_grid_bmp1_ptr       : PWord;
      sel_grid_bmp2_ptr       : PDWord;
      images_inds_arr_ptr     : PWord;
      images_label_arr0_ptr   : PString;
      images_label_arr1_ptr   : PString;
      sprite_arr_ptr          : PFastImageItem;
      txt_prop                : TFTextProp;
      txt_label_default       : string;
      cur_pos                 : TPoint;
      pos_shift               : TPtPosF;
      pos_shift_size          : TPtPos;
      low_rct_size_limit0     : TPtPos;
      low_rct_size_limit1     : TPtPos;
      mrg_rct                 : TPtRect;
      mrg_rct_default         : TPtRect;
      item_rct_f              : TPtRectF;
      item_rct_prev_f         : TPtRectF;
      item_rct                : TPtRect;
      item_rct_prev           : TPtRect;
      item_rct_size_inc       : integer;
      items_cnt               : integer;
      item_focused_ind        : TColor;
      // Index of first visibe item in scrollbox:
      first_vis_item_ind      : TColor;
      // Items row length:
      row_length              : TColor;
      shift                   : TShiftStateEnum2;
      sel_grid                : byte;
      multithreading_block_cnt: byte;
      line_break              : boolean;
      fit_item_img_to_rct     : boolean;
      constructor Create;
      destructor  Destroy; override;
      procedure   SetItemLabelVis     (      txt_draw_        :boolean);          inline;
      procedure   RowLengthCalc       (const x0_              :integer);          inline;
      function    RowCntCalc                                           : integer; inline;
      function    ItemsBndRctWidth                                     : integer; inline;
      function    ItemsBndRctHeight                                    : integer; inline;
      procedure   Draw;
      procedure   GetItemFocusedInd   (      x,y              :integer);          inline;
      procedure   GetItemFocusedInd   (      pvt              :TPoint );          inline;
      procedure   GetItemSelectedInd  (      x,y              :integer);          inline;
      procedure   SetItemsUnselected;                                             inline;
      procedure   SetPosShiftSize     (var   pvt              :TPoint;
                                       var   dir              :TMovingDirection;
                                       const b                :boolean=True);     inline;
      procedure   SetValScrBarsDefault(      scr_bar          :TUIScrollBar)      inline;
      procedure   SetPosScrBarVDefault;
      procedure   SetPosScrBarHDefault;
      {Events}
      procedure   OnMouseEnter;
      procedure   OnMouseLeave;
      procedure   OnMouseMove         (      x,y              :integer;
                                             screen_cursor_ptr:PCursor);
      procedure   OnMouseDown         (      x,y              :integer);
      procedure   OnMouseUp           (      x,y              :integer);
      procedure   OnMouseWheel        (      shift_           :TShiftState;
                                             mousepos_        :TPoint;
                                       var   dir              :TMovingDirection);
  end; {$endregion}
  PUIImgScrollBox =^TUIImgScrollBox;



var

  ui_obj_mgr           : TUIObjManager;
  ui_sprite_sheet_v_ind: integer;
  ui_sprite_sheet_h_ind: integer;



implementation

uses

  Fast_Threads, Fast_Main;

(******************************* Selection grid *******************************) {$region -fold}

constructor TSelectionGrid.Create        (w,h:integer; b:byte=0);         {$region -fold}
begin
  case b of
    0: SetLength(sel_grid_bmp0,w*h);
    1: SetLength(sel_grid_bmp1,w*h);
    2: SetLength(sel_grid_bmp2,w*h);
  end;
end; {$endregion}
destructor  TSelectionGrid.Destroy;                                       {$region -fold}
begin
  inherited Destroy;
end; {$endregion}
procedure   TSelectionGrid.GetUIItemPos2D(x,y:integer          ); inline; {$region -fold}
begin
end; {$endregion}

{$endregion}



(****************************** UI object manager *****************************) {$region -fold}

constructor TUIObjManager.Create;                                 {$region -fold}
begin
 {F_MainForm.M_Test_Log.Lines.Text:=IntToStr(ui_grad_prop{grad_prop.}grad_vec.x)+#13+
                                    IntToStr(ui_grad_prop{grad_prop.}grad_vec.y)+#13+
                                    IntToStr(ui_grad_prop{grad_prop.}grad_col.x)+#13+
                                    IntToStr(ui_grad_prop{grad_prop.}grad_col.y);}
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



(********************************** ScrollBar *********************************) {$region -fold}

constructor TUIScrollBar.Create;                             {$region -fold}
var
  i: integer;
begin
  scr_bar_rct_default_color:=$004F4F4F;
  scr_bar_rct_focused_color:=$00FCE8C9;
  scr_bar_rct_default_draw :=True;
  scr_bar_rct_focused_draw :=True;
  scr_bar_rct_pp_fx_0_draw :=True;
  scr_bar_rct_pp_fx_1_draw :=True;
  sprite_sheet_cnt         :=6;
  set_default_pos          :=True;
  bkgnd_draw               :=True;
  scr_bar_visible          :=True;
  scr_bar_draw             :=True;
  SetLength  (sprite_sheet_scl_arr,sprite_sheet_cnt);
  SetLength  (sprite_sheet_mrg_arr,sprite_sheet_cnt);
  SetLength  (sprite_sheet_pos_arr,sprite_sheet_cnt);
  SetLength  (sprite_sheet_inv_arr,sprite_sheet_cnt);
  SetLength  (sprite_sheet_vis_arr,sprite_sheet_cnt);
  for i:=0 to sprite_sheet_cnt-1 do
    begin
      sprite_sheet_scl_arr[i]:=PtPosF(1.0,1.0);
      sprite_sheet_mrg_arr[i]:=PtPos (000,000);
      sprite_sheet_pos_arr[i]:=PtPos (000,000);
      sprite_sheet_inv_arr[i]:=0;
      sprite_sheet_vis_arr[i]:=True;
    end;
end; {$endregion}
destructor  TUIScrollBar.Destroy;                            {$region -fold}
begin
  inherited Destroy;
end; {$endregion}
function    TUIScrollBar.GetSelectedItemInd: TColor; inline; {$region -fold}
begin
  if       (MAX_TYPE_VAL[sel_grid]-(1+sprite_sheet_cnt*Ord(scr_bar_type))-item_selected_ind>=0) then
    Result:=MAX_TYPE_VAL[sel_grid]-(1+sprite_sheet_cnt*Ord(scr_bar_type))-item_selected_ind
  else
    Result:=7;
end; {$endregion}
procedure   TUIScrollBar.Draw(const rct_clp:TPtRect);        {$region -fold}
type
  TProc0_=procedure is nested;
var
  SetSpritePosProc  : array[0..1] of TProc0_;
  rct               : TPtRect;
  sprite_pos        : TPtPos;
  item_selected_ind_: TColor;
  i                 : integer;
  t                 : byte   =1;
  b                 : boolean=False;

  procedure SetFXPow(pow0,pow1:byte); inline; {$region -fold}
  begin
    with fast_image_proc_var.fast_image_data_ptr0^ do
      begin
        with fx_arr[0] do
          begin
            nt_fx_prop.cfx_pow0:=pow0;
            pt_fx_prop.cfx_pow0:=pow0;
          end;
        with fx_arr[1] do
          begin
            nt_fx_prop.cfx_pow0:=0000;
            pt_fx_prop.cfx_pow0:=pow1;
          end;
      end;
  end; {$endregion}
  procedure SetSpritePos0;            inline; {$region -fold}
  begin
    with sprite_pos do
      begin
        x:=      sprite_sheet_pos_arr[i].x;
        y:=      sprite_sheet_pos_arr[i].y-
                (sprite_sheet_mrg_arr[i].x+
            Byte(sprite_sheet_inv_arr[i] in [2{,3}])*
                (sprite_sheet_mrg_arr[i].y-
                 sprite_sheet_mrg_arr[i].x));
      end;
  end; {$endregion}
  procedure SetSpritePos1;            inline; {$region -fold}
  begin
    with sprite_pos,fast_image_proc_var do
      begin
        x:=      sprite_sheet_pos_arr[i].x-
           (Byte(sprite_sheet_inv_arr[i] in [1{,3}])*
                (fast_image_data_ptr0^.bmp_ftimg_width_origin-
                 sprite_sheet_w_arr  [i]));
        y:=      sprite_sheet_pos_arr[i].y;
      end;
  end; {$endregion}

begin
  SetSpritePosProc[0]:=@SetSpritePos0;
  SetSpritePosProc[1]:=@SetSpritePos1;
  scr_bar_rct        :=ClippedRct(rct_clp,scr_bar_rct);
  with sprite_arr[sprite_sheet_ind_],fast_image_data,fast_image_proc_var do
    if (scr_bar_rct.width >0) and
       (scr_bar_rct.height>0) then
      begin
        fast_image_data_ptr0:=@fast_image_data;

        {Set sprites background params:scrollbox canvas(surface)}
        SetBkgnd(oc_bmp_ptr0,
                 oc_bmp_ptr1,
                 oc_w,
                 oc_h,
                 rct_clp);

        {Default state FX}
        if scr_bar_rct_pp_fx_0_draw then
          PPBlurRGB9(oc_bmp_ptr0,
                     oc_w,
                     scr_bar_rct,
                     TBlurType(0));

        {Image selection grid fill----------} {$region -fold}
        begin

          t:=1+sprite_sheet_cnt*Ord(scr_bar_type);
          {case scr_bar_type of
            sbtVertical  : t:=1;
            sbtHorizontal: t:=1+sprite_sheet_cnt;
          end;}
          item_selected_ind_:=GetSelectedItemInd; // item_selected_ind_:=MAX_TYPE_VAL[sel_grid]-t-item_selected_ind;

          b:=((item_focused_ind<=(MAX_TYPE_VAL[sel_grid]-t)) and
              (item_focused_ind> (MAX_TYPE_VAL[sel_grid]-t-sprite_sheet_cnt)));
          case sel_grid of
            0: ArrClrB(sel_grid_bmp0_ptr,scr_bar_rct,oc_w,MAXBYTE -t);
            1: ArrClrW(sel_grid_bmp1_ptr,scr_bar_rct,oc_w,MAXWORD -t);
            2: ArrClrL(sel_grid_bmp2_ptr,scr_bar_rct,oc_w,MAXDWORD-t);
          end;

          for i in [2,4,5] do
            begin
              case scr_bar_type of
                sbtVertical  : rct:=ClippedRct(rct_clp,
                                               PtBounds(scr_bar_rct.left,
                                                        sprite_sheet_pos_arr[i].y-2,
                                                        scr_bar_rct.width      -1,
                                                        sprite_sheet_h_arr  [i]-1+3));
                sbtHorizontal: rct:=ClippedRct(rct_clp,
                                               PtBounds(sprite_sheet_pos_arr[i].x-2,
                                                        scr_bar_rct.top,
                                                        sprite_sheet_w_arr  [i]-1+3,
                                                        scr_bar_rct.height     -1));
              end;
              case sel_grid of
                0: ArrClrB(sel_grid_bmp0_ptr,rct,oc_w,MAXBYTE -t-i);
                1: ArrClrW(sel_grid_bmp1_ptr,rct,oc_w,MAXWORD -t-i);
                2: ArrClrL(sel_grid_bmp2_ptr,rct,oc_w,MAXDWORD-t-i);
              end;
            end;

          {Debug} {$region -fold}
          {for i in [2,4,5] do
            begin
              if (scr_bar_type=sbtVertical) then
                RectangleL(scr_bar_rct.left,
                           sprite_sheet_pos_arr[i].y,
                           scr_bar_rct.right-1,
                           sprite_sheet_pos_arr[i].y+sprite_sheet_h_arr[i]-1,
                           oc_bmp_ptr0,
                           oc_w,
                           rct_clp,
                           clBlue)
              else
                RectangleL(sprite_sheet_pos_arr[i].x,
                           scr_bar_rct.top,
                           sprite_sheet_pos_arr[i].x+sprite_sheet_w_arr[i]-1,
                           scr_bar_rct.bottom-1,
                           oc_bmp_ptr0,
                           oc_w,
                           rct_clp,
                           clBlue);
            end;} {$endregion}

          with oc_bmp_ptr_^,Canvas do
            begin
              Brush.Style:=bsClear;
              Pen  .Width:=1;
              Pen  .Mode :=pmCopy;
              if (b and scr_bar_rct_focused_bnd) or
                 (item_selected_ind_=5) then
                begin
                  if scr_bar_rct_focused_draw then
                    begin
                      Pen.Color:=scr_bar_rct_focused_color;
                      Rectangle (scr_bar_rct.left  ,
                                 scr_bar_rct.top   ,
                                 scr_bar_rct.right ,
                                 scr_bar_rct.bottom);
                    end;
                end
              else
                begin
                  if scr_bar_rct_default_draw then
                    begin
                      Pen.Color:=scr_bar_rct_default_color;
                      Rectangle (scr_bar_rct.left  ,
                                 scr_bar_rct.top   ,
                                 scr_bar_rct.right ,
                                 scr_bar_rct.bottom);
                    end;
                end;
            end;
        end; {$endregion}

        for i:=0 to Min2(sprite_sheet_cnt,Length(sprite_sheet_inv_arr))-1 do
          if sprite_sheet_vis_arr[i] then
            if ((not (i in [0,1,3])) and (not bkgnd_draw)) or bkgnd_draw then
              with fast_image_data_arr[0] do
                begin
                  if (i=item_selected_ind_) then
                    begin
                      if (i<>5) then
                        SetFXPow(060,MAXBYTE)
                      else
                        SetFXPow(100,MAXBYTE);
                    end
                  else
                    SetFXPow(160,0);
                  rct_src_mrg.bottom:=                                 sprite_sheet_mrg_arr[i].y;
                  rct_src_mrg.top   :=                                 sprite_sheet_mrg_arr[i].x;
                  img_inv_type      :=                                 sprite_sheet_inv_arr[i];
                  pvt0_shift        :=PtPosF(0,                        sprite_sheet_mrg_arr[i].x);
                  scl_mul           :=PtPosF(                          sprite_sheet_scl_arr[i].x,
                                                                       sprite_sheet_scl_arr[i].y);
                  SetSpritePosProc[Ord(scr_bar_type)];
                  SdrProc         [fast_image_data_ptr0^.sdr_proc_ind](sprite_pos.x,
                                                                       sprite_pos.y,
                                                                       fast_image_data_ptr0);
                  scl_mul           :=PtPosF(1.0,1.0);
                  pvt0_shift        :=PtPosF(0,0);
                  img_inv_type      :=0;
                  rct_src_mrg.top   :=0;
                  rct_src_mrg.bottom:=0;
                end;

        {Active/Inactive state FX}
        if      scr_bar_rct_pp_fx_1_draw and
           (not scr_bar_rct_focused_bnd) and
           (item_selected_ind_<>5) then
          PPGrayscaleGDec(oc_bmp_ptr0,
                          oc_w,
                          scr_bar_rct,
                          100);

        {Reset sprites background params:main canvas(surface)}
        SetBkgnd(mc_bmp_ptr,
                 oc_bmp_ptr1,
                 mc_w,
                 mc_h,
                 mc_rct);

      end;

end; {$endregion}

{$endregion}



(******************************* Image ScrollBox ******************************) {$region -fold}

constructor TUIImgScrollBox.Create;                                                                                                 {$region -fold}
var
  pvt: TPoint;
  dir: TMovingDirection=mdUp;
begin
  scr_bar_v               :=TUIScrollBar.Create;
  scr_bar_h               :=TUIScrollBar.Create;

 {scr_bar_v.
  scr_bar_draw            :=False;}

  SetLength(item_col_arr,7);
  item_col_arr[0]         :=$00665F4D;
  item_col_arr[1]         :=$00858585;
  item_col_arr[2]         :=$003C422F;
  item_col_arr[3]         :=$00C8AE9B;
  item_col_arr[4]         :=$00DDCDC1;
  item_col_arr[5]         :=clLtGray;
  item_col_arr[6]         :=clDkGray;
  item_rct_size_inc       :=16;
  item_rct_f              :=PtBoundsF(0,0,100,100);
  item_rct_prev_f         :=item_rct_f;
  item_rct                :=PtBounds (0,0,100,100);
  item_rct_prev           :=item_rct;
  mrg_rct                 :=PtBounds (4,4,0{004},024);
  mrg_rct_default         :=mrg_rct;
  low_rct_size_limit0     :=PtPos    (048,048);
  low_rct_size_limit1     :=PtPos    (100,100);
  multithreading_block_cnt:=usable_threads_cnt{1};
  line_break              :=True{False};
  fit_item_img_to_rct     :=True{False};
  txt_prop                :=ftext_default_prop;
  txt_label_default       :='Import Image or Drag''n''Drop right here';
  pvt                     :=Default(TPoint);
  shift                   :=ss2Empty;
  SetPosShiftSize(pvt,dir,False);
end; {$endregion}
destructor  TUIImgScrollBox.Destroy;                                                                                                {$region -fold}
begin
  inherited Destroy;
end; {$endregion}
procedure   TUIImgScrollBox.SetItemLabelVis     (      txt_draw_  :boolean);                                                inline; {$region -fold}
begin
  with txt_prop do
    begin
      txt_draw:=txt_draw_;
      if (not txt_draw) then
        mrg_rct:=PtBounds(mrg_rct_default.left,mrg_rct_default.top,mrg_rct_default.width,0)
      else
        mrg_rct:=mrg_rct_default;
    end;
end; {$endregion}
procedure   TUIImgScrollBox.RowLengthCalc       (const x0_        :integer);                                                inline; {$region -fold}
begin
  row_length:=0;
  if (items_cnt<>0) and line_break then
    begin
          row_length:=Min2(items_cnt-1,Trunc((img_w-x0_-item_rct.width)/(item_rct.width+mrg_rct.{left}right))+1);
      if (row_length =     items_cnt-1) and  (img_w-x0_-item_rct.width>=(item_rct.width+mrg_rct.{left}right)*row_length) then
          row_length:=0;
    end;
end; {$endregion}
function    TUIImgScrollBox.RowCntCalc       : integer;                                                                     inline; {$region -fold}
var
  m: integer;
begin
  if (row_length=0) then
    Result:=0
  else
    begin
      if ((items_cnt mod row_length)<>0) then
        m:=00
      else
        m:=-1;
      Result:=(items_cnt div row_length)+m;
    end;
end; {$endregion}
function    TUIImgScrollBox.ItemsBndRctWidth : integer;                                                                     inline; {$region -fold}
begin
  if (RowCntCalc<>0) then
    Result:=(row_length+1)*(item_rct.width+mrg_rct.right)
  else
    Result:=(items_cnt +1)*(item_rct.width+mrg_rct.right);
end; {$endregion}
function    TUIImgScrollBox.ItemsBndRctHeight: integer;                                                                     inline; {$region -fold}
begin
  Result:=(RowCntCalc+1)*(item_rct.height+mrg_rct.bottom);
end; {$endregion}
procedure   TUIImgScrollBox.Draw;                                                                                                   {$region -fold}
type
  TProc0_=procedure is nested;
var
  SetLinebreakProc: array[0..2] of TProc0_;
  color_info2     : TColorInfo;
  color_info      : TColorInfo;
  rct0            : TPtRect;
  rct2            : TPtRect;
  rct3            : TPtRect;
  rct4            : TPtRect;
  rct5            : TRect;
  pt              : double;
  i,j             : integer;
  x0,y0           : integer;
  x1,y1           : integer;
  text_height     : integer;
  offset          : integer;
  s               : string='...';
  row_length_     : TColor;
  row_cnt         : TColor=2;
  b0,b1           : boolean;
  set_shift_type  : byte=0;

  procedure SetLinebreak0; inline; {$region -fold}
  begin
  end; {$endregion}

  procedure SetLinebreak1; inline; {$region -fold}
  begin
    if (x0+item_rct.width>img_w) then
      begin
        x0:=x1;
        Inc(y0,item_rct.height+mrg_rct.bottom);
      end;
  end; {$endregion}

  procedure SetLinebreak2; inline; {$region -fold}
  begin
    if (i=row_length*j) then
      begin
        x0:=x1;
        Inc(y0,item_rct.height+mrg_rct.bottom);
        Inc(j);
      end;
  end; {$endregion}

begin
  if (rct_clp.width <=0) or
     (rct_clp.height<=0) then
    Exit;
  SetLinebreakProc[0]:=@SetLinebreak0;
  SetLinebreakProc[1]:=@SetLinebreak1;
  SetLinebreakProc[2]:=@SetLinebreak2;
  rct0               :=PtBounds(0,0,img_w,img_h);
  SetColorInfo(item_col_arr[0],color_info);

  {ScrollBox selection grid-----------} {$region -fold}
  if         (sel_grid_bmp0_ptr<>Nil) then
    begin
      ArrClrB(sel_grid_bmp0_ptr,rct0,oc_w,MAXBYTE);
              sel_grid:=0;
    end
  else
  if         (sel_grid_bmp1_ptr<>Nil) then
    begin
      ArrClrW(sel_grid_bmp1_ptr,rct0,oc_w,MAXWORD);
              sel_grid:=1;
    end
  else
  if         (sel_grid_bmp2_ptr<>Nil) then
    begin
      ArrClrL(sel_grid_bmp2_ptr,rct0,oc_w,MAXDWORD);
              sel_grid:=2;
    end; {$endregion}

  {ScrollBox background---------------} {$region -fold}
  PPFloodFill(oc_bmp_ptr0,
              oc_w,
              rct0,
              color_info.pix_col); {$endregion}

  //exec_time0:=0;
  //exec_timer.Start;

  if (items_cnt<>0) then

    {ScrollBox items drawing----------} {$region -fold}
    begin

      {Icons-----------------------} {$region -fold}
      x0:={Trunc}Round(pos_shift.x);
      y0:={Trunc}Round(pos_shift.y);
      x1:=x0;
      y1:=y0;
      j :=1;
      set_shift_type:=Byte(line_break)*(Byte(shift in [ss2Ctrl])+1);
      if (set_shift_type=1) then
        RowLengthCalc(x0);
      if (multithreading_block_cnt>1) then
        begin

          {Loop 0} {$region -fold}
          x0:=x1;
          y0:=y1;
          for i:=0 to items_cnt-1 do
            with sprite_arr[(images_inds_arr_ptr+i)^],fast_image_data,fast_image_proc_var do
              begin
                SetLinebreakProc[Byte(i<>0)*set_shift_type];
                rct2:=ClippedRct(rct_clp,
                                 PtBounds(x0,
                                          y0,
                                          item_rct.width,
                                          item_rct.height));

                {Image background---} {$region -fold}
                SetColorInfo(item_col_arr[1],color_info);
                PPFloodFill (oc_bmp_ptr0,
                             oc_w,
                             rct2,
                             color_info.pix_col); {$endregion}

                {Image icon drawing-} {$region -fold}
                fast_image_data_ptr0:=@fast_image_data;

                {Set sprites background params:scrollbox canvas(surface)}
                SetBkgnd(oc_bmp_ptr0,
                         oc_bmp_ptr1,
                         oc_w,
                         oc_h,
                         rct_clp); {$endregion}

                Inc(x0,item_rct.width+mrg_rct.{left}right);
              end; {$endregion}

          {Loop 1} {$region -fold}
          case set_shift_type of
            0,1: ui_img_scroll_box_proc_var.Loop10(self,x1,y1,multithreading_block_cnt);
            2  : ui_img_scroll_box_proc_var.Loop11(self,x1,y1,multithreading_block_cnt);
          end; {$endregion}

          {Loop 2} {$region -fold}
          x0:=x1;
          y0:=y1;
          j :=1;
          for i:=0 to items_cnt-1 do
            with sprite_arr [(images_inds_arr_ptr+i)^],fast_image_data,fast_image_proc_var do
              begin
                SetLinebreakProc[Byte(i<>0)*set_shift_type];
                rct2:=ClippedRct(rct_clp,
                                 PtBounds(x0,
                                          y0,
                                          item_rct.width,
                                          item_rct.height));

                {Image icon drawing-} {$region -fold}
                fast_image_data_ptr0:=@fast_image_data;

                {Reset sprites background params:main canvas(surface)}
                SetBkgnd(mc_bmp_ptr,
                         oc_bmp_ptr1,
                         mc_w,
                         mc_h,
                         mc_rct); {$endregion}

                {Image background FX} {$region -fold}
                {case i of
                  00: PPAlphaBlend       (oc_bmp_ptr0,oc_w,rct2,color_info.pix_col,127           );
                  01: PPAdditiveDec      (oc_bmp_ptr0,oc_w,rct2,color_info.pix_col,100           );
                  02: PPInverseDec       (oc_bmp_ptr0,oc_w,rct2,                   MAXBYTE-255   );
                  03: PPHighlight        (oc_bmp_ptr0,oc_w,rct2,                   100           );
                  04: PPDarken           (oc_bmp_ptr0,oc_w,rct2,                   100           );
                  05: PPGrayscaleRDec    (oc_bmp_ptr0,oc_w,rct2,                   255           );
                  06: PPGrayscaleGDec    (oc_bmp_ptr0,oc_w,rct2,                   255           );
                  07: PPGrayscaleBDec    (oc_bmp_ptr0,oc_w,rct2,                   255           );
                  08: PPMonoNoiseDec     (oc_bmp_ptr0,oc_w,rct2,color_info.pix_col,100           );
                  09: PPRandNoise        (oc_bmp_ptr0,oc_w,rct2,@RandNoise0,       255,       001);
                  10: PPRandNoise        (oc_bmp_ptr0,oc_w,rct2,@RandNoise1,       001,       001);
                  11: PPRandNoise        (oc_bmp_ptr0,oc_w,rct2,@RandNoise2,       001,       001);
                  12: PPRandNoise        (oc_bmp_ptr0,oc_w,rct2,@RandNoise3,       127,       000);
                  13: PPRandNoise        (oc_bmp_ptr0,oc_w,rct2,@RandNoise4,       000,       002);
                  14: PPBlurRGB9         (oc_bmp_ptr0,oc_w,rct2,btRGB                            );
                  15: PPContrast1        (oc_bmp_ptr0,oc_w,rct2,                   127           );
                  16: PPGamma            (oc_bmp_ptr0,oc_w,rct2,                   005{127}      );
                end;} {$endregion}

                Inc(x0,item_rct.width+mrg_rct.{left}right);
              end; {$endregion}

        end
      else
        for i:=0 to items_cnt-1 do
        //with (sprite_arr_ptr+(images_inds_arr_ptr+i)^)^,fast_image_data,fast_image_proc_var do
          with  sprite_arr    [(images_inds_arr_ptr+i)^] ,fast_image_data,fast_image_proc_var do
            begin
              SetLinebreakProc[Byte(i<>0)*set_shift_type];
              rct2:=ClippedRct(rct_clp,
                               PtBounds(x0,
                                        y0,
                                        item_rct.width,
                                        item_rct.height));

              {Image background---} {$region -fold}
              SetColorInfo(item_col_arr[1],color_info);
              PPFloodFill (oc_bmp_ptr0,
                           oc_w,
                           rct2,
                           color_info.pix_col); {$endregion}

              {Image icon drawing-} {$region -fold}
              fast_image_data_ptr0:=@fast_image_data;

              {Set sprites background params:scrollbox canvas(surface)}
              SetBkgnd(oc_bmp_ptr0,
                       oc_bmp_ptr1,
                       oc_w,
                       oc_h,
                       rct_clp);

              fast_image_data_arr[0].rct_src_mrg.top   :=sprite_sheet_mrg_arr[i].x;
              fast_image_data_arr[0].rct_src_mrg.bottom:=sprite_sheet_mrg_arr[i].y;
              fast_image_data_arr[0].frame_height_int  := bmp_ftimg_height_origin-fast_image_data_arr[0].rct_src_mrg.top-fast_image_data_arr[0].rct_src_mrg.bottom;
              if fit_item_img_to_rct then
                begin
                  pt                                   :=(item_rct.height-2)/Max1(fast_image_data_arr[0].frame_height_int,bmp_ftimg_width_origin);
                  fast_image_data_arr[0].scl_mul       :=PtPosF(pt,pt);
                end
              else
                begin
                  if (bmp_ftimg_height_origin/bmp_ftimg_width_origin>=item_rct.height/item_rct.width) then
                    pt:=(item_rct.height-2)  /bmp_ftimg_height_origin
                  else
                    pt:=(item_rct.width -2)  /bmp_ftimg_width_origin;
                  if (bmp_ftimg_width_origin <=item_rct.width) and
                     (bmp_ftimg_height_origin<=item_rct.height) then
                    fast_image_data_arr[0].scl_mul     :=PtPosF(1.0,1.0)
                  else
                    fast_image_data_arr[0].scl_mul     :=PtPosF(pt,pt);
                end;
              SdrProc[sdr_proc_ind](x0+{Trunc}Round((item_rct.width {+1}-bmp_ftimg_width_origin*pt                 )/2),
                                    y0+{Trunc}Round((item_rct.height{+1}-fast_image_data_arr[0].frame_height_int*pt)/2-fast_image_data_arr[0].rct_src_mrg.top*pt),
                                    fast_image_data_ptr0);
              fast_image_data_arr[0].scl_mul           :=PtPosF(1.0,1.0);
              fast_image_data_arr[0].rct_src_mrg.top   :=0;
              fast_image_data_arr[0].rct_src_mrg.bottom:=0;

              {Reset sprites background params:main canvas(surface)}
              SetBkgnd(mc_bmp_ptr,
                       oc_bmp_ptr1,
                       mc_w,
                       mc_h,
                       mc_rct); {$endregion}

              {Image background FX} {$region -fold}
              {case i of
              //00: PPAlphaBlend       (oc_bmp_ptr0,oc_w,rct2,color_info.pix_col,127           );
                01: PPAdditiveDec      (oc_bmp_ptr0,oc_w,rct2,color_info.pix_col,100           );
                02: PPInverseDec       (oc_bmp_ptr0,oc_w,rct2,                   MAXBYTE-255   );
                03: PPHighlight        (oc_bmp_ptr0,oc_w,rct2,                   100           );
                04: PPDarken           (oc_bmp_ptr0,oc_w,rct2,                   100           );
                05: PPGrayscaleRDec    (oc_bmp_ptr0,oc_w,rct2,                   255           );
                06: PPGrayscaleGDec    (oc_bmp_ptr0,oc_w,rct2,                   255           );
                07: PPGrayscaleBDec    (oc_bmp_ptr0,oc_w,rct2,                   255           );
                08: PPMonoNoiseDec     (oc_bmp_ptr0,oc_w,rct2,color_info.pix_col,100           );
                09: PPRandNoise        (oc_bmp_ptr0,oc_w,rct2,@RandNoise0,       255,       001);
                10: PPRandNoise        (oc_bmp_ptr0,oc_w,rct2,@RandNoise1,       001,       001);
                11: PPRandNoise        (oc_bmp_ptr0,oc_w,rct2,@RandNoise2,       001,       001);
                12: PPRandNoise        (oc_bmp_ptr0,oc_w,rct2,@RandNoise3,       127,       000);
                13: PPRandNoise        (oc_bmp_ptr0,oc_w,rct2,@RandNoise4,       000,       002);
                14: PPBlurRGB9         (oc_bmp_ptr0,oc_w,rct2,btRGB                            );
                15: PPContrast1        (oc_bmp_ptr0,oc_w,rct2,                   127           );
                16: PPGamma            (oc_bmp_ptr0,oc_w,rct2,                   005{127}      );
                00{17}:
                  begin
                    with ui_grad_prop do
                      begin
                        rct_ent.height      :=100;
                        set_grad_to_vis_area:=True{False};
                        SetGradVec(0,
                                   item_rct.height,
                                   @ui_grad_prop,
                                    ui_grad_prop);
                        SetGradCol($00000000+$000000FF,
                                   $FF000000+$00FF0000,
                                   ui_grad_prop);
                      end;
                    PPGrVAlphaBlend    (oc_bmp_ptr0,oc_w,rct2,ui_grad_prop.grad_prop);

                   {F_MainForm.M_Test_Log.Lines.Text:=IntToStr(grad_vec.x)+#13+
                                                      IntToStr(grad_vec.y)+#13+
                                                      IntToStr(grad_col.x)+#13+
                                                      IntToStr(grad_col.y);}

                  end;
              end;} {$endregion}

              Inc(x0,item_rct.width+mrg_rct.{left}right);
            end;

      {Loop 3} {$region -fold}
      x0:=x1;
      y0:=y1;
      j :=1;
      for i:=0 to items_cnt-1 do
        begin
          SetLinebreakProc[Byte(i<>0)*set_shift_type];
          rct2:=ClippedRct(rct_clp,
                           PtBounds(x0,
                                    y0,
                                    item_rct.width,
                                    item_rct.height));
          rct3:=ClippedRct(rct_clp,
                           PtBounds(x0+1,
                                    y0+item_rct.height+4,
                                    txt_prop.rct_mrg0.width,
                                    txt_prop.rct_mrg0.height));
          rct4:=ClippedRct(rct_clp,
                           PtBounds(x0,
                                    y0+item_rct.height+3,
                                    txt_prop.rct_mrg0.width +1,
                                    txt_prop.rct_mrg0.height+1));

          {Image icon rectangle to selection grid} {$region -fold}
          if (rct2.width >0) and
             (rct2.height>0) then
            case sel_grid of
              0: ArrClrB(sel_grid_bmp0_ptr,rct2,oc_w,BYTE (2*i));
              1: ArrClrW(sel_grid_bmp1_ptr,rct2,oc_w,WORD (2*i));
              2: ArrClrL(sel_grid_bmp2_ptr,rct2,oc_w,DWORD(2*i));
            end; {$endregion}

          {Image icon label     to selection grid} {$region -fold}
          if (rct3.width >0) and
             (rct3.height>0) then
            case sel_grid of
              0: ArrClrB(sel_grid_bmp0_ptr,rct3,oc_w,BYTE (2*i+1));
              1: ArrClrW(sel_grid_bmp1_ptr,rct3,oc_w,WORD (2*i+1));
              2: ArrClrL(sel_grid_bmp2_ptr,rct3,oc_w,DWORD(2*i+1));
            end; {$endregion}

          {Image icon       FX: focused----------} {$region -fold}
          if (item_focused_ind=2*i) then
            PPHighlight{Limit}(oc_bmp_ptr0,
                               oc_w,
                               rct2,
                               20); {$endregion}

          {Image icon bounding rectangle---------} {$region -fold}
          SetColorInfo(item_col_arr[2],color_info);
          RectangleL  (x0,
                       y0,
                       x0+item_rct.width -1,
                       y0+item_rct.height-1,
                       oc_bmp_ptr0,
                       oc_w,
                       rct_clp,
                       color_info.pix_col); {$endregion}

          {Image icon label----------------------} {$region -fold}
          with txt_prop do
            if txt_draw then
              begin
                if (item_rct.width <=low_rct_size_limit1.x) or
                   (item_rct.height<=low_rct_size_limit1.y) then
                  txt_size:=Trunc(item_rct.height*txt_size_max/low_rct_size_limit1.y);
                if (         Length((images_label_arr1_ptr+i)^)*txt_size>=1.4{1.45}*item_rct.width) then
                  txt_content:=Copy((images_label_arr1_ptr+i)^,1,
                        Min2(Length((images_label_arr1_ptr+i)^),    Trunc(1.4{1.45}*item_rct.width/txt_size)))+s{'Img '+IntToStr(i)}
                else
                  txt_content:=     (images_label_arr1_ptr+i)^;{'Img '+IntToStr(i)};
                bkgnd_draw1  :=True;
                bkgnd_col1   :=Darken2(item_col_arr[0],10);
                Text(x0+1,
                     y0+item_rct.height+4,
                     oc_bmp_ptr0,
                     oc_w,
                     @rct_clp,
                     oc_bmp_ptr_^.Canvas,
                     txt_prop);
              end; {$endregion}

          {Image icon label FX: focused----------} {$region -fold}
          if (item_focused_ind=2*i+1) then
            begin
              SetColorInfo(item_col_arr[3],color_info);
              RectangleL  (rct4.left,
                           rct4.top,
                           rct4.right,
                           rct4.bottom,
                           oc_bmp_ptr0,
                           oc_w,
                           rct_clp,
                           color_info.pix_col);
             {PPInverse(oc_bmp_ptr0,
                        oc_w,
                        rct3);}
            end; {$endregion}

          Inc(x0,item_rct.width+mrg_rct.{left}right);
        end; {$endregion} {$endregion}

      {Debug-----------------------} {$region -fold}
      {    x0     :=x1;
          y0     :=y1;
          row_cnt:=RowCntCalc;
      if (row_cnt<>0) then
          row_length_:=row_length
      else
          row_length_:=items_cnt;
      RectangleL(x0,
                 y0,
                 x0+(row_length_  )*(item_rct.width +mrg_rct.right )-mrg_rct.left,
                 y0+(row_cnt    +1)*(item_rct.height+mrg_rct.bottom)-mrg_rct.top+1,
                 oc_bmp_ptr0,
                 oc_w,
                 rct_clp,
                 clBlue);} {$endregion}

      {Vertical   scrollbar drawing} {$region -fold}
      b0:=(y1>=mrg_rct.top+2) and (y1+ItemsBndRctHeight<=img_h-2);
      //scr_bar_v.scr_bar_visible:=not b0;
      if    scr_bar_v.scr_bar_draw then
        if (not b0) then
          begin
            scr_bar_v.sel_grid        :=sel_grid;
            scr_bar_v.item_focused_ind:=item_focused_ind;
            scr_bar_v.Draw(rct_clp);
          end; {$endregion}

      {Horizontal scrollbar drawing} {$region -fold}
      b1:=(x1>=mrg_rct.left+2) and (x1+ItemsBndRctWidth<=img_w-2);
      //scr_bar_h.scr_bar_visible:=not b1;
      if    scr_bar_h.scr_bar_draw then
        if (not b1) then
          begin
            scr_bar_h.sel_grid        :=sel_grid;
            scr_bar_h.item_focused_ind:=item_focused_ind;
            scr_bar_h.Draw(rct_clp);
          end; {$endregion}

      {Corner drawing--------------} {$region -fold}
      if (not (b0 or b1)) then
        begin
          PPGrayscaleGDec(oc_bmp_ptr0,
                          oc_w,
                          ClippedRct(rct_clp,
                                     PtBounds(scr_bar_v.scr_bar_rct.left,
                                              scr_bar_v.scr_bar_rct.bottom,
                                              scr_bar_v.scr_bar_rct.width,
                                              scr_bar_h.scr_bar_rct.height)),
                          100);
          RectangleL(scr_bar_v.scr_bar_rct.left  +1,
                     scr_bar_v.scr_bar_rct.bottom+1,
                     scr_bar_v.scr_bar_rct.left  +scr_bar_v.scr_bar_rct.width -2,
                     scr_bar_v.scr_bar_rct.bottom+scr_bar_h.scr_bar_rct.height-2,
                     oc_bmp_ptr0,
                     oc_w,
                     rct_clp,
                     SetColorInv($00C1C58B));
        end; {$endregion}

    end {$endregion}

  else

    {ScrollBox default background text} {$region -fold}
    with txt_prop do
      begin
        txt_content:=txt_label_default;
        txt_align  :=DT_WORDBREAK or DT_CENTER or DT_NOPREFIX;
        rct5       :=Rect(rct0.left +10,
                          rct0.top,
                          rct0.right-10,
                          rct0.bottom);
        DrawText(oc_bmp_ptr_^.Canvas.Handle,
                 PChar (txt_content),
                 Length(txt_content),
                 rct5,
                 DT_WORDBREAK or DT_CALCRECT);
        text_height:=  rct5.bottom-rct5.top;
        offset     :=((rct0.bottom-rct0.top)-text_height)>>1;
        rct5       :=Rect(rct0.left +10,
                          rct0.top,
                          rct0.right-10,
                          rct0.bottom);
        Inc(rct5.top,offset);
        rct_mrg0   :=PtRct( 0,0,rct0    .width   ,rct0.height);
        rct_mrg1   :=PtRct(10,0,rct_mrg0.width-10,text_height);
        Text(0,
             rct5.top,
             oc_bmp_ptr0,
             oc_w,
             @rct_clp,
             oc_bmp_ptr_^.Canvas,
             txt_prop);
       {rct_mrg0   :=rct0;
        rct_mrg1   :=rct0;
        Text(0,
             0,
             oc_bmp_ptr0,
             oc_w,
             @rct_clp,
             oc_bmp_ptr_^.Canvas,
             txt_prop);}
      end; {$endregion}

  //exec_timer.Stop;
  //exec_time0+=Trunc(exec_timer.Delay*1000);

  {ScrollBox bounding rectangle-------} {$region -fold}
  // Bounding rectangle selection grid:
  case sel_grid of
    0:
      begin
        RectangleB(0,
                   0,
                   img_w-1,
                   img_h-1,
                   sel_grid_bmp0_ptr,
                   oc_w,
                   rct0,
                   MAXBYTE);
        RectangleB(1,
                   1,
                   img_w-2,
                   img_h-2,
                   sel_grid_bmp0_ptr,
                   oc_w,
                   rct0,
                   MAXBYTE);
      end;
    1:
      begin
        RectangleW(0,
                   0,
                   img_w-1,
                   img_h-1,
                   sel_grid_bmp1_ptr,
                   oc_w,
                   rct0,
                   MAXWORD);
        RectangleW(1,
                   1,
                   img_w-2,
                   img_h-2,
                   sel_grid_bmp1_ptr,
                   oc_w,
                   rct0,
                   MAXWORD);
      end;
    2:
      begin
        RectangleL(0,
                   0,
                   img_w-1,
                   img_h-1,
                   sel_grid_bmp2_ptr,
                   oc_w,
                   rct0,
                   MAXDWORD);
        RectangleL(1,
                   1,
                   img_w-2,
                   img_h-2,
                   sel_grid_bmp2_ptr,
                   oc_w,
                   rct0,
                   MAXDWORD);
      end;
  end;

  with oc_bmp_ptr_^,Canvas do
    begin
      Brush.Style:=bsClear;
      Pen  .Width:=1;
      Pen  .Mode :=pmCopy;
      Pen  .Color:=item_col_arr[5];
      Rectangle(0,0,img_w  ,img_h  );
      Pen  .Color:=item_col_arr[6];
      Rectangle(1,1,img_w-1,img_h-1);
    end; {$endregion}

  //F_MainForm.M_Test_Log.Lines.Text:=IntToStr(exec_time0);

end; {$endregion}
procedure   TUIImgScrollBox.GetItemFocusedInd   (      x,y        :integer);                                                inline; {$region -fold}
begin
  case sel_grid of
    0:
      begin
        if (sel_grid_bmp0_ptr=Nil) then
          Exit;
        item_focused_ind              :=(sel_grid_bmp0_ptr+x+y*oc_w)^;
      end;
    1:
      begin
        if (sel_grid_bmp1_ptr=Nil) then
          Exit;
        item_focused_ind              :=(sel_grid_bmp1_ptr+x+y*oc_w)^;
      end;
    2:
      begin
        if (sel_grid_bmp2_ptr=Nil) then
          Exit;
        item_focused_ind              :=(sel_grid_bmp2_ptr+x+y*oc_w)^;
      end;
  end;
  scr_bar_v.scr_bar_rct_focused_bnd:=(item_focused_ind<=(MAX_TYPE_VAL[sel_grid]-1                             )) and
                                     (item_focused_ind> (MAX_TYPE_VAL[sel_grid]-1-scr_bar_v.sprite_sheet_cnt  ));
  scr_bar_h.scr_bar_rct_focused_bnd:=(item_focused_ind<=(MAX_TYPE_VAL[sel_grid]-1-scr_bar_h.sprite_sheet_cnt  )) and
                                     (item_focused_ind> (MAX_TYPE_VAL[sel_grid]-1-scr_bar_h.sprite_sheet_cnt*2));
end; {$endregion}
procedure   TUIImgScrollBox.GetItemFocusedInd   (      pvt        :TPoint );                                                inline; {$region -fold}
begin
  GetItemFocusedInd(pvt.x,pvt.y);
end; {$endregion}
procedure   TUIImgScrollBox.GetItemSelectedInd  (      x,y        :integer);                                                inline; {$region -fold}
var
  item_focused_ind_max: TColor;
begin
  case sel_grid of
    0:
      if (sel_grid_bmp0_ptr=Nil) then
        Exit;
    1:
      if (sel_grid_bmp1_ptr=Nil) then
        Exit;
    2:
      if (sel_grid_bmp2_ptr=Nil) then
        Exit;
  end;
  item_focused_ind_max             :=MAX_TYPE_VAL[sel_grid];
  if    scr_bar_v.scr_bar_rct_focused_bnd then
    begin
      if (not (Byte(item_focused_ind_max-1-item_focused_ind                           ) in [0,1,3])) then
        scr_bar_v.item_selected_ind:=      item_focused_ind
      else
        scr_bar_v.item_selected_ind:=      item_focused_ind_max;
    end
  else
        scr_bar_v.item_selected_ind:=      item_focused_ind_max;
  if    scr_bar_h.scr_bar_rct_focused_bnd then
    begin
      if (not (Byte(item_focused_ind_max-1-item_focused_ind-scr_bar_h.sprite_sheet_cnt) in [0,1,3])) then
        scr_bar_h.item_selected_ind:=      item_focused_ind
      else
        scr_bar_h.item_selected_ind:=      item_focused_ind_max;
    end
  else
        scr_bar_h.item_selected_ind:=      item_focused_ind_max;
end; {$endregion}
procedure   TUIImgScrollBox.SetItemsUnselected;                                                                             inline; {$region -fold}
var
  item_focused_ind_max: TColor;
begin
  case sel_grid of
    0:
      if (sel_grid_bmp0_ptr=Nil) then
        Exit;
    1:
      if (sel_grid_bmp1_ptr=Nil) then
        Exit;
    2:
      if (sel_grid_bmp2_ptr=Nil) then
        Exit;
  end;
  item_focused_ind_max       :=MAX_TYPE_VAL[sel_grid];
  scr_bar_v.item_selected_ind:=item_focused_ind_max;
  scr_bar_h.item_selected_ind:=item_focused_ind_max;
end; {$endregion}
procedure   TUIImgScrollBox.SetPosShiftSize     (var   pvt        :TPoint; var dir:TMovingDirection; const b:boolean=True); inline; {$region -fold}
var
  pvt0          : TPoint;
  v0,v1,v2,v3,v4: double;
  scl_mul       : double=1.0;
  row_length_   : TColor;
  row_cnt       : TColor=2;
  p0,p1,r0,r1   : integer;
  c             : byte;

  procedure ItemRctCalc; inline; {$region -fold}
  var
    d: shortint=1;
  begin
    if (dir=mdDown) then
      d:=-1;
    item_rct_prev_f.width :=                    item_rct_f.width;
    item_rct_prev_f.height:=                    item_rct_f.height;
    item_rct_prev  .width :=                    item_rct  .width;
    item_rct_prev  .height:=                    item_rct  .height;
    scl_mul               :=                1+d*item_rct_size_inc/
                                                item_rct_prev_f.width;
    item_rct_f     .width :=                    item_rct_f.width+d*
                                                item_rct_size_inc;
    item_rct_f     .height:=                    item_rct_prev_f.height*scl_mul;
    item_rct              :=PtBounds (0,0,Round(item_rct_f.width),
                                          Round(item_rct_f.height));
  end; {$endregion}

begin
  if b then
    begin
      if (items_cnt=0) then
        Exit;
      pvt0.x:=pvt.x;
      pvt0.y:=pvt.y;
      if (shift in [ss2Ctrl,ss2Shift]) then
        begin
          if (shift=ss2Shift) then
            begin
              pos_shift.x:=mrg_rct.left+2;
              pos_shift.y:=mrg_rct.top +2;
              pvt.x      :=mrg_rct.left+2;
              pvt.y      :=mrg_rct.top +2;
            end;
          if (dir=mdDown) then
            if (item_rct.width <=low_rct_size_limit0.x) or
               (item_rct.height<=low_rct_size_limit0.y) then
              begin
                pvt.x:=pvt0.x;
                pvt.y:=pvt0.y;
                Exit;
              end;
        end
      else
      if (shift=ss2Empty) then
        begin
          if (dir=mdDown) then
            begin
              RowLengthCalc(Round(pos_shift.x));
              if (items_cnt=1) or (row_length=0) then
                Exit;
              row_cnt:=RowCntCalc;
              if (pos_shift.y<=-row_cnt*(item_rct.height+mrg_rct.bottom)+mrg_rct.top+2) then
                begin
                  pos_shift.y:=-row_cnt*(item_rct.height+mrg_rct.bottom)+mrg_rct.top+2;
                  Exit;
                end;
              pos_shift.y-=pos_shift_size.y;
            end
          else
            begin
              if (pos_shift.y>=mrg_rct.top+2) then
                begin
                  pos_shift.y:=mrg_rct.top+2;
                  Exit;
                end;
              pos_shift.y+=pos_shift_size.y;
            end;
          Exit;
        end;
      ItemRctCalc;
    end
  else
    begin
      pos_shift.x:=mrg_rct.left+2;
      pos_shift.y:=mrg_rct.top +2;
      Exit;
    end;
  v3             :=pvt.x+1-pos_shift.x;
  v4             :=      item_rct_prev_f.width +mrg_rct.right;
  v1             :=     Trunc((v3                             )/   v4);
  v0             :=Max1(Trunc((v3              +mrg_rct.right )/   v4),v1);
  c              :=Byte(v0<>v1);
  v2             :=           (v3            +c*mrg_rct.right )-v0*v4;
  pos_shift.x    :=-(v0*(item_rct_f     .width +mrg_rct.right )-
                                              c*mrg_rct.right  +v2*(1-c)*scl_mul-(pvt.x+1));
  v3             :=pvt.y+1-pos_shift.y;
  v4             :=      item_rct_prev_f.height+mrg_rct.bottom;
  v1             :=     Trunc((v3                             )/   v4);
  v0             :=Max1(Trunc((v3              +mrg_rct.bottom)/   v4),v1);
  c              :=Byte(v0<>v1);
  v2             :=           (v3            +c*mrg_rct.bottom)-v0*v4;
  pos_shift.y    :=-(v0*(item_rct_f     .height+mrg_rct.bottom)-
                                              c*mrg_rct.bottom +v2*(1-c)*scl_mul-(pvt.y+1));
  pos_shift_size :=PtPos(item_rct       .height+mrg_rct.bottom,
                         item_rct       .height+mrg_rct.bottom);
  if (shift=ss2Ctrl) then
    begin
      if (dir=mdDown) then
        begin
          if (pos_shift.x>=mrg_rct.left+2) then
              pos_shift.x:=mrg_rct.left+2;
          if (pos_shift.y>=mrg_rct.top +2) then
              pos_shift.y:=mrg_rct.top +2;
        end
      else
        begin
          GetItemFocusedInd(pvt0);
          if (item_focused_ind<=2*(items_cnt-1)+1) then
            Exit;
          if (items_cnt       =1) and
             (item_focused_ind<>0) then
            begin
              pos_shift.x:=mrg_rct.left+2;
              pos_shift.y:=mrg_rct.top +2;
              //shift     :=ss2Ctrl;
              //row_length:=0;
              Exit;
            end;
              row_cnt    :=RowCntCalc;
          if (row_cnt<>0) then
              row_length_:=row_length
          else
              row_length_:=items_cnt;
          p0:=Round(pos_shift.x)+(row_length_-1)*(item_rct.width +mrg_rct.right );
          p1:=Round(pos_shift.x)+(row_length_  )*(item_rct.width +mrg_rct.right );
          r0:=Round(pos_shift.y)+(row_cnt      )*(item_rct.height+mrg_rct.bottom);
          r1:=Round(pos_shift.y)+(row_cnt    +1)*(item_rct.height+mrg_rct.bottom);
          if  ((row_cnt          <>0)    and
             (((p0<{=}mrg_rct.left+2)    and
               (p1>{=}mrg_rct.left+2)    and
               (p1<{=}img_w       -2))   or
              ((r0<{=}mrg_rct.top +2)    and
               (r1>{=}mrg_rct.top +2)    and
               (r1<{=}img_h       -2)))) or
              ((row_cnt           =0)    and
             (((p0<{=}mrg_rct.left+2)    and
               (p1>{=}mrg_rct.left+2)    and
               (p1<{=}img_w       -2))   or
              ((r0<{=}mrg_rct.top +2)    and
               (r1<{=}mrg_rct.top +2)))) then
            begin
              dir  :=mdDown;
              shift:=ss2Ctrl;
              SetPosShiftSize(pvt,dir);
              Exit;
            end;
        end;
    end;
  if (shift=ss2Shift) then
    begin
      pvt.x:=pvt0.x;
      pvt.y:=pvt0.y;
    end;
end; {$endregion}
procedure   TUIImgScrollBox.SetValScrBarsDefault(scr_bar:TUIScrollBar);                                                     inline; {$region -fold}
begin
  with scr_bar do
    begin
      oc_bmp_ptr_      :=self.oc_bmp_ptr_;
      oc_bmp_ptr0      :=self.oc_bmp_ptr0;
      oc_bmp_ptr1      :=self.oc_bmp_ptr1;
      oc_w             :=self.oc_w;
      oc_h             :=self.oc_h;
      mc_bmp_ptr       :=self.mc_bmp_ptr;
      mc_w             :=self.mc_w;
      mc_h             :=self.mc_h;
      mc_rct           :=self.mc_rct;
      sel_grid_bmp0_ptr:=self.sel_grid_bmp0_ptr;
      sel_grid_bmp1_ptr:=self.sel_grid_bmp1_ptr;
      sel_grid_bmp2_ptr:=self.sel_grid_bmp2_ptr;
    end;
end; {$endregion}
procedure   TUIImgScrollBox.SetPosScrBarVDefault;                                                                                   {$region -fold}
var
  slider_pos_min_max: TPtPos;
begin
  with scr_bar_h do
       scr_bar_visible:=scr_bar_draw and (not ((Round(pos_shift.x)>=mrg_rct.left+2) and (Round(pos_shift.x)+ItemsBndRctWidth<=img_w-2)));
  with scr_bar_v do
    if not ((Round(pos_shift.y)>=mrg_rct.top+2) and (Round(pos_shift.y)+ItemsBndRctHeight<=img_h-2)) then
      begin
        SetValScrBarsDefault(scr_bar_v);
        scr_bar_type             :=sbtVertical;
        sprite_sheet_ind_        :=ui_sprite_sheet_v_ind;
        sprite_sheet_cnt         :=06;
        if         (sprite_sheet_h_arr=Nil) then
          SetLength(sprite_sheet_h_arr,sprite_sheet_cnt);

        // i=0: top    arrow block;
        sprite_sheet_mrg_arr[0].x:=00;
        sprite_sheet_mrg_arr[0].y:=40;
        sprite_sheet_h_arr  [0]  :=         sprite_arr[sprite_sheet_ind_].fast_image_data.bmp_ftimg_height_origin-
                                                       sprite_sheet_mrg_arr[0].x-
                                                       sprite_sheet_mrg_arr[0].y;
        sprite_sheet_pos_arr[0].x:=img_w-04-sprite_arr[sprite_sheet_ind_].fast_image_data.bmp_ftimg_width_origin;
        sprite_sheet_pos_arr[0].y:=04;

        // i=1: middle       block;
        sprite_sheet_mrg_arr[1].x:=06;
        sprite_sheet_mrg_arr[1].y:=40;
        sprite_sheet_h_arr  [1]  :=         sprite_arr[sprite_sheet_ind_].fast_image_data.bmp_ftimg_height_origin-
                                                       sprite_sheet_mrg_arr[1].x-
                                                       sprite_sheet_mrg_arr[1].y;
        sprite_sheet_pos_arr[1].x:=                    sprite_sheet_pos_arr[0].x;
        sprite_sheet_pos_arr[1].y:=                    sprite_sheet_pos_arr[0].y+
                                                       sprite_sheet_h_arr  [0];

        // i=2: top    arrow;
        sprite_sheet_mrg_arr[2].x:=07;
        sprite_sheet_mrg_arr[2].y:=31;
        sprite_sheet_h_arr  [2]  :=         sprite_arr[sprite_sheet_ind_].fast_image_data.bmp_ftimg_height_origin-
                                                       sprite_sheet_mrg_arr[2].x-
                                                       sprite_sheet_mrg_arr[2].y;
        sprite_sheet_pos_arr[2].x:=                    sprite_sheet_pos_arr[0].x;
        sprite_sheet_pos_arr[2].y:=07;

        // i=3: bottom arrow block;
        sprite_sheet_inv_arr[3]  :=02;
        sprite_sheet_mrg_arr[3]  :=                    sprite_sheet_mrg_arr[0];
        sprite_sheet_h_arr  [3]  :=         sprite_arr[sprite_sheet_ind_].fast_image_data.bmp_ftimg_height_origin-
                                                       sprite_sheet_mrg_arr[3].x-
                                                       sprite_sheet_mrg_arr[3].y;
        sprite_sheet_pos_arr[3].x:=                    sprite_sheet_pos_arr[0].x;
        sprite_sheet_pos_arr[3].y:=img_h              -sprite_sheet_pos_arr[0].y-
                                                       sprite_sheet_h_arr  [3]  -22*Byte(scr_bar_h.scr_bar_visible);

        // i=4: bottom arrow;
        sprite_sheet_inv_arr[4]  :=02;
        sprite_sheet_mrg_arr[4]  :=                    sprite_sheet_mrg_arr[2];
        sprite_sheet_h_arr  [4]  :=         sprite_arr[sprite_sheet_ind_].fast_image_data.bmp_ftimg_height_origin-
                                                       sprite_sheet_mrg_arr[4].x-
                                                       sprite_sheet_mrg_arr[4].y;
        sprite_sheet_pos_arr[4].x:=                    sprite_sheet_pos_arr[0].x;
        sprite_sheet_pos_arr[4].y:=img_h              -sprite_sheet_pos_arr[2].y-
                                                       sprite_sheet_h_arr  [4]  -22*Byte(scr_bar_h.scr_bar_visible);

        // i=5: slider;
        sprite_sheet_mrg_arr[5].x:=15;
        sprite_sheet_mrg_arr[5].y:=00;
        sprite_sheet_h_arr  [5]  :=         sprite_arr[sprite_sheet_ind_].fast_image_data.bmp_ftimg_height_origin-
                                                       sprite_sheet_mrg_arr[5].x-
                                                       sprite_sheet_mrg_arr[5].y;
        sprite_sheet_pos_arr[5].x:=                    sprite_sheet_pos_arr[0].x;
        slider_pos_min_max       :=PtPos(02           +sprite_sheet_pos_arr[2].y+
                                                       sprite_sheet_h_arr  [2],
                                         02           +sprite_sheet_pos_arr[4].y-
                                                       sprite_sheet_h_arr  [5]  -4);
        if (GetSelectedItemInd =5) then
           sprite_sheet_pos_arr[5].y:=cur_pos.y      -(sprite_sheet_h_arr  [5]>>1)
        else
        if set_default_pos then
           sprite_sheet_pos_arr[5].y:=slider_pos_min_max.x
        else
           sprite_sheet_pos_arr[5].y:=slider_pos_min_max.y-Trunc(
                                     (slider_pos_min_max.y-
                                      slider_pos_min_max.x)*(Round(pos_shift.y)+ItemsBndRctHeight)
                                                           /(mrg_rct.top+2     +ItemsBndRctHeight));
        if sprite_sheet_pos_arr[5].y< slider_pos_min_max.x then
           sprite_sheet_pos_arr[5].y:=slider_pos_min_max.x;
        if sprite_sheet_pos_arr[5].y> slider_pos_min_max.y then
           sprite_sheet_pos_arr[5].y:=slider_pos_min_max.y;

        sprite_sheet_vis_arr[5]  :=                   (sprite_sheet_h_arr  [5]<=
                                                       sprite_sheet_pos_arr[4].y-
                                                       sprite_sheet_pos_arr[2].y-
                                                       sprite_sheet_h_arr  [2]  -4);

        sprite_sheet_scl_arr[1].y:=                    sprite_sheet_pos_arr[3].y-
                                                       sprite_sheet_pos_arr[0].y-
                                                       sprite_sheet_h_arr  [0];

        scr_bar_rct              :=PtBounds(           sprite_sheet_pos_arr[0].x-2,
                                                       sprite_sheet_pos_arr[0].y-2,
                                            sprite_arr[sprite_sheet_ind_].fast_image_data.bmp_ftimg_width_origin+4,
                                                       sprite_sheet_pos_arr[3].y+
                                                       sprite_sheet_h_arr  [3]);

        sprite_sheet_vis_arr[0]  :=(scr_bar_rct.height>=16);
        sprite_sheet_vis_arr[3]  :=                    sprite_sheet_vis_arr[0];
        sprite_sheet_vis_arr[2]  :=(scr_bar_rct.height>=30);
        sprite_sheet_vis_arr[4]  :=                    sprite_sheet_vis_arr[2];
      end;
end; {$endregion}
procedure   TUIImgScrollBox.SetPosScrBarHDefault;                                                                                   {$region -fold}
var
  slider_pos_min_max: TPtPos;
begin
  with scr_bar_v do
       scr_bar_visible:=scr_bar_draw and (not ((Round(pos_shift.y)>=mrg_rct.top+2) and (Round(pos_shift.y)+ItemsBndRctHeight<=img_h-2)));
  with scr_bar_h do
    if not ((Round(pos_shift.x)>=mrg_rct.left+2) and (Round(pos_shift.x)+ItemsBndRctWidth<=img_w-2)) then
      begin
        SetValScrBarsDefault(scr_bar_h);
        scr_bar_type             :=sbtHorizontal;
        sprite_sheet_ind_        :=ui_sprite_sheet_h_ind;
        sprite_sheet_cnt         :=06;
        if         (sprite_sheet_w_arr=Nil) then
          SetLength(sprite_sheet_w_arr,sprite_sheet_cnt);

        // i=0: top    arrow block;
        sprite_sheet_w_arr  [0]  :=06;
        sprite_sheet_mrg_arr[0].x:=00;
        sprite_sheet_mrg_arr[0].y:=54;
        sprite_sheet_pos_arr[0].x:=04;
        sprite_sheet_pos_arr[0].y:=img_h-04-18;

        // i=1: middle       block;
        sprite_sheet_w_arr  [1]  :=01;
        sprite_sheet_mrg_arr[1].x:=18;
        sprite_sheet_mrg_arr[1].y:=36;
        sprite_sheet_pos_arr[1].x:=                    sprite_sheet_pos_arr[0].x+
                                                       sprite_sheet_w_arr  [0];
        sprite_sheet_pos_arr[1].y:=                    sprite_sheet_pos_arr[0].y-
                                                       sprite_sheet_mrg_arr[1].x;

        // i=2: top    arrow;
        sprite_sheet_w_arr  [2]  :=08;
        sprite_sheet_mrg_arr[2].x:=36;
        sprite_sheet_mrg_arr[2].y:=18;
        sprite_sheet_pos_arr[2].x:=07;
        sprite_sheet_pos_arr[2].y:=                    sprite_sheet_pos_arr[0].y-
                                                       sprite_sheet_mrg_arr[2].x;

        // i=3: bottom arrow block;
        sprite_sheet_w_arr  [3]  :=                    sprite_sheet_w_arr  [0];
        sprite_sheet_inv_arr[3]  :=01;
        sprite_sheet_mrg_arr[3]  :=                    sprite_sheet_mrg_arr[0];
        sprite_sheet_pos_arr[3].x:=img_w              -sprite_sheet_pos_arr[0].x-
                                                       sprite_sheet_w_arr  [3]  -22*Byte(scr_bar_v.scr_bar_visible);
        sprite_sheet_pos_arr[3].y:=                    sprite_sheet_pos_arr[0].y;

        // i=4: bottom arrow;
        sprite_sheet_w_arr  [4]  :=                    sprite_sheet_w_arr  [2];
        sprite_sheet_inv_arr[4]  :=01;
        sprite_sheet_mrg_arr[4]  :=                    sprite_sheet_mrg_arr[2];
        sprite_sheet_pos_arr[4].x:=img_w              -sprite_sheet_pos_arr[2].x-
                                                       sprite_sheet_w_arr  [4]  -22*Byte(scr_bar_v.scr_bar_visible);
        sprite_sheet_pos_arr[4].y:=                    sprite_sheet_pos_arr[0].y-
                                                       sprite_sheet_mrg_arr[2].x;

        // i=5: slider;
        sprite_sheet_w_arr  [5]  :=31;
        sprite_sheet_mrg_arr[5].x:=51;
        sprite_sheet_mrg_arr[5].y:=00;
        slider_pos_min_max       :=PtPos(02           +sprite_sheet_pos_arr[2].x+
                                                       sprite_sheet_w_arr  [2],
                                         02           +sprite_sheet_pos_arr[4].x-
                                                       sprite_sheet_w_arr  [5]  -4);
        if (GetSelectedItemInd =5) then
           sprite_sheet_pos_arr[5].x:=cur_pos.x      -(sprite_sheet_w_arr  [5]>>1)
        else
        if set_default_pos then
           sprite_sheet_pos_arr[5].x:=slider_pos_min_max.x
        else
           sprite_sheet_pos_arr[5].x:=slider_pos_min_max.y-Trunc(
                                     (slider_pos_min_max.y-
                                      slider_pos_min_max.x)*(Round(pos_shift.x)+ItemsBndRctWidth)
                                                           /(mrg_rct.left+2    +ItemsBndRctWidth));
        if sprite_sheet_pos_arr[5].x< slider_pos_min_max.x then
           sprite_sheet_pos_arr[5].x:=slider_pos_min_max.x;
        if sprite_sheet_pos_arr[5].x> slider_pos_min_max.y then
           sprite_sheet_pos_arr[5].x:=slider_pos_min_max.y;

        sprite_sheet_pos_arr[5].y:=                    sprite_sheet_pos_arr[0].y-
                                                       sprite_sheet_mrg_arr[5].x-3;
        sprite_sheet_vis_arr[5]  :=                   (sprite_sheet_w_arr  [5]<=
                                                       sprite_sheet_pos_arr[4].x-
                                                       sprite_sheet_pos_arr[2].x-
                                                       sprite_sheet_w_arr  [2]  -4);

        sprite_sheet_scl_arr[1].x:=                    sprite_sheet_pos_arr[3].x-
                                                       sprite_sheet_pos_arr[0].x-
                                                       sprite_sheet_w_arr  [0];

        scr_bar_rct              :=PtBounds(           sprite_sheet_pos_arr[0].x-2,
                                                       sprite_sheet_pos_arr[0].y-2,
                                                       sprite_sheet_pos_arr[3].x+
                                                       sprite_sheet_w_arr  [3],
                                           (sprite_arr[sprite_sheet_ind_].fast_image_data.bmp_ftimg_height_origin-
                                                       sprite_sheet_mrg_arr[0].x-
                                                       sprite_sheet_mrg_arr[0].y)+4);

        sprite_sheet_vis_arr[0]  :=(scr_bar_rct.width>=16);
        sprite_sheet_vis_arr[3]  :=                    sprite_sheet_vis_arr[0];
        sprite_sheet_vis_arr[2]  :=(scr_bar_rct.width>=30);
        sprite_sheet_vis_arr[4]  :=                    sprite_sheet_vis_arr[2];
      end;
end; {$endregion}
{Events}
procedure   TUIImgScrollBox.OnMouseEnter;                                                                                           {$region -fold}
begin
end; {$endregion}
procedure   TUIImgScrollBox.OnMouseLeave;                                                                                           {$region -fold}
begin
  item_focused_ind                 :=MAX_TYPE_VAL[sel_grid];
  scr_bar_v.item_selected_ind      :=MAX_TYPE_VAL[sel_grid];
  scr_bar_h.item_selected_ind      :=MAX_TYPE_VAL[sel_grid];
  scr_bar_v.scr_bar_rct_focused_bnd:=False;
  scr_bar_h.scr_bar_rct_focused_bnd:=False;
end; {$endregion}
procedure   TUIImgScrollBox.OnMouseMove         (x,y:integer; screen_cursor_ptr:PCursor);                                           {$region -fold}
var
  slider_pos_min_max: TPtPos;
begin
  if (items_cnt=0) then
    Exit;
  GetItemFocusedInd(x,y);
  cur_pos.x:=x;
  cur_pos.y:=y;
  if scr_bar_v.scr_bar_rct_focused_bnd or
     scr_bar_h.scr_bar_rct_focused_bnd then
    screen_cursor_ptr^:=-21
  else
    begin
      if (item_focused_ind<=2*(items_cnt-1)+1) then
        screen_cursor_ptr^:=-21
      else
      if (scr_bar_v.GetSelectedItemInd<>5) and
         (scr_bar_h.GetSelectedItemInd<>5) then
        begin
          screen_cursor_ptr^:=0;
          SetItemsUnselected;
        end;
    end;
  with scr_bar_v do
    if (GetSelectedItemInd=5) then
      begin
        slider_pos_min_max:=      PtPos(02+sprite_sheet_pos_arr[2].y+
                                           sprite_sheet_h_arr  [2],
                                        02+sprite_sheet_pos_arr[4].y-
                                           sprite_sheet_h_arr  [5]  -4);
        pos_shift.y:=(slider_pos_min_max.y-sprite_sheet_pos_arr[5].y)*(mrg_rct.top +2+ItemsBndRctHeight)/
                     (slider_pos_min_max.y-
                      slider_pos_min_max.x)                                          -ItemsBndRctHeight;
        Exit;
      end;
  with scr_bar_h do
    if (GetSelectedItemInd=5) then
      begin
        slider_pos_min_max:=      PtPos(02+sprite_sheet_pos_arr[2].x+
                                           sprite_sheet_w_arr  [2],
                                        02+sprite_sheet_pos_arr[4].x-
                                           sprite_sheet_w_arr  [5]  -4);
        pos_shift.x:=(slider_pos_min_max.y-sprite_sheet_pos_arr[5].x)*(mrg_rct.left+2+ItemsBndRctWidth )/
                     (slider_pos_min_max.y-
                      slider_pos_min_max.x)                                          -ItemsBndRctWidth;
      end;
end; {$endregion}
procedure   TUIImgScrollBox.OnMouseDown         (x,y:integer);                                                                      {$region -fold}
begin
  GetItemFocusedInd (x,y);
  GetItemSelectedInd(x,y);
  scr_bar_v.set_default_pos:=False;
  scr_bar_h.set_default_pos:=False;
end; {$endregion}
procedure   TUIImgScrollBox.OnMouseUp           (x,y:integer);                                                                      {$region -fold}
begin
 GetItemFocusedInd(x,y);
 SetItemsUnselected;
end; {$endregion}
procedure   TUIImgScrollBox.OnMouseWheel        (shift_:TShiftState; mousepos_:TPoint; var dir:TMovingDirection);                   {$region -fold}
begin
  if (shift_=[ssCtrl ]) then // Cursor      zoom axis
      shift:=ss2Ctrl
  else
  if (shift_=[ssShift]) then // Left corner zoom axis
      shift:=ss2Shift
  else
      shift:=ss2Empty;
  SetPosShiftSize(mousepos_,dir);
  cur_pos.x:=mousepos_.x;
  cur_pos.y:=mousepos_.y;
end; {$endregion}

{$endregion}

end.
