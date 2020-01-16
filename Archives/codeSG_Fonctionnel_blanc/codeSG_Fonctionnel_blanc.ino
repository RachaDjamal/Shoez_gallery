£
#include <Adafruit_NeoPixel.h>

#define USE_SERIAL true
#define WHITE Color( 255, 135, 50 )

#define NUM_PIXELS 400
#define NUM_LINES 5

int backPins[ NUM_LINES ] = { 33, 41, 45, 49, 53 };
int frontPins[ NUM_LINES ] = { 26, 30, 34, 38, 42 };

Adafruit_NeoPixel frontPixels[ NUM_LINES ];
Adafruit_NeoPixel backPixels[ NUM_LINES ];

int sensorPin = A1;

void setup() {
  #ifdef USE_SERIAL
    Serial.begin( 9600 );
  #endif

  for( int i=0; i < NUM_LINES; i ++ ){
    frontPixels[ i ] = Adafruit_NeoPixel( NUM_PIXELS, frontPins[ i ], NEO_GRB + NEO_KHZ800 );
    frontPixels[ i ].begin();
    backPixels[ i ] = Adafruit_NeoPixel( NUM_PIXELS, backPins[ i ], NEO_GRB + NEO_KHZ800 );
    backPixels[ i ].begin();
 
  
  int sensorValue = analogRead( sensorPin );
  int brightness = map( sensorValue, 0, 1023, 0, 255 );
  brightness = 80 ;

  for( int i=0; i < NUM_LINES; i ++ ){
    frontPixels[ i ].setBrightness( brightness );
    backPixels[ i ].setBrightness( brightness );
    
    for(int j=0; j < NUM_PIXELS; j++ ){
      frontPixels[ i ].setPixelColor( j, frontPixels[ i ].WHITE );
      backPixels[ i ].setPixelColor( j, backPixels[ i ].WHITE );
    }
    
    frontPixels[ i ].show();
    backPixels[ i ].show();
  }
  
 }
}
void loop() { 
}
