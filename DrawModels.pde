boolean opStartTimeRecorded = false;
boolean edTransitTimeRecorded = false;
int opelapsedTime,opstartTime; // 時間を格納する変数

boolean isFirstEdRender = true; // 初めてedRenderが実行されたかどうかのフラグ


class DrawModels{    
    void renderModels() {
        xy.clearWaves(); // clear waves
        
        
        pushMatrix();
        textDisp.displayText(); // テキスト表示
        popMatrix();
        
        
        xy.line(0 ,height - 10, width, height - 10); // draw line at bottom of screen
        
        
        characterMove.updateCharacterPosition();  // キャラクターの位置更新
        
        characterMove.fallSVG_disp();  // SVGの落下
        
        // build audio from shapes
        xy.buildWaves();
        xy.drawXY();
    }
    
    void opRender() {
        background(0,60,200);
        xy.clearWaves(); // clear waves
        xy.freq(200);
        xy.resetWaves(); // reset waves
        
        textDisp.opDispText();  // テキスト表示
        
        
        xy.buildWaves(); // 波形の生成
        xy.drawXY();  // 波形の描画
        
        //---〇ボタンを押したらmainPlayへ遷移---//
        if (!opStartTimeRecorded) {
            opstartTime = millis();
            opStartTimeRecorded = true;
        }
        //500ms待機して、○ボタンを検出開始（遷移時の誤動作防止）
        opelapsedTime = millis() - opstartTime;
        if (opelapsedTime >= 500) {
            /*
            if (joycon_buttonFlag == 1) {   // 〇ボタンが押されたら
            joycon_buttonFlag = 0;  // ボタンの初期化
            playseq = 1;
        }
            */
            //左クリックしたらmainPlayへ遷移(デバッグ用)
            if (mousePressed) {
                playseq = 1;
            }
        }
    }
    
    void edRender() {
        xy.clearWaves(); // clear waves
        
        background(0,60,200);
        xy.freq(200);
        
        
        
        characterMove.displayObj();  // objの表示
        textDisp.edDispText();  // テキスト表示
        xy.buildWaves();
        
        xy.drawXY();
        
        /*
        //〇ボタンを押したらopPlayへ遷移
        if (joycon_buttonFlag == 1) {
            joycon_buttonFlag = 0;  // ボタンの初期化
            opStartTimeRecorded = false;
            xy.clearWaves(); // clear 
            characterMove.flag = 0; // スコアフラッグを初期化
            characterMove.svgSpeed = 0; // SVGのスピードを初期化
            playseq = 0;
        }
        */
        
        
        //左クリックしたらopPlayへ遷移
        if (mousePressed) {
            opStartTimeRecorded = false;
            xy.clearWaves(); // clear 
            characterMove.flag = 0; // スコアフラッグを初期化
            characterMove.svgSpeed = 0; // SVGのスピードを初期化
            playseq = 0;
        }
        
        // 時間でも遷移するようにする
        if (!edTransitTimeRecorded) {
            startTime = millis();
            edTransitTimeRecorded = true;
        }
        elapsedTime = millis() - startTime;
        if (elapsedTime >= 10000) {         //10秒経ったら
            playseq = 0; // opPlayへ遷移
        }
    }
    
}