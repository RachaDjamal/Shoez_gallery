PShape createCasier() {
    PShape casier = createShape(GROUP);
    int w = CASE_SIZE;
    int hw = w/2;

    for (int x = 0; x < NUM_SEGMENTS; x ++) {
        for (int y = 0; y < NUM_LINES; y ++) {
            PShape s = createShape();
            s.setStroke(color(255, 255));
            // s.setFill(false);
            s.setFill(color(0));

            s.beginShape(QUAD_STRIP);
            s.vertex(-W/2 + w * x    , -H/2 + w * y    , -hw);
            s.vertex(-W/2 + w * x    , -H/2 + w * y    , +hw);
            s.vertex(-W/2 + w * x + w, -H/2 + w * y    , -hw);
            s.vertex(-W/2 + w * x + w, -H/2 + w * y    , +hw);
            s.vertex(-W/2 + w * x + w, -H/2 + w * y + w, -hw);
            s.vertex(-W/2 + w * x + w, -H/2 + w * y + w, +hw);
            s.vertex(-W/2 + w * x    , -H/2 + w * y + w, -hw);
            s.vertex(-W/2 + w * x    , -H/2 + w * y + w, +hw);
            s.vertex(-W/2 + w * x    , -H/2 + w * y    , -hw);
            s.vertex(-W/2 + w * x    , -H/2 + w * y    , +hw);
            s.endShape();

            casier.addChild(s);
        }
    }

    return casier;
}
