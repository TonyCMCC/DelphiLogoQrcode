program qrcode;

uses
  Vcl.Forms,
  main in 'main.pas' {ɽ���ƶ���ά��logo������},
  DelphiZXIngQRCode in 'DelphiZXIngQRCode.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
