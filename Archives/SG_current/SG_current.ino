#include <Adafruit_NeoPixel.h>

#define USE_SERIAL false
#define WHITE Color(255, 100, 20)
#define WHITE2 Color(255, 255, 150)
#define BLACK Color(0, 0, 0)
#define RED Color(255, 0, 0)

#define NUM_PIXELS 400
#define NUM_LINES 5

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

    turnAllOff();
    delay(2000);
}

void turnAllOff() {
    for (int i = 0; i < NUM_LINES; i ++) {
        turnLineOff(i);
    }
}

void turnAllOn() {
    for (int i = 0; i < NUM_LINES; i ++) {
        turnLineOn(i, 0, NUM_PIXELS);
    }
}

void turnLineOff(int index) { 
    frontPixels[index].begin();
    backPixels[index].begin();

    int brightness = 10;
    frontPixels[index].setBrightness(brightness);
    backPixels[index].setBrightness(brightness);

    for (int j = 0; j < NUM_PIXELS; j++) {
        frontPixels[index].setPixelColor(j, frontPixels[index].BLACK);
        backPixels[index].setPixelColor(j, backPixels[index].BLACK);
    }

    frontPixels[index].show();
    backPixels[index].show();
}

void turnLineOn(int index, int from, int to) { 
    frontPixels[index].begin();
    backPixels[index].begin();

    int brightness = 80;
    frontPixels[index].setBrightness(brightness);
    backPixels[index].setBrightness(brightness);

    for (int j = from; j < to; j++) {
        frontPixels[index].setPixelColor(j, frontPixels[index].WHITE);
        backPixels[index].setPixelColor(j, backPixels[index].WHITE);
    }

    frontPixels[index].show();
    backPixels[index].show();
}

void setPixelWhite(int index, int pixelIndex) {
    frontPixels[index].begin();
    backPixels[index].begin();

    int brightness = 80;
    frontPixels[index].setBrightness(brightness);
    backPixels[index].setBrightness(brightness);

    frontPixels[index].setPixelColor(pixelIndex, frontPixels[index].WHITE);
    backPixels[index].setPixelColor(pixelIndex, backPixels[index].WHITE);

    frontPixels[index].show();
    backPixels[index].show();
}

void blink() {
    turnAllOn();
    delay(1000);
    turnAllOff();
    delay(1000);
}

void oneLiner() {
    static int index = 0;
    turnLineOn(index, 0, NUM_PIXELS);

    delay(1000);
    turnLineOff(index);

    index = (index + 1) % NUM_LINES;
}

void fillIn() {
    for(int i=0; i<NUM_PIXELS; i+=2){
        for(int index=0; index<NUM_LINES; index++){
            frontPixels[index].begin();
            backPixels[index].begin();

            int brightness = 80;
            frontPixels[index].setBrightness(brightness);
            backPixels[index].setBrightness(brightness);

            for (int j = 0; j < i; j++) {
                frontPixels[index].setPixelColor(j, frontPixels[index].RED);
                backPixels[index].setPixelColor(j, backPixels[index].RED);
            }

            frontPixels[index].show();
            backPixels[index].show();
        }
    }

    turnAllOff();
}


void segments() {
    //turnAllOff();
    static int rw = true;
    for(int i=0; i<NUM_SEGMENTS; i++){
        for(int l = 0; l<NUM_LINES; l++) {
            frontPixels[l].begin();
            backPixels[l].begin();

            int brightness = 80;
            frontPixels[l].setBrightness(brightness);
            backPixels[l].setBrightness(brightness);
            
            for (int j = frontSegments[l][i]-1; j < frontSegments[l][i+1]; j++) {
                frontPixels[l].setPixelColor(j, rw ? frontPixels[l].RED : frontPixels[l].BLACK);
            }
            for (int j = backSegments[l][i]-1; j < backSegments[l][i+1]; j++) {
                backPixels[l].setPixelColor(j, rw ? backPixels[l].RED : backPixels[l].BLACK);
            }
            frontPixels[l].show();
            backPixels[l].show();
            
            // frontPixels[l].setBrightness(0);
            // backPixels[l].setBrightness(0);
            // for (int j = frontSegments[l][i]; j < frontSegments[l][i+1]; j++) {
            //     frontPixels[l].setPixelColor(j, frontPixels[l].RED);
            // }

            // for (int j = backSegments[l][i]; j < backSegments[l][i+1]; j++) {
            //     backPixels[l].setPixelColor(j, backPixels[l].RED);
            // }
        }
    }
    rw = !rw;
}

void loop() {
    static int anim = 0;
    int animIndex = (millis() / 10000) % 4;

    if(anim != animIndex) {
        turnAllOff();
        anim = animIndex;
    }

    switch(anim){
        case 0:
            blink();
            break;
        case 1:
            oneLiner();
            break;
        case 2:
            fillIn();
            break;
        case 3:
            segments();
            break;
    }

    // index = (index + 1) % NUM_LINES;
}

void serialEvent(){

}
