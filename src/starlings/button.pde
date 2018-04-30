// Button Class
class Button {
    // class vars
    int buttonX;
    int buttonY;
    int buttonWidth;
    int buttonHeight;
    int mouseposX;
    int mouseposY;
    boolean overButton;

    color buttonColor;
    color buttonHighlight;

    String text;

    Button (int _buttonX, int _buttonY, int _buttonWidth, int _buttonHeight, String _text) {
        buttonX = _buttonX;
        buttonY = _buttonY;
        buttonWidth = _buttonWidth;
        buttonHeight = _buttonHeight;

        buttonColor = color(20, 200, 100);
        buttonHighlight = color(10, 100, 50);

        text = _text;
    }

    void draw() {

        // draw a button
        if (!this.isOver()) {
            fill(buttonColor);
        } else {
            fill(buttonHighlight);
        }

        rect(buttonX, buttonY, buttonWidth, buttonHeight);
        fill(250, 250, 250);

        textSize(18);
        text(text, buttonX + 50, buttonY + 25);
        textSize(12);
    }

    boolean isOver () {
        // Check if mouse is over the button
        if (mouseX >= buttonX && mouseX <= buttonX + buttonWidth &&
            mouseY >= buttonY && mouseY <= buttonY + buttonHeight) {
            return true;
        } else {
            return false;
        }
    }
}

