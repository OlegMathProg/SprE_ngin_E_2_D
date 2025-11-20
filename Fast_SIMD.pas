unit Fast_SIMD;

{This file contains some SIMD powered routines}

{$mode objfpc}
{$asmmode intel}
{$H+,INLINE+}

interface

type

  TColor  = longword;
  PInteger=PLongWord;

  T4ArrPL =array[0..3] of PInteger;
  P4ArrPL =^T4ArrPL;

  T4ArrD  =array[0..3] of double;
  P4ArrD  =^T4ArrD;

  T4ArrI  =array[0..3] of integer;
  P4ArrI  =^T4ArrI;

  T4ArrL  =array[0..3] of longword;
  P4ArrL  =^T4ArrL;

  T4ArrW  =array[0..3] of word;
  P4ArrW  =^T4ArrW;

  T8ArrD  =array[0..7] of double;
  P8ArrD  =^T8ArrD;

  T8ArrS  =array[0..7] of single;
  P8ArrS  =^T8ArrS;

  T8ArrI  =array[0..7] of integer;
  P8ArrI  =^T8ArrI;

  T8ArrL  =array[0..7] of longword;
  P8ArrL  =^T8ArrL;

  T8ArrW  =array[0..7] of word;
  P8ArrW  =^T8ArrW;

  T8ArrB  =array[0..7] of boolean;
  P8ArrB  =^T8ArrW;

  T16ArrL =array[0..3] of T4ArrL;
  P16ArrL =^T16ArrL;

  T2_4ArrL=array[0..1] of T4ArrL;
  P2_4ArrL=^T2_4ArrL;

  TRGBA04 =record {$region -fold}
    r00,r01,r02,r03: dword;
  end; {$endregion}
  PRGBA04 =^TRGBA04;

  TRGBA08 =record {$region -fold}
    r00,r01,r02,r03,
    r04,r05,r06,r07: dword;
  end; {$endregion}
  PRGBA08 =^TRGBA08;

  TRGBA16 =record {$region -fold}
    r00,r01,r02,r03,
    r04,r05,r06,r07,
    r08,r09,r10,r11,
    r12,r13,r14,r15: dword;
  end; {$endregion}
  PRGBA16 =^TRGBA16;



const

  ONE_S_1 : single  =1.0;
  ONE_I_8 : T8ArrI  =(1,1,1,1,1,1,1,1);

  NT_BIT_MASK_ALPHA2=$00FFFFFF;

  MSK0_128: TRGBA04 =
    (r00:%00000010000000100000001000000010;
     r01:%00000010000000100000001000000010;
     r02:%00000010000000100000001000000010;
     r03:%00000010000000100000001000000010);
  MSK1_128: TRGBA04 =
    (r00:%00000001000000010000000100000001;
     r01:%00000001000000010000000100000001;
     r02:%00000001000000010000000100000001;
     r03:%00000001000000010000000100000001);
  MSK2_128: TRGBA04 =
    (r00:$0C080400;
     r01:$07060501;
     r02:$0B0A0902;
     r03:$0F0E0D03);
  MSK3_128: TRGBA04 =
    (r00:%00000000111111111111111111111111;
     r01:%00000000111111111111111111111111;
     r02:%00000000111111111111111111111111;
     r03:%00000000111111111111111111111111);
  MSK4_128: TRGBA04 =
    (r00:%00000000000000000000000000000001;
     r01:%00000000000000000000000100000000;
     r02:%00000000000000010000000000000000;
     r03:%00000000000000000000000000000000);
  MSK5_128: TRGBA04 =
    (r00:$0E0C0A08;
     r01:$07060504;
     r02:$0B010900;
     r03:$0F030D02);
  MSK6_128: TRGBA04 =
    (r00:$0E0C0A08;
     r01:$07060504;
     r02:$0B010900;
     r03:$0F030D02);
  MSK7_128: TRGBA04 =
    (r00:$00FF00FF;
     r01:$00FF00FF;
     r02:$00FF00FF;
     r03:$00FF00FF);
  MSK8_128: TRGBA04 =
    (r00:%00000000000000010000000000000001;
     r01:%00000000000000000000000000000001;
     r02:%00000000000000010000000000000001;
     r03:%00000000000000000000000000000001);
  MSK9_128: T4ArrL  =
    (NT_BIT_MASK_ALPHA2,
     NT_BIT_MASK_ALPHA2,
     NT_BIT_MASK_ALPHA2,
     NT_BIT_MASK_ALPHA2);
  MSK0_256: TRGBA08 =
    (r00:%00000010000000100000001000000010;
     r01:%00000010000000100000001000000010;
     r02:%00000010000000100000001000000010;
     r03:%00000010000000100000001000000010;
     r04:%00000010000000100000001000000010;
     r05:%00000010000000100000001000000010;
     r06:%00000010000000100000001000000010;
     r07:%00000010000000100000001000000010);
  MSK1_256: TRGBA08 =
    (r00:%00000001000000010000000100000001;
     r01:%00000001000000010000000100000001;
     r02:%00000001000000010000000100000001;
     r03:%00000001000000010000000100000001;
     r04:%00000001000000010000000100000001;
     r05:%00000001000000010000000100000001;
     r06:%00000001000000010000000100000001;
     r07:%00000001000000010000000100000001);
  MSK2_256: T8ArrL  =
    (NT_BIT_MASK_ALPHA2,
     NT_BIT_MASK_ALPHA2,
     NT_BIT_MASK_ALPHA2,
     NT_BIT_MASK_ALPHA2,
     NT_BIT_MASK_ALPHA2,
     NT_BIT_MASK_ALPHA2,
     NT_BIT_MASK_ALPHA2,
     NT_BIT_MASK_ALPHA2);
  MSK3_256: T4ArrD  =(0.0,1.0,2.0,3.0);



var

  has_avx2: boolean=False;



{Check if AVX instructions are supported}
function  HasAVX                                                                 : boolean;
function  HasAVX2                                                                : boolean;
function  HasAVX512                                                              : boolean;

{Convert 4 double to 4 integer: AVX2}
procedure DoubleToInt256  (const    src            :T4ArrD;
                           var      dst            :T4ArrI                      );          assembler;

{Convert 8 single to 8 integer: AVX2}
procedure SingleToInt256  (const    src            :T8ArrS;
                           var      dst            :T8ArrI                      );          assembler;

{Special flood fill, similar to Fast_Graphics.PPFloodFillAdd: AVX2}
procedure FloodFillAdd256 (const    src,       msk1:TRGBA08                     );          assembler;

{Clear alpha-channel(4th byte in unsigned integer(dword))}
// SSE2:
procedure ClrAlphaByte128 (var      arr,       msk1:T4ArrL                      );          assembler;
// AVX2:
procedure ClrAlphaByte256 (var      arr,       msk1:T8ArrL                      );          assembler;

{Non-zero items count}
// replaces Fast_Graphics.ArrNzItCnt:
// SSE2:
function  NZByteCnt128    (const    src,{msk0,}msk1:TRGBA04                     ): byte;    assembler;
// AVX2:
function  NZByteCnt256    (const    src            :TRGBA08                     ): word;    assembler;
// AVX512:
function  NZByteCnt512    (const    src            :TRGBA16                     ): word;    assembler; experimental;

{Prepare pixel scale info: AVX2}
// used in Fast_Graphics:
procedure ScalePixInfo256A(var      arr0           :T4ArrW;
                           var      arr1,arr2      :T4ArrL;
                           var      arr3           :T4ArrD;
                           constref c0,c1,c2       :double;
                           constref c3             :double=1.0                  );          assembler;
procedure ScalePixInfo256B(var      arr0           :T8ArrW;
                           var      arr1,arr2      :T8ArrL;
                           var      arr3           :T8ArrS;
                           constref c0,c1,c2       :single;
                           constref c3             :single=1.0                  );          assembler; deprecated;
procedure ScalePixInfo256C(var      arr1,arr2      :T4ArrL;
                           var      arr3           :T4ArrD;
                           constref msk            :T4ArrD;
                           const    pix            :word;
                           constref c0,c1,c2       :double;
                           constref c3             :double=1.0                  );          assembler;
procedure ScalePixInfo256D(var      arr0           :T2_4ArrL;
                           const    arr1           :T4ArrD;
                           constref c0,c1          :double                      );          assembler;
procedure ScalePixInfo256E(var      arr0           :T2_4ArrL;
                           const    arr1           :T4ArrD;
                           constref c0             :double                      );          assembler;

{ScalePix used in image scaling}
// replaces Fast_Graphics.ScalePix:
// SSE2:
procedure ScalePix128A    (const    msk0           :TRGBA04;
                           var      dst,src        :dword;
                           const    s0,s1          :dword;
                           const    b              :boolean                     );          assembler;
procedure ScalePix128B    (const    msk0           :TRGBA04;
                           var      dst,src        :dword;
                           const    s0,s1          :dword;
                           const    arr_width      :dword                       );          assembler;
// replaces Fast_Graphics.AlphaBlend4:
// SSE2:
procedure ScalePix128C    (const    msk0,msk1      :TRGBA04;
                           var      dst,src        :dword;
                           const    s0,s1,s2       :dword;
                           const    b              :boolean                     );          assembler;
procedure ScalePix128D    (const    msk0,msk1      :TRGBA04;
                           var      dst,src        :dword;
                           const    s0,s1,s2       :dword;
                           const    arr_width      :dword                       );          assembler;
procedure ScalePix128E    (const    msk0           :TRGBA04;
                           var      dst            :qword;
                           const    src            :dword;
                           const    s0,s1          :dword;
                           const    b              :boolean                     );          assembler; deprecated;
procedure ScalePix128F    (const    msk0           :TRGBA04;
                           var      dst            :qword;
                           const    src            :dword;
                           const    s0,s1,s2,s3    :dword;
                           const    b              :boolean;
                           const    arr_width      :dword                       );          assembler; deprecated;
// AVX2:
procedure ScalePix256     (const    msk0,msk1      :TRGBA08;
                           var      dst,src        :dword;
                           const    s0,s1,s2,s3    :dword;
                           const    arr_width      :dword                       );          assembler; unimplemented;

{3x3 pixels point: point(1 pixel) with transparent border(1 pixel)}
// replaces Fast_Graphics.Point:
procedure Point3x3128     (const    msk0           :TRGBA04;
                           var      dst            :dword;
                           const    src            :dword;
                           const    s0,s1          :dword;
                           const    arr_width      :dword                       );          assembler; experimental;



implementation

{Some auxilary procedures}
procedure CpuID (eax_,ecx_:dword; out a,b,c,d:dword); assembler; {$region -fold}
asm
  {$ifdef CPU64}
  push rbx
  push rdi
  mov  eax,eax_
  mov  ecx,ecx_
  cpuid
  mov  [a],rax
  mov  [b],rbx
  mov  [c],rcx
  mov  [d],rdx
  pop  rdi
  pop  rbx
  {$endif}
end; {$endregion}
function  XGetBV(ind      :dword                   ): qword;     {$region -fold}
var
  eax_,edx_: dword;
begin
  asm
    mov ecx   ,ind
    db  $0F   ,$01,$D0 // XGETBV
    mov eax   ,eax_
    mov edx   ,edx_
    mov [eax_],eax
    mov [edx_],edx
  end;
  Result:=QWord(edx_) shl 32 or eax_;
end; {$endregion}

{Check if AVX instructions are supported}
function  HasAVX   : boolean; experimental; {$region -fold}
var
  a,b,c,d: dword;
  xcr    : qword;
begin
  CpuID(1,0,a,b,c,d);
  // AVX=ECX bit 28, XSAVE=bit 27, OSXSAVE=bit 27
  if (((c and (1 shl 28))<>0) and ((c and (1 shl 27))<>0)) then
    begin
      xcr:=XGetBV(0);
      if ((xcr and $6)=$6) then
        Exit(True);
    end;
  Result:=False;
end; {$endregion}
function  HasAVX2  : boolean;               {$region -fold}
var
  a,b,c,d: dword;
begin
  {if not HasAVX then
    Exit(False);}
  CpuID(7,0,a,b,c,d);
  Result:=(b and (1 shl 5))<>0; // EBX bit 5
end; {$endregion}
function  HasAVX512: boolean; experimental; {$region -fold}
var
  a,b,c,d: dword;
  xcr    : QWord;
begin
  if (not HasAVX2) then
    Exit(False);
  CpuID(7,0,a,b,c,d);
  if ((b and (1 shl 16))<>0) then  // AVX-512F
    begin
      xcr:=XGetBV(0);
      if ((xcr and $E0)=$E0) then  // ZMM+opmask сохранение
        Exit(True);
    end;
  Result:=False;
end; {$endregion}

{Convert 4 double to 4 integer: AVX2}
procedure DoubleToInt256  (const src      :T4ArrD; var dst:T4ArrI                                                                                                           );       assembler; nostackframe;                {$region -fold}
asm
  vmovupd    ymm0, [src]
  vcvttpd2dq xmm0, ymm0
  vmovdqu    [dst],xmm0
  vzeroupper
end; {$endregion}

{Convert 8 single to 8 integer: AVX2}
procedure SingleToInt256  (const src      :T8ArrS; var dst:T8ArrI                                                                                                           );       assembler; nostackframe;                {$region -fold}
asm
  vmovups    ymm0, [src]
  vcvttps2dq ymm1, ymm0
  vmovdqu    [dst],ymm1
  vzeroupper
end; {$endregion}

{Special flood fill, similar to Fast_Graphics.PPFloodFillAdd: AVX2}
procedure FloodFillAdd256 (const src ,msk1:TRGBA08                                                                                                                          );       assembler; nostackframe;                {$region -fold}
asm
  vmovdqu ymm0 ,[msk1]
  vpaddd  ymm1 ,ymm0  ,[src]
  vmovdqu [src],ymm1
  vzeroupper
end; {$endregion}

{Clear alpha-channel(4th byte in each of 8 unsigned integers(dwords))}
// SSE2:
procedure ClrAlphaByte128 (var   arr ,msk1:T4ArrL                                                                                                                           );       assembler; nostackframe;                {$region -fold}
asm
  movdqu xmm0 ,[arr]
  pand   xmm0 ,[msk1]
  movdqu [arr],xmm0
end; {$endregion}
// AVX2:
procedure ClrAlphaByte256 (var   arr ,msk1:T8ArrL                                                                                                                           );       assembler; nostackframe;                {$region -fold}
asm
  vmovdqu    ymm0 ,[arr]
  vpand      ymm0 ,ymm0 ,[msk1]
  vmovdqu    [arr],ymm0
  vzeroupper
end; {$endregion}

{Non-zero items count}
// replaces Fast_Graphics.ArrNzItCnt:
// SSE2:
function  NZByteCnt128    (const src ,msk1:TRGBA04                                                                                                                          ): byte; assembler; nostackframe;                {$region -fold}
asm
  pxor    xmm3    ,xmm3
  movdqu  xmm0    ,[src]
  pcmpeqb xmm0    ,xmm3

  paddb   xmm0    ,[msk1]
 {paddb   xmm0    ,[msk0]
  psubb   xmm0    ,[msk1]}

  movq    r8      ,xmm0
  popcnt  r8      ,r8
  psrldq  xmm0    ,08
  movq    r9      ,xmm0
  popcnt  r9      ,r9
  add     r8      ,r9
  mov     [Result],r8
end; {$endregion}
// AVX2:
function  NZByteCnt256    (const src      :TRGBA08                                                                                                                          ): word; assembler; nostackframe;                {$region -fold}
asm
//vpxor     ymm0    ,ymm0 ,ymm0
  vpxor     ymm1    ,ymm1 ,ymm1
  vmovdqu   ymm0    ,[src]      // загрузить 32 байта
  vpcmpeqb  ymm0    ,ymm0 ,ymm1 // 0xFF там, где байт == 0; 0x00 иначе
  vpmovmskb eax     ,ymm0       // EAX: 32-битная маска по старшим битам байт
  not       eax                 // теперь 1 = байт ненулевой
  popcnt    eax     ,eax        // посчитать количество 1
  mov       [Result], ax        // вернуть как qword (расширение нулями)
  vzeroupper
end; {$endregion}
// AVX512:
function  NZByteCnt512    (const src      :TRGBA16                                                                                                                          ): word; assembler; nostackframe; experimental;  {$region -fold}
asm
  {
  vmovdqu8  zmm0    ,[src] // загрузить 32 байта (вообще 64, но нам хватит)
  vpmovb2m  k1      ,zmm0  // побитовая маска: 1 = ненулевой байт
  kmovq     rax     ,k1    // перенести маску в регистр
  popcnt    rax     ,rax   // посчитать количество 1
  mov       [Result], ax   // вернуть как qword (расширение нулями)
  }
end; {$endregion}

{Prepare pixel scale info: AVX2}
// used in Fast_Graphics:
procedure ScalePixInfo256A(var arr0:T4ArrW;   var   arr1,arr2:T4ArrL; var arr3:T4ArrD;                                      constref c0,c1,c2:double; constref c3:double=1.0);       assembler;                              {$region -fold}
asm

  {load arr0}
  vpmovzxwd    ymm0  ,[arr0]             // extend 4 word → 4 dword
  vcvtdq2pd    ymm0  ,xmm0               // dword → double

  {load c0,c1,c2,c3}
  mov          rax   ,[c0]
  vbroadcastsd ymm10 ,[rax]

  mov          rax   ,[c1]
  vbroadcastsd ymm11 ,[rax]

  mov          rax   ,[c2]
  vbroadcastsd ymm12 ,[rax]

  mov          rax   ,[c3]
  vbroadcastsd ymm13 ,[rax]

  {ymm0 <- arr0*c0}
  vmulpd       ymm0  ,ymm0  ,ymm10

  {ymm0 <- ymm0+c2}
  vaddpd       ymm0  ,ymm0  ,ymm12

  {ymm1 <- Trunc(ymm0)}
  vcvttpd2dq   xmm1  ,ymm0
  vmovdqu      [arr1],xmm1

  {ymm2 <-(arr1+c3)-Frac(ymm0)}
  vcvtdq2pd    ymm1  ,xmm1               // restore integer to double
  vsubpd       ymm0  ,ymm0  ,ymm1
  vaddpd       ymm2  ,ymm13 ,ymm0
  vsubpd       ymm2  ,ymm13 ,ymm2
  vaddpd       ymm2  ,ymm13 ,ymm2
  vmovupd      [arr3],ymm2

  {xmm2 <-arr2=arr3<c1}
  vcmpltpd     ymm2  ,ymm2  ,ymm11       // маска 0 / -1 (64-бит)
  vextractf128 xmm3  ,ymm2  ,1           // вынести верхнюю половину
  vpackssdw    xmm2  ,xmm2  ,xmm3        // packssdw xmm2, xmm3 // упаковать → 8 × 16-бит
  vpsrld       xmm2  ,xmm2  ,31          // -1 → 1, 0 → 0
  vmovdqu      [arr2],xmm2               // сохранить 4 × LongWord

  {if (not Boolean(arr2)) then arr3:=c1}
  vpxor        xmm7  ,xmm7  ,xmm7
  vpcmpgtd     xmm6  ,xmm2  ,xmm7        // vpcmpgtd     xmm2  ,xmm2  ,xmm7        // xmm0 = (arr2>0) ? 0xFFFFFFFF : 0x00000000 (4 x dword mask)
  vpmovsxdq    ymm6  ,xmm6               // vpmovsxdq    ymm6  ,xmm2               // расширяем маску до 4 x qword: 0 или -1 (нужно для vblendvpd)

  vblendvpd    ymm8  ,ymm11 ,[arr3],ymm6 // ymm1 = (mask ? arr3 : c1)
  vmovupd      [arr3],ymm8               // записываем обратно

  vzeroupper

end; {$endregion}
procedure ScalePixInfo256B(var arr0:T8ArrW;   var   arr1,arr2:T8ArrL; var arr3:T8ArrS;                                      constref c0,c1,c2:single; constref c3:single=1.0);       assembler;               deprecated;    {$region -fold}
asm

  {load arr0}
  {3.
  pxor         xmm0  ,xmm0
  pxor         xmm1  ,xmm1
  mov          ax    ,[arr0+00]
  pinsrw       xmm0  ,ax       ,0
  mov          ax    ,[arr0+02]
  pinsrw       xmm0  ,ax       ,2
  mov          ax    ,[arr0+04]
  pinsrw       xmm0  ,ax       ,4
  mov          ax    ,[arr0+06]
  pinsrw       xmm0  ,ax       ,6
  mov          ax    ,[arr0+08]
  pinsrw       xmm1  ,ax       ,0
  mov          ax    ,[arr0+10]
  pinsrw       xmm1  ,ax       ,2
  mov          ax    ,[arr0+12]
  pinsrw       xmm1  ,ax       ,4
  mov          ax    ,[arr0+14]
  pinsrw       xmm1  ,ax       ,6
  vinserti128  ymm0  ,ymm0     ,xmm1  ,1
  }
  vpmovzxwd    ymm0  ,[arr0]            // расширяем 8 word → 8 dword (zero extend); тоже самое что и 1.vmovdqu xmm0,[arr0]; 2.vpmovzxwd ymm0,xmm0; или блок 3., что выше

  {load c0,c1,c2,c3}
  mov          rax,   [c0]
  vbroadcastss ymm10 ,[rax]

  mov          rax,   [c1]
  vbroadcastss ymm11 ,[rax]

  mov          rax,   [c2]
  vbroadcastss ymm12 ,[rax]

  mov          rax,   [c3]
  vbroadcastss ymm13 ,[rax]

  {ymm0 <- arr0*c0}
  vcvtdq2ps    ymm0  ,ymm0
  vmulps       ymm0  ,ymm0     ,ymm10

  {ymm0 <- ymm0+c2}
  vaddps       ymm0  ,ymm0     ,ymm12

  {ymm1 <- Trunc(ymm0)}
  vcvttps2dq   ymm1  ,ymm0
  vmovdqu      [arr1],ymm1

  {ymm2 <-(arr1+c3)-Frac(ymm0)}
  vcvtdq2ps    ymm1  ,ymm1
  vsubps       ymm0  ,ymm0     ,ymm1
  vaddps       ymm2  ,ymm13    ,ymm0
  vsubps       ymm2  ,ymm13    ,ymm2
  vaddps       ymm2  ,ymm13    ,ymm2
  vmovups      [arr3],ymm2

  {ymm2 <-arr2=arr3<c1}
  vcmpltps     ymm2  ,ymm2     ,ymm11
  vmovdqu      [arr2],ymm2

  {if (not Boolean(arr2)) then arr3:=c1}
  vblendvps    ymm2  ,ymm11    ,[arr3],ymm2
  vmovups      [arr3],ymm2

  vzeroupper

end; {$endregion}
procedure ScalePixInfo256C(                   var   arr1,arr2:T4ArrL; var arr3:T4ArrD; constref msk:T4ArrD; const pix:word; constref c0,c1,c2:double; constref c3:double=1.0);       assembler;                              {$region -fold}
asm

  {load pix and add mask(MSK3_256) to get (pix+0,pix+1,pix+2,pix+3)}
  movzx        eax   , word ptr [pix]
  vmovd        xmm0  , eax
  vcvtdq2pd    ymm0  , xmm0
  vbroadcastsd ymm0  , xmm0
  vaddpd       ymm0  , ymm0,[msk]

  {load c0,c1,c2,c3}
  mov          rax   ,[c0]
  vbroadcastsd ymm10 ,[rax]

  mov          rax   ,[c1]
  vbroadcastsd ymm11 ,[rax]

  mov          rax   ,[c2]
  vbroadcastsd ymm12 ,[rax]

  mov          rax   ,[c3]
  vbroadcastsd ymm13 ,[rax]

  {ymm0 <- arr0*c0}
  vmulpd       ymm0  ,ymm0 ,ymm10

  {ymm0 <- ymm0+c2}
  vaddpd       ymm0  ,ymm0 ,ymm12

  {ymm1 <- Trunc(ymm0)}
  vcvttpd2dq   xmm1  ,ymm0
  vmovdqu      [arr1],xmm1

  {ymm2 <-(arr1+c3)-Frac(ymm0)}
  vcvtdq2pd    ymm1  ,xmm1              // restore integer to double
  vsubpd       ymm0  ,ymm0 ,ymm1
  vaddpd       ymm2  ,ymm13,ymm0
  vsubpd       ymm2  ,ymm13,ymm2
  vaddpd       ymm2  ,ymm13,ymm2
  vmovupd      [arr3],ymm2

  {xmm2 <-arr2=arr3<c1}
  vcmpltpd     ymm2  ,ymm2 ,ymm11       // маска 0 / -1 (64-бит)
  vextractf128 xmm3  ,ymm2 ,1           // вынести верхнюю половину
  vpackssdw    xmm2  ,xmm2 ,xmm3        // packssdw xmm2, xmm3 // упаковать → 8 × 16-бит
  vpsrld       xmm2  ,xmm2 ,31          // -1 → 1, 0 → 0
  vmovdqu      [arr2],xmm2              // сохранить 4 × LongWord

  {if (not Boolean(arr2)) then arr3:=c1}
  vpxor        xmm7  ,xmm7 ,xmm7
  vpcmpgtd     xmm6  ,xmm2 ,xmm7        // vpcmpgtd  xmm2,xmm2,xmm7 // xmm0 = (arr2>0) ? 0xFFFFFFFF : 0x00000000 (4 x dword mask)
  vpmovsxdq    ymm6  ,xmm6              // vpmovsxdq ymm6,xmm2      // расширяем маску до 4 x qword: 0 или -1 (нужно для vblendvpd)

  vblendvpd    ymm8  ,ymm11,[arr3],ymm6 // ymm1 = (mask ? arr3 : c1)
  vmovupd      [arr3],ymm8              // записываем обратно

  vzeroupper

end; {$endregion}
procedure ScalePixInfo256D(var arr0:T2_4ArrL; const arr1     :T4ArrD;                                                       constref c0,c1   :double                        );       assembler;                              {$region -fold}
asm
// rdi=arr0, rsi=arr1, rdx=c0, rcx=c1
  push rdi
//push rsi
//push rdx
//push rcx
  mov rdi, arr0
  mov rax{rsi}, arr1
  mov rdx, c0
  mov rcx, c1
  vbroadcastsd ymm10   ,[rdx]
  vbroadcastsd ymm11   ,[rcx]
  vmovupd      ymm3    ,[rax{rsi}]
  vmulpd       ymm4    ,ymm3,ymm10 // ymm4=arr1*c4
  vmulpd       ymm5    ,ymm3,ymm11 // ymm5=arr1*c5
  vextractf128 xmm0    ,ymm4,0
  vextractf128 xmm1    ,ymm5,0
  vcvttpd2dq   xmm0    ,xmm0
  vcvttpd2dq   xmm1    ,xmm1
  vmovq        [rdi+00],xmm0       // arr0[0] low pair
  vmovq        [rdi+16],xmm1       // arr0[1] low pair
  vextractf128 xmm4    ,ymm4,1
  vextractf128 xmm5    ,ymm5,1
  vcvttpd2dq   xmm4    ,xmm4
  vcvttpd2dq   xmm5    ,xmm5
  vmovq        [rdi+08],xmm4       // arr0[0] high pair
  vmovq        [rdi+24],xmm5       // arr0[1] high pair
  vzeroupper
//pop rcx
//pop rdx
//pop rsi
  pop rdi
end; {$endregion}
procedure ScalePixInfo256E(var arr0:T2_4ArrL; const arr1     :T4ArrD;                                                       constref c0      :double                        );       assembler;                              {$region -fold}
asm
// rdi=arr0, rsi=arr1, rdx=c0
  push rdi
//push rsi
//push rdx
  mov rdi, arr0
  mov rax{rsi}, arr1
  mov rdx, c0
  vbroadcastsd ymm10   ,[rdx]
  vmovupd      ymm3    ,[rax{rsi}]
  vmulpd       ymm4    ,ymm3,ymm10 // ymm4=arr1*c4
  vextractf128 xmm0    ,ymm4,0
  vcvttpd2dq   xmm0    ,xmm0
  vmovq        [rdi+00],xmm0       // arr0[0] low pair
  vextractf128 xmm4    ,ymm4,1
  vcvttpd2dq   xmm4    ,xmm4
  vmovq        [rdi+08],xmm4       // arr0[0] high pair
  vzeroupper
//pop rdx
//pop rsi
  pop rdi
end; {$endregion}

{ScalePix used in image scaling}
// replaces Fast_Graphics.ScalePix:
// SSE2:
procedure ScalePix128A    (const msk0     :TRGBA04; var dst,src:dword;                  const s0,s1      :dword; const b:boolean                                            );       assembler;                              {$region -fold}
asm

  {load mask for shuffling}
  movdqu xmm0   ,[msk0]

  {load src to xmm1 and xmm2}
  movd   xmm1   ,[src]
  pshufb xmm1   ,xmm0
  movdqu xmm2   ,xmm1

  {load s0 to each 32-bit integer of xmm3}
  movd   xmm3   ,s0
  pshufd xmm3   ,xmm3   ,00

  {load each byte of PColor(@dst+0)^ into each appropriate 32-bit integer of xmm4}
  movd   xmm4   ,[dst]
  pshufb xmm4   ,xmm0

  {PColor(@dst+0)^ processing}
  psubd  xmm1   ,xmm4
  pmulld xmm1   ,xmm3
  psrad  xmm1   ,16
  paddd  xmm1   ,xmm4

  {pack result and store in PColor(@dst+0)^}
  pshufb xmm1   ,xmm0
  movd   [dst+0],xmm1

  {check whether it is necessary to calculate the neighboring pixel}
  cmp    b      ,0
  je     @Exit

  {load s1 to each 32-bit integer of xmm3}
  movd   xmm3   ,s1
  pshufd xmm3   ,xmm3   ,00

  {load each byte of PColor(@dst+1)^ into each appropriate 32-bit integer of xmm4}
  movd   xmm4   ,[dst+4]
  pshufb xmm4   ,xmm0

  {PColor(@dst+1)^ processing}
  psubd  xmm2   ,xmm4
  pmulld xmm2   ,xmm3
  psrad  xmm2   ,16
  paddd  xmm2   ,xmm4

  {pack result and store in PColor(@dst+1)^}
  pshufb xmm2   ,xmm0
  movd   [dst+4],xmm2

  @Exit:

end; {$endregion}
procedure ScalePix128B    (const msk0     :TRGBA04; var dst,src:dword;                  const s0,s1      :dword;                  const arr_width:dword                     );       assembler;                              {$region -fold}
asm

  {load mask for shuffling}
  movdqu xmm0       ,[msk0]

  {load src to xmm1,xmm2}
  movd   xmm1       ,[src]
  pshufb xmm1       ,xmm0
  movdqu xmm2       ,xmm1

  {load arr_width}
  mov    eax        ,[arr_width]

  {load s0 to each 32-bit integer of xmm3}
  movd   xmm3       ,s0
  pshufd xmm3       ,xmm3       ,00

  {load each byte of PColor(@dst+000000000)^ into each appropriate 32-bit integer of xmm4}
  movd   xmm4       ,[dst]
  pshufb xmm4       ,xmm0

  {PColor(@dst+000000000)^ processing}
  psubd  xmm1       ,xmm4
  pmulld xmm1       ,xmm3
  psrad  xmm1       ,16
  paddd  xmm1       ,xmm4

  {pack result and store in PColor(@dst+000000000)^}
  pshufb xmm1       ,xmm0
  movd   [dst]      ,xmm1

  {load s1 to each 32-bit integer of xmm3}
  movd   xmm3       ,s1
  pshufd xmm3       ,xmm3       ,00

  {load each byte of PColor(@dst+arr_width)^ into each appropriate 32-bit integer of xmm4}
  movd   xmm4       ,[dst+4*eax]
  pshufb xmm4       ,xmm0

  {PColor(@dst+arr_width)^ processing}
  psubd  xmm2       ,xmm4
  pmulld xmm2       ,xmm3
  psrad  xmm2       ,16
  paddd  xmm2       ,xmm4

  {pack result and store in PColor(@dst+arr_width)^}
  pshufb xmm2       ,xmm0
  movd   [dst+4*eax],xmm2

end; {$endregion}
// replaces Fast_Graphics.AlphaBlend4:
// SSE2:
procedure ScalePix128C    (const msk0,msk1:TRGBA04; var dst,src:dword;                  const s0,s1,s2   :dword; const b:boolean                                            );       assembler;                              {$region -fold}
asm

  {load mask for shuffling}
  movdqu xmm0   ,[msk0]

  {load src to xmm1}
  movd   xmm1   ,[src]

  {extract alpha-channel(s2) from src into xmm5}
  movd   xmm5   ,s2//movdqu xmm5     ,xmm1
//psrad  xmm5   ,24
  pshufd xmm5   ,xmm5   ,0

  {clear alpha-channel in xmm1(src)}
  pand   xmm1   ,[msk1]
  pshufb xmm1   ,xmm0
  movdqu xmm2   ,xmm1

  {load s0 to each 32-bit integer of xmm3}
  movd   xmm3   ,s0
  pshufd xmm3   ,xmm3   ,0

  {load each byte of PColor(@dst+0)^ into each appropriate 32-bit integer of xmm4, having previously cleared the alpha channel}
  movd   xmm4   ,[dst]
//pand   xmm4   ,[msk1]
  pshufb xmm4   ,xmm0

  {PColor(@dst+0)^ processing}
  psubd  xmm1   ,xmm4
  pmulld xmm1   ,xmm3
  psrad  xmm1   ,16
  pmulld xmm1   ,xmm5
  psrad  xmm1   ,8
  paddd  xmm1   ,xmm4

  {pack result and store in PColor(@dst+0)^}
  pshufb xmm1   ,xmm0
  movd   [dst+0],xmm1

  {check whether it is necessary to calculate the neighboring pixel}
  cmp    b      ,0
  je     @Exit

  {load s1 to each 32-bit integer of xmm3}
  movd   xmm3   ,s1
  pshufd xmm3   ,xmm3   ,00

  {load each byte of PColor(@dst+1)^ into each appropriate 32-bit integer of xmm4, having previously cleared the alpha channel}
  movd   xmm4   ,[dst+4]
//pand   xmm4   ,[msk1]
  pshufb xmm4   ,xmm0

  {PColor(@dst+1)^ processing}
  psubd  xmm2   ,xmm4
  pmulld xmm2   ,xmm3
  psrad  xmm2   ,16
  pmulld xmm2   ,xmm5
  psrad  xmm2   ,8
  paddd  xmm2   ,xmm4

  {pack result and store in PColor(@dst+1)^}
  pshufb xmm2   ,xmm0
  movd   [dst+4],xmm2

  @Exit:

end; {$endregion}
procedure ScalePix128D    (const msk0,msk1:TRGBA04; var dst,src:dword;                  const s0,s1,s2   :dword;                  const arr_width:dword                     );       assembler;                              {$region -fold}
asm

  {load mask for shuffling}
  movdqu xmm0       ,[msk0]

  {load src to xmm1}
  movd   xmm1       ,[src]

  {extract alpha-channel(s2) from src into xmm5}
  movd   xmm5       ,s2//movdqu xmm5     ,xmm1
//psrad  xmm5       ,24
  pshufd xmm5       ,xmm5       ,0

  {clear alpha-channel in xmm1(src)}
  pand   xmm1       ,[msk1]
  pshufb xmm1       ,xmm0
  movdqu xmm2       ,xmm1

  {load arr_width}
  mov    eax        ,[arr_width]

  {load s0 to each 32-bit integer of xmm3}
  movd   xmm3       ,s0
  pshufd xmm3       ,xmm3       ,00

  {load each byte of PColor(@dst+000000000)^ into each appropriate 32-bit integer of xmm4, having previously cleared the alpha channel}
  movd   xmm4       ,[dst]
//pand   xmm4       ,[msk1]
  pshufb xmm4       ,xmm0

  {PColor(@dst+000000000)^ processing}
  psubd  xmm1       ,xmm4
  pmulld xmm1       ,xmm3
  psrad  xmm1       ,16
  pmulld xmm1       ,xmm5
  psrad  xmm1       ,8
  paddd  xmm1       ,xmm4

  {pack result and store in PColor(@dst+000000000)^}
  pshufb xmm1       ,xmm0
  movd   [dst]      ,xmm1

  {load s1 to each 32-bit integer of xmm3}
  movd   xmm3       ,s1
  pshufd xmm3       ,xmm3       ,00

  {load each byte of PColor(@dst+arr_width)^ into each appropriate 32-bit integer of xmm4, having previously cleared the alpha channel}
  movd   xmm4       ,[dst+4*eax]
//pand   xmm4       ,[msk1]
  pshufb xmm4       ,xmm0

  {PColor(@dst+arr_width)^ processing}
  psubd  xmm2       ,xmm4
  pmulld xmm2       ,xmm3
  psrad  xmm2       ,16
  pmulld xmm2       ,xmm5
  psrad  xmm2       ,8
  paddd  xmm2       ,xmm4

  {pack result and store in PColor(@dst+arr_width)^}
  pshufb xmm2       ,xmm0
  movd   [dst+4*eax],xmm2

end; {$endregion}
procedure ScalePix128E    (const msk0     :TRGBA04; var dst    :qword; const src:dword; const s0,s1      :dword; const b:boolean                                            );       assembler;               deprecated;    {$region -fold}
asm

  {load mask for bitwise AND}
  movdqu    xmm0           ,[msk0]

  {load mask for bitwise AND}
//movdqu    xmm4           ,[msk1]

  {load and stretch src by 4 32-bit integers(whole xmm1-register)}
  mov       eax            ,src
  movd      xmm1           ,eax
  pinsrd    xmm1           ,eax            ,1
  punpcklbw xmm1           ,xmm1
  pand      xmm1           ,xmm0

  {load s0 to xmm2 as 2 first  32-bit integers}
  movd      xmm2           ,s0
  pshuflw   xmm2           ,xmm2           ,0
 {pinsrw    xmm2           ,edi            ,0
  pinsrw    xmm2           ,edi            ,1
  pinsrw    xmm2           ,edi            ,2
  pinsrw    xmm2           ,edi            ,3}

  {check whether it is necessary to calculate the neighboring pixel}
  cmp       b              ,0
  je        @Continue

  {load s1 to xmm2 as 2 second 32-bit integers}
  movd      xmm3           ,s1
  pshuflw   xmm3           ,xmm3           ,0
  movq      rax            ,xmm3
  pinsrq    xmm2           ,rax            ,1
//pxor      xmm3           ,xmm3
 {pinsrw    xmm2           ,esi            ,4
  pinsrw    xmm2           ,esi            ,5
  pinsrw    xmm2           ,esi            ,6
  pinsrw    xmm2           ,esi            ,7}

  @Continue:

  {load and stretch two pixels(PColor(@dst+0)^ and PColor(@dst+1)^) by 4 32-bit integers(whole xmm3-register)}
  movq      xmm3           ,dqword ptr[dst]
  punpcklbw xmm3           ,xmm3
  pand      xmm3           ,xmm0

  {PQWord(@dst)^ mass-processing}
//movdqu    xmm5           ,xmm1
//pcmpgtw   xmm5           ,xmm3
  psubw     xmm1           ,xmm3
  pmulhw    xmm1           ,xmm2
  paddw     xmm1           ,xmm3
//paddw     xmm1           ,xmm5
//paddw     xmm1           ,xmm4

 {pack result and store in PQWord(@dst)^}
  packuswb  xmm1           ,xmm1
  movq      dqword ptr[dst],xmm1

end; {$endregion}
procedure ScalePix128F    (const msk0     :TRGBA04; var dst    :qword; const src:dword; const s0,s1,s2,s3:dword; const b:boolean; const arr_width:dword                     );       assembler;               deprecated;    {$region -fold}
asm

  {load mask for bitwise AND}
  movdqu    xmm0                 ,[msk0]

  {load and stretch src by 4 32-bit integers(whole xmm1-register)}
  mov       eax                  ,src
  movd      xmm1                 ,eax
  pinsrd    xmm1                 ,eax                  ,1
  punpcklbw xmm1                 ,xmm1
  pand      xmm1                 ,xmm0
  movdqu    xmm4                 ,xmm1

  {load s0 to xmm2 as 2 first  32-bit integers}
  movd      xmm2                 ,s0
  pshuflw   xmm2                 ,xmm2                 ,0

  {check whether it is necessary to calculate the neighboring pixel}
  cmp       b                    ,0
  je        @Continue0

  {load s1 to xmm2 as 2 second 32-bit integers}
  movd      xmm3                 ,s1
  pshuflw   xmm3                 ,xmm3                 ,0
  movq      rax                  ,xmm3
  pinsrq    xmm2                 ,rax                  ,1

  @Continue0:

  {load and stretch two pixels(PColor(@dst+0)^ and PColor(@dst+1)^) by 4 32-bit integers(whole xmm3-register)}
  movq      xmm3                 ,dqword ptr[dst]
  punpcklbw xmm3                 ,xmm3
  pand      xmm3                 ,xmm0

  {PQWord(@dst)^ mass-processing}
  psubw     xmm1                 ,xmm3
  pmulhw    xmm1                 ,xmm2
  paddw     xmm1                 ,xmm3

  {pack result and store in PQWord(@dst)^}
  packuswb  xmm1                 ,xmm1
  movq      dqword ptr[dst]      ,xmm1

  {restore src}
  movdqu    xmm1                 ,xmm4

  {load s2 to xmm2 as 2 first  32-bit integers}
  movd      xmm2                 ,s2
  pshuflw   xmm2                 ,xmm2                 ,0

  {check whether it is necessary to calculate the neighboring pixel}
  je        @Continue1

  {load s3 to xmm2 as 2 second 32-bit integers}
  movd      xmm3                 ,s3
  pshuflw   xmm3                 ,xmm3                 ,0
  movq      rax                  ,xmm3
  pinsrq    xmm2                 ,rax                  ,1

  @Continue1:

  {load arr_width}
  mov       eax                  ,[arr_width]

  {load and stretch two pixels(PColor(@dst+arr_width+0)^ and PColor(@dst+arr_width+1)^) by 4 32-bit integers(whole xmm3-register)}
  movq      xmm3                 ,dqword ptr[dst+4*eax]
  punpcklbw xmm3                 ,xmm3
  pand      xmm3                 ,xmm0

  {PQWord(@dst)^ mass-processing}
  psubw     xmm1                 ,xmm3
  pmulhw    xmm1                 ,xmm2
  paddw     xmm1                 ,xmm3

  {pack result and store in PQWor(@dst+arr_width)^}
  packuswb  xmm1                 ,xmm1
  movq      dqword ptr[dst+4*eax],xmm1

end; {$endregion}
// AVX2:
procedure ScalePix256     (const msk0,msk1:TRGBA08; var dst,src:dword;                  const s0,s1,s2,s3:dword;                  const arr_width:dword                     );       assembler;               unimplemented; {$region -fold}
asm
  {TODO}
end; {$endregion}

{3x3 pixels point: point(1 pixel) with transparent border(1 pixel): SSE2}
// replaces Fast_Graphics.Point:
procedure Point3x3128     (const msk0     :TRGBA04; var dst    :dword; const src:dword; const s0,s1      :dword;                  const arr_width:dword                     );       assembler;               experimental;  {$region -fold}
asm

  {load mask for bitwise AND}
  movdqu    xmm0              ,[msk0]

  {load arr_width}
  mov       ecx               ,arr_width

  {load and stretch src by 4 32-bit integers(whole xmm1-register)}
  mov       eax               ,src
  movd      xmm1              ,eax
  pinsrd    xmm1              ,eax               ,1
  punpcklbw xmm1              ,xmm1
  pand      xmm1              ,xmm0

  {load s0 to xmm2 into 2 first  32-bit integers}
  movd      xmm2              ,s0
  pshuflw   xmm2              ,xmm2              ,0

  {save s0(s1 will be in xmm3)}
  //movq      xmm4              ,xmm2

  {load s1 to xmm2 into 2 second 32-bit integers}
  movd      xmm3              ,s1
  pshuflw   xmm3              ,xmm3              ,0
  movq      rax               ,xmm3
  pinsrq    xmm2              ,rax               ,1

  //PColor(@dst+0)^ and PColor(@dst+1)^:

  {load pixel PColor(@dst+0)^            as first  32-bit integer into xmm5}
  movd      xmm5              ,dword[dst+0      ]

  {load pixel PColor(@dst+1)^ and insert as second 32-bit integer into xmm5}
  mov       eax               ,dword[dst+4      ]
  movd      xmm5              ,eax
  pinsrd    xmm5              ,eax               ,1

  {stretch xmm5}
  punpcklbw xmm5              ,xmm5
  pand      xmm5              ,xmm0

  {PColor(@dst+0)^ and PColor(@dst+1)^ mass-processing}
  psubsw    xmm5              ,xmm1
  pmullw    xmm5              ,xmm2
  psraw     xmm5              ,8
  paddsw    xmm5              ,xmm1
  pand      xmm5              ,xmm0

  {pack result and store in PColor(@dst+0)^ and PColor(@dst+1)^}
  packuswb  xmm5              ,xmm5
  movd      dword[dst+0      ],xmm5
  pextrd    eax               ,xmm5              ,1
  mov       dword[dst+4      ],eax

  //PColor(@dst+2)^ and PColor(@dst+arr_width)^:

  {load pixel PColor(@dst+2        )^            as first  32-bit integer into xmm5}
  movd      xmm5              ,dword[dst+8      ]

  {load pixel PColor(@dst+arr_width)^ and insert as second 32-bit integer into xmm5}
  mov       eax               ,dword[dst+4*ecx  ]
  movd      xmm5              ,eax
  pinsrd    xmm5              ,eax               ,1

  {stretch xmm5}
  punpcklbw xmm5              ,xmm5
  pand      xmm5              ,xmm0

  {PColor(@dst+2)^ and PColor(@dst+arr_width)^ mass-processing}
  psubsw    xmm5              ,xmm1
  pmullw    xmm5              ,xmm2
  psraw     xmm5              ,8
  paddsw    xmm5              ,xmm1
  pand      xmm5              ,xmm0

  {pack result and store in PColor(@dst+2)^ and PColor(@dst+arr_width)^}
  packuswb  xmm5              ,xmm5
  movd      dword[dst+8      ],xmm5
  pextrd    eax               ,xmm5              ,1
  mov       dword[dst+4*ecx  ],eax

  //PColor(@dst+2*arr_width)^ and PColor(@dst+arr_width+2)^:

  {load pixel PColor(@dst+2*arr_width)^            as first  32-bit integer into xmm5}
  movd      xmm5              ,dword[dst+8*ecx  ]

  {load pixel PColor(@dst+arr_width+2)^ and insert as second 32-bit integer into xmm5}
  mov       eax               ,dword[dst+4*ecx+8]
  movd      xmm5              ,eax
  pinsrd    xmm5              ,eax               ,1

  {stretch xmm5}
  punpcklbw xmm5              ,xmm5
  pand      xmm5              ,xmm0

  {PColor(@dst+2*arr_width)^ and PColor(@dst+arr_width+2)^ mass-processing}
  psubsw    xmm5              ,xmm1
  pmullw    xmm5              ,xmm2
  psraw     xmm5              ,8
  paddsw    xmm5              ,xmm1
  pand      xmm5              ,xmm0

  {pack result and store in PColor(@dst+2*arr_width)^ and PColor(@dst+arr_width+2)^}
  packuswb  xmm5              ,xmm5
  movd      dword[dst+8*ecx  ],xmm5
  pextrd    eax               ,xmm5              ,1
  mov       dword[dst+4*ecx+8],eax

  //PColor(@dst+2*arr_width+2)^ and PColor(@dst+2*arr_width+1)^:

  {load pixel PColor(@dst+2*arr_width+2)^            as first  32-bit integer into xmm5}
  movd      xmm5              ,dword[dst+8*ecx+8]

  {load pixel PColor(@dst+2*arr_width+1)^ and insert as second 32-bit integer into xmm5}
  mov       eax               ,dword[dst+8*ecx+4]
  movd      xmm5              ,eax
  pinsrd    xmm5              ,eax               ,1

  {stretch xmm5}
  punpcklbw xmm5              ,xmm5
  pand      xmm5              ,xmm0

  {PColor(@dst+2*arr_width+2)^ and PColor(@dst+2*arr_width+1)^ mass-processing}
  psubsw    xmm5              ,xmm1
  pmullw    xmm5              ,xmm2
  psraw     xmm5              ,8
  paddsw    xmm5              ,xmm1
  pand      xmm5              ,xmm0

  {pack result and store in PColor(@dst+2*arr_width+2)^ and PColor(@dst+2*arr_width+1)^}
  packuswb  xmm5              ,xmm5
  movd      dword[dst+8*ecx+8],xmm5
  pextrd    eax               ,xmm5              ,1
  mov       dword[dst+8*ecx+4],eax

end; {$endregion}

end.
