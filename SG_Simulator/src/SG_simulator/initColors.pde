    
void initColors() {
    colors = new PGraphics[NUM_COLORS];
    colors[BLACK] = createColorPGrahpics(color(0));
    colors[WHITE] = createColorPGrahpics(color(255));
    colors[RED] = createColorPGrahpics(color(231, 130, 69));
    colors[YELLOW] = createColorPGrahpics(color(253, 250, 101));
    colors[GREEN] = createColorPGrahpics(color(88, 179, 105));
    colors[CYAN] = createColorPGrahpics(color(73, 214, 210));
    colors[BLUE] = createColorPGrahpics(color(69, 194, 253));
    colors[PURPLE] = createColorPGrahpics(color(213, 40, 183));

    randomCurrentColors();
}

PGraphics createColorPGrahpics(color c) {
    int r = c >> 16 & 255;
    int g = c >> 8 & 255;
    int b = c & 255;

    PGraphics pg = createGraphics(1, 10);
    pg.beginDraw();
    pg.clear();
    for(int y = 0; y < pg.height; y++) {
        pg.stroke(r, g, b, (1 - y / float(pg.height - 1)) * 100);
        pg.line(0, y, pg.width, y);
    }
    pg.endDraw();

    return pg;
}

PGraphics createColorPGrahpics(int r, int g, int b) {
    return createColorPGrahpics(color(r, g, b));
}
