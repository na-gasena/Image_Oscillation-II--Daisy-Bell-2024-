class CharacterMove {
    RShape svg, svgprop1, svgprop2;
    RPoint[][] pointPaths, pointPathsProp1, pointPathsProp2,temp_pointPaths;
    PShape obj; //objプロップ読み込み
    float scaleValue = 50; // svgファイルのスケール値
    float imageX = 250; // 画像の初期位置X
    float imageY = height; // 画像の初期位置Y
    float objimageX = 0; // objの初期回転角X
    float objimageY = 0; // objの初期回転角Y
    float fallImageX; // 画像の落下位置
    float fallImageY = 150;
    float imageWidth, imageWidthProp1, imageWidthProp2,temp_imageWidth; // 画像の幅
    float imageHeight, imageHeightProp1, imageHeightProp2,temp_imageHeight; // 画像の高さ
    float sliderValue = 0; // スライダーの値
    float sliderValueY = 0; // スライダーの値
    float keyValue = 0; // キーボードの入力値
    float keyValueY = 0; // キーボードの入力値
    float freqStartTime; //周波数変更の開始時間
    float nowFreq; // 現在の音の周波数を保存しておく変数
    PVector tempFreq;    // 一時的に周波数を保存しておく変数
    float svgSpeed = 0.5; // SVGの落下速度
    int flag = 0; // フラグ:ハートをどれだけゲットしたか
    boolean freqFlag = true; //周波数変更のフラグ
    int screenOutFlag = 0; // 画面外に出たフラグ
    float[][] posMemory = new float[3][2]; //画面の位置を保存する配列
    int count = 0; // 画面の位置を保存するためのカウント
    boolean leftScreenOut, rightScreenOut = false; // 画面外に出たフラグ
    int increment = 0;
    
    // ノイズフィルターのパラメータ
    float noiseThreshold = 0.1; // ノイズの閾値
    float noiseFilter = 0.05; // ノイズフィルターの強度
    
    //キャラクター(svg)を読みこむ
    void loadCharacterImage(String svgFileName) {
        svg = RG.loadShape(svgFileName);
        svg.centerIn(g, 30);
        pointPaths = svg.getPointsInPaths();
        imageWidth = svg.width; // svgの幅をimageWidthに代入
        imageHeight = svg.height; // svgの高さをimageHeightに代入
        
    }
    
    //プロップ(svg)=ハートを読み込む
    void loadSvgImage1(String svgFileName) {
        svgprop1 = RG.loadShape(svgFileName);
        svgprop1.centerIn(g, 30);
        pointPathsProp1 = svgprop1.getPointsInPaths();
        imageWidthProp1 = svgprop1.width; // svgの幅をimageWidthに代入
        imageHeightProp1 = svgprop1.height; // svgの高さをimageHeightに代入
    }
    
    //プロップ8svg)=自転車たち漕ぎを読み込む
    void loadSvgImage2(String svgFileName) {
        svgprop2 = RG.loadShape(svgFileName);
        svgprop2.centerIn(g, 30);
        pointPathsProp2 = svgprop2.getPointsInPaths();
        imageWidthProp2 = svgprop2.width; // svgの幅をimageWidthに代入
        imageHeightProp2 = svgprop2.height; // svgの高さをimageHeightに代入
    }
    
    //X方向のスライダーの値によってキャラクターの位置を変更
    void updateCharacterPosition() {
        
        // コントローラ入力ノイズフィルタリング
        //sliderValue = joyconX;
        
        if (abs(sliderValue) < noiseThreshold) {
            sliderValue = 0;
        } else {
            sliderValue -= noiseFilter * sliderValue;
        }
        /*
        if (sw_state == 0) {     //ジョイスティックの押し込みがあればダッシュするようにする
        imageX += sliderValue * (10) * 2;
        temp_imageWidth = imageWidthProp2;
        temp_imageHeight = imageHeightProp2;
        temp_pointPaths = pointPathsProp2;
    } else{  //なければ
        imageX += sliderValue * (10);
        temp_imageWidth = imageWidth;
        temp_imageHeight = imageHeight;
        temp_pointPaths = pointPaths;
    }
        */
        imageX += sliderValue * (10);
        temp_imageWidth = imageWidth;
        temp_imageHeight = imageHeight;
        temp_pointPaths = pointPaths;
        //svgのY座標を設定
        imageY = height - temp_imageHeight + 50;
        
        
        //キーボードの入力値によってsvgの位置を変更(デバッグ用)
        if (keyPressed) {
            if (keyCode == LEFT) {
                keyValue = -1;
            } else if (keyCode == RIGHT) {
                keyValue = 1;
            }
        } else {
            keyValue = 0;
        }
        imageX += keyValue * 10; 
        
        
        //svgのスケール値
        scaleValue = 0.5;
        
        // 画像が表示画面内に収まるように制限する
        imageX = constrain(imageX, 0, width - temp_imageWidth + 100);
        
        pushMatrix();
        
        
        //スライダの値によってsvgの位置を変更
        if (sliderValue > 0 || keyValue > 0) {
            translate(imageX, imageY);
            scale( -1, 1, 1); // x軸方向のスケールを-1に設定
            scale(scaleValue);
            renderSVG(temp_pointPaths);
        } else if (sliderValue < 0 || keyValue < 0) {
            translate(imageX, imageY);
            //scale( -1, 1, 1); // x軸方向のスケールを-1に設定
            scale(scaleValue);
            renderSVG(temp_pointPaths);
        } else if (sliderValue == 0 || keyValue == 0) {
            translate(imageX, imageY);
            scale(scaleValue);
            renderSVG(temp_pointPaths);
        }
        
        popMatrix();
    }
    
    //X方向、Y方向のスライダーの値によってSVGの位置を変更
    void updateSvgPosition() {
        
        // コントローラ入力ノイズフィルタリング
        /*
        sliderValue = joyconX;
        sliderValueY = joyconY;
        */
        
        if (abs(sliderValue) < noiseThreshold) {
            sliderValue = 0;
        } else {
            sliderValue -= noiseFilter * sliderValue;
        }
        
        if (abs(sliderValueY) < noiseThreshold) {
            sliderValueY = 0;
        } else {
            sliderValueY -= noiseFilter * sliderValueY;
        }
        
        //svgのX座標を設定： スライダーの値に応じて画像をX移動
        imageX = sliderValue * 100 + width / 2; 
        imageY = sliderValueY * 100 + height / 2;
        
        //svgのスケール値
        scaleValue = 0.5;
        
        
        
        pushMatrix();
        
        //スライダの値によってsvgの位置を変更
        if (sliderValue > 0 || sliderValueY > 0 || keyValue > 0) {
            translate(imageX, imageY);
            scale( -1, 1, 1); // x軸方向のスケールを-1に設定
            scale(scaleValue);
            renderSVG(pointPathsProp1);
        } else if (sliderValue < 0 || sliderValueY < 0 || keyValue < 0) {
            translate(imageX, imageY);
            //scale( -1, 1, 1); // x軸方向のスケールを-1に設定
            scale(scaleValue);
            renderSVG(pointPathsProp1);
        } else if (sliderValue == 0 || sliderValueY == 0 || keyValue == 0) {
            translate(imageX, imageY);
            scale(scaleValue);
            renderSVG(pointPathsProp1);
        }
        
        popMatrix();
        
    } 
    
    //OBJプロップを表示および位置の変更
    void displayObj() {
        /*
        sliderValue = joyconX;
        sliderValueY = joyconY;
        */
        //デバッグ用初期化
        sliderValue = 0;
        sliderValueY = 0;
        scaleValue = 50;
        
        //objのX座標を設定： スライダーの値に応じて画像をX移動
        objimageX = sliderValue * ( -30); 
        objimageY = sliderValueY * 30;
        
        /*
        //svgのスケール値(ジョイスティック押し込みでスケール変更)
        if (sw_state == 1) {
            scaleValue = 50;
        } else if (sw_state == 0) {
            scaleValue = 70;
        }
        */
        
        
        
        xy.clearWaves();
        
        pushMatrix();
        translate(width / 2, height / 2);
        scale(scaleValue); // Scale the model based on the scaleValue
        rotateZ(PI);
        rotateY(radians(objimageX));
        rotateX(radians(objimageY));
        
        // break 3D obj into its pieces
        int children = obj.getChildCount();
        
        // render vertices in XYscope
        xy.beginShape();
        for (int i = 0; i < children; i++) {
            PShape child = obj.getChild(i);
            int total = child.getVertexCount();
            
            for (int j = 0; j < total; j++) {
                PVector v = child.getVertex(j);
                xy.vertex(v.x, v.y, v.z);
            }
        }
        xy.endShape();
        popMatrix();
        
        xy.buildWaves();
        xy.drawXY();
    }
    
    
    void fallSVG_disp() {
        if (fallImageY >= height + 30) { // SVGが画面の下まで落下したら
            // X座標をランダムに生成
            fallImageX = random(0, width);
            // SVGが画面の下までいったら初期Y座標に戻す
            fallImageY = 150;
            
            leftScreenOut = false;
            rightScreenOut = false;
        } else {
            // SVGの位置を一定に保つ
            fallImageY += 3 + svgSpeed;
        }
        
        // SVGのスケール値
        float scaleValue = 0.2;
        
        pushMatrix();
        
        translate(fallImageX, fallImageY);
        scale(scaleValue);
        renderSVG(pointPathsProp1);
        
        popMatrix();
        
        
        int margin = 50; //当たり判定用のマージン
        //--- 当たり判定 ---//
        if (fallImageX >= imageX - margin && fallImageX <= imageX + imageWidth + margin && fallImageY >= imageY - margin && fallImageY <= imageY + imageHeight + margin) {
            // Collision detected, regenerate the falling object
            fallImageX = random(0, width);
            fallImageY = 150;
            svgSpeed += 0.1;    // 速度を上げる
            tempFreq = xy.freq(); // 現在の音の周波数を取得
            freqFlag = false;
            freqStartTime = millis();
            xy.freq(1000);  //音の周波数を変更する
            flag += 1; // フラグを増やす
        }
        
        //--- 当たり時の周波数を元に戻す ---//
        if (freqFlag == false) {
            if (millis() - freqStartTime > 100) { // 500ms経過したら
                nowFreq = xy.freq().x;    //現在の周波数を確認する
                if (nowFreq == 1000) {
                    xy.freq(tempFreq); //音の周波数を元に戻す
                    freqFlag = true;
                }
            }
        }
    }
    
    
    void renderSVG(RPoint[][] pointPaths) {
        if (pointPaths != null) { // only draw if we have points
            for (int i = 0; i < pointPaths.length; i++) {
                xy.beginShape();
                for (int j = 0; j < pointPaths[i].length; j++) {
                    xy.vertex(pointPaths[i][j].x, pointPaths[i][j].y);
                }
                xy.endShape();
            }
        }
    }
    
}
