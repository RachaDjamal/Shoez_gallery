class NeoPixel {
    Pixel[] pixels;
    int index;
    int depth;
    boolean started = false;

    NeoPixel(int _index, int _depth) {
        index = _index;
        depth = _depth;
        pixels = new Pixel[NUM_PIXELS];

        int y = -H/2 + index * CASE_SIZE;
        int z = int(depth * (CASE_SIZE / 2. * 3. / 4.));
        for(int i = 0; i < pixels.length; i++) {
            int x = int((W - W/NUM_PIXELS) / 2 - (i + 1.) / (pixels.length + 2.) * W);
            pixels[i] = new Pixel(x, y, z);
        }
    }

    void begin() {
        started = true;
    }

    void setBrightness(int b) {
        if(started) {
            for(Pixel p : pixels) {
                p.setBrightness(b);
            }
        }
        else {
            println("You need to call NeoPixel.begin() before using NeoPixel.setBrightness(...)");
        }
    }

    void setPixelColor(int index, int c) {
        if(started) {
            pixels[index].setColor(c);
        }
        else {
            println("You need to call NeoPixel.begin() before using NeoPixel.setPixelColor(...)");
        }
    }

    void clear() {
        for(int i = 0; i < pixels.length; i++) {
            pixels[index].setColor(BLACK);
        }
    }
    
    void show() {
        // started = false;
    }

    void display() {
        for(int i = 0; i < pixels.length; i ++) {
            pixels[i].display();
        }
    }
}
