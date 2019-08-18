unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ComCtrls, DelphiZXingQRCode, Vcl.ExtCtrls, Vcl.Imaging.jpeg,
  ZXing.ReadResult,ZXing.BarCodeFormat, ZXing.ScanManager;

type
  TForm1 = class(TForm)
    Button1: TButton;
    OpenDialog1: TOpenDialog;
    StatusBar1: TStatusBar;
    Image1: TImage;
    Image2: TImage;
    Button2: TButton;
    btn1: TButton;
    Label1: TLabel;
    edt1: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    function Decode(qrcode: TBitmap): string;
    function Encode(str: string): TBitmap;
    function Encode_zint(str: string;width:Integer=600;height:Integer=600;QuietZone:Integer=10): TBitmap;
    function AddLogo(bmp: TBitmap;logo:TBitmap): Integer;
    procedure btn1Click(Sender: TObject);
  private
    QRCodeBitmap: TBitmap;
    logobmp: TBitmap;
  public
    { Public declarations }
  end;
 type
  TZintSymbol = packed record
    symbology: Integer;
    height: Integer;
    whitespace_width: Integer;
    border_width: Integer;
    output_options: Integer;
    fgcolour: array[0..9] of AnsiChar;
    bgcolour: array[0..9] of AnsiChar;
    outfile: array[0..255] of AnsiChar;
    scale: Single;
    option_1: Integer;
    option_2: Integer;
    option_3: Integer;
    show_hrt: Integer;
    input_mode: Integer;
    eci: Integer;
    text: array[0..127] of AnsiChar;
    rows: Integer;
    width: Integer;
    primary: array[0..127] of AnsiChar;
    encoded_data: array[0..199, 0..142] of AnsiChar;
    row_height: array[0..199] of Integer; // Largest symbol is 189 x 189
    errtxt: array[0..99] of AnsiChar;
    bitmap: PAnsiChar;
    bitmap_width: Integer;
    bitmap_height: Integer;
    bitmap_byte_length: Cardinal;
    dot_size: Single;
    rendered: Pointer;
    debug: Integer;
  end;
  PZintSymbol = ^TZintSymbol;
const
  // Tbarcode 7 codes
  BARCODE_QRCODE        = 58;
const
  LibName = 'zint.dll';

  //struct zint_symbol *ZBarcode_Create(void);
  function ZBarcode_Create(): PZintSymbol; cdecl; external LibName;

  //void ZBarcode_Delete(struct zint_symbol *symbol);
  procedure ZBarcode_Delete(symbol: PZintSymbol); cdecl; external LibName;

  //int ZBarcode_Encode_and_Buffer(struct zint_symbol *symbol, unsigned char *input, int length, int rotate_angle);
  function ZBarcode_Encode_and_Buffer(symbol: PZintSymbol; input: PAnsiChar; length, rotate_angle: Integer): Integer; cdecl; external LibName;

  // create bitmap ���������ʹ�ñ���������ͼ����������Bitmap�ļ���������zint����˲���zint.hͷ�ļ��У������������zint.hͷ�ļ��С�
  procedure ZBarcode_To_Bitmap(symbol: PZintSymbol; const ABitmap: TBitmap);

var
  Form1: TForm1;

implementation

{$R *.dfm}

function TForm1.AddLogo(bmp: TBitmap;logo:TBitmap): Integer;
//��ͼ����м�λ�����logo
var
  w,h,icon_w,icon_h:Integer;
begin
 //����logo��λ��
  w := Round(bmp.Width / 4);
  h := Round(bmp.Height / 4);
  if logo.Width > w then
    icon_w := w
  else
  begin
    icon_w := logo.Width;
  end;
  if logo.Height > h then
    icon_h := h
  else
  begin
    icon_h :=logo.Height;
  end;

  w := Round((bmp.Width - icon_w) / 2);
  h := Round((bmp.Height - icon_h) / 2);
  SetStretchBltMode(bmp.Canvas.Handle,HALFTONE);
  StretchBlt(bmp.Canvas.Handle,w,h,icon_w,icon_h,logo.Canvas.Handle,0,0,
             logo.Width,logo.Height,SRCCOPY);
  Result := 1;
end;



function TForm1.Decode(qrcode: TBitmap): string;
//����λͼ�ļ����Զ�ά����ܲ����ؽ����ļ�
var
  ReadResult: TReadResult;
  ScanManager: TScanManager;
begin
  ReadResult := nil;
  ScanManager := nil;
  try
    ScanManager := TScanManager.Create(TBarcodeFormat.Auto, nil);
    ReadResult := ScanManager.Scan(qrcode);
    if ReadResult <> nil then
    begin
      Result := ReadResult.text;
    end
    else
      Result := '';
  finally
    FreeAndNil(ScanManager);
    FreeAndNil(ReadResult);
  end;
end;

function TForm1.Encode(str: string): TBitmap;
//����url�����֣����ܳɶ�ά�벢����bitmap
//��һ�ַ�ʽ��ʹ��TQRCodeEncoding����Ȼ���ݴ��ʵ��࣬���ӿ���û����صĲ��������ܿ����ݴ���
const
  IMG_SCALE = 10; //�Ŵ���
var
  QRCode: TDelphiZXingQRCode;
  Row, Column: Integer;
  QRCodeBitmap: VCL.Graphics.TBitmap;
begin
  QRCode := TDelphiZXingQRCode.Create;
  QRCodeBitmap := TBitmap.Create;
  try
    //�Ȼ��ƶ�ά��ͼ��
    QRCode.Data := str;
    QRCode.Encoding := TQRCodeEncoding.qrAuto;
    QRCode.QuietZone := 1;
    QRCodeBitmap.SetSize(QRCode.Rows * IMG_SCALE, QRCode.Columns * IMG_SCALE);
    QRCodeBitmap.Canvas.Lock;
    //�Ȱѱ�����Ϊ��ɫ����ͼʱֻ���ɫ
    QRCodeBitmap.Canvas.Brush.Color := clWhite;
    QRCodeBitmap.Canvas.FillRect(Rect(0, 0, QRCodeBitmap.Width, QRCodeBitmap.Height));
    QRCodeBitmap.Canvas.Brush.Color := clBlack;
    for Row := 0 to QRCode.Rows - 1 do
    begin
      for Column := 0 to QRCode.Columns - 1 do
      begin
        if (QRCode.IsBlack[Row, Column]) then
        begin
          QRCodeBitmap.Canvas.FillRect(Rect(Column * IMG_SCALE, Row * IMG_SCALE, Column * IMG_SCALE + IMG_SCALE, Row * IMG_SCALE + IMG_SCALE));
        end;
      end;
    end;
    AddLogo(QRCodeBitmap,logobmp);
    QRCodeBitmap.Canvas.Unlock;
    Result := QRCodeBitmap;
  finally
    FreeAndNil(QRCode);
  end;

end;
procedure ZBarcode_To_Bitmap(symbol: PZintSymbol; const ABitmap: TBitmap);
// �����ɵĶ�ά��ת���bitmapͼ��
var
  SrcRGB: PRGBTriple;
  Row, RowWidth: Integer;
begin
  ABitmap.PixelFormat := pf24bit;
  ABitmap.SetSize(symbol.bitmap_width, symbol.bitmap_height);

  SrcRGB := Pointer(symbol.bitmap);
  RowWidth := symbol.bitmap_width * 3;

  for Row := 0 to symbol.bitmap_height - 1 do
  begin
    CopyMemory(ABitmap.ScanLine[Row], SrcRGB, RowWidth);
    Inc(SrcRGB, symbol.bitmap_width);
  end;

  SetBitmapBits(ABitmap.Handle, symbol.bitmap_width * symbol.bitmap_height * 3, symbol.bitmap);
end;
function TForm1.Encode_zint(str: string;width:Integer=600;height:Integer=600;QuietZone:Integer=10): TBitmap;
var
  lvData: UTF8String; // ʹ��UTF8������ַ���
  lvBitMap: TBitmap;
  lvSymbol: PZintSymbol;
  lvErrorNumber: Integer;
  bmp: TBitmap;
begin
   lvSymbol := ZBarcode_Create();
  if lvSymbol = nil then
    Exit;
  lvBitMap := TBitmap.Create;
  bmp := TBitmap.Create;
  bmp.Width := width;
  bmp.Height:= height;
  try
    lvData := UTF8String(str);
    // ������������ΪQRCODE
    lvSymbol.symbology := BARCODE_QRCODE;
    // ����ݴ���
    lvSymbol.option_1 :=4;
    // ����
    lvErrorNumber := ZBarcode_Encode_and_Buffer(lvSymbol, PAnsiChar(lvData), Length(lvData), 0);
    // ����ɹ�
    if lvErrorNumber = 0 then
    begin
      // ����Bitmapͼ��
      ZBarcode_To_Bitmap(lvSymbol, lvBitMap);

      // ������ά���С����ʾ��Image��
      bmp.Canvas.Brush.Color := clWhite;
      bmp.Canvas.FillRect(Rect(0, 0, bmp.Width, bmp.Height));
      bmp.Canvas.StretchDraw(Rect(QuietZone, QuietZone, bmp.Width - QuietZone, bmp.Height - QuietZone), lvBitMap);
      AddLogo(bmp,logobmp)  ;
    end;
    Result:= bmp;
  finally
    ZBarcode_Delete(lvSymbol);
  end;
end;

procedure TForm1.btn1Click(Sender: TObject);
begin
  Image1.Picture.Bitmap.Assign(Encode_zint(edt1.Text));
  Image1.Picture.SaveToFile('d:\new.bmp');
  Image1.Picture.SaveToFile('d:\new.jpg');
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  bmp: VCL.Graphics.TBitmap;
  bmp_qr: VCL.Graphics.TBitmap;
  url: string;
begin
  if not opendialog1.Execute then
    exit;
  StatusBar1.Panels[0].Text := '��' + opendialog1.FileName;
  bmp := TBitmap.Create;
  bmp_qr := TBitmap.Create;
  url := '';
  Image1.Picture.LoadFromFile(opendialog1.FileName);
  bmp.assign(Image1.Picture.Graphic);
  //����url
  url := Decode(bmp);
  StatusBar1.Panels[0].Text := url;
  //����������logo�ļ�
  bmp_qr := Encode_zint(url);
  bmp_qr.SaveToFile('d:\temp.bmp');
  Image2.Picture.Bitmap.Assign(bmp_qr);
  FreeAndNil(bmp);
  FreeAndNil(bmp_qr);
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  bmp_qr: VCL.Graphics.TBitmap;
begin
  bmp_qr := TBitmap.Create;
  bmp_qr := Encode(edt1.Text);
  bmp_qr.SaveToFile('d:\temp.bmp');
  Image1.Picture.Bitmap.Assign(bmp_qr);
  FreeAndNil(bmp_qr);
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  logo:TPicture;
begin
  QRCodeBitmap := TBitmap.Create;
  logobmp:=TBitmap.Create;
  logo := TPicture.Create;
  logo.LoadFromFile('logo.jpg');
  logobmp.Height:=logo.Height;
  logobmp.Width:=logo.Width;
  logobmp.Canvas.Draw(0,0,logo.Graphic);
  FreeAndNil(logo);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FreeAndNil(logobmp);
  FreeAndNil(QRCodeBitmap);
end;

end.

