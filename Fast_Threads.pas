unit Fast_Threads;

{This file contains some routines for working with threads(in particular,
implementations of multi-threaded variants of some functions from other modules)}

{$mode objfpc}
{$H+,INLINE+}

interface

uses

  Classes, SysUtils, MTProcs, PasMP, Fast_Graphics, Fast_UI;



const

  MAXBYTE=255;



type

  TThreadObj         =class;
  TFastImageProc     =class;
  TUIImgScrollBoxProc=class;

  TThreadObj         =class(TThread)                      {$region -fold}
    public // private
      thread_ind       : integer;
      bmp_dst_ptr      : PInteger;
      bmp_dst_width    : TColor;
      bmp_dst_height   : TColor;
      rct_dst          : TPtRect;
      class var
        color_info     : TColorInfo;
        PPRandNoiseProc: byte;
        PPBlurProc     : TProc8;
        thread_cnt     : byte;
        proc_ind       : byte;
    public
      constructor Create(thread_cnt_    : integer;
                         thread_ind_    : integer;
                         proc_ind_      : byte;
                         bmp_dst_ptr_   : PInteger;
                         bmp_dst_width_ : TColor;
                         bmp_dst_height_: TColor;
                         rct_dst_       : TPtRect);
      procedure   ThreadWork; deprecated;
      procedure   Execute; override;
  end; {$endregion}

  TFastImageProc     =class(Fast_Graphics.TFastImageProc) {$region -fold}
    constructor Create;
    procedure   FastImageDataMTInit;                                override; {$ifdef Linux}[local];{$endif}
    procedure   UberShader8         (const pt_arr_ptr  :PPtPosF;
                                     const sprites_cnt,
                                           w_a_s_x,
                                           w_a_s_y     :integer;
                                     const block_count :integer=1); override; {$ifdef Linux}[local];{$endif}
    procedure   UberShader9         (const pt_arr_ptr  :PPtPosF;
                                     const sprites_cnt,
                                           w_a_s_x,
                                           w_a_s_y     :integer;
                                     const block_count :integer=1); override; {$ifdef Linux}[local];{$endif}
  end; {$endregion}

  TUIImgScrollBoxProc=class                               {$region -fold}
    constructor Create;
    procedure   Loop10(const ui_img_scroll_box:TUIImgScrollBox;
                       const x1,y1            :integer;
                       const block_count      :integer=1); {$ifdef Linux}[local];{$endif}
    procedure   Loop11(const ui_img_scroll_box:TUIImgScrollBox;
                       const x1,y1            :integer;
                       const block_count      :integer=1);
  end; {$endregion}

  TFuncData          =record                              {$region -fold}
    bmp_dst_ptr  : PInteger;
    bmp_dst_width: TColor;
    rct_dst_     : TPtRect;
    col          : TColor;
    pow          : byte;
    block_count  : integer;
  end; {$endregion}
  PFuncData          =^TFuncData;



var
  max_physical_threads_cnt  : integer=64{      CPUCount     };
  max_virtual_threads_cnt   : integer=64{      CPUCount     };
  usable_threads_cnt        : integer=05{Trunc(CPUCount/1.5)};
  valid_threads_cnt         : integer=05{Trunc(CPUCount/1.5)};
  thread_obj_arr            : array of TThreadObj;
  ui_img_scroll_box_proc_var: TUIImgScrollBoxProc;



function  SetRct           (      index         :PtrInt;
                            const rct_dst       :TPtRect;
                            const block_count   :integer): TPtRect; inline;
procedure SetValidThreadCnt(const rct_clp_height:integer);          inline;
procedure ThreadObjArrInit (      thread_cnt    :integer);

{Regular FX}
// FloodFill:
procedure PPFloodFillMT    (const bmp_dst_ptr   :PInteger;
                            const bmp_dst_width :TColor;
                            const rct_dst_      :TPtRect;
                            const col           :TColor;
                            const block_count   :integer=1);
// AlphaBlend:
procedure PPAlphaBlend128MT(const bmp_dst_ptr   :PInteger;
                            const bmp_dst_width :TColor;
                            const rct_dst_      :TPtRect;
                            const col           :TColor;
                            const pow           :byte=64;
                            const block_count   :integer=1);
procedure PPAlphaBlend256MT(const bmp_dst_ptr   :PInteger;
                            const bmp_dst_width :TColor;
                            const rct_dst_      :TPtRect;
                            const col           :TColor;
                            const pow           :byte=64;
                            const block_count   :integer=1);
// Additive:
procedure PPAdditiveMT     (const bmp_dst_ptr   :PInteger;
                            const bmp_dst_width :TColor;
                            const rct_dst_      :TPtRect;
                            const col           :TColor;
                            const block_count   :integer=1);
procedure PPAdditiveDecMT  (const bmp_dst_ptr   :PInteger;
                            const bmp_dst_width :TColor;
                            const rct_dst_      :TPtRect;
                            const col           :TColor;
                            const pow           :byte=64;
                            const block_count   :integer=1);
// Inverse:
procedure PPInverseMT      (const bmp_dst_ptr   :PInteger;
                            const bmp_dst_width :TColor;
                            const rct_dst_      :TPtRect;
                            const block_count   :integer=1);
procedure PPInverseDecMT   (const bmp_dst_ptr   :PInteger;
                            const bmp_dst_width :TColor;
                            const rct_dst_      :TPtRect;
                            const pow           :byte=64;
                            const block_count   :integer=1);
// Highlight:
procedure PPHighlightMT    (const bmp_dst_ptr   :PInteger;
                            const bmp_dst_width :TColor;
                            const rct_dst_      :TPtRect;
                            const pow           :byte=64;
                            const block_count   :integer=1);
// Darken:
procedure PPDarkenMT       (const bmp_dst_ptr   :PInteger;
                            const bmp_dst_width :TColor;
                            const rct_dst_      :TPtRect;
                            const pow           :byte=64;
                            const block_count   :integer=1);
// GrayscaleR:
procedure PPGrayscaleRMT   (const bmp_dst_ptr   :PInteger;
                            const bmp_dst_width :TColor;
                            const rct_dst_      :TPtRect;
                            const block_count   :integer=1);
procedure PPGrayscaleRDecMT(const bmp_dst_ptr   :PInteger;
                            const bmp_dst_width :TColor;
                            const rct_dst_      :TPtRect;
                            const pow           :byte=64;
                            const block_count   :integer=1);
// GrayscaleG:
procedure PPGrayscaleGMT   (const bmp_dst_ptr   :PInteger;
                            const bmp_dst_width :TColor;
                            const rct_dst_      :TPtRect;
                            const block_count   :integer=1);
procedure PPGrayscaleGDecMT(const bmp_dst_ptr   :PInteger;
                            const bmp_dst_width :TColor;
                            const rct_dst_      :TPtRect;
                            const pow           :byte=64;
                            const block_count   :integer=1);
// GrayscaleB:
procedure PPGrayscaleBMT   (const bmp_dst_ptr   :PInteger;
                            const bmp_dst_width :TColor;
                            const rct_dst_      :TPtRect;
                            const block_count   :integer=1);
procedure PPGrayscaleBDecMT(const bmp_dst_ptr   :PInteger;
                            const bmp_dst_width :TColor;
                            const rct_dst_      :TPtRect;
                            const pow           :byte=64;
                            const block_count   :integer=1);
// Mono. noise:
procedure PPMonoNoiseMT    (const bmp_dst_ptr   :PInteger;
                            const bmp_dst_width :TColor;
                            const rct_dst_      :TPtRect;
                            const col           :TColor;
                            const block_count   :integer=1);
procedure PPMonoNoiseDecMT (const bmp_dst_ptr   :PInteger;
                            const bmp_dst_width :TColor;
                            const rct_dst_      :TPtRect;
                            const col           :TColor;
                            const pow           :byte=64;
                            const block_count   :integer=1);
// Rand. noise:
procedure PPRandNoiseMT    (const bmp_dst_ptr   :PInteger;
                            const bmp_dst_width :TColor;
                            const rct_dst_      :TPtRect;
                            const proc_ind      :byte;
                                  pow1,pow2     :byte;
                            const block_count   :integer=1);
procedure PPRandNoiseDecMT (const bmp_dst_ptr   :PInteger;
                            const bmp_dst_width :TColor;
                            const rct_dst_      :TPtRect;
                            const proc_ind      :byte;
                                  pow1,pow2     :byte;
                            const pow           :byte=64;
                            const block_count   :integer=1);
// Blur:
procedure PPBlur4MT        (const bmp_dst_ptr   :PInteger;
                            const bmp_dst_width :TColor;
                            const rct_dst_      :TPtRect;
                            const PPBlur4Proc   :TProc8;
                            const block_count   :integer=1);
procedure PPBlur4DecMT     (const bmp_dst_ptr   :PInteger;
                            const bmp_dst_width :TColor;
                            const rct_dst_      :TPtRect;
                            const PPBlur4Proc   :TProc19;
                            const pow           :byte=64;
                            const block_count   :integer=1);
// Contrast:
procedure PPContrastMT     (const bmp_dst_ptr   :PInteger;
                            const bmp_dst_width :TColor;
                            const rct_dst_      :TPtRect;
                            const pow           :byte=64;
                            const block_count   :integer=1);
// Gamma:
procedure PPGammaMT        (const bmp_dst_ptr   :PInteger;
                            const bmp_dst_width :TColor;
                            const rct_dst_      :TPtRect;
                            const pow0          :single;
                            const block_count   :integer=1);
procedure PPGammaDecMT     (const bmp_dst_ptr   :PInteger;
                            const bmp_dst_width :TColor;
                            const rct_dst_      :TPtRect;
                            const pow0          :single;
                            const pow           :byte=64;
                            const block_count   :integer=1);

{Gradient FX}
// Auxilary proc.(gradient precalc.):
procedure GrVPrecalc       (      index         :PtrInt;
                            var   block_rct1    :TPtRect;
                            const rct_dst_      :TPtRect;
                            const col0,col1     :TColor;
                            const block_count   :integer);
// FloodFill:
procedure PPGrVFloodFillMT (const bmp_dst_ptr   :PInteger;
                            const bmp_dst_width :TColor;
                            const rct_dst_      :TPtRect;
                            const col0,col1     :TColor;
                            const block_count   :integer=1);
// AlphaBlend:
procedure PPGrVAlphaBlendMT(const bmp_dst_ptr   :PInteger;
                            const bmp_dst_width :TColor;
                            const rct_dst_      :TPtRect;
                            const col0,col1     :TColor;
                            const block_count   :integer=1);
// Additive:
procedure PPGrVAdditiveMT  (const bmp_dst_ptr   :PInteger;
                            const bmp_dst_width :TColor;
                            const rct_dst_      :TPtRect;
                            const col0,col1     :TColor;
                            const block_count   :integer=1);
// Inverse:
procedure PPGrVInverseMT   (const bmp_dst_ptr   :PInteger;
                            const bmp_dst_width :TColor;
                            const rct_dst_      :TPtRect;
                            const col0,col1     :TColor;
                            const block_count   :integer=1);
// Highlight:
procedure PPGrVHighlightMT (const bmp_dst_ptr   :PInteger;
                            const bmp_dst_width :TColor;
                            const rct_dst_      :TPtRect;
                            const col0,col1     :TColor;
                            const block_count   :integer=1);
// Darken:
procedure PPGrVDarkenMT    (const bmp_dst_ptr   :PInteger;
                            const bmp_dst_width :TColor;
                            const rct_dst_      :TPtRect;
                            const col0,col1     :TColor;
                            const block_count   :integer=1);
// GrayscaleR:
procedure PPGrVGrayscaleRMT(const bmp_dst_ptr   :PInteger;
                            const bmp_dst_width :TColor;
                            const rct_dst_      :TPtRect;
                            const col0,col1     :TColor;
                            const block_count   :integer=1);
// GrayscaleG:
procedure PPGrVGrayscaleGMT(const bmp_dst_ptr   :PInteger;
                            const bmp_dst_width :TColor;
                            const rct_dst_      :TPtRect;
                            const col0,col1     :TColor;
                            const block_count   :integer=1);
// GrayscaleB:
procedure PPGrVGrayscaleBMT(const bmp_dst_ptr   :PInteger;
                            const bmp_dst_width :TColor;
                            const rct_dst_      :TPtRect;
                            const col0,col1     :TColor;
                            const block_count   :integer=1);
// Mono. noise:
procedure PPGrVMonoNoiseMT (const bmp_dst_ptr   :PInteger;
                            const bmp_dst_width :TColor;
                            const rct_dst_      :TPtRect;
                            const col0,col1     :TColor;
                            const block_count   :integer=1);
// Rand. noise:
procedure PPGrVRandNoiseMT (const bmp_dst_ptr   :PInteger;
                            const bmp_dst_width :TColor;
                            const rct_dst_      :TPtRect;
                            const col0,col1     :TColor;
                            const fx_style1     :byte;
                            const block_count   :integer=1);
// Blur:
procedure PPGrVBlur4MT     (const bmp_dst_ptr   :PInteger;
                            const bmp_dst_width :TColor;
                            const rct_dst_      :TPtRect;
                            const col0,col1     :TColor;
                            const fx_style1     :byte;
                            const block_count   :integer=1);
// Contrast:
procedure PPGrVContrastMT  (const bmp_dst_ptr   :PInteger;
                            const bmp_dst_width :TColor;
                            const rct_dst_      :TPtRect;
                            const col0,col1     :TColor;
                            const block_count   :integer=1);
// Gamma:
procedure PPGrVGammaMT     (const bmp_dst_ptr   :PInteger;
                            const bmp_dst_width :TColor;
                            const rct_dst_      :TPtRect;
                            const col0,col1     :TColor;
                            const block_count   :integer=1);



implementation

function    SetRct           (      index         :PtrInt; const rct_dst:TPtRect; const block_count:integer): TPtRect; inline; {$region -fold}
var
  pixels_per_block_y0: integer;
  pixels_per_block_y1: integer;
begin
  pixels_per_block_y0:=Round(rct_dst.height/block_count);
  if (index<block_count-1) then
    pixels_per_block_y1:=pixels_per_block_y0
  else
    pixels_per_block_y1:=      rct_dst.height   -pixels_per_block_y0*(block_count-1);
  Result               :=PtRct(rct_dst.left,
                               rct_dst.top+index*pixels_per_block_y0,
                               rct_dst.right,
                               rct_dst.top+index*pixels_per_block_y0+
                                                 pixels_per_block_y1);
end; {$endregion}
procedure   SetValidThreadCnt(const rct_clp_height:integer                                                 );          inline; {$region -fold}
begin
  if (rct_clp_height<usable_threads_cnt) then
    valid_threads_cnt:=1
  else
    valid_threads_cnt:=usable_threads_cnt;
end; {$endregion}

procedure   ThreadObjArrInit (thread_cnt :integer); {$region -fold}
begin
  if         (thread_obj_arr=Nil) then
    SetLength(thread_obj_arr,thread_cnt);
end; {$endregion}
constructor TThreadObj.Create(thread_cnt_:integer; thread_ind_:integer; proc_ind_:byte; bmp_dst_ptr_:PInteger; bmp_dst_width_:TColor; bmp_dst_height_:TColor; rct_dst_:TPtRect); {$region -fold}
begin

  {Init.Thread---} {$region -fold}
  inherited Create(False);
  FreeOnTerminate:=False; {$endregion}

  {Fill Some Data} {$region -fold}
  thread_cnt     :=thread_cnt_;
  thread_ind     :=thread_ind_;
  proc_ind       :=proc_ind_;
  bmp_dst_ptr    :=bmp_dst_ptr_;
  bmp_dst_width  :=bmp_dst_width_;
  bmp_dst_height :=bmp_dst_height_;
  rct_dst        :=SetRct(thread_ind,rct_dst_,thread_cnt); {$endregion}

end; {$endregion}
procedure   TThreadObj.ThreadWork; deprecated;{$region -fold}
{var
  x,y: integer;}
begin

   case proc_ind of
     00:
       if (color_info.alpha1=MAXBYTE) then
         PPFloodFill    (bmp_dst_ptr,bmp_dst_width,rct_dst,                color_info.pix_col                                    )
       else
         PPAlphaBlend   (bmp_dst_ptr,bmp_dst_width,rct_dst,                color_info.pix_col,color_info.alpha1                  );
     01: PPAdditiveDec  (bmp_dst_ptr,bmp_dst_width,rct_dst,                color_info.pix_col,color_info.alpha1                  );
     02: PPInverseDec   (bmp_dst_ptr,bmp_dst_width,rct_dst,                                   color_info.alpha1                  );
     03: PPHighlight    (bmp_dst_ptr,bmp_dst_width,rct_dst,                                   color_info.alpha1                  );
     04: PPDarken       (bmp_dst_ptr,bmp_dst_width,rct_dst,                                   color_info.alpha1                  );
     05: PPGrayscaleRDec(bmp_dst_ptr,bmp_dst_width,rct_dst,                                   color_info.alpha1                  );
     06: PPGrayscaleGDec(bmp_dst_ptr,bmp_dst_width,rct_dst,                                   color_info.alpha1                  );
     07: PPGrayscaleBDec(bmp_dst_ptr,bmp_dst_width,rct_dst,                                   color_info.alpha1                  );
     08: PPMonoNoiseDec (bmp_dst_ptr,bmp_dst_width,rct_dst,                color_info.pix_col,color_info.alpha1                  );
     09: PPRandNoise    (bmp_dst_ptr,bmp_dst_width,rct_dst,PPRandNoiseProc,                   color_info.alpha1,color_info.alpha2);
     10: PPBlur4        (bmp_dst_ptr,bmp_dst_width,rct_dst,PPBlurProc                                                            );
   end;

  {Debug} {$region -fold}
  {if (rct_dst.width<=0) or (rct_dst.height<=0) then
    Exit;
  bmp_dst_ptr+=rct_dst.left+bmp_dst_width*rct_dst.top;
  for y:=0 to rct_dst.height-1 do
    begin
      for x:=0 to rct_dst.width-1 do
        AlphaBlend1(bmp_dst_ptr+x,color_info.pix_col,color_info.d_alpha1);
      Inc(bmp_dst_ptr,bmp_dst_width);
    end;} {$endregion}

end; {$endregion}
procedure   TThreadObj.Execute;               {$region -fold}
begin
  //inherited CurrentThread;
  {TThread.Synchronize(TThread.CurrentThread,@ThreadWork);//}{Synchronize(@}ThreadWork{)};
end; {$endregion}

constructor TFastImageProc.Create;              {$region -fold}
begin
  inherited Create;
  FastImageDataMTInit;
end; {$endregion}
procedure   TFastImageProc.FastImageDataMTInit; {$region -fold}
var
  i: integer;
begin
  SetLength(fast_image_data_arr,max_virtual_threads_cnt);
  for i:=0 to max_virtual_threads_cnt-1 do
    begin
      fast_image_data_arr[i].scl_mul    :=PtPosF (1.0,1.0);
      fast_image_data_arr[i].rct_src_mrg:=Default(TPtRect);
    end;
end; {$endregion}
procedure   TFastimageProc.UberShader8(const pt_arr_ptr:PPtPosF; const sprites_cnt,w_a_s_x,w_a_s_y:integer; const block_count:integer=1); {$ifdef Linux}[local];{$endif} {$region -fold}

  procedure DrawCallMT(index:PtrInt); {$region -fold}
  var
    i: integer;
  begin
    with fast_image_data_ptr0^ do
      for i:=0 to sprites_cnt-1 do
        begin
          //fast_image_data_arr[i].img_inv_type:=Byte(Odd(i));
          SdrProc[sdr_proc_ind+0](Trunc(pt_arr_ptr[i].x)+w_a_s_x,
                                  Trunc(pt_arr_ptr[i].y)+w_a_s_y,
                                  fast_image_data_ptr0,
                                  index,
                                  block_count);

        end;
  end; {$endregion}

begin
  ProcThreadPool.DoParallelLocalProc(@DrawCallMT,0,block_count-1);
end; {$endregion}
procedure   TFastimageProc.UberShader9(const pt_arr_ptr:PPtPosF; const sprites_cnt,w_a_s_x,w_a_s_y:integer; const block_count:integer=1); {$ifdef Linux}[local];{$endif} {$region -fold}

  procedure DrawCallMT(index:PtrInt); {$region -fold}
  var
    i: integer;
  begin

    {with fast_image_data_arr[index] do
      begin
        with fx_arr[0] do
          begin
            nt_fx_prop.is_fx_animate:=True;
            pt_fx_prop.is_fx_animate:=True;
            nt_fx_prop.pix_cfx_type :=2;
            pt_fx_prop.pix_cfx_type :=2;
            nt_fx_prop.pix_cng_type :=1;
            pt_fx_prop.pix_cng_type :=1;
            //nt_fx_prop.cfx_pow0     :=100;
            //pt_fx_prop.cfx_pow0     :=100;
            Inc(nt_fx_prop.cfx_pow0);
            Inc(pt_fx_prop.cfx_pow0);
          end;
        with fx_arr[1] do
          begin
            nt_fx_prop.is_fx_animate:=True;
            pt_fx_prop.is_fx_animate:=True;
            nt_fx_prop.pix_cfx_type :=2;
            pt_fx_prop.pix_cfx_type :=2;
            nt_fx_prop.pix_cng_type :=1;
            pt_fx_prop.pix_cng_type :=1;
            //nt_fx_prop.cfx_pow0     :=100;
            //pt_fx_prop.cfx_pow0     :=100;
            Inc(nt_fx_prop.cfx_pow0);
            Inc(pt_fx_prop.cfx_pow0);
          end;
      end;}

    with fast_image_data_ptr0^ do
      for i:=0 to sprites_cnt-1 do
        SdrProc[sdr_proc_ind+4](Trunc(pt_arr_ptr[i].x)+w_a_s_x,
                                Trunc(pt_arr_ptr[i].y)+w_a_s_y,
                                fast_image_data_ptr0,
                                index,
                                block_count);
  end; {$endregion}

begin
  ProcThreadPool.DoParallelLocalProc(@DrawCallMT,0,block_count-1);
end; {$endregion}

constructor TUIImgScrollBoxProc.Create; {$region -fold}
begin
  //inherited Create;
end; {$endregion}
procedure   TUIImgScrollBoxProc.Loop10(const ui_img_scroll_box:TUIImgScrollBox; const x1,y1:integer; const block_count:integer=1); {$ifdef Linux}[local];{$endif} {$region -fold}

  procedure Loop10MT(index:PtrInt); {$region -fold}
  var
    pt     : double;
    x0,y0,i: integer;
  begin
    x0:=x1;
    y0:=y1;
    with ui_img_scroll_box do
      for i:=0 to items_cnt-1 do
        with sprite_arr [(images_inds_arr_ptr+i)^],fast_image_data,fast_image_proc_var do
          begin
            if line_break then
              if (i<>0) then
                if (x0+item_rct.width>img_w) then
                  begin
                    x0:=x1;
                    Inc(y0,item_rct.height+mrg_rct.bottom);
                  end;

            {Image icon drawing-} {$region -fold}

            fast_image_data_arr[index].rct_src_mrg.top   :=sprite_sheet_mrg_arr[i].x;
            fast_image_data_arr[index].rct_src_mrg.bottom:=sprite_sheet_mrg_arr[i].y;
            fast_image_data_arr[index].frame_height_int  := bmp_ftimg_height_origin-fast_image_data_arr[index].rct_src_mrg.top-fast_image_data_arr[index].rct_src_mrg.bottom;
            if fit_item_img_to_rct then
              begin
                pt                                       :=(item_rct.height-2)/Max1(fast_image_data_arr[index].frame_height_int,bmp_ftimg_width_origin);
                fast_image_data_arr[index].scl_mul       :=PtPosF(pt,pt);
              end
            else
              begin
                if (bmp_ftimg_height_origin/bmp_ftimg_width_origin>=item_rct.height/item_rct.width) then
                  pt:=(item_rct.height-2)  /bmp_ftimg_height_origin
                else
                  pt:=(item_rct.width -2)  /bmp_ftimg_width_origin;
                if (bmp_ftimg_width_origin <=item_rct.width) and
                   (bmp_ftimg_height_origin<=item_rct.height) then
                  fast_image_data_arr[index].scl_mul     :=PtPosF(1.0,1.0)
                else
                  fast_image_data_arr[index].scl_mul     :=PtPosF(pt,pt);
              end;
            SdrProc[sdr_proc_ind](x0+{Trunc}Round((item_rct.width {+1}-bmp_ftimg_width_origin                     *pt)/2),
                                  y0+{Trunc}Round((item_rct.height{+1}-fast_image_data_arr[index].frame_height_int*pt)/2-fast_image_data_arr[index].rct_src_mrg.top*pt),
                                  @fast_image_data,
                                  index,
                                  block_count);
            fast_image_data_arr[index].scl_mul           :=PtPosF(1.0,1.0);
            fast_image_data_arr[index].rct_src_mrg.top   :=0;
            fast_image_data_arr[index].rct_src_mrg.bottom:=0; {$endregion}

            Inc(x0,item_rct.width+mrg_rct.{left}right);
          end;
  end; {$endregion}

begin
  ProcThreadPool.DoParallelLocalProc(@Loop10MT,0,block_count-1);
end; {$endregion}
procedure   TUIImgScrollBoxProc.Loop11(const ui_img_scroll_box:TUIImgScrollBox; const x1,y1:integer; const block_count:integer=1); {$ifdef Linux}[local];{$endif} {$region -fold}

  procedure Loop11MT(index:PtrInt); {$region -fold}
  var
    pt       : double;
    x0,y0,i,j: integer;
  begin
    x0:=x1;
    y0:=y1;
    j :=1;
    with ui_img_scroll_box do
      for i:=0 to items_cnt-1 do
        with sprite_arr [(images_inds_arr_ptr+i)^],fast_image_data,fast_image_proc_var do
          begin
            if line_break then
              if (i<>0) then
                if (i=row_length*j) then
                  begin
                    x0:=x1;
                    Inc(y0,item_rct.height+mrg_rct.bottom);
                    Inc(j);
                  end;

            {Image icon drawing-} {$region -fold}

            fast_image_data_arr[index].rct_src_mrg.top   :=sprite_sheet_mrg_arr[i].x;
            fast_image_data_arr[index].rct_src_mrg.bottom:=sprite_sheet_mrg_arr[i].y;
            fast_image_data_arr[index].frame_height_int  := bmp_ftimg_height_origin-fast_image_data_arr[index].rct_src_mrg.top-fast_image_data_arr[index].rct_src_mrg.bottom;
            if fit_item_img_to_rct then
              begin
                pt                                       :=(item_rct.height-2)/Max1(fast_image_data_arr[index].frame_height_int,bmp_ftimg_width_origin);
                fast_image_data_arr[index].scl_mul       :=PtPosF(pt,pt);
              end
            else
              begin
                if (bmp_ftimg_height_origin/bmp_ftimg_width_origin>=item_rct.height/item_rct.width) then
                  pt:=(item_rct.height-2)  /bmp_ftimg_height_origin
                else
                  pt:=(item_rct.width -2)  /bmp_ftimg_width_origin;
                if (bmp_ftimg_width_origin <=item_rct.width) and
                   (bmp_ftimg_height_origin<=item_rct.height) then
                  fast_image_data_arr[index].scl_mul     :=PtPosF(1.0,1.0)
                else
                  fast_image_data_arr[index].scl_mul     :=PtPosF(pt,pt);
              end;
            SdrProc[sdr_proc_ind](x0+{Trunc}Round((item_rct.width {+1}-bmp_ftimg_width_origin                     *pt)/2),
                                  y0+{Trunc}Round((item_rct.height{+1}-fast_image_data_arr[index].frame_height_int*pt)/2-fast_image_data_arr[index].rct_src_mrg.top*pt),
                                  @fast_image_data,
                                  index,
                                  block_count);
            fast_image_data_arr[index].scl_mul           :=PtPosF(1.0,1.0);
            fast_image_data_arr[index].rct_src_mrg.top   :=0;
            fast_image_data_arr[index].rct_src_mrg.bottom:=0; {$endregion}

            Inc(x0,item_rct.width+mrg_rct.{left}right);
          end;
  end; {$endregion}

begin
  ProcThreadPool.DoParallelLocalProc(@Loop11MT,0,block_count-1);
end; {$endregion}

{Regular FX}
// FloodFill:
procedure PPFloodFillMT     (const bmp_dst_ptr:PInteger; const bmp_dst_width:TColor; const rct_dst_:TPtRect; const col:TColor;                                       const block_count:integer=1); {$region -fold}

  procedure PPFloodFillMTParallel(index:PtrInt; data:pointer; item:TMultiThreadProcItem); {$region -fold}
  begin
    PPFloodFill(bmp_dst_ptr,bmp_dst_width,SetRct(index,rct_dst_,block_count),col);
  end; {$endregion}

begin
  ProcThreadPool.DoParallelLocalProc(@PPFloodFillMTParallel,0,block_count-1);
end; {$endregion}
// AlphaBlend:
{Dummy: using not local proc.} {$region -fold}
{
procedure PPAlphaBlend128ST(index:PtrInt; data:pointer; item:TMultiThreadProcItem); {$region -fold}
var
  func_data_ptr: PFuncData;
begin
  func_data_ptr:=data;
  with func_data_ptr^ do
    PPAlphaBlend128(bmp_dst_ptr,
                    bmp_dst_width,
                    SetRct(index,rct_dst_,block_count),
                    col,
                    pow);
end; {$endregion}
procedure PPAlphaBlend128MT(const bmp_dst_ptr:PInteger; const bmp_dst_width:TColor; const rct_dst_:TPtRect; const col:TColor;                    const pow:byte=64; const block_count:integer=1); {$region -fold}
var
  func_data: TFuncData;
begin
  func_data.bmp_dst_ptr  :=bmp_dst_ptr;
  func_data.bmp_dst_width:=bmp_dst_width;
  func_data.rct_dst_     :=rct_dst_;
  func_data.col          :=col;
  func_data.pow          :=pow;
  func_data.block_count  :=block_count;
  ProcThreadPool.DoParallel(@PPAlphaBlend128AST,0,block_count-1,@func_data);
end; {$endregion}
} {$endregion}
procedure PPAlphaBlend128MT (const bmp_dst_ptr:PInteger; const bmp_dst_width:TColor; const rct_dst_:TPtRect; const col:TColor;                    const pow:byte=64; const block_count:integer=1); {$region -fold}

  procedure PPAlphaBlendMTParallel(index:PtrInt; data:pointer; item:TMultiThreadProcItem); {$region -fold}
  begin
    PPAlphaBlend128(bmp_dst_ptr,bmp_dst_width,SetRct(index,rct_dst_,block_count),col,pow);
  end; {$endregion}

begin
  ProcThreadPool.DoParallelLocalProc(@PPAlphaBlendMTParallel,0,block_count-1);
end; {$endregion}
procedure PPAlphaBlend256MT (const bmp_dst_ptr:PInteger; const bmp_dst_width:TColor; const rct_dst_:TPtRect; const col:TColor;                    const pow:byte=64; const block_count:integer=1); {$region -fold}

  procedure PPAlphaBlendMTParallel(index:PtrInt; data:pointer; item:TMultiThreadProcItem); {$region -fold}
  begin
    PPAlphaBlend256(bmp_dst_ptr,bmp_dst_width,SetRct(index,rct_dst_,block_count),col,pow);
  end; {$endregion}

begin
  ProcThreadPool.DoParallelLocalProc(@PPAlphaBlendMTParallel,0,block_count-1);
end; {$endregion}
// Additive:
procedure PPAdditiveMT      (const bmp_dst_ptr:PInteger; const bmp_dst_width:TColor; const rct_dst_:TPtRect; const col:TColor;                                       const block_count:integer=1); {$region -fold}

  procedure PPAdditiveMTParallel(index:PtrInt; data:pointer; item:TMultiThreadProcItem); {$region -fold}
  begin
    PPAdditive(bmp_dst_ptr,bmp_dst_width,SetRct(index,rct_dst_,block_count),col);
  end; {$endregion}

begin
  ProcThreadPool.DoParallelLocalProc(@PPAdditiveMTParallel,0,block_count-1);
end; {$endregion}
procedure PPAdditiveDecMT   (const bmp_dst_ptr:PInteger; const bmp_dst_width:TColor; const rct_dst_:TPtRect; const col:TColor;                    const pow:byte=64; const block_count:integer=1); {$region -fold}

  procedure PPAdditiveDecMTParallel(index:PtrInt; data:pointer; item:TMultiThreadProcItem); {$region -fold}
  begin
    PPAdditiveDec(bmp_dst_ptr,bmp_dst_width,SetRct(index,rct_dst_,block_count),col,pow);
  end; {$endregion}

begin
  ProcThreadPool.DoParallelLocalProc(@PPAdditiveDecMTParallel,0,block_count-1);
end; {$endregion}
// Inverse:
procedure PPInverseMT       (const bmp_dst_ptr:PInteger; const bmp_dst_width:TColor; const rct_dst_:TPtRect;                                                         const block_count:integer=1); {$region -fold}

  procedure PPInverseMTParallel(index:PtrInt; data:pointer; item:TMultiThreadProcItem); {$region -fold}
  begin
    PPInverse(bmp_dst_ptr,bmp_dst_width,SetRct(index,rct_dst_,block_count));
  end; {$endregion}

begin
  ProcThreadPool.DoParallelLocalProc(@PPInverseMTParallel,0,block_count-1);
end; {$endregion}
procedure PPInverseDecMT    (const bmp_dst_ptr:PInteger; const bmp_dst_width:TColor; const rct_dst_:TPtRect;                                      const pow:byte=64; const block_count:integer=1); {$region -fold}

  procedure PPInverseDecMTParallel(index:PtrInt; data:pointer; item:TMultiThreadProcItem); {$region -fold}
  begin
    PPInverseDec(bmp_dst_ptr,bmp_dst_width,SetRct(index,rct_dst_,block_count),pow);
  end; {$endregion}

begin
  ProcThreadPool.DoParallelLocalProc(@PPInverseDecMTParallel,0,block_count-1);
end; {$endregion}
// Highlight:
procedure PPHighlightMT     (const bmp_dst_ptr:PInteger; const bmp_dst_width:TColor; const rct_dst_:TPtRect;                                      const pow:byte=64; const block_count:integer=1); {$region -fold}

  procedure PPHighlightMTParallel(index:PtrInt; data:pointer; item:TMultiThreadProcItem); {$region -fold}
  begin
    PPHighlight(bmp_dst_ptr,bmp_dst_width,SetRct(index,rct_dst_,block_count),pow);
  end; {$endregion}

begin
  ProcThreadPool.DoParallelLocalProc(@PPHighlightMTParallel,0,block_count-1);
end; {$endregion}
// Darken:
procedure PPDarkenMT        (const bmp_dst_ptr:PInteger; const bmp_dst_width:TColor; const rct_dst_:TPtRect;                                      const pow:byte=64; const block_count:integer=1); {$region -fold}

  procedure PPDarkenMTParallel(index:PtrInt; data:pointer; item:TMultiThreadProcItem); {$region -fold}
  begin
    PPDarken(bmp_dst_ptr,bmp_dst_width,SetRct(index,rct_dst_,block_count),pow);
  end; {$endregion}

begin
  ProcThreadPool.DoParallelLocalProc(@PPDarkenMTParallel,0,block_count-1);
end; {$endregion}
// GrayscaleR:
procedure PPGrayscaleRMT    (const bmp_dst_ptr:PInteger; const bmp_dst_width:TColor; const rct_dst_:TPtRect;                                                         const block_count:integer=1); {$region -fold}

  procedure PPGrayscaleRMTParallel(index:PtrInt; data:pointer; item:TMultiThreadProcItem); {$region -fold}
  begin
    PPGrayscaleR(bmp_dst_ptr,bmp_dst_width,SetRct(index,rct_dst_,block_count));
  end; {$endregion}

begin
  ProcThreadPool.DoParallelLocalProc(@PPGrayscaleRMTParallel,0,block_count-1);
end; {$endregion}
procedure PPGrayscaleRDecMT (const bmp_dst_ptr:PInteger; const bmp_dst_width:TColor; const rct_dst_:TPtRect;                                      const pow:byte=64; const block_count:integer=1); {$region -fold}

  procedure PPGrayscaleRDecMTParallel(index:PtrInt; data:pointer; item:TMultiThreadProcItem); {$region -fold}
  begin
    PPGrayscaleRDec(bmp_dst_ptr,bmp_dst_width,SetRct(index,rct_dst_,block_count),pow);
  end; {$endregion}

begin
  ProcThreadPool.DoParallelLocalProc(@PPGrayscaleRDecMTParallel,0,block_count-1);
end; {$endregion}
// GrayscaleG:
procedure PPGrayscaleGMT    (const bmp_dst_ptr:PInteger; const bmp_dst_width:TColor; const rct_dst_:TPtRect;                                                         const block_count:integer=1); {$region -fold}

  procedure PPGrayscaleGMTParallel(index:PtrInt; data:pointer; item:TMultiThreadProcItem); {$region -fold}
  begin
    PPGrayscaleG(bmp_dst_ptr,bmp_dst_width,SetRct(index,rct_dst_,block_count));
  end; {$endregion}

begin
  ProcThreadPool.DoParallelLocalProc(@PPGrayscaleGMTParallel,0,block_count-1);
end; {$endregion}
procedure PPGrayscaleGDecMT (const bmp_dst_ptr:PInteger; const bmp_dst_width:TColor; const rct_dst_:TPtRect;                                      const pow:byte=64; const block_count:integer=1); {$region -fold}

  procedure PPGrayscaleGDecMTParallel(index:PtrInt; data:pointer; item:TMultiThreadProcItem); {$region -fold}
  begin
    PPGrayscaleGDec(bmp_dst_ptr,bmp_dst_width,SetRct(index,rct_dst_,block_count),pow);
  end; {$endregion}

begin
  ProcThreadPool.DoParallelLocalProc(@PPGrayscaleGDecMTParallel,0,block_count-1);
end; {$endregion}
// GrayscaleB:
procedure PPGrayscaleBMT    (const bmp_dst_ptr:PInteger; const bmp_dst_width:TColor; const rct_dst_:TPtRect;                                                         const block_count:integer=1); {$region -fold}

  procedure PPGrayscaleBMTParallel(index:PtrInt; data:pointer; item:TMultiThreadProcItem); {$region -fold}
  begin
    PPGrayscaleB(bmp_dst_ptr,bmp_dst_width,SetRct(index,rct_dst_,block_count));
  end; {$endregion}

begin
  ProcThreadPool.DoParallelLocalProc(@PPGrayscaleBMTParallel,0,block_count-1);
end; {$endregion}
procedure PPGrayscaleBDecMT (const bmp_dst_ptr:PInteger; const bmp_dst_width:TColor; const rct_dst_:TPtRect;                                      const pow:byte=64; const block_count:integer=1); {$region -fold}

  procedure PPGrayscaleBDecMTParallel(index:PtrInt; data:pointer; item:TMultiThreadProcItem); {$region -fold}
  begin
    PPGrayscaleBDec(bmp_dst_ptr,bmp_dst_width,SetRct(index,rct_dst_,block_count),pow);
  end; {$endregion}

begin
  ProcThreadPool.DoParallelLocalProc(@PPGrayscaleBDecMTParallel,0,block_count-1);
end; {$endregion}
// Mono. noise:
procedure PPMonoNoiseMT     (const bmp_dst_ptr:PInteger; const bmp_dst_width:TColor; const rct_dst_:TPtRect; const col:TColor;                                       const block_count:integer=1); {$region -fold}

  procedure PPMonoNoiseMTParallel(index:PtrInt; data:pointer; item:TMultiThreadProcItem); {$region -fold}
  begin
    PPMonoNoise(bmp_dst_ptr,bmp_dst_width,SetRct(index,rct_dst_,block_count),col);
  end; {$endregion}

begin
  ProcThreadPool.DoParallelLocalProc(@PPMonoNoiseMTParallel,0,block_count-1);
end; {$endregion}
procedure PPMonoNoiseDecMT  (const bmp_dst_ptr:PInteger; const bmp_dst_width:TColor; const rct_dst_:TPtRect; const col:TColor;                    const pow:byte=64; const block_count:integer=1); {$region -fold}

  procedure PPMonoNoiseDecMTParallel(index:PtrInt; data:pointer; item:TMultiThreadProcItem); {$region -fold}
  begin
    PPMonoNoiseDec(bmp_dst_ptr,bmp_dst_width,SetRct(index,rct_dst_,block_count),col,pow);
  end; {$endregion}

begin
  ProcThreadPool.DoParallelLocalProc(@PPMonoNoiseDecMTParallel,0,block_count-1);
end; {$endregion}
// Rand. noise:
procedure PPRandNoiseMT     (const bmp_dst_ptr:PInteger; const bmp_dst_width:TColor; const rct_dst_:TPtRect; const proc_ind:byte; pow1,pow2:byte;                    const block_count:integer=1); {$region -fold}

  procedure PPRandNoiseMTParallel(index:PtrInt; data:pointer; item:TMultiThreadProcItem); {$region -fold}
  begin
    PPRandNoise(bmp_dst_ptr,bmp_dst_width,SetRct(index,rct_dst_,block_count),proc_ind,pow1,pow2);
  end; {$endregion}

begin
  ProcThreadPool.DoParallelLocalProc(@PPRandNoiseMTParallel,0,block_count-1);
end; {$endregion}
procedure PPRandNoiseDecMT  (const bmp_dst_ptr:PInteger; const bmp_dst_width:TColor; const rct_dst_:TPtRect; const proc_ind:byte; pow1,pow2:byte; const pow:byte=64; const block_count:integer=1); {$region -fold}

  procedure PPRandNoiseDecMTParallel(index:PtrInt; data:pointer; item:TMultiThreadProcItem); {$region -fold}
  begin
    PPRandNoiseDec(bmp_dst_ptr,bmp_dst_width,SetRct(index,rct_dst_,block_count),proc_ind,pow1,pow2,pow);
  end; {$endregion}

begin
  ProcThreadPool.DoParallelLocalProc(@PPRandNoiseDecMTParallel,0,block_count-1);
end; {$endregion}
// Blur:
procedure PPBlur4MT         (const bmp_dst_ptr:PInteger; const bmp_dst_width:TColor; const rct_dst_:TPtRect; const PPBlur4Proc:TProc8;                               const block_count:integer=1); {$region -fold}

  procedure PPBlur4MTParallel(index:PtrInt; data:pointer; item:TMultiThreadProcItem); {$region -fold}
  begin
    {
    {Debug}
    PPFloodFill(bmp_dst_ptr,bmp_dst_width,SetRct(index,rct_dst_,block_count),RGB(Random(100),Random(100),Random(100)));
    }
    PPBlur4(bmp_dst_ptr,bmp_dst_width,SetRct(index,rct_dst_,block_count),PPBlur4Proc);
  end; {$endregion}

begin
  ProcThreadPool.DoParallelLocalProc(@PPBlur4MTParallel,0,block_count-1);
end; {$endregion}
procedure PPBlur4DecMT      (const bmp_dst_ptr:PInteger; const bmp_dst_width:TColor; const rct_dst_:TPtRect; const PPBlur4Proc:TProc19;           const pow:byte=64; const block_count:integer=1); {$region -fold}

  procedure PPBlur4DecMTParallel(index:PtrInt; data:pointer; item:TMultiThreadProcItem); {$region -fold}
  begin
    {
    {Debug}
    PPFloodFill(bmp_dst_ptr,bmp_dst_width,SetRct(index,rct_dst_,block_count),RGB(62*index,62*index,62*index));
    }
    PPBlur4Dec(bmp_dst_ptr,bmp_dst_width,SetRct(index,rct_dst_,block_count),PPBlur4Proc,pow);
  end; {$endregion}

begin
  ProcThreadPool.DoParallelLocalProc(@PPBlur4DecMTParallel,0,block_count-1);
end; {$endregion}
// Contrast:
procedure PPContrastMT      (const bmp_dst_ptr:PInteger; const bmp_dst_width:TColor; const rct_dst_:TPtRect;                                      const pow:byte=64; const block_count:integer=1); {$region -fold}

  procedure PPContrastMTParallel(index:PtrInt; data:pointer; item:TMultiThreadProcItem); {$region -fold}
  begin
    PPContrast1(bmp_dst_ptr,bmp_dst_width,SetRct(index,rct_dst_,block_count),pow);
  end; {$endregion}

begin
  ProcThreadPool.DoParallelLocalProc(@PPContrastMTParallel,0,block_count-1);
end; {$endregion}
// Gamma:
procedure PPGammaMT         (const bmp_dst_ptr:PInteger; const bmp_dst_width:TColor; const rct_dst_:TPtRect; const pow0:single;                                      const block_count:integer=1); {$region -fold}

    procedure PPGammaMTParallel(index:PtrInt; data:pointer; item:TMultiThreadProcItem); {$region -fold}
    begin
      PPGamma(bmp_dst_ptr,bmp_dst_width,SetRct(index,rct_dst_,block_count),pow0);
    end; {$endregion}

begin
  ProcThreadPool.DoParallelLocalProc(@PPGammaMTParallel,0,block_count-1);
end; {$endregion}
procedure PPGammaDecMT      (const bmp_dst_ptr:PInteger; const bmp_dst_width:TColor; const rct_dst_:TPtRect; const pow0:single;                   const pow:byte=64; const block_count:integer=1); {$region -fold}

  procedure PPGammaDecMTParallel(index:PtrInt; data:pointer; item:TMultiThreadProcItem); {$region -fold}
  begin
    PPGammaDec(bmp_dst_ptr,bmp_dst_width,SetRct(index,rct_dst_,block_count),pow0,pow);
  end; {$endregion}

begin
  ProcThreadPool.DoParallelLocalProc(@PPGammaDecMTParallel,0,block_count-1);
end; {$endregion}

{Gradient FX}
// Auxilary proc.(gradient precalc.):
procedure GrVPrecalc        (index:PtrInt; var block_rct1:TPtRect;                   const rct_dst_:TPtRect; const col0,col1:TColor;                                 const block_count:integer  ); {$region -fold}
var
  block_rct0              : TPtRect;
  set_grad_to_vis_area_tmp: boolean;
begin
  with fast_image_proc_var,fast_image_data_arr[index] do
    begin
      rct_ent                 :=rct_dst_;
      block_rct0              :=SetRct  (index,rct_dst_,block_count);
      rct_src                 :=PtBounds(block_rct0.left-rct_ent.left,
                                         block_rct0.top -rct_ent.top,
                                         block_rct0.width,
                                         block_rct0.height);

      {Store set_grad_to_vis_area in temp. var!}
      set_grad_to_vis_area_tmp:=set_grad_to_vis_area;

      set_grad_to_vis_area    :=False;
      SetGradVec                        (0,
                                         rct_ent.height,
                                         @fast_image_data_arr[index],
                                          fast_image_data_arr[index]);
      SetGradCol                        (col0,
                                         col1,
                                          fast_image_data_arr[index]);

      {Restore set_grad_to_vis_area!}
      set_grad_to_vis_area    :=set_grad_to_vis_area_tmp;

      GrVNTResVar1                      (@fast_image_data_arr[index],
                                          fast_image_data_arr[index]);
      block_rct1              :=PtBounds(rct_dst_.left,
                                         res_var4,
                                         rct_dst_.width,
                                         res_var2+1);
    end;
end; {$endregion}
// FloodFill:
procedure PPGrVFloodFillMT  (const bmp_dst_ptr:PInteger; const bmp_dst_width:TColor; const rct_dst_:TPtRect; const col0,col1:TColor;                                 const block_count:integer=1); {$region -fold}

  procedure PPGrVFloodFillMTParallel(index:PtrInt; data:pointer; item:TMultiThreadProcItem); {$region -fold}
  var
    block_rct1: TPtRect;
  begin
    GrVPrecalc     (index,block_rct1,rct_dst_,col0,col1,block_count);
    PPGrVMonochrome(bmp_dst_ptr,bmp_dst_width,block_rct1,fast_image_proc_var.fast_image_data_arr[index].grad_prop,bmp_dst_width);
  end; {$endregion}

begin
  ProcThreadPool.DoParallelLocalProc(@PPGrVFloodFillMTParallel,0,block_count-1);
end; {$endregion}
// AlphaBlend:
procedure PPGrVAlphaBlendMT (const bmp_dst_ptr:PInteger; const bmp_dst_width:TColor; const rct_dst_:TPtRect; const col0,col1:TColor;                                 const block_count:integer=1); {$region -fold}

  procedure PPGrVAlphaBlendMTParallel(index:PtrInt; data:pointer; item:TMultiThreadProcItem); {$region -fold}
  var
    block_rct1: TPtRect;
  begin
    GrVPrecalc     (index,block_rct1,rct_dst_,col0,col1,block_count);
    PPGrVAlphablend(bmp_dst_ptr,bmp_dst_width,block_rct1,fast_image_proc_var.fast_image_data_arr[index].grad_prop,bmp_dst_width);
  end; {$endregion}

begin
  ProcThreadPool.DoParallelLocalProc(@PPGrVAlphaBlendMTParallel,0,block_count-1);
end; {$endregion}
// Additive:
procedure PPGrVAdditiveMT   (const bmp_dst_ptr:PInteger; const bmp_dst_width:TColor; const rct_dst_:TPtRect; const col0,col1:TColor;                                 const block_count:integer=1); {$region -fold}

  procedure PPGrVAdditiveMTParallel(index:PtrInt; data:pointer; item:TMultiThreadProcItem); {$region -fold}
  var
    block_rct1: TPtRect;
  begin
    GrVPrecalc   (index,block_rct1,rct_dst_,col0,col1,block_count);
    PPGrVAdditive(bmp_dst_ptr,bmp_dst_width,block_rct1,fast_image_proc_var.fast_image_data_arr[index].grad_prop,bmp_dst_width);
  end; {$endregion}

begin
  ProcThreadPool.DoParallelLocalProc(@PPGrVAdditiveMTParallel,0,block_count-1);
end; {$endregion}
// Inverse:
procedure PPGrVInverseMT    (const bmp_dst_ptr:PInteger; const bmp_dst_width:TColor; const rct_dst_:TPtRect; const col0,col1:TColor;                                 const block_count:integer=1); {$region -fold}

  procedure PPGrVInverseMTParallel(index:PtrInt; data:pointer; item:TMultiThreadProcItem); {$region -fold}
  var
    block_rct1: TPtRect;
  begin
    GrVPrecalc  (index,block_rct1,rct_dst_,col0,col1,block_count);
    PPGrVInverse(bmp_dst_ptr,bmp_dst_width,block_rct1,fast_image_proc_var.fast_image_data_arr[index].grad_prop,bmp_dst_width);
  end; {$endregion}

begin
  ProcThreadPool.DoParallelLocalProc(@PPGrVInverseMTParallel,0,block_count-1);
end; {$endregion}
// Highlight:
procedure PPGrVHighlightMT  (const bmp_dst_ptr:PInteger; const bmp_dst_width:TColor; const rct_dst_:TPtRect; const col0,col1:TColor;                                 const block_count:integer=1); {$region -fold}

  procedure PPGrVHighlightMTParallel(index:PtrInt; data:pointer; item:TMultiThreadProcItem); {$region -fold}
  var
    block_rct1: TPtRect;
  begin
    GrVPrecalc(index,block_rct1,rct_dst_,col0,col1,block_count);
    PPGrV16   (bmp_dst_ptr,bmp_dst_width,block_rct1,fast_image_proc_var.fast_image_data_arr[index].grad_prop,@HighlightDec1,bmp_dst_width);
  end; {$endregion}

begin
  ProcThreadPool.DoParallelLocalProc(@PPGrVHighlightMTParallel,0,block_count-1);
end; {$endregion}
// Darken:
procedure PPGrVDarkenMT     (const bmp_dst_ptr:PInteger; const bmp_dst_width:TColor; const rct_dst_:TPtRect; const col0,col1:TColor;                                 const block_count:integer=1); {$region -fold}

  procedure PPGrVDarkenMTParallel(index:PtrInt; data:pointer; item:TMultiThreadProcItem); {$region -fold}
  var
    block_rct1: TPtRect;
  begin
    GrVPrecalc(index,block_rct1,rct_dst_,col0,col1,block_count);
    PPGrV16   (bmp_dst_ptr,bmp_dst_width,block_rct1,fast_image_proc_var.fast_image_data_arr[index].grad_prop,@DarkenDec1,bmp_dst_width);
  end; {$endregion}

begin
  ProcThreadPool.DoParallelLocalProc(@PPGrVDarkenMTParallel,0,block_count-1);
end; {$endregion}
// GrayscaleR:
procedure PPGrVGrayscaleRMT (const bmp_dst_ptr:PInteger; const bmp_dst_width:TColor; const rct_dst_:TPtRect; const col0,col1:TColor;                                 const block_count:integer=1); {$region -fold}

  procedure PPGrVGrayscaleRMTParallel(index:PtrInt; data:pointer; item:TMultiThreadProcItem); {$region -fold}
  var
    block_rct1: TPtRect;
  begin
    GrVPrecalc(index,block_rct1,rct_dst_,col0,col1,block_count);
    PPGrV17   (bmp_dst_ptr,bmp_dst_width,block_rct1,fast_image_proc_var.fast_image_data_arr[index].grad_prop,@GrayscaleRDec1,bmp_dst_width);
  end; {$endregion}

begin
  ProcThreadPool.DoParallelLocalProc(@PPGrVGrayscaleRMTParallel,0,block_count-1);
end; {$endregion}
// GrayscaleG:
procedure PPGrVGrayscaleGMT (const bmp_dst_ptr:PInteger; const bmp_dst_width:TColor; const rct_dst_:TPtRect; const col0,col1:TColor;                                 const block_count:integer=1); {$region -fold}

  procedure PPGrVGrayscaleGMTParallel(index:PtrInt; data:pointer; item:TMultiThreadProcItem); {$region -fold}
  var
    block_rct1: TPtRect;
  begin
    GrVPrecalc(index,block_rct1,rct_dst_,col0,col1,block_count);
    PPGrV17   (bmp_dst_ptr,bmp_dst_width,block_rct1,fast_image_proc_var.fast_image_data_arr[index].grad_prop,@GrayscaleGDec1,bmp_dst_width);
  end; {$endregion}

begin
  ProcThreadPool.DoParallelLocalProc(@PPGrVGrayscaleGMTParallel,0,block_count-1);
end; {$endregion}
// GrayscaleB:
procedure PPGrVGrayscaleBMT (const bmp_dst_ptr:PInteger; const bmp_dst_width:TColor; const rct_dst_:TPtRect; const col0,col1:TColor;                                 const block_count:integer=1); {$region -fold}

  procedure PPGrVGrayscaleBMTParallel(index:PtrInt; data:pointer; item:TMultiThreadProcItem); {$region -fold}
  var
    block_rct1: TPtRect;
  begin
    GrVPrecalc(index,block_rct1,rct_dst_,col0,col1,block_count);
    PPGrV17   (bmp_dst_ptr,bmp_dst_width,block_rct1,fast_image_proc_var.fast_image_data_arr[index].grad_prop,@GrayscaleBDec1,bmp_dst_width);
  end; {$endregion}

begin
  ProcThreadPool.DoParallelLocalProc(@PPGrVGrayscaleBMTParallel,0,block_count-1);
end; {$endregion}
// Mono. noise:
procedure PPGrVMonoNoiseMT  (const bmp_dst_ptr:PInteger; const bmp_dst_width:TColor; const rct_dst_:TPtRect; const col0,col1:TColor;                                 const block_count:integer=1); {$region -fold}

  procedure PPGrVMonoNoiseMTParallel(index:PtrInt; data:pointer; item:TMultiThreadProcItem); {$region -fold}
  var
    block_rct1: TPtRect;
  begin
    GrVPrecalc    (index,block_rct1,rct_dst_,col0,col1,block_count);
    PPGrVMonoNoise(bmp_dst_ptr,bmp_dst_width,block_rct1,fast_image_proc_var.fast_image_data_arr[index].grad_prop,bmp_dst_width);
  end; {$endregion}

begin
  ProcThreadPool.DoParallelLocalProc(@PPGrVMonoNoiseMTParallel,0,block_count-1);
end; {$endregion}
// Rand. noise:
procedure PPGrVRandNoiseMT  (const bmp_dst_ptr:PInteger; const bmp_dst_width:TColor; const rct_dst_:TPtRect; const col0,col1:TColor; const fx_style1:byte;           const block_count:integer=1); {$region -fold}

  procedure PPGrVRandNoiseMTParallel(index:PtrInt; data:pointer; item:TMultiThreadProcItem); {$region -fold}
  var
    block_rct1: TPtRect;
  begin
    GrVPrecalc    (index,block_rct1,rct_dst_,col0,col1,block_count);
    with fast_image_proc_var.fast_image_data_arr[index].grad_prop do
      begin
        TRGBA(grad_col0).r:=TRGBA(SetColorInv(col0)).b;
        TRGBA(grad_col1).r:=TRGBA(SetColorInv(col1)).b;
      end;
    PPGrVRandNoise(bmp_dst_ptr,bmp_dst_width,block_rct1,fast_image_proc_var.fast_image_data_arr[index].grad_prop,fx_style1,bmp_dst_width);
  end; {$endregion}

begin
  ProcThreadPool.DoParallelLocalProc(@PPGrVRandNoiseMTParallel,0,block_count-1);
end; {$endregion}
// Blur:
procedure PPGrVBlur4MT      (const bmp_dst_ptr:PInteger; const bmp_dst_width:TColor; const rct_dst_:TPtRect; const col0,col1:TColor; const fx_style1:byte;           const block_count:integer=1); {$region -fold}

  procedure PPGrVBlur4MTParallel(index:PtrInt; data:pointer; item:TMultiThreadProcItem); {$region -fold}
  var
    block_rct1: TPtRect;
  begin
    GrVPrecalc(index,block_rct1,rct_dst_,col0,col1,block_count);
    PPGrVBlur4(bmp_dst_ptr,bmp_dst_width,block_rct1,fast_image_proc_var.fast_image_data_arr[index].grad_prop,fx_style1,bmp_dst_width);
  end; {$endregion}

begin
  ProcThreadPool.DoParallelLocalProc(@PPGrVBlur4MTParallel,0,block_count-1);
end; {$endregion}
// Contrast:
procedure PPGrVContrastMT   (const bmp_dst_ptr:PInteger; const bmp_dst_width:TColor; const rct_dst_:TPtRect; const col0,col1:TColor;                                 const block_count:integer=1); {$region -fold}

  procedure PPGrVContrastMTParallel(index:PtrInt; data:pointer; item:TMultiThreadProcItem); {$region -fold}
  var
    block_rct1: TPtRect;
  begin
    GrVPrecalc   (index,block_rct1,rct_dst_,col0,col1,block_count);
    PPGrVContrast(bmp_dst_ptr,bmp_dst_width,block_rct1,fast_image_proc_var.fast_image_data_arr[index].grad_prop,bmp_dst_width);
  end; {$endregion}

begin
  ProcThreadPool.DoParallelLocalProc(@PPGrVContrastMTParallel,0,block_count-1);
end; {$endregion}
// Gamma:
procedure PPGrVGammaMT      (const bmp_dst_ptr:PInteger; const bmp_dst_width:TColor; const rct_dst_:TPtRect; const col0,col1:TColor;                                 const block_count:integer=1); {$region -fold}

  procedure PPGrVGammaMTParallel(index:PtrInt; data:pointer; item:TMultiThreadProcItem); {$region -fold}
  var
    block_rct1: TPtRect;
  begin
    GrVPrecalc(index,block_rct1,rct_dst_,col0,col1,block_count);
    PPGrVGamma(bmp_dst_ptr,bmp_dst_width,block_rct1,fast_image_proc_var.fast_image_data_arr[index].grad_prop,bmp_dst_width);
  end; {$endregion}

begin
  ProcThreadPool.DoParallelLocalProc(@PPGrVGammaMTParallel,0,block_count-1);
end; {$endregion}

end.
