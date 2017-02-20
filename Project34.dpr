program Project34;

uses
  Forms,
  Unit34 in 'Unit34.pas' {Form34},
  USyllableKor in 'USyllableKor.pas',
  UPredictList in 'UPredictList.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := (DebugHook <> 0);

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm34, Form34);
  Application.Run;
end.
