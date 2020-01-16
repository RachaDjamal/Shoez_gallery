void resetSegments() {
    for(int i = 0; i < NUM_LINES; i++) {
        segmentStates[i] = 0;
    }
}

void setLine(int index, int from, int to, int c) { 
    if(index >= 0 && index < NUM_LINES) {
        int brightness = 80;
        backPixels[index].setBrightness(brightness);
        frontPixels[index].setBrightness(brightness);

        from = constrain(from, 0, NUM_PIXELS);
        to = constrain(to, 0, NUM_PIXELS);
        if(from > to) {
            int tmp = from;
            from = to;
            to = tmp;
        }

        for (int j = from; j < to; j++) {
            backPixels[index].setPixelColor(j, c);
            frontPixels[index].setPixelColor(j, c);
        }

        backPixels[index].show();
        frontPixels[index].show();
    }
}

void setLine(int index, int c) { 
    setLine(index, 0, NUM_PIXELS, c);
}

void setAllLines(int c) {
    for (int i = 0; i < NUM_LINES; i ++) {
        setLine(i, c);
    }
}

void setSegment(int lineIndex, int segmentIndex, int c) {
    if(lineIndex >= 0 && lineIndex < NUM_LINES && segmentIndex >= 0 && segmentIndex < NUM_SEGMENTS) {
        int brightness = 80;
        backPixels[lineIndex].setBrightness(brightness);
        frontPixels[lineIndex].setBrightness(brightness);

        int back_from = backSegments[lineIndex][segmentIndex];
        int back_to = backSegments[lineIndex][segmentIndex + 1];
        int front_from = frontSegments[lineIndex][segmentIndex];
        int front_to = frontSegments[lineIndex][segmentIndex + 1];
        int from = min(back_from, front_from);
        int to = max(back_to, front_to);

        for (int j = from; j < to; j++) {
            if(j >= back_from && j < back_to) backPixels[lineIndex].setPixelColor(j, c);
            if(j >= front_from && j < front_to) frontPixels[lineIndex].setPixelColor(j, c);
        }
    }
}

void nextAnim() {
    anim ++;
    animStep = 0;
    timestamp = millis();
}

// utility anim to wait
void wait(int duration) {
    if(timer > duration) nextAnim();
}

/*
1111111111      2222222222      1111111111
1111111111      2222222222      1111111111
1111111111  ->  2222222222  ->  1111111111
1111111111      2222222222      1111111111
1111111111      2222222222      1111111111
*/
void blink(int time, int c, int c2, int n) {
    if(timer < time/2 && animStep % 2 == 0) {
        setAllLines(c);
        animStep ++;
    }
    else if(timer >= time/2 && animStep % 2 == 1) {
        setAllLines(c2);
        animStep ++;
    }
    else if(timer >= time) {
        if(animStep == n * 2) {
            nextAnim();
        }
        else {
            timestamp = millis();
        }
    }
}

/*
1111111111      2222222222      1111111111
2222222222      1111111111      2222222222
1111111111  ->  2222222222  ->  1111111111
2222222222      1111111111      2222222222
1111111111      2222222222      1111111111
*/
void blinkOdd(int time, int c, int c2, int n) {
    if(timer < time/2 && animStep % 2 == 0) {
        for(int y = 0; y < NUM_LINES; y++){
            setLine(y, y % 2 == 0 ? c : c2);
        }
        animStep++;
    }
    else if(timer >= time/2 && animStep % 2 == 1) {
        for(int y = 0; y < NUM_LINES; y++){
            setLine(y, y % 2 == 0 ? c2 : c);
        }
        animStep++;
    }
    else if(timer >= time) {
        if(animStep == n * 2) {
            nextAnim();
        }
        else {
            timestamp = millis();
        }
    }
}

/*
1111111111      1111111111      1111111111
..........      1111111111      1111111111
..........  ->  ..........  ->  1111111111
..........      ..........      ..........
..........      ..........      ..........
*/
void fillTop(int time, int[] c) {
    if(timer > time) {
        timestamp = millis();
        setLine(animStep, c[animStep % c.length]);
        animStep ++;
        if(animStep >= NUM_LINES) nextAnim();
    }
}

void fillTop(int time, int c) {
    fillTop(time, new int[]{ c });
}

/*
..........      ..........      ..........
..........      ..........      ..........
..........  ->  ..........  ->  1111111111
..........      1111111111      1111111111
1111111111      1111111111      1111111111
*/
void fillBottom(int time, int[] c) {
    if(timer > time) {
        timestamp = millis();
        setLine(NUM_LINES - (animStep + 1), c[animStep % c.length]); // turn on line
        animStep ++;
        if(animStep >= NUM_LINES) nextAnim();
    }
}

void fillBottom(int time, int c) {
    fillBottom(time, new int[]{ c });
}

/*
........11      ......1111      ....111111
........11      ......1111      ....111111
........11  ->  ......1111  ->  ....111111
........11      ......1111      ....111111
........11      ......1111      ....111111
*/
void fillRight(int time, int[] c, int speedX, int delayY) {
    if(timer > time) {
        timestamp = millis();
        animStep ++;

        int x = animStep * speedX;

        for(int y = 0; y < NUM_LINES; y++) {
            int d = delayY > 0 ? y * delayY : -(NUM_LINES - 1 - y) * delayY;
            setLine(y, x - speedX - d, x - d, c[y % c.length]);
        }

        if(x > NUM_PIXELS + max((NUM_LINES - 1) * delayY, -(NUM_LINES - 1) * delayY)) {
            nextAnim();
        }
    }
}

void fillRight(int time, int c, int speedX, int delayY) {
    fillRight(time, new int[]{ c }, speedX, delayY);
}

void fillRight(int time, int c, int speedX) {
    fillRight(time, new int[]{ c }, speedX, 0);
}

void fillRight(int time, int c) {
    fillRight(time, new int[]{ c }, 10, 0);
}

/*
11........      1111......      111111....
11........      1111......      111111....
11........  ->  1111......  ->  111111....
11........      1111......      111111....
11........      1111......      111111....
*/
void fillLeft(int time, int[] c, int speedX, int delayY) {
    if(timer > time) {
        timestamp = millis();
        animStep ++;

        int x = NUM_PIXELS - (animStep * speedX);

        for(int y = 0; y < NUM_LINES; y++) {
            int d = delayY > 0 ? y * delayY : -(NUM_LINES - 1 - y) * delayY;
            setLine(y, x + d, x + speedX + d, c[y % c.length]);
        }

        if(x < -max((NUM_LINES - 1) * delayY, -(NUM_LINES - 1) * delayY)) {
            nextAnim();
        }
    }
}

void fillLeft(int time, int c, int speedX, int delayY) {
    fillLeft(time, new int[]{ c }, speedX, delayY);
}

void fillLeft(int time, int c, int speedX) {
    fillLeft(time, new int[]{ c }, speedX, 0);
}

void fillLeft(int time, int c) {
    fillLeft(time, new int[]{ c }, 10, 0);
}

/*
..........      ..........      ....1.....
..........      .1........      .1........
..........  ->  ..........  ->  ..........
.....1....      .....1....      .....1....
..........      ..........      ..........
*/
void randomSegment(int time, int c, int n) {
    if(timer > time) {
        timestamp = millis();

        int x = int(random(NUM_SEGMENTS));
        int y = int(random(NUM_LINES));
        setSegment(y, x, c);

        backPixels[y].show();
        frontPixels[y].show();

        animStep ++;
        if(animStep == n) nextAnim();
    }
}

/*
..........      ........11      ........11
..........      .........1      ........11
.........1  ->  .........1  ->  ........11
.........1      .........1      ........11
.........1      .........1      .........1
*/
void snake(int time, int c, int direction) {
    if(timer > time) {
        timestamp = millis();
        
        int x, y;
        boolean limit;

        if(direction == 0) {
            x = animStep / NUM_LINES;
            int mod = animStep % NUM_LINES;
            y = x % 2 == 0 ? mod : NUM_LINES - 1 - mod;
            limit = x == NUM_SEGMENTS;
        }
        else if(direction == 1) {
            y = animStep / NUM_SEGMENTS;
            int mod = animStep % NUM_SEGMENTS;
            x = y % 2 == 0 ? mod : NUM_SEGMENTS - 1 - mod;
            limit = y == NUM_LINES;
        }
        else if(direction == 2) {
            x = NUM_SEGMENTS - 1 - (animStep / NUM_LINES);
            int mod = animStep % NUM_LINES;
            y = x % 2 == 0 ? mod : NUM_LINES - 1 - mod;
            limit = x == -1;
        }
        else {
            y = NUM_LINES - 1 - (animStep / NUM_SEGMENTS);
            int mod = animStep % NUM_SEGMENTS;
            x = y % 2 == 0 ? mod : NUM_SEGMENTS - 1 - mod;
            limit = y == -1;
        }

        animStep ++;

        if(limit) nextAnim();
        else {
            setSegment(y, x, c);

            backPixels[y].show();
            frontPixels[y].show();
        }
    }
}

/*
.........1      ........21      .......121
..........      .........2      ........12
..........  ->  ..........  ->  .........1
..........      ..........      ..........
..........      ..........      ..........
*/
void stripes(int time, int[] c, int w, int delayY) {
    if(timer > time) {
        timestamp = millis();

        w = max(1, w);
        delayY = max(0, delayY);

        for(int y = 0; y < NUM_LINES; y++) {
            int x = animStep - y * delayY;
            setSegment(y, x, c[((x + y * delayY) / w) % c.length]);
        }
        
        for(int y = 0; y < NUM_LINES; y++) {
            backPixels[y].show();
            frontPixels[y].show();
        }

        animStep ++;
        if(animStep >= NUM_SEGMENTS + NUM_LINES * delayY) nextAnim();
    }
}

void stripes(int time, int c, int c2) {
    stripes(time, new int[]{ c, c2 }, 1, 0);
}

/*
1.........      12........      121.......
..........      2.........      21........
..........  ->  ..........  ->  1.........
..........      ..........      ..........
..........      ..........      ..........
*/
void stripesLeft(int time, int[] c, int w, int delayY) {
    if(timer > time) {
        timestamp = millis();

        w = max(1, w);
        delayY = max(0, delayY);

        for(int y = 0; y < NUM_LINES; y++) {
            int x = NUM_SEGMENTS - 1 - (animStep - y * delayY);
            if(x >= 0) setSegment(y, x, c[((x + y * delayY) / w) % c.length]);
        }

        for(int y = 0; y < NUM_LINES; y++) {
            backPixels[y].show();
            frontPixels[y].show();
        }

        animStep ++;
        if(animStep >= NUM_SEGMENTS + NUM_LINES * delayY) nextAnim();
    }
}

void stripesLeft(int time, int c, int c2) {
    stripesLeft(time, new int[]{ c, c2 }, 1, 0);
}

/*
X.X.X.X.X.      .X.X.X.X.X      X.X.X.X.X.      .X.X.X.X.X
..........      X.X.X.X.X.      .X.X.X.X.X      X.X.X.X.X.
..........  ->  ..........  ->  X.X.X.X.X.  ->  .X.X.X.X.X
..........      ..........      ..........      X.X.X.X.X.
..........      ..........      ..........      ..........
*/
long[] SG = { 
    258311801030517L, 
    152454768641109L, 
    262432256968549L, 
    46903279764562L, 
    258311804385106L 
};

void SG(int time, int c, int c2) {
    if(timer > time) {
        timestamp = millis();

        if(animStep == 0) resetSegments();

        int t = animStep < 50 ? 50 - animStep : animStep - 50;
        for(int y = 0; y < NUM_LINES; y++) {
            long u = animStep < 50 ? SG[y] >> t : SG[y] << t;
            for(int x = 0; x < min(animStep, NUM_SEGMENTS); x++) {
                if(((u >> x) & 1) == 1) setSegment(y, x, c);
                else setSegment(y, x, c2);
            }
        }
        
        for(int y = 0; y < NUM_LINES; y++) {
            backPixels[y].show();
            frontPixels[y].show();
        }

        animStep ++;
        if(animStep > 50 + NUM_SEGMENTS) nextAnim();
    }
}

void SG(int time, int c) {
    SG(time, c, BLACK);
}
// void checker() {
// }
