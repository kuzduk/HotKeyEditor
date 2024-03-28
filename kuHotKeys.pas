unit kuHotKeys;
{
Редактор горячих клавиш Delphi
Отлавливает не только Ctrl, Shift, Alt но и Win
Автор Горкун Григорий https://kuzduk.ru/delphi/kulibrary

НУЖНО СДЕЛАТЬ:
Запретить в ComboBox все HK: Up Dn Left Right PgUp PgDown чтоб при OnKeyDown они не меняли строку а делали только KeyToStr
Запретить потрею фокуса по Tab в ComboBox и Edit1
Перехватить все глобальные клавиши системы чтоб они не выпонгялись, а только  отображались редакторе, например Win чтоб не включалось меню пуск, или например Win + E
}
interface

uses
  Windows, SysUtils, Classes, Forms, StdCtrls, Controls, Dialogs, Buttons;

type
  TFormHK = class(TForm)
    chWin: TCheckBox;
    chAlt: TCheckBox;
    chShift: TCheckBox;
    chCtrl: TCheckBox;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    ListBox1: TListBox;
    btnAdd: TSpeedButton;
    btnDel: TSpeedButton;

    procedure Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Edit1KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);

    procedure chCtrlClick(Sender: TObject);
    procedure chShiftClick(Sender: TObject);
    procedure chAltClick(Sender: TObject);
    procedure chWinClick(Sender: TObject);
    procedure ModToCheckBox(const ModStr: string = '');

    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);

    procedure btnAddClick(Sender: TObject);
    procedure btnDelClick(Sender: TObject);

    private
      _KeyDown: Boolean;
  end;

var
  FormHK: TFormHK;

function kuHotKeyEditorExecute: Boolean;


//Key ~ Mod ~ Str
function  ModToStr: string; overload;
function  ModToStr(sMod: word): string; overload;
function  KeyToStr(Key: word): string;
procedure StrToKeyMod(ShortcutStr: string; var vKey, vMod: word);


//Key Down
function KeyDownly(Key: integer): Boolean;
function CtrlDown: Boolean;
function ShiftDown: Boolean;
function AltDown: Boolean;
function WinDown: Boolean;





implementation

{$R *.dfm}



//============================================================================== kuHotKeyEditorExecute
function kuHotKeyEditorExecute: Boolean;
begin

if Application.FindComponent('FormHotKeys') = nil then
  Application.CreateForm(TFormHK, FormHK);

end;






{$REGION ' Form '}





//------------------------------------------------------------------------------ Edit1 Key Down
procedure TFormHK.Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  sMod, sKey: string;

begin

//if (Key = 9) and (ActiveControl = Self) then begin
//  //не работает!
//  Perform(CM_DialogKey, VK_TAB, 0);
//  ActiveControl := Self;
//  Self.SetFocus;
//end;


sMod := ModToStr;
sKey := KeyToStr(Key);

_KeyDown := sKey <> '';

Edit1.text := sMod + sKey;
ModToCheckBox;
FormHK.ComboBox1.ItemIndex := FormHK.ComboBox1.Items.IndexOf(sKey);

end;



//------------------------------------------------------------------------------ Edit1 Key Up
procedure TFormHK.Edit1KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin

if not _KeyDown then begin
  ModToCheckBox('');
  Edit1.text := '';
end;

//if (KeyToStr(Key) = '') and (ModToStr = '') then

end;









//------------------------------------------------------------------------------ ComboBox Change
procedure TFormHK.ComboBox1Change(Sender: TObject);
var
p: integer;
s: string;
sKey, sMod: word;

begin

StrToKeyMod(Edit1.Text, sKey, sMod);
Edit1.Text := ModToStr(sMod) + ComboBox1.Text;

end;



//------------------------------------------------------------------------------ ComboBox KeyDown
procedure TFormHK.ComboBox1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
s: string;
//k: Word;

begin
s := KeyToStr(Key);
//k := Key;





ComboBox1.ItemIndex := ComboBox1.Items.IndexOf(s);

//if Key = VK_TAB then ActiveControl := ComboBox1; //не работает
Key := 0; //чтобы не обрабатывать клавиши Up, Down, Left, Right, Home, End, PgUp, PgDown,
end;










//------------------------------------------------------------------------------ chWin
procedure TFormHK.chWinClick(Sender: TObject);
var
p: integer;
s: string;
sKey, sMod: word;

begin

if chWin.Checked

then begin
  StrToKeyMod(Edit1.Text, sKey, sMod);
  sMod := MOD_WIN xor sMod;
  Edit1.Text := ModToStr(sMod) + KeyToStr(sKey);
end

else begin
  s := Edit1.Text;
  p := pos('Win+', Edit1.Text);
  if p <> 0 then Delete(s, p, 4);
  Edit1.Text := s;
end;

end;



//------------------------------------------------------------------------------ chCtrl
procedure TFormHK.chCtrlClick(Sender: TObject);
var
p: integer;
s: string;
sKey, sMod: word;

begin

if chCtrl.Checked

then begin
  StrToKeyMod(Edit1.Text, sKey, sMod);
  sMod := MOD_CONTROL xor sMod;
  Edit1.Text := ModToStr(sMod) + KeyToStr(sKey);
end

else begin
  s := Edit1.Text;
  p := pos('Ctrl+', Edit1.Text);
  if p <> 0 then Delete(s, p, 5);
  Edit1.Text := s;
end;


end;



//------------------------------------------------------------------------------ chShift
procedure TFormHK.chShiftClick(Sender: TObject);
var
p: integer;
s: string;
sKey, sMod: word;

begin

if chShift.Checked

then begin
  StrToKeyMod(Edit1.Text, sKey, sMod);
  sMod := MOD_SHIFT xor sMod;
  Edit1.Text := ModToStr(sMod) + KeyToStr(sKey);
end

else begin
  s := Edit1.Text;
  p := pos('Shift+', Edit1.Text);
  if p <> 0 then Delete(s, p, 6);
  Edit1.Text := s;
end;

end;



//------------------------------------------------------------------------------ chAlt
procedure TFormHK.chAltClick(Sender: TObject);
var
p: integer;
s: string;
sKey, sMod: word;

begin

if chAlt.Checked

then begin
  StrToKeyMod(Edit1.Text, sKey, sMod);
  sMod := MOD_ALT xor sMod;
//  FormHotKeys.Caption := ModToStr(sMod) + '|||' + KeyToStr(sKey);
  Edit1.Text := ModToStr(sMod) + KeyToStr(sKey);
end

else begin
  s := Edit1.Text;
  p := pos('Alt+', Edit1.Text);
  if p <> 0 then Delete(s, p, 4);
  Edit1.Text := s;
end;

end;



//------------------------------------------------------------------------------ Moding To CheckBox
procedure TFormHK.ModToCheckBox(const ModStr: string = '');
begin
if ModStr <> '' then begin
  chCtrl.Checked  := pos('Ctrl',  ModStr) <> 0;
  chShift.Checked := pos('Shift', ModStr) <> 0;
  chAlt.Checked   := pos('Ctrl',  ModStr) <> 0;
  chWin.Checked   := pos('Win',   ModStr) <> 0;
  exit;
end;

chCtrl.Checked  := CtrlDown;
chShift.Checked := ShiftDown;
chAlt.Checked   := AltDown;
chWin.Checked   := WinDown;
end;










//------------------------------------------------------------------------------ btnAdd
procedure TFormHK.btnAddClick(Sender: TObject);
begin
if ListBox1.Items.IndexOf(Edit1.Text) <> -1 then exit;

ListBox1.Items.Add(Edit1.Text)
end;




//------------------------------------------------------------------------------ btnDel
procedure TFormHK.btnDelClick(Sender: TObject);
var
  i, r: Integer;

//  function isItemSelected(iItem: integer): Boolean;
//  begin
//    Result := ListBox1.Selected[iItem];
//  end;

begin

//r := List_SmartSelectAfterDeleteMulti(ListBox1.ItemIndex, ListBox1.Count, @isItemSelected) ;


for i := ListBox1.Count - 1 downto 0
do
begin
   if ListBox1.Selected[i]
   then
   begin
     ListBox1.Items.Delete(i);
   end;
end;



//if ListBox1.Count > 0 then begin
//  ListBox1.ItemIndex := r;
//  ListBox1.Selected[r] := True;
//end;

end;






{$ENDREGION}






{$REGION '  Uni  Key ~ Mod ~ Str  '}
{
Key - клавиша
Mod - клавиша модификатор Ctrl, Shift, Alt, Win
ShiftState - набор модификаторов ssCtrl, ssShift, ssAlt. БЕЗ клавиши Win

ShortCutToText - uses Vcl.Menus
GetKeyNameText - uese Winapi.Windows
}

//------------------------------------------------------------------------------ Str To KeyMod
procedure StrToKeyMod(ShortcutStr: string; var vKey, vMod: word);
var k:word;
begin

 vMod := 0;
 if pos('Win+',  ShortcutStr)<>0 then vMod :=MOD_WIN or vMod;
 if pos('Shift+',ShortcutStr)<>0 then vMod :=MOD_SHIFT or vMod;
 if pos('Ctrl+', ShortcutStr)<>0 then vMod :=MOD_CONTROL or vMod;
 if pos('Alt+',  ShortcutStr)<>0 then vMod :=MOD_ALT or vMod;

if vMod <> 0 then begin
  if pos('Win+',  ShortcutStr)<>0 then Delete(ShortcutStr, pos('Win+',  ShortcutStr),4);
  if pos('Shift+',ShortcutStr)<>0 then Delete(ShortcutStr, pos('Shift+',ShortcutStr),6);
  if pos('Ctrl+', ShortcutStr)<>0 then Delete(ShortcutStr, pos('Ctrl+', ShortcutStr),5);
  if pos('Alt+',  ShortcutStr)<>0 then Delete(ShortcutStr, pos('Alt+',  ShortcutStr),4);
end;




for k := 3 to 226 do
  if pos(ShortcutStr, KeyToStr(k)) <> 0 then begin
   vKey := k;
//   yy(ShortcutString+'|||'+Chr(vkey));
   break;
  end;

end;


//------------------------------------------------------------------------------ Key To Str
function KeyToStr(Key: word): string;
//спасибо n0wheremany
var sKey: String;
begin

case key of
     3:sKey:='Scroll Lock';
     8:sKey:='BackSpace';
     9:sKey:='Tab';
    12:sKey:='Num 5';
    13:sKey:='Enter';

    20:sKey:='Caps Lock';
    27:sKey:='Esc';
    32:sKey:='Space';
    33:sKey:='PgUp';
    34:sKey:='PgDn';
    35:sKey:='End';
    36:sKey:='Home';
    37:sKey:='Left';
    38:sKey:='Up';
    39:sKey:='Right';
    40:sKey:='Down';
    44:sKey:='PrintScreen';
    45:sKey:='Ins';
    46:sKey:='Del';

    48..57,
    65..90 :sKey:=Chr(key);

    96..105:sKey:='Num '+inttostr(key-96);

   106:sKey:='Num *';
   107:sKey:='Num +';
   109:sKey:='Num -';
   110:sKey:='Num Del';
   111:sKey:='Num /';

   112..135:sKey:='F'+inttostr(key-111);

   144:sKey:='PauseBreak';
   145:sKey:='ScrollLock';

   172:sKey:='M';
   173:sKey:='D';
   174:sKey:='C';
   175:sKey:='B';
   176:sKey:='P';
   177:sKey:='Q';
   178:sKey:='J';
   179:sKey:='G';
   183:sKey:='F';

   186:sKey:=';';
   187:sKey:='=';
   188:sKey:='<';
   190:sKey:='>';
   189:sKey:='-';
   192:sKey:='~';
   194:sKey:='F15';
   219:sKey:='[';
   221:sKey:=']';
   222:sKey:='''';

   191:sKey:='/';
   220:sKey:='\';
   226:sKey:='\';

   else
   begin
     sKey:='';
//     exit;
   end;

end;

Result := sKey;

end;


//------------------------------------------------------------------------------ Mod To Str
function ModToStr: string; overload;
var s: String;
begin

Result := '';

//if ((HiWord(GetKeyState(VK_LWIN))<>0) or (HiWord(GetKeyState(VK_RWIN))<>0)) then Result := 'Win+';
//if HiWord(GetKeyState(VK_CONTROL))<>0 then Result := Result + 'Ctrl+';
//if HiWord(GetKeyState(VK_SHIFT))<>0   then Result := Result + 'Shift+';
//if HiWord(GetKeyState(VK_MENU))<>0    then Result := Result + 'Alt+';

if WinDown   then Result := 'Win+';
if CtrlDown  then Result := Result + 'Ctrl+';
if ShiftDown then Result := Result + 'Shift+';
if AltDown   then Result := Result + 'Alt+';

end;


//------------------------------------------------------------------------------ Mod To Str
function ModToStr(sMod: word): string; overload;
begin

Result := '';

if (sMod = MOD_WIN or sMod)     then Result := 'Win+';
if (sMod = MOD_CONTROL or sMod) then Result := Result + 'Ctrl+';
if (sMod = MOD_SHIFT or sMod)   then Result := Result + 'Shift+';
if (sMod = MOD_ALT or sMod)     then Result := Result + 'Alt+';

end;


{$ENDREGION}







{$REGION '  Uni Key Down  '}



//------------------------------------------------------------------------------ Key Downly
function KeyDownly(Key: integer): Boolean;
{
вжата ли клавиша?
Ctrl  = VK_Control
Shift = VK_Shift
Alt   = VK_Menu
MouseRight = VK_RBUTTON
}
var
  State : TKeyboardState;

begin

GetKeyboardState(State);
Result := ( (State[Key] and 128) <> 0 );


//Result := HiWord(GetKeyState(Key)) <> 0 ;

end;



//------------------------------------------------------------------------------ Ctrl
function CtrlDown: Boolean;
//вжата ли клавиша Ctrl?
begin

Result := KeyDownly(VK_CONTROL);

end;



//------------------------------------------------------------------------------ Shift
function ShiftDown: Boolean;
//вжата ли клавиша Shift?
begin

Result := KeyDownly(VK_SHIFT);

end;



//------------------------------------------------------------------------------ Alt
function AltDown: Boolean;
//вжата ли клавиша Alt?
begin

Result := KeyDownly(VK_MENU);

end;



//------------------------------------------------------------------------------ Win
function WinDown: Boolean;
//вжата ли клавиша Alt?
begin

Result := KeyDownly(VK_LWIN) or KeyDownly(VK_RWIN);

end;




//------------------------------------------------------------------------------ KeyDownEmulate
procedure KeyDownEmulate(Component: TComponent;  Key: Word; Shift: TShiftState = []);
var k: word;
begin

//эмулируем нажатие клавиши чтоб всё сработало точно также как и в kuShellListView.pas
k := Key;
//LVS.KeyDown(k, []);

end;




{$ENDREGION}




end.
