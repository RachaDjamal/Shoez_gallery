class Pixel {
    final static int w = 10;
    final static int h = CASE_SIZE;
    
    PShape s, s1, s2;
    int c;
    int x, y, z;
    int alpha;

    Pixel(int _x, int _y, int _z) {
        x = _x;
        y = _y;
        z = _z;
        alpha = 80;
        c = BLACK;
        initShape();
    }

    void initShape() {
        s = createShape(GROUP);
        
        s1 = createShape();
        s1.setStroke(false);
        s1.beginShape();
        s1.vertex(-1, 0, 0);
        s1.vertex(-w/2, h, 0);
        s1.vertex(w/2, h, 0);
        s1.vertex(1, 0, 0);
        s1.endShape();
        s1.setTexture(colors[c]);
        s1.setTextureMode(NORMAL);
        s1.setTextureUV(0, 0, 0);
        s1.setTextureUV(1, 1, 1);
        s1.setTextureUV(2, 0, 1);
        s1.setTextureUV(3, 0, 0);
        s.addChild(s1);

        s2 = createShape();
        s2.setStroke(false);
        s2.beginShape();
        s2.vertex(0, 0, -1);
        s2.vertex(0, h, -w/2);
        s2.vertex(0, h, w/2);
        s2.vertex(0, 0, 1);
        s2.endShape();
        s2.setTexture(colors[c]);
        s2.setTextureMode(NORMAL);
        s2.setTextureUV(0, 0, 0);
        s2.setTextureUV(1, 1, 1);
        s2.setTextureUV(2, 0, 1);
        s2.setTextureUV(3, 0, 0);
        //s.addChild(s2);
    }

    void setColor(int _c) {
        c = _c;
        s1.setTexture(colors[c]);
        s2.setTexture(colors[c]);
    }

    void setBrightness(int b) {
        alpha = b;
    }

    void display() {
        pushMatrix();
        translate(x, y, z);
        shape(s, 0, 0);
        popMatrix();
    }
}
