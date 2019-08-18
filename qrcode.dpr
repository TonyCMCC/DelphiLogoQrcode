program qrcode;

uses
  Vcl.Forms,
  main in 'main.pas' {山东移动二维码logo生成器},
  DelphiZXIngQRCode in 'DelphiZXIngQRCode.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
