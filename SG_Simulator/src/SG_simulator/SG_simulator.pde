/*
🔴🔴🔴⚫️🔴⚫️🔴⚫️🔴🔴🔴⚫️🔴🔴🔴⚫️🔴🔴🔴⚫️⚫️🔴🔴🔴⚫️⚫️🔴⚫️⚫️🔴⚫️⚫️⚫️🔴⚫️⚫️⚫️🔴🔴🔴⚫️🔴🔴🔴⚫️🔴⚫️🔴
🔴⚫️⚫️⚫️🔴⚫️🔴⚫️🔴⚫️🔴⚫️🔴⚫️⚫️⚫️⚫️⚫️🔴⚫️⚫️🔴⚫️⚫️⚫️🔴⚫️🔴⚫️🔴⚫️⚫️⚫️🔴⚫️⚫️⚫️🔴⚫️⚫️⚫️🔴⚫️🔴⚫️🔴⚫️🔴
🔴🔴🔴⚫️🔴🔴🔴⚫️🔴⚫️🔴⚫️🔴🔴⚫️⚫️⚫️🔴⚫️⚫️⚫️🔴⚫️🔴⚫️🔴🔴🔴⚫️🔴⚫️⚫️⚫️🔴⚫️⚫️⚫️🔴🔴⚫️⚫️🔴🔴⚫️⚫️🔴⚫️🔴
⚫️⚫️🔴⚫️🔴⚫️🔴⚫️🔴⚫️🔴⚫️🔴⚫️⚫️⚫️🔴⚫️⚫️⚫️⚫️🔴⚫️🔴⚫️🔴⚫️🔴⚫️🔴⚫️⚫️⚫️🔴⚫️⚫️⚫️🔴⚫️⚫️⚫️🔴⚫️🔴⚫️⚫️🔴⚫️
🔴🔴🔴⚫️🔴⚫️🔴⚫️🔴🔴🔴⚫️🔴🔴🔴⚫️🔴🔴🔴⚫️⚫️🔴🔴🔴⚫️🔴⚫️🔴⚫️🔴🔴🔴⚫️🔴🔴🔴⚫️🔴🔴🔴⚫️🔴⚫️🔴⚫️⚫️🔴⚫️
*/

import peasy.PeasyCam;

final static int NUM_PIXELS = 400;
final static int NUM_LINES = 5;
final static int NUM_SEGMENTS = 20;
final static int CASE_SIZE = 40;
final static int W = CASE_SIZE * NUM_SEGMENTS; // casier width
final static int H = CASE_SIZE * NUM_LINES; // casier Height

PeasyCam camera;
PShape casier;

// Colors
final static int NUM_COLORS = 8;
PGraphics[] colors;

final static int BLACK = 0;
final static int WHITE = 1;
final static int RED = 2;
final static int YELLOW = 3;
final static int GREEN = 4;
final static int CYAN = 5;
final static int BLUE = 6;
final static int PURPLE = 7;
int CURRENT_COLOR;
int CURRENT_COLOR_2;

// NeoPixels strips
int[][] backSegments = {
    { 0, 21, 40, 59, 79, 98, 117, 136, 155, 174, 193, 212, 232, 251, 269, 288, 308, 327, 346, 364, 381 },
    { 0, 20, 40, 60, 80, 99, 118, 138, 158, 178, 196, 217, 237, 257, 277, 297, 316, 337, 356, 376, 398 },
    { 0, 20, 39, 60, 79, 98, 117, 136, 156, 175, 194, 213, 233, 253, 272, 291, 311, 330, 349, 368, 386 },
    { 0, 20, 39, 60, 79, 98, 117, 137, 156, 176, 196, 215, 236, 255, 275, 294, 314, 333, 352, 372, 390 },
    { 0, 21, 40, 61, 80, 99, 118, 137, 157, 176, 196, 215, 235, 254, 274, 292, 312, 332, 351, 370, 388 }
};

int[][] frontSegments = {
    { 0, 21, 40, 59, 79, 98, 117, 136, 155, 174, 193, 212, 231, 250, 269, 288, 307, 326, 345, 364, 380 },
    { 0, 19, 39, 59, 79, 98, 117, 137, 157, 176, 196, 216, 237, 256, 277, 296, 316, 336, 356, 376, 391 },
    { 0, 19, 38, 58, 78, 97, 116, 135, 155, 174, 194, 214, 234, 254, 273, 292, 312, 331, 351, 370, 388 },
    { 0, 20, 39, 60, 79, 98, 118, 138, 157, 177, 196, 215, 235, 255, 274, 293, 313, 332, 352, 371, 388 },
    { 0, 20, 40, 60, 79, 98, 118, 137, 157, 176, 196, 215, 235, 255, 274, 293, 313, 332, 351, 370, 388 }  // pb soudure sur dernier segment 373
};
/*
    // utility script to see the offset between strips

    int backSegments[][] = {
        { 0, 21, 40, 59, 79, 98, 117, 136, 155, 174, 193, 212, 232, 251, 269, 288, 308, 327, 346, 364, 381 },
        { 0, 20, 40, 60, 80, 99, 118, 138, 158, 178, 196, 217, 237, 257, 277, 297, 316, 337, 356, 376, 398 },
        { 0, 20, 39, 60, 79, 98, 117, 136, 156, 175, 194, 213, 233, 253, 272, 291, 311, 330, 349, 368, 386 },
        { 0, 20, 39, 60, 79, 98, 117, 137, 156, 176, 196, 215, 236, 255, 275, 294, 314, 333, 352, 372, 390 },
        { 0, 21, 40, 61, 80, 99, 118, 137, 157, 176, 196, 215, 235, 254, 274, 292, 312, 332, 351, 370, 388 }
    };

    int[][] frontSegments = {
        { 0, 21, 40, 59, 79, 98, 117, 136, 155, 174, 193, 212, 231, 250, 269, 288, 307, 326, 345, 364, 380 },
        { 0, 19, 39, 59, 79, 98, 117, 137, 157, 176, 196, 216, 237, 256, 277, 296, 316, 336, 356, 376, 391 },
        { 0, 19, 38, 58, 78, 97, 116, 135, 155, 174, 194, 214, 234, 254, 273, 292, 312, 331, 351, 370, 388 },
        { 0, 20, 39, 60, 79, 98, 118, 138, 157, 177, 196, 215, 235, 255, 274, 293, 313, 332, 352, 371, 388 },
        { 0, 20, 40, 60, 79, 98, 118, 137, 157, 176, 196, 215, 235, 255, 274, 293, 313, 332, 351, 370, 388 }  // pb soudure sur dernier segment 373
    };

    int nx, ny;

    void setup() {
        size(500, 300);
        nx = frontSegments[0].length;
        ny = frontSegments.length;
    }

    void draw() {
        background(0);

        translate(50, 50);

        for(int x=0; x <= 400; x += 20) {
            stroke(255, 50);
            line(x, 0, x, height-100);
        }

        for(int j = 0; j < ny; j++) {
            int y = (height - 100) / (ny - 1) * j;

            stroke(255);
            line(0, y, width - 100, y); 

            for(int i = 0; i < nx; i ++) {
                int x1 = backSegments[j][i];
                stroke(255, 0, 0);
                line(x1, y - 3, x1, y + 3);

                int x2 = backSegments[j][i];
                stroke(80, 80, 255);
                line(x2, y - 3, x2, y + 3);
            }
        }
    }
*/

long[] segmentStates;

NeoPixel[] backPixels;
NeoPixel[] frontPixels;

// Timeline
final static int NUM_ANIMS = 85;
long timer;
long timestamp = 0;
int anim = 0;
int animStep = 0;
int currentAnim = 0;
int repetition = 0;
int nbRepetition = 1;
boolean play = false;

void settings() {
    size(displayWidth, displayHeight, P3D);
    smooth(3);
}

void setup() {
    camera = new PeasyCam(this, 400);
    camera.setMinimumDistance(100);
    camera.setMaximumDistance(600);
    camera.setYawRotationMode();
    camera.setWheelScale(0.5);

    casier = createCasier();

    initColors();

    // remap pixels
    for(int i = 0; i < NUM_LINES; i++) {
        for(int j = 0; j < NUM_SEGMENTS + 1; j++) {
            backSegments[i][j] = j * 20;
            frontSegments[i][j] = j * 20;
        }
    }

    segmentStates = new long[NUM_LINES];
    resetSegments();

    backPixels = new NeoPixel[NUM_LINES];
    frontPixels = new NeoPixel[NUM_LINES];
    for(int i = 0; i < NUM_LINES; i++) {
        backPixels[i] = new NeoPixel(i, -1);
        backPixels[i].begin();

        frontPixels[i] = new NeoPixel(i, 1);
        frontPixels[i].begin();
    }

    timestamp = millis();
}

void randomCurrentColors() {
    CURRENT_COLOR = int(random(NUM_COLORS));
    CURRENT_COLOR_2 = int(random(NUM_COLORS));

    while(CURRENT_COLOR_2 == CURRENT_COLOR) {
        CURRENT_COLOR_2 = int(random(NUM_COLORS));
    }
}

void draw() {
    // Timeline
    timer = millis() - timestamp;

    int n = anim;
    
    if(play) {
        switch (currentAnim) {
            case 0: wait(1000); break;
            case 1: blink(1000, CURRENT_COLOR, CURRENT_COLOR_2, 5); break;
            case 2: blink(500, CURRENT_COLOR, BLACK, 10); break;
            case 3: blinkOdd(1000, CURRENT_COLOR, CURRENT_COLOR_2, 3); break;
            case 4: blinkOdd(500, CURRENT_COLOR, BLACK, 6); break;
            case 5: blinkOdd(500, BLACK, CURRENT_COLOR, 6); break;
            case 6: fillTop(100, CURRENT_COLOR); break;
            case 7: fillTop(100, new int[]{ CURRENT_COLOR, CURRENT_COLOR_2 }); break;
            case 8: fillTop(100, new int[]{ CURRENT_COLOR, BLACK }); break;
            case 9: fillBottom(100, CURRENT_COLOR); break;
            case 10: fillBottom(100, new int[]{ CURRENT_COLOR, CURRENT_COLOR_2 }); break;
            case 11: fillBottom(100, new int[]{ CURRENT_COLOR, BLACK }); break;
            case 12: fillLeft(20, CURRENT_COLOR); break;
            case 13: fillLeft(10, CURRENT_COLOR, 5); break;
            case 14: fillLeft(20, CURRENT_COLOR, 10, 100); break;
            case 15: fillLeft(20, CURRENT_COLOR, 10, -100); break;
            case 16: fillLeft(20, new int[]{ CURRENT_COLOR, CURRENT_COLOR_2 }, 10, 20); break;
            case 17: fillLeft(20, new int[]{ CURRENT_COLOR, CURRENT_COLOR_2 }, 10, -20); break;
            case 18: fillLeft(20, new int[]{ CURRENT_COLOR, CURRENT_COLOR_2 }, 10, NUM_PIXELS/5); break;
            case 19: fillLeft(20, new int[]{ CURRENT_COLOR, CURRENT_COLOR_2 }, 10, -NUM_PIXELS/5); break;
            case 20: fillLeft(20, new int[]{ CURRENT_COLOR, BLACK }, 10, 0); break;
            case 21: fillLeft(20, new int[]{ CURRENT_COLOR, CURRENT_COLOR_2 }, 10, 0); break;
            case 22: fillLeft(20, new int[]{ CURRENT_COLOR, CURRENT_COLOR_2 }, 10, NUM_PIXELS); break;
            case 23: fillLeft(20, new int[]{ CURRENT_COLOR, CURRENT_COLOR_2 }, 10, -NUM_PIXELS); break;
            case 24: fillLeft(20, new int[]{ RED, YELLOW, GREEN, CYAN, BLUE }, 10, 200); break;
            case 25: fillLeft(20, new int[]{ RED, YELLOW, GREEN, CYAN, BLUE }, 10, -200); break;
            case 26: fillRight(20, CURRENT_COLOR); break;
            case 27: fillRight(10, CURRENT_COLOR, 5); break;
            case 28: fillRight(20, CURRENT_COLOR, 10, 100); break;
            case 29: fillRight(20, CURRENT_COLOR, 10, -100); break;
            case 30: fillRight(20, new int[]{ CURRENT_COLOR, CURRENT_COLOR_2 }, 10, 20); break;
            case 31: fillRight(20, new int[]{ CURRENT_COLOR, CURRENT_COLOR_2 }, 10, -20); break;
            case 32: fillRight(20, new int[]{ CURRENT_COLOR, CURRENT_COLOR_2 }, 10, NUM_PIXELS/5); break;
            case 33: fillRight(20, new int[]{ CURRENT_COLOR, CURRENT_COLOR_2 }, 10, -NUM_PIXELS/5); break;
            case 34: fillRight(20, new int[]{ CURRENT_COLOR, BLACK }, 10, 0); break;
            case 35: fillRight(20, new int[]{ CURRENT_COLOR, CURRENT_COLOR_2 }, 10, 0); break;
            case 36: fillRight(20, new int[]{ CURRENT_COLOR, CURRENT_COLOR_2 }, 10, NUM_PIXELS); break;
            case 37: fillRight(20, new int[]{ CURRENT_COLOR, CURRENT_COLOR_2 }, 10, -NUM_PIXELS); break;
            case 38: fillRight(20, new int[]{ RED, YELLOW, GREEN, CYAN, BLUE }, 10, 200); break;
            case 39: fillRight(20, new int[]{ RED, YELLOW, GREEN, CYAN, BLUE }, 10, -200); break;
            case 40: randomSegment(20, CURRENT_COLOR, 100); break;
            case 41: randomSegment(20, int(random(NUM_COLORS)), 100); break;
            case 42: snake(20, CURRENT_COLOR, 0); break;
            case 43: snake(20, int(random(2)), 0); break;
            case 44: snake(20, int(random(2, NUM_COLORS)), 0); break;
            case 45: snake(20, CURRENT_COLOR, 1); break;
            case 46: snake(20, int(random(2)), 1); break;
            case 47: snake(20, int(random(2, NUM_COLORS)), 1); break;
            case 48: snake(20, CURRENT_COLOR, 2); break;
            case 49: snake(20, int(random(2)), 2); break;
            case 50: snake(20, int(random(2, NUM_COLORS)), 2); break;
            case 51: snake(20, CURRENT_COLOR, 3); break;
            case 52: snake(20, int(random(2)), 3); break;
            case 53: snake(20, int(random(1, NUM_COLORS)), 3); break;
            case 54: fillTop(400, new int[]{ CURRENT_COLOR, CURRENT_COLOR_2, int(random(NUM_COLORS)), CURRENT_COLOR_2, CURRENT_COLOR }); break;
            case 55: fillBottom(400, new int[]{ CURRENT_COLOR, CURRENT_COLOR_2, int(random(NUM_COLORS)), CURRENT_COLOR_2, CURRENT_COLOR }); break;
            case 56: stripes(50, new int[]{ CURRENT_COLOR, CURRENT_COLOR_2 }, 1, 1); break;
            case 57: stripes(50, new int[]{ CURRENT_COLOR, CURRENT_COLOR_2 }, 2, 2); break;
            case 58: stripes(50, new int[]{ CURRENT_COLOR, CURRENT_COLOR_2 }, 2, 3); break;
            case 59: stripes(50, new int[]{ CURRENT_COLOR, CURRENT_COLOR_2 }, 3, 2); break;
            case 60: stripes(50, new int[]{ CURRENT_COLOR, CURRENT_COLOR_2 }, 1, 1); break;
            case 61: stripes(50, new int[]{ CURRENT_COLOR, CURRENT_COLOR_2 }, 2, 0); break;
            case 62: stripes(50, new int[]{ CURRENT_COLOR, CURRENT_COLOR_2 }, 1, 0); break;
            case 63: stripes(50, new int[]{ CURRENT_COLOR, CURRENT_COLOR_2 }, 4, 3); break;
            case 64: stripes(50, new int[]{ BLACK, int(random(2, NUM_COLORS)) }, 1, 0); break;
            case 65: stripes(50, new int[]{ BLACK, int(random(2, NUM_COLORS)) }, 1, 1); break;
            case 66: stripes(50, new int[]{ BLACK, int(random(2, NUM_COLORS)), BLACK }, 1, 0); break;
            case 67: stripes(50, new int[]{ BLACK, int(random(2, NUM_COLORS)), BLACK }, 1, 1); break;
            case 68: stripesLeft(50, new int[]{ CURRENT_COLOR, CURRENT_COLOR_2 }, 1, 1); break;
            case 69: stripesLeft(50, new int[]{ CURRENT_COLOR, CURRENT_COLOR_2 }, 2, 2); break;
            case 70: stripesLeft(50, new int[]{ CURRENT_COLOR, CURRENT_COLOR_2 }, 2, 3); break;
            case 71: stripesLeft(50, new int[]{ CURRENT_COLOR, CURRENT_COLOR_2 }, 3, 2); break;
            case 72: stripesLeft(50, new int[]{ CURRENT_COLOR, CURRENT_COLOR_2 }, 1, 1); break;
            case 73: stripesLeft(50, new int[]{ CURRENT_COLOR, CURRENT_COLOR_2 }, 2, 0); break;
            case 74: stripesLeft(50, new int[]{ CURRENT_COLOR, CURRENT_COLOR_2 }, 1, 0); break;
            case 75: stripesLeft(50, new int[]{ CURRENT_COLOR, CURRENT_COLOR_2 }, 4, 3); break;
            case 76: stripesLeft(50, new int[]{ BLACK, int(random(2, NUM_COLORS)) }, 1, 0); break;
            case 77: stripesLeft(50, new int[]{ BLACK, int(random(2, NUM_COLORS)) }, 1, 1); break;
            case 78: stripesLeft(50, new int[]{ BLACK, int(random(2, NUM_COLORS)), BLACK }, 1, 0); break;
            case 79: stripesLeft(50, new int[]{ BLACK, int(random(2, NUM_COLORS)), BLACK }, 1, 1); break;
            case 80: SG(200, CURRENT_COLOR); break;
            case 81: SG(200, CURRENT_COLOR, CURRENT_COLOR_2); break;
            case 82: SG(200, CURRENT_COLOR); break;
            case 83: SG(200, CURRENT_COLOR, CURRENT_COLOR_2); break;
            case 84: SG(200, CURRENT_COLOR); break;
        }
    }

    if(n != anim) {
        randomCurrentColors();
        repetition++;

        if(repetition == nbRepetition) {
            currentAnim = int(random(6, NUM_ANIMS));
            //currentAnim = 81;
            println("currentAnim: " + currentAnim);

            // nbRepetition = int(random(1, 4));
            nbRepetition = 1;
            repetition = 0;
        }
    }


    // Display
    background(0);
    shape(casier, 0, 0);

    for (int i = 0; i < NUM_LINES; i ++) {
        frontPixels[i].display();
        backPixels[i].display();
    }
}

void keyPressed() {
    if(key == ' ') {
        play = !play;
        println("play: " + play);
    }
}
