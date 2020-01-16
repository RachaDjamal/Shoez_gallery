#include <Adafruit_NeoPixel.h>

#define USE_SERIAL false
#define NUM_COLORS 11

#define RED colors[0]
#define GREEN colors[1]
#define BLUE colors[2]
#define CYAN colors[3]
#define MAGENTA colors[4]
#define YELLOW colors[5]
#define MINT colors[6]
#define PINK colors[7]
#define MOJITO colors[8]
#define WHITE colors[NUM_COLORS-2]
#define BLACK colors[NUM_COLORS-1]

#define NUM_PIXELS 400
#define NUM_LINES 5

#define NUM_ANIMS 7

int anim = 0;
uint32_t colors[NUM_COLORS];

int backPins[ NUM_LINES ] = { 42, 53, 30, 33, 41 };
int frontPins[ NUM_LINES ] = { 26, 49, 45, 34, 38 };

#define NUM_SEGMENTS 20

int backSegments[NUM_LINES][NUM_SEGMENTS + 1] = {
    { 0, 21, 40, 59, 79, 98, 117, 136, 155, 174, 193, 212, 232, 251, 269, 288, 308, 327, 346, 364, 381 },
    { 0, 20, 40, 60, 80, 99, 118, 138, 158, 178, 196, 217, 237, 257, 277, 297, 316, 337, 356, 376, 398 },
    { 0, 20, 39, 60, 79, 98, 117, 136, 156, 175, 194, 213, 233, 253, 272, 291, 311, 330, 349, 368, 386 },
    { 0, 20, 39, 60, 79, 98, 117, 137, 156, 176, 196, 215, 236, 255, 275, 294, 314, 333, 352, 372, 390 },
    { 0, 21, 40, 61, 80, 99, 118, 137, 157, 176, 196, 215, 235, 254, 274, 292, 312, 332, 351, 370, 388 }
};

int frontSegments[NUM_LINES][NUM_SEGMENTS + 1] = {
    { 0, 21, 40, 59, 79, 98, 117, 136, 155, 174, 193, 212, 231, 250, 269, 288, 307, 326, 345, 364, 380 },
    { 0, 19, 39, 59, 79, 98, 117, 137, 157, 176, 196, 216, 237, 256, 277, 296, 316, 336, 356, 376, 391 },
    { 0, 19, 38, 58, 78, 97, 116, 135, 155, 174, 194, 214, 234, 254, 273, 292, 312, 331, 351, 370, 388 },
    { 0, 20, 39, 60, 79, 98, 118, 138, 157, 177, 196, 215, 235, 255, 274, 293, 313, 332, 352, 371, 388 },
    { 0, 20, 40, 60, 79, 98, 118, 137, 157, 176, 196, 215, 235, 255, 274, 293, 313, 332, 351, 370, 388 }  // pb soudure sur denier segment 373
};

Adafruit_NeoPixel frontPixels[ NUM_LINES ];
Adafruit_NeoPixel backPixels[ NUM_LINES ];

void setup() {
    #ifdef USE_SERIAL
        Serial.begin(9600);
    #endif
   
    // instantiate all lines
    for (int i = 0; i < NUM_LINES; i ++) {
        frontPixels[ i ] = Adafruit_NeoPixel(NUM_PIXELS, frontPins[ i ], NEO_GRB + NEO_KHZ800);
        backPixels[ i ] = Adafruit_NeoPixel(NUM_PIXELS, backPins[ i ], NEO_GRB + NEO_KHZ800);
    }
    
    colors[0] = frontPixels[0].Color(255, 0, 0);// RED
    colors[1] = frontPixels[0].Color(0, 255, 0); // GREEN
    colors[2] = frontPixels[0].Color(0, 0, 255);// BLUE
    colors[3] = frontPixels[0].Color(0, 255, 255);// CYAN
    colors[4] = frontPixels[0].Color(255, 0, 255);// MAGENTA
    colors[5] = frontPixels[0].Color(255, 160, 0);// YELLOW
    colors[6] = frontPixels[0].Color(80, 180, 10);// MINT
    colors[7] = frontPixels[0].Color(255, 0, 128);// PINK
    colors[8] = frontPixels[0].Color(120, 255, 50);// MOJITO
    colors[NUM_COLORS-2] = frontPixels[0].Color(255, 135, 50);//WHITE
    colors[NUM_COLORS-1] = frontPixels[0].Color(0, 0, 0);//BLACK

    turnAllOn(WHITE);
}
    
uint32_t getRandomColor() {
    int static current = 0;
    current = (current + 1) % (NUM_COLORS - 2);
    return colors[current];
}

void setLineColor(int index, int from, int to, uint32_t color) { 
    frontPixels[index].begin();
    backPixels[index].begin();

    int brightness = 80;
    frontPixels[index].setBrightness(brightness);
    backPixels[index].setBrightness(brightness);

    for (int j = from; j < to; j++) {
        frontPixels[index].setPixelColor(j, color);
        backPixels[index].setPixelColor(j, color);
    }

    frontPixels[index].show();
    backPixels[index].show();
}

void turnAllOff() {
    for (int i = 0; i < NUM_LINES; i ++) {
        setLineColor(i, 0, NUM_PIXELS, BLACK);
    }
}

void turnAllOn(uint32_t color) {
    for (int i = 0; i < NUM_LINES; i ++) {
        setLineColor(i, 0, NUM_PIXELS, color);
    }
}

/****************
* animations
****************/
void blink() {
    uint32_t currentColor = getRandomColor();
    turnAllOn(currentColor);
    delay(500);
    turnAllOff();
    delay(500);
}

void oneLiner() {
    uint32_t currentColor = getRandomColor();
    for(int i=0; i<NUM_LINES; i++) {
        setLineColor(i, 0, NUM_PIXELS, currentColor);
        delay(300);
        setLineColor(i, 0, NUM_PIXELS, BLACK);
    }
}

void oneLinerRainbow() {
    for(int i=0; i<NUM_LINES; i++) {
        uint32_t currentColor = getRandomColor();
        setLineColor(i, 0, NUM_PIXELS, currentColor);
        delay(300);
        setLineColor(i, 0, NUM_PIXELS, BLACK);
    }
}

void fillIn() {
    uint32_t currentColor = getRandomColor();
    for(int i=0; i<NUM_PIXELS; i += 5) { // turn pixels on 5 by 5 to speed up things
        for(int index=0; index<NUM_LINES; index++){
            frontPixels[index].begin();
            backPixels[index].begin();

            int brightness = 80;
            frontPixels[index].setBrightness(brightness);
            backPixels[index].setBrightness(brightness);

            for (int j = 0; j < i; j++) {
                frontPixels[index].setPixelColor(j, currentColor);
                backPixels[index].setPixelColor(j, currentColor);
            }

            frontPixels[index].show();
            backPixels[index].show();
        }
    }

    turnAllOff();
}

void segments() {
    uint32_t currentColor = getRandomColor();
    static int rw = true;
    for(int m=0; m<2; m ++) {
        for(int i=0; i<NUM_SEGMENTS; i++){
            for(int l = 0; l<NUM_LINES; l++) {
                frontPixels[l].begin();
                backPixels[l].begin();

                int brightness = 80;
                frontPixels[l].setBrightness(brightness);
                backPixels[l].setBrightness(brightness);
                
                for (int j = frontSegments[l][i]-1; j < frontSegments[l][i+1]; j++) {
                    frontPixels[l].setPixelColor(j, rw ? currentColor : BLACK);
                }
                for (int j = backSegments[l][i]-1; j < backSegments[l][i+1]; j++) {
                    backPixels[l].setPixelColor(j, rw ? currentColor : BLACK);
                }
                frontPixels[l].show();
                backPixels[l].show();
            }
        }
        rw = !rw;
    }
}

/*void segments2() {
    uint32_t currentColor = getRandomColor();
    static int rw = true;
    for(int m=0; m<2; m++){
        for(int l = 0; l<NUM_LINES; l++) {
            for(int i=0; i<NUM_SEGMENTS; i++){
                frontPixels[l].begin();
                backPixels[l].begin();

                int brightness = 80;
                frontPixels[l].setBrightness(brightness);
                backPixels[l].setBrightness(brightness);
                
                for (int j = frontSegments[l][i]-1; j < frontSegments[l][i+1]; j++) {
                    frontPixels[l].setPixelColor(j, rw ? currentColor : BLACK);
                }
                for (int j = backSegments[l][i]-1; j < backSegments[l][i+1]; j++) {
                    backPixels[l].setPixelColor(j, rw ? currentColor : BLACK);
                }
                frontPixels[l].show();
                backPixels[l].show();
            }
        }
        rw = !rw;
    }
}

void segments3() {
    uint32_t currentColor = getRandomColor();
    static int rw = true;
    for(int m=0; m<2; m++){
        for(int l = 0; l<NUM_LINES; l++) {
            for(int i=0; i<NUM_SEGMENTS; i++){
                frontPixels[l].begin();
                backPixels[l].begin();

                int brightness = 80;
                frontPixels[l].setBrightness(brightness);
                backPixels[l].setBrightness(brightness);
                
                for (int j = frontSegments[l][i]-1; j < frontSegments[l][i+1]; j++) {
                    frontPixels[l].setPixelColor(j, rw ? currentColor : BLACK);
                }
                for (int j = backSegments[l][i]-1; j < backSegments[l][i+1]; j++) {
                    backPixels[l].setPixelColor(j, rw ? currentColor : BLACK);
                }
                frontPixels[l].show();
                backPixels[l].show();
            }
        }
        rw = !rw;
    }
}

void segmentsRainbow() {
    for(int a=0; a<NUM_COLORS; a++) {
        for(int i=0; i<NUM_SEGMENTS; i++) {
            for(int l = 0; l<NUM_LINES; l++) {
                frontPixels[l].begin();
                backPixels[l].begin();

                int brightness = 80;
                frontPixels[l].setBrightness(brightness);
                backPixels[l].setBrightness(brightness);
                
                for (int j = frontSegments[l][i]-1; j < frontSegments[l][i+1]; j++) {
                    frontPixels[l].setPixelColor(j, colors[i]);
                }
                for (int j = backSegments[l][i]-1; j < backSegments[l][i+1]; j++) {
                    backPixels[l].setPixelColor(j, colors[i]);
                }
                frontPixels[l].show();
                backPixels[l].show();
            }
        }
    }
    turnAllOff();
}*/

void strob() {
    //uint32_t currentColor = getRandomColor();
    turnAllOn(WHITE);
    delay(20);
    turnAllOff();
    delay(20);
}

void strob_color() {
    uint32_t currentColor = getRandomColor();
    turnAllOn(currentColor);
    delay(20);
    turnAllOff();
    delay(20);
}

///////////////////////////////
void loop() {
    unsigned long time = (millis() / 1000);
    delay(20);

    if (time > 34500) {
        switch(anim){
            case 0:
                for (int repeat=0; repeat<6; repeat++) {
                    blink();
                }
                break;
            case 1:
                for (int repeat=0; repeat<5; repeat++) {
                    oneLiner();
                }
                break;
            case 2:
                for (int repeat=0; repeat<4; repeat++) {
                    segments();
                }
                break;
            case 3:
                for (int repeat=0; repeat<5; repeat++) {
                    oneLinerRainbow();
                }
                break;
            case 4:
                fillIn();
                break;
            case 5:
                for (int repeat=0; repeat<15; repeat++) {
                strob();
                }
                break;
            case 6:
                for (int repeat=0; repeat<15; repeat++) {
                strob_color();
                }
                break;
        }

        anim = ++anim % NUM_ANIMS;
    }
}
