object Form1: TForm1
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = #20108#32500#30721'logo'#29983#25104#22120
  ClientHeight = 367
  ClientWidth = 649
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 32
    Top = 63
    Width = 260
    Height = 260
    Stretch = True
  end
  object Image2: TImage
    Left = 344
    Top = 63
    Width = 260
    Height = 260
    Stretch = True
  end
  object Label1: TLabel
    Left = 57
    Top = 11
    Width = 28
    Height = 13
    Caption = #20869#23481':'
  end
  object Button1: TButton
    Left = 433
    Top = 32
    Width = 75
    Height = 25
    Caption = #25171#24320#20108#32500#30721
    TabOrder = 0
    OnClick = Button1Click
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 348
    Width = 649
    Height = 19
    Panels = <
      item
        Text = #35831#25171#24320#21407#20108#32500#30721#25991#20214
        Width = 50
      end>
    ExplicitTop = 338
    ExplicitWidth = 639
  end
  object Button2: TButton
    Left = 71
    Top = 32
    Width = 75
    Height = 25
    Caption = #31532#19968#31181#26041#24335
    TabOrder = 2
    OnClick = Button2Click
  end
  object btn1: TButton
    Left = 184
    Top = 32
    Width = 75
    Height = 25
    Caption = #31532#20108#31181#26041#24335
    TabOrder = 3
    OnClick = btn1Click
  end
  object edt1: TEdit
    Left = 88
    Top = 8
    Width = 185
    Height = 21
    TabOrder = 4
    Text = 'https://blog.csdn.net/Blue_Tear'
  end
  object OpenDialog1: TOpenDialog
    Left = 16
    Top = 8
  end
end
