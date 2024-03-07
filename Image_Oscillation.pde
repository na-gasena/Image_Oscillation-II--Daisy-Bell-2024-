import processing.sound.*;
import processing.core.PImage;
import ddf.minim.*; // minim req to gen audio
import ddf.minim.ugens.*; // freq from pitch
import xyscope.*;   // import XYscope
import geomerative.*; // import Geomerative
import javax.sound.midi.*;  //MIDIのためのライブラリ
//import processing.serial.*; //Arduinoと通信するためのライブラリの読み込み
import java.util.Arrays; // needed for 2D Array to string

//XYscopeのためのインスタンスを生成
XYscope xy;

///---クラスの読み込み---///
TextDisp textDisp;
CharacterMove characterMove = new CharacterMove();
MidiControl midiControl = new MidiControl();
DrawModels drawModels = new DrawModels();
AudioPlayer player;
Minim minim;
//Serial myPort;              //シリアル通信を行うための変数を定義

//変数宣言
int playseq = 0;    //進行管理の変数の初期化
boolean midiSetupDone = false; // MIDIのセットアップが完了したかどうかのフラグ
boolean soundSetupDone = false; // サウンドのセットアップが完了したかどうかのフラグ
//boolean mainKnobPosRecord = false; // メインのつまみの位置を記録したかどうかのフラグ
//boolean edKnobPosRecord = false; // エンディングのつまみの位置を記録したかどうかのフラグ
//boolean knobRotated = false;    //つまみが動かされたかどうかのフラグ
int startTime,elapsedTime; // 時間を格納する変数
//int x_pos, y_pos, sw_state, pm_pos, psw_state; //ジョイスティックの入力値を格納する変数
//int joycon_buttonFlag = 0;      //ボタンの状態を格納する変数
// int joystick_buttonFlag = 0;    //ボタンの状態を格納する変数
// float joyconX, joyconY,objJoyconX,objJoyconY;       //ジョイスティックの入力値を格納する変数
// float tempknobPos; // エンディングのつまみの位置を記録する変数
int keyTranspose = -2;  //デバッグ用、キー操作によるピッチ変更
boolean keyBool = false;

void setup() {
    size(500, 400,P3D);
    frameRate(30); // フレームレートを30に設定
    xy = new XYscope(this, ""); // XYscopeの初期化
    textDisp = new TextDisp(this.xy); // テキスト表示の初期化
    textDisp.lines = loadStrings("daisybell_lyrics.txt");   //歌詞データの読み込み
    RG.init(this); // initialize Geomerative
    
    // println("Available serial ports:");
    // printArray(Serial.list());              //使用できるCOMポートの取得
    //myPort = new Serial(this, Serial.list()[0], 9600); //通信するポートと速度の設定、Arduinoと合わせる必要あり
    // myPort.clear();                      //受信データをクリア
    
    
    characterMove.loadCharacterImage("bicycle_for_two.svg");  // 自転車画像の読み込み
    characterMove.loadSvgImage1("heart.svg");  // 自転車たち漕ぎ画像の読み込み
    characterMove.loadSvgImage2("bicycle_for_two_stand.svg");  // 自転車たち漕ぎ画像の読み込み
    characterMove.obj = loadShape("heart_d26.obj"); // ハートの3Dモデルの読み込み
    
}

void draw() {
    if (playseq == 0) {
        // JoyConDetect();  // JoyConの検出
        opPlay();
        // edKnobPosRecord = false; // エンディングのつまみの位置を記録したかどうかのフラグをリセット
        // edTransitTimeRecorded = false; // エンディングの遷移時間を記録したかどうかのフラグをリセット
    } else if (playseq == 1) {
        // JoyConDetect();  // JoyConの検出
        mainPlay();
    } else if (playseq == 2) {
        // JoyConDetect();  // JoyConの検出
        edPlay();
        // mainKnobPosRecord = false; // メインのつまみの位置を記録したかどうかのフラグをリセット
        characterMove.svgSpeed = 0; // オブジェクト落下スピードをリセット
    }
}

//---進行管理---//
void mainPlay() {
    background(0,60,200);
    drawModels.renderModels();
    
    xy.amp(0.7); // 生成した波形の音量を設定
    
    if (!midiSetupDone) {
        midiControl.setupMidi(midiControl.midiTrack); //MIDIのセットアップ
        midiSetupDone = true;
        startTime = millis(); // 開始時間を記録
    }
    
    /*
    if (!mainKnobPosRecord) {
    mainKnobPosRecord = true;
    tempknobPos = pm_pos;
    knobRotated = false;    //つまみが動かされたかどうかのフラグ
}
    //もしつまみを動かしたら
    if (tempknobPos != pm_pos) {
    knobRotated = true;
}
    //つまみでトランスポーズを変更
    if (knobRotated == true) {
    float knobTranspose = pm_pos; // MIDIトランスポーズの値を取得
    knobTranspose = int(map(knobTranspose, 0, 255, -7, 2)); // MIDIトランスポーズの値を-3から3に変換
    midiControl.midiTranspose = int(knobTranspose); // MIDIトランスポーズの値を設定
} else{
    midiControl.midiTranspose = -2;     //初期値
}
    
    //ジョイコンのボタンが押されたらトランスポーズをリセットする
    if (joycon_buttonFlag == 1) {
    midiControl.midiTranspose = -1;
    mainKnobPosRecord = false; // メインのつまみの位置を記録したかどうかのフラグをリセット
    knobRotated = false;    //つまみが動かされたかどうかのフラグを初期化
}
    */
    
    //キーボード上下キーでトランスポーズを変更
    if (keyPressed) {
        if (!keyBool) {
            if (keyCode == UP) {
                keyTranspose += 1;
            } else if (keyCode == DOWN) {
                keyTranspose -= 1;
            }
        }
        
        keyBool = true;
        
        keyTranspose = constrain(keyTranspose, -7, 4);
        midiControl.midiTranspose = keyTranspose;
    }
    println(keyTranspose);
    
    
    // 時間を計測
    elapsedTime = millis() - startTime;
    if (elapsedTime >= 76000) {         //終了する時間を指定する
        playseq = 2; // 指定時間経ったらplayseq変数に2を代入 //現状曲の長さ76000ms
        stopMidi(); // Stop the currently playing MIDI
    }
    /*/ 右上に時間を表示
    fill(255);
    textSize(16);
    textAlign(RIGHT, TOP);
    text("Time: " + elapsedTime / 1000 + " seconds", width, 0);
    */
}

void keyReleased() {
    if ((keyCode == UP) || (keyCode == DOWN)) {
        keyBool = false;
    }
}

void opPlay() {
    drawModels.opRender();
    xy.amp(1); // 生成した波形の音量を設定
    keyTranspose = -2;      //MIDIピッチ初期化（デバッグ用）
}

void edPlay() {
    drawModels.edRender();
    xy.amp(1); // xyの音量を0に設定
    
    /*
    if (!edKnobPosRecord) {
    edKnobPosRecord = true;
    tempknobPos = pm_pos;
    knobRotated = false;    //つまみが動かされたかどうかのフラグ
}
    //もしつまみを動かしたら
    if (tempknobPos != pm_pos) {
    knobRotated = true;
}
    //つまみの値によって周波数を変更
    if (knobRotated == true) {
    float knobFreq = pm_pos; // つまみの値を取得
    knobFreq = map(knobFreq, 0, 255, 1, 500); // つまみの値を0から1に変換
    xy.freq(knobFreq); // つまみの値を周波数に設定
    xy.resetWaves(); // 波形をリセット 
} else{     //つまみを動かしてなければ
    xy.freq(100);
    xy.resetWaves();
}
    */
    
    textDisp.currentLineIndex = 0;      //歌詞の表示をリセット
    midiSetupDone = false; 
    
    fill(255);
    textSize(16);
    textAlign(RIGHT, TOP);
    text("Love: " + characterMove.flag, width, 0);
}


//---MIDI停止処理---//
void stopMidi() {
    if (midiSetupDone) {
        midiControl.sequencer.stop(); // Stop the sequencer
        midiControl.sequencer.close(); // Close the sequencer
        midiSetupDone = false; // Reset the flag
    }
}

/*
void JoyConDetect() {
int c;  //ローカル変数の設定
if (myPort.available() > 5) {     //データが4以上おくられてきたかの判断
c = myPort.read();            //スタートデータの読み込み
if (c == 's') {
x_pos = myPort.read();      //X座標データ読み込み
y_pos = myPort.read();      //Y座標データ読み込み
sw_state = myPort.read();   //SWデータ読み込み
psw_state = myPort.read();
pm_pos = myPort.read();

//ジョイスティック押し込み
if (sw_state == 0) {            //ジョイスティック押し込み
joystick_buttonFlag = 1;    //ジョイスティックのボタン状態を1にする
} else{ //ジョイスティック押し込み解除
joystick_buttonFlag = 0;    //ジョイスティックのボタン状態を0にする
} 

//ボタンが押されると
if (psw_state == 0) {
joycon_buttonFlag = 1;
} else{ //ボタンが押されていないと    
joycon_buttonFlag = 0;
}
//println("joycon_flag"+joycon_buttonFlag);
//ジョイスティックの入力値の正規化
float joyconX = map(y_pos, 0, 255, -1, 1);
float joyconY = map(x_pos, 0, 255, -1, 1);

joyconX =y_pos / 255 * 2 - 1;
joyconY = x_pos / 255 * 2 - 1;

//joyconX = y_pos;
//joyconY = x_pos;
joyconX = (y_pos - 129) / 126;
joyconY = (x_pos - 129) / 126;
objJoyconX = y_pos;
objJoyconY = x_pos;
}

}
    }
*/