unit Hot_Keys;

{This file contains some routines for key mapping}

{$mode objfpc}
{$H+,INLINE+}

interface

uses

  Forms, Controls, Graphics, Dialogs, ComCtrls, ExtCtrls, Classes, SysUtils,
  LCLType;



type

  { TF_Hot_Keys }
  TF_Hot_Keys=class(TForm) {$region -fold}
    LV_Hot_Keys: TListView;
    procedure FormCreate           (sender:TObject);
    procedure FormShow             (sender:TObject);
    procedure FormHide             (sender:TObject);
    procedure LV_Hot_KeysMouseDown (sender:TObject; button:TMouseButton; shift:TshiftState; x,y:integer);
    procedure LV_Hot_KeysMouseEnter(sender:TObject);
    procedure LV_Hot_KeysMouseLeave(sender:TObject);

    private

    public

  end; {$endregion}



var

  F_Hot_Keys : TF_Hot_Keys;
  key_arr    : array of word{integer};
  key_alt_arr: array of word{integer};



implementation

uses

  Fast_Main;

{$R *.lfm}

{ TF_Hot_Keys }

function  ParseKeyStringToKeyAndshift      (const s:string; out key:word; out shift:TshiftState): boolean; {$region -fold}
var
  tokens        : TStringList;
  i             : integer;
  t             : string;
  main_key_found: boolean;
  n             : integer;
begin
  Result:=False;
  key   :=0;
  shift :=[];
  if (Trim(s)='') then
    Exit;
  tokens:=TStringList.Create;
  try
    // разделяем по '+'
    ExtractStrings(['+'],[],PChar(UpperCase(Trim(S))),tokens);
    main_key_found:=False;

    for i:=0 to tokens.Count-1 do
      begin
        t:=Trim(tokens[i]);
        if (t='') then
          Continue;

        // модификаторы
        if (t='CTRL') then
          begin
            Include(shift,ssCtrl);
            Continue;
          end;
        if (t='shift') then
          begin
            Include(shift,ssshift);
            Continue;
          end;
        if (t='ALT'  ) or
           (t='ALTGR') then
          begin
            Include(shift,ssAlt);
            Continue;
          end;

        // если уже нашли основную клавишу — игнорируем лишнее
        if main_key_found then
          Continue;

        // Основные клавиши (строки)
        if (t='TAB') or
           (t='T'  ) then
          begin
            key           :=VK_TAB;
            main_key_found:=True;
            Continue;
          end;
        if (t='ENTER' ) or
           (t='RETURN') then
          begin
            key           :=VK_RETURN;
            main_key_found:=True;
            Continue;
          end;
        if (t='SPACE') or
           (t=' '    ) then
          begin
            key           :=VK_SPACE;
            main_key_found:=True;
            Continue;
          end;
        if (t='BACKSPACE') or
           (t='BS'       ) then
          begin
            key           :=VK_BACK;
            main_key_found:=True;
            Continue;
          end;
        if (t='INS'   ) or
           (t='INSERT') then
          begin
            key           :=VK_INSERT;
            main_key_found:=True;
            Continue;
          end;
        if (t='DEL'   ) or
           (t='DELETE') then
          begin
            key           :=VK_DELETE;
            main_key_found:=True;
            Continue;
          end;
        if (t='LEFT') then
          begin
            key           :=VK_LEFT;
            main_key_found:=True;
            Continue;
          end;
        if (t='RIGHT') then
          begin
            key           :=VK_RIGHT;
            main_key_found:=True;
            Continue;
          end;
        if (t='UP') then
          begin
            key           :=VK_UP;
            main_key_found:=True;
            Continue;
          end;
        if (t='DOWN') then
          begin
            key           :=VK_DOWN;
            main_key_found:=True;
            Continue;
          end;
        if (t='HOME') then
          begin
            key           :=VK_HOME;
            main_key_found:=True;
            Continue;
          end;
        if (t='END') then
          begin
            key           :=VK_END;
            main_key_found:=True;
            Continue;
          end;
        if (t='PGUP'  ) or
           (t='PAGEUP') or
           (t='PRIOR' ) then
          begin
            key           :=VK_PRIOR;
            main_key_found:=True;
            Continue;
          end;
        if (t='PGDN'    ) or
           (t='PAGEDOWN') or
           (t='NEXT'    ) then
          begin
            key           :=VK_NEXT;
            main_key_found:=True;
            Continue;
          end;

        // F-keys: F1..F24
        if (Length(t)>=2) and (t[1]='F') then
          begin
            if TryStrToInt(Copy(t,2,MaxInt),n) then
              begin
                if (n>=01) and
                   (n<=24) then
                  begin
                    key           :=VK_F1+(n-1);
                    main_key_found:=True;
                    Continue;
                  end;
              end;
          end;

        // Если это одиночный символ (буква или цифра)
        if Length(t)=1 then
          begin
            key           :=Ord(t[1]);
            main_key_found:=True;
            Continue;
          end;

        // Если токен — одна цифра/символ в кавычках, или "A"
        // Попытка распознать как число (на случай '65')
        if TryStrToInt(t,n) then
          begin
            key           :=Word(n);
            main_key_found:=True;
            Continue;
          end;

        // Если не распознали — возвращаем False
        Exit(False);
      end;

    if main_key_found then
      Result:=True
    else
      Result:=False;
  finally
    tokens.Free;
  end;
end; {$endregion}
procedure TF_Hot_Keys.FormCreate           (sender:TObject); {$region -fold}
var
  i    : integer;
  s    : string;
  k    : word;
  shift: TshiftState=[];
begin
  with LV_Hot_Keys do
    begin
      AlphaBlendValue:=150;
      Sort;
      SetLength(key_arr    ,Items.Count);
      SetLength(key_alt_arr,Items.Count);
      for i:=0 to Items.Count-1 do
        begin
          s:=Items[i].SubItems[0]{[1]};
          if ParseKeyStringToKeyAndshift(s,k,shift) then
            key_arr[i]:=k;
        end;

      {Editor HUD}
      //Items[19].SubItems[1]:='Tab';

      for i:=0 to Items.Count-1 do
        if (Items[i].SubItems[1]<>'') then
          begin
            s:=Items[i].SubItems[1]{[1]};
            if ParseKeyStringToKeyAndshift(s,k,shift) then
              key_alt_arr[i]:=k;
          end;

      {Editor HUD}
      //key_alt_arr[19]:=VK_TAB;
    end;
end; {$endregion}
procedure TF_Hot_Keys.FormShow             (sender:TObject); {$region -fold}
begin
  self.PopUpParent:=F_MainForm;
end; {$endregion}
procedure TF_Hot_Keys.FormHide             (sender:TObject); {$region -fold}
begin
end; {$endregion}
procedure TF_Hot_Keys.LV_Hot_KeysMouseDown (sender:TObject; button:TMouseButton; shift:TshiftState; x,y:integer); {$region -fold}
var
  item_ind: integer;

  procedure ReadKey(var key_arr_:array of word{integer}; sub_items_ind:integer; message_label:string); {$region -fold}
  var
    s: string;
    k: word;
  begin
    with LV_Hot_Keys do
      begin
            s:=Items[item_ind].SubItems[sub_items_ind];
        if (s ='Tab') and (sub_items_ind=1) then
          Exit;
            s:=InputBox('Enter a key',message_label,s);
        if (s =' ') then
            s:=' Space';
        if (Trim(s)<>'') then
          begin
            if ParseKeyStringToKeyAndshift(s,k,shift) then
              begin
                Items   [item_ind].SubItems[sub_items_ind]:=s;
                key_arr_[item_ind]                        :=k;
              end;
            {key_arr_ [item_ind]:=Ord(
                 Items[item_ind]      .SubItems[sub_items_ind][1] );}
          end;
      end;
  end; {$endregion}

begin
  with LV_Hot_Keys do
    if GetItemAt(x,y)<>Nil then
      begin
        item_ind:=GetItemAt(x,y).Index;
        ReadKey(key_arr    ,0,'base shortcut'     );
        ReadKey(key_alt_arr,1,'alternate shortcut');
        Selected:=Nil;
      end;
end; {$endregion}
procedure TF_Hot_Keys.LV_Hot_KeysMouseEnter(sender:TObject); {$region -fold}
begin
  AlphaBlend          :=False;
  move_with_child_form:=True;
end; {$endregion}
procedure TF_Hot_Keys.LV_Hot_KeysMouseLeave(sender:TObject); {$region -fold}
begin
  AlphaBlend:=True;
end; {$endregion}

end.
