program Demo_kuHotKeyEditor;

uses
  Forms,
  kuHotKeys;

{$R *.res}

begin
  Application.Initialize;
//  Application.MainFormOnTaskbar := True;
  kuHotKeyEditorExecute;
  Application.Run;
end.
