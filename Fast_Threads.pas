unit Fast_Threads;

{$mode objfpc}{$H+}

interface

uses ////

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
        PPRandNoiseProc: TProc23;
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
      procedure   ThreadWork;
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
// MT FloodFill:
procedure PPFloodFillMT    (const bmp_dst_ptr   :PInteger;
                            const bmp_dst_width :TColor;
                            const rct_dst       :TPtRect;
                            const col           :TColor;
                            const block_count   :integer=1);
// MT AlphaBlend:
procedure PPAlphaBlendMT   (const bmp_dst_ptr   :PInteger;
                            const bmp_dst_width :TColor;
                            const rct_dst       :TPtRect;
                            const col           :TColor;
                            const pow           :byte=64;
                            const block_count   :integer=1);
// MT Additive:
procedure PPAdditiveMT     (const bmp_dst_ptr   :PInteger;
                            const bmp_dst_width :TColor;
                            const rct_dst       :TPtRect;
                            const col           :TColor;
                            const pow           :byte=64;
                            const block_count   :integer=1);
// MT Inverse:
procedure PPInverseMT      (const bmp_dst_ptr   :PInteger;
                            const bmp_dst_width :TColor;
                            const rct_dst       :TPtRect;
                            const pow           :byte=64;
                            const block_count   :integer=1);
// MT Highlight:
procedure PPHighlightMT    (const bmp_dst_ptr   :PInteger;
                            const bmp_dst_width :TColor;
                            const rct_dst       :TPtRect;
                            const pow           :byte=64;
                            const block_count   :integer=1);
// MT Darken:
procedure PPDarkenMT       (const bmp_dst_ptr   :PInteger;
                            const bmp_dst_width :TColor;
                            const rct_dst       :TPtRect;
                            const pow           :byte=64;
                            const block_count   :integer=1);
// MT GrayscaleR:
procedure PPGrayscaleRMT   (const bmp_dst_ptr   :PInteger;
                            const bmp_dst_width :TColor;
                            const rct_dst       :TPtRect;
                            const pow           :byte=64;
                            const block_count   :integer=1);
// MT GrayscaleG:
procedure PPGrayscaleGMT   (const bmp_dst_ptr   :PInteger;
                            const bmp_dst_width :TColor;
                            const rct_dst       :TPtRect;
                            const pow           :byte=64;
                            const block_count   :integer=1);
// MT GrayscaleB:
procedure PPGrayscaleBMT   (const bmp_dst_ptr   :PInteger;
                            const bmp_dst_width :TColor;
                            const rct_dst       :TPtRect;
                            const pow           :byte=64;
                            const block_count   :integer=1);
// MT MonoNoise:
procedure PPMonoNoiseMT    (const bmp_dst_ptr   :PInteger;
                            const bmp_dst_width :TColor;
                            const rct_dst       :TPtRect;
                            const col           :TColor;
                            const pow           :byte=64;
                            const block_count   :integer=1);
{// MT RandNoise:
procedure PPRandNoiseMT    (const bmp_dst_ptr   :PInteger;
                            const bmp_dst_width :TColor;
                            const rct_dst       :TPtRect;
                            const col           :TColor;
                            const pow           :byte=64;
                            const block_count   :integer=1);
// MT Blur:
procedure PPBlurMT         (const bmp_dst_ptr   :PInteger;
                            const bmp_dst_width :TColor;
                            const rct_dst       :TPtRect;
                            const col           :TColor;
                            const pow           :byte=64;
                            const block_count   :integer=1);}



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
procedure   TThreadObj.ThreadWork; {$region -fold}
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
     10: PPBlur         (bmp_dst_ptr,bmp_dst_width,rct_dst,PPBlurProc                                                            );
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
procedure   TThreadObj.Execute;    {$region -fold}
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

// MT FloodFill:
procedure PPFloodFillMT (const bmp_dst_ptr:PInteger; const bmp_dst_width:TColor; const rct_dst:TPtRect; const col:TColor;                    const block_count:integer=1); {$region -fold}

  procedure PPFloodFillMTParallel(index:PtrInt; data:pointer; item:TMultiThreadProcItem); {$region -fold}
  begin
    PPFloodFill(bmp_dst_ptr,bmp_dst_width,SetRct(index,rct_dst,block_count),col);
  end; {$endregion}

begin
  ProcThreadPool.DoParallelLocalProc(@PPFloodFillMTParallel,0,block_count-1);
end; {$endregion}
// MT AlphaBlend:
procedure PPAlphaBlendMT(const bmp_dst_ptr:PInteger; const bmp_dst_width:TColor; const rct_dst:TPtRect; const col:TColor; const pow:byte=64; const block_count:integer=1); {$region -fold}

  procedure PPAlphaBlendMTParallel(index:PtrInt; data:pointer; item:TMultiThreadProcItem); {$region -fold}
  begin
    PPAlphaBlend(bmp_dst_ptr,bmp_dst_width,SetRct(index,rct_dst,block_count),col,pow);
  end; {$endregion}

begin
  ProcThreadPool.DoParallelLocalProc(@PPAlphaBlendMTParallel,0,block_count-1);
end; {$endregion}
// MT Additive:
procedure PPAdditiveMT  (const bmp_dst_ptr:PInteger; const bmp_dst_width:TColor; const rct_dst:TPtRect; const col:TColor; const pow:byte=64; const block_count:integer=1); {$region -fold}

  procedure PPAdditiveMTParallel(index:PtrInt; data:pointer; item:TMultiThreadProcItem); {$region -fold}
  begin
    PPAdditiveDec(bmp_dst_ptr,bmp_dst_width,SetRct(index,rct_dst,block_count),col,pow);
  end; {$endregion}

begin
  ProcThreadPool.DoParallelLocalProc(@PPAdditiveMTParallel,0,block_count-1);
end; {$endregion}
// MT Inverse:
procedure PPInverseMT   (const bmp_dst_ptr:PInteger; const bmp_dst_width:TColor; const rct_dst:TPtRect;                   const pow:byte=64; const block_count:integer=1); {$region -fold}

  procedure PPInverseMTParallel(index:PtrInt; data:pointer; item:TMultiThreadProcItem); {$region -fold}
  begin
    PPInverseDec(bmp_dst_ptr,bmp_dst_width,SetRct(index,rct_dst,block_count),pow);
  end; {$endregion}

begin
  ProcThreadPool.DoParallelLocalProc(@PPInverseMTParallel,0,block_count-1);
end; {$endregion}
// MT Highlight:
procedure PPHighlightMT (const bmp_dst_ptr:PInteger; const bmp_dst_width:TColor; const rct_dst:TPtRect;                   const pow:byte=64; const block_count:integer=1); {$region -fold}

  procedure PPHighlightMTParallel(index:PtrInt; data:pointer; item:TMultiThreadProcItem); {$region -fold}
  begin
    PPHighlight(bmp_dst_ptr,bmp_dst_width,SetRct(index,rct_dst,block_count),pow);
  end; {$endregion}

begin
  ProcThreadPool.DoParallelLocalProc(@PPHighlightMTParallel,0,block_count-1);
end; {$endregion}
// MT Darken:
procedure PPDarkenMT    (const bmp_dst_ptr:PInteger; const bmp_dst_width:TColor; const rct_dst:TPtRect;                   const pow:byte=64; const block_count:integer=1); {$region -fold}

  procedure PPDarkenMTParallel(index:PtrInt; data:pointer; item:TMultiThreadProcItem); {$region -fold}
  begin
    PPDarken(bmp_dst_ptr,bmp_dst_width,SetRct(index,rct_dst,block_count),pow);
  end; {$endregion}

begin
  ProcThreadPool.DoParallelLocalProc(@PPDarkenMTParallel,0,block_count-1);
end; {$endregion}
// MT GrayscaleR:
procedure PPGrayscaleRMT(const bmp_dst_ptr:PInteger; const bmp_dst_width:TColor; const rct_dst:TPtRect;                   const pow:byte=64; const block_count:integer=1); {$region -fold}

  procedure PPGrayscaleRMTParallel(index:PtrInt; data:pointer; item:TMultiThreadProcItem); {$region -fold}
  begin
    PPGrayscaleRDec(bmp_dst_ptr,bmp_dst_width,SetRct(index,rct_dst,block_count),pow);
  end; {$endregion}

begin
  ProcThreadPool.DoParallelLocalProc(@PPGrayscaleRMTParallel,0,block_count-1);
end; {$endregion}
// MT GrayscaleG:
procedure PPGrayscaleGMT(const bmp_dst_ptr:PInteger; const bmp_dst_width:TColor; const rct_dst:TPtRect;                   const pow:byte=64; const block_count:integer=1); {$region -fold}

  procedure PPGrayscaleGMTParallel(index:PtrInt; data:pointer; item:TMultiThreadProcItem); {$region -fold}
  begin
    PPGrayscaleGDec(bmp_dst_ptr,bmp_dst_width,SetRct(index,rct_dst,block_count),pow);
  end; {$endregion}

begin
  ProcThreadPool.DoParallelLocalProc(@PPGrayscaleGMTParallel,0,block_count-1);
end; {$endregion}
// MT GrayscaleB:
procedure PPGrayscaleBMT(const bmp_dst_ptr:PInteger; const bmp_dst_width:TColor; const rct_dst:TPtRect;                   const pow:byte=64; const block_count:integer=1); {$region -fold}

  procedure PPGrayscaleBMTParallel(index:PtrInt; data:pointer; item:TMultiThreadProcItem); {$region -fold}
  begin
    PPGrayscaleBDec(bmp_dst_ptr,bmp_dst_width,SetRct(index,rct_dst,block_count),pow);
  end; {$endregion}

begin
  ProcThreadPool.DoParallelLocalProc(@PPGrayscaleBMTParallel,0,block_count-1);
end; {$endregion}
// MT MonoNoise:
procedure PPMonoNoiseMT (const bmp_dst_ptr:PInteger; const bmp_dst_width:TColor; const rct_dst:TPtRect; const col:TColor; const pow:byte=64; const block_count:integer=1); {$region -fold}

  procedure PPMonoNoiseMTParallel(index:PtrInt; data:pointer; item:TMultiThreadProcItem); {$region -fold}
  begin
    PPMonoNoiseDec(bmp_dst_ptr,bmp_dst_width,SetRct(index,rct_dst,block_count),col,pow);
  end; {$endregion}

begin
  ProcThreadPool.DoParallelLocalProc(@PPMonoNoiseMTParallel,0,block_count-1);
end; {$endregion}

end.
