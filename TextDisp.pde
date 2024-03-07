class TextDisp {
    
    String[] lines;
    int currentLineIndex = 0;
    int lineDisplayDuration = 1000; // 1秒

    
    //XYスコープの初期化
    XYscope xy;
    RShape grp, grp_op1, grp_op2, grp_ed1,grp_ed2;
    RPoint[][] pointPaths, pointsPaths_op1, pointsPaths_op2, pointsPaths_ed1, pointsPaths_ed2;
    String fontName = "FreeSans.ttf"; // フォント名
    String txt_op1_String = ""; //"DaisyBell" //タイトルを入れると波形が見づらい？
    String txt_op2_String = "〇  →  P L A Y ";
    String txt_ed1_String = "  LOVE";  //Well Wishes
    String txt_ed2_String = "your LOVE";    //your LOVE


    TextDisp(XYscope xy) {
        this.xy = xy;
        RG.init(Image_Oscillation.this); // initialize Geomerative
    } 
    
    

    
    void displayText() {
        fill(0);
        textSize(20);
        textAlign(CENTER, CENTER);

        //xy.clearWaves(); // clear waves

        
        if (playseq == 2) { // エンドシーンになったら読み込んだ行をリセット
            currentLineIndex = 0;
        }

        if (frameCount % 15 == 0) { // 1秒ごとにテキストを切り替える
            if (currentLineIndex < lines.length - 1) {
                renderText();
                //text(lines[currentLineIndex], width / 2, height / 2);
                currentLineIndex++;
            } else {
            }
        } else {
            // 1秒経過していない場合は前のテキストを表示し続ける
            if (currentLineIndex > -1) {
                renderText();
                //text(lines[currentLineIndex - 1], width / 2, height / 2);
            }
        }
    }

    void opDispText(){
        fill(0);
        textSize(20);
        textAlign(CENTER, CENTER);

        xy.clearWaves();

        /*
        //テキストの描画 Text1
        grp_op1 = RG.getText(txt_op1_String, fontName, width/2, CENTER); 
        grp_op1.centerIn(g, 30);
        RG.setPolygonizer(RG.UNIFORMSTEP);
        RG.setPolygonizerStep(10);
        pointsPaths_op1 = grp_op1.getPointsInPaths();

        pushMatrix();
        translate(width/2, height-330); 
        if (pointsPaths_op1 != null) { // only draw if we have points 
            for (int i = 0; i < pointsPaths_op1.length; i++) { 
                xy.beginShape(); 
                for (int j=0; j < pointsPaths_op1[i].length; j++) { 
                    xy.vertex(pointsPaths_op1[i][j].x, pointsPaths_op1[i][j].y);
                } 
                xy.endShape();
            }
        } 
        popMatrix();
        */

        //テキストの描画 Text2
        grp_op2 = RG.getText(txt_op2_String, fontName, width/2, CENTER);
        grp_op2.centerIn(g, 30);
        RG.setPolygonizer(RG.UNIFORMSTEP);
        RG.setPolygonizerStep(10);
        pointsPaths_op2 = grp_op2.getPointsInPaths();

        pushMatrix();
        translate(width/2, height /2);
        scale(0.7);
        if (pointsPaths_op2 != null) { // only draw if we have points 
            for (int i = 0; i < pointsPaths_op2.length; i++) { 
                xy.beginShape(); 
                for (int j=0; j < pointsPaths_op2[i].length; j++) { 
                    xy.vertex(pointsPaths_op2[i][j].x, pointsPaths_op2[i][j].y);
                } 
                xy.endShape();
            }
        }
        popMatrix();

        //xy.rect(0,height - 50, width, 20);  //画面下に線を引く

        /* xy.buildWaves(); // 波形の生成
        xy.drawXY();  // 波形の描画 */
    }

    void edDispText(){
        fill(0);
        textSize(20);
        textAlign(CENTER, CENTER);

        //edxy.clearWaves();

        //テキストの描画1
        grp_ed1 = RG.getText(characterMove.flag + txt_ed1_String, fontName, width/2, CENTER); 
        grp_ed1.centerIn(g, 30);
        RG.setPolygonizer(RG.UNIFORMSTEP);
        RG.setPolygonizerStep(10);
        pointsPaths_ed1 = grp_ed1.getPointsInPaths();

        pushMatrix();
        translate(width/2, height - 50); 
        if (pointsPaths_ed1 != null) { // only draw if we have points 
            for (int i = 0; i < pointsPaths_ed1.length; i++) { 
                xy.beginShape(); 
                for (int j=0; j < pointsPaths_ed1[i].length; j++) { 
                    xy.vertex(pointsPaths_ed1[i][j].x, pointsPaths_ed1[i][j].y);
                } 
                xy.endShape();
            }
        } 
        popMatrix();

/* 
        //テキストの描画2
        grp_ed2 = RG.getText(txt_ed2_String, fontName, width/2, CENTER);
        grp_ed2.centerIn(g, 30);
        RG.setPolygonizer(RG.UNIFORMSTEP);
        RG.setPolygonizerStep(10);
        pointsPaths_ed2 = grp_ed2.getPointsInPaths();

        pushMatrix();
        translate(width/2, height - 50);
        if (pointsPaths_ed2 != null) { // only draw if we have points 
            for (int i = 0; i < pointsPaths_ed2.length; i++) { 
                xy.beginShape(); 
                for (int j=0; j < pointsPaths_ed2[i].length; j++) { 
                    xy.vertex(pointsPaths_ed2[i][j].x, pointsPaths_ed2[i][j].y);
                } 
                xy.endShape();
            }
        }
        popMatrix(); */
    }

    void renderText() {
        // render type with Geomerative
        grp = RG.getText(lines[currentLineIndex], fontName, width/2, CENTER); 
        grp.centerIn(g, 30);
        RG.setPolygonizer(RG.UNIFORMSTEP);
        RG.setPolygonizerStep(10);
        pointPaths = grp.getPointsInPaths();

        //pushMatrix();

        translate(width/2, height-330); 
        if (pointPaths != null) { // only draw if we have points 
            for (int i = 0; i < pointPaths.length; i++) { 
                xy.beginShape(); 
                for (int j=0; j < pointPaths[i].length; j++) { 
                    xy.vertex(pointPaths[i][j].x, pointPaths[i][j].y);
                } 
                xy.endShape();
            }
        } 

        //popMatrix();   
    }
}
