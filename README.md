This Code is from my interactive Oscilloscope work created for a [FabCafeNagoya's Event](https://www.instagram.com/p/C3R3qTwPpvE/?utm_source=ig_web_copy_link&igsh=MzRlODBiNWFlZA==)
<br>
(a simplified version)
<br>
[FabCafeNagoyaで行われた展示](https://www.instagram.com/p/C3R3qTwPpvE/?utm_source=ig_web_copy_link&igsh=MzRlODBiNWFlZA==)で出展したオシロスコープ作品のソフトウェア簡易版になります。

![screenshot image of Image Oscillation II](https://github.com/na-gasena/Image_Oscillation-II--Daisy-Bell-2024-/assets/102959583/fdd612d1-8294-4dbe-8567-ae87aeeb788d)



# **How to Play**
Run  <Image_Oscillation.pde>  on Processing 4
<br>
Processing上で　＜**Image_Oscillation.pde**＞　を実行してください。

← / → Move character

↑ / ↓ Change frequency (pitch change)

LMB Start / Ending screen transition

← / →　キャラクターの左右移動

↑ / ↓　周波数の変更（ピッチ変化）

左マウスクリック　スタート画面、エンディング画面　遷移



# **Required**
・Processing 4.3


## **Libraries**
・XYScope 3.0.0
<br>
・Minim 2.2.2
<br>
・Geomerative
<br>

実際にはArduino Nanoを用いたUSBコントローラを使用して操作していたため、ライブラリとして「Serial」が必要ですが、今回のデモ版はキーボードで簡易的に操作できるようにしているので必要ありません（コード上でもコメントアウトされています）



# **Credit**
Programming : [Nagasena](https://twitter.com/due9102)
<br>
Hardware : [inkinunchikun](https://www.instagram.com/rin.rin369?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw==)


# Original Version

![osilloPlay_2](https://github.com/na-gasena/Image_Oscillation-II--Daisy-Bell-2024-/assets/102959583/745ccf82-ea0f-452b-801b-9663e362294f)
![osilloPlay_1](https://github.com/na-gasena/Image_Oscillation-II--Daisy-Bell-2024-/assets/102959583/9ab9fd85-c563-475c-baee-f6f2dadff2c6)


<br>
Tools : Tektronix2225 (Analog Oscilloscope),<br> Raspberry Pi 4 8GB (for StandAlone),<br> Arduino Nano (Controller) ,<br> Minifuse2 (I/O)
