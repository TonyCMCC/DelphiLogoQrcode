# DelphiLogoQrcode
Delphi开发window下解析二维码内容，并生成带logo的二维码

解析二维码使用zxing进行解析，本项目中生成二维码有两种方式：
第一种：使用TDelphiZXingQRCode
第二种：使用zint2.6.dll

最后使用zint生成，使用TDelphiZXingQRCode生成的二维码无法控制容错率，缺少接口。

程序界面如下：
![Image text](https://github.com/TonyCMCC/DelphiLogoQrcode/blob/master/ui.png)
