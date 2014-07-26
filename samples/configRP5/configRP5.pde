Button enter, nojruby;
String processingRoot = "enter your processing root here"; // edit this line in the sketch
String done = "Done";
String OS = System.getProperty("os.name").toLowerCase();
String home, suggestion, separator, root;
PFont font;
StringBuilder header = new StringBuilder(200);
float rectX, rectX2, rectY;      // Position of buttons
float rectHeight = 30;           // height of rect
float rectWidth = 90;            // width of rect
int rectColor, rectColor2;
int rectHighlight, rectHighlight2;
int currentColor;
int selectedColor;
boolean acceptOver = false;
boolean noJruby = false;
boolean selected = false;
boolean no_jruby = false;


void setup() {
  size(600, 200);
  home = System.getProperty("user.home");
  File f = new File(home);
  root = f.getParent();
  separator = System.getProperty("file.separator");
  header.append("# YAML configuration file for ruby-processing\n");
  header.append("# RP5HOME: \"").append(root).append(separator).append("ruby193 ... ").append(separator);
  header.append("ruby-processing\" #windows users may need to set this\n");
  font = createFont("Helvetica", 18);
  if (OS.contains("mac")) {
    suggestion = "/Applications/Processing.app/Contents/Resources/Java";
  } else {
    suggestion = home + separator + "processing-2.2.1";
  }
  rectColor = color(140);
  rectColor2 = color(140);
  rectHighlight = color(100);
  rectHighlight2 = color(100);
  selectedColor = color(0);
  rectX = rectWidth + 20;
  rectX2 = rectWidth + 150;
  rectY = height * 0.8f - rectHeight / 4;
  enter = new Button(rectX2, rectY, rectWidth, rectHeight, "enter");
  nojruby = new Button(rectX, rectY, rectWidth, rectHeight, "nojruby");
}

void draw() {
  background(200);
  fill(0, 0, 200);
  text("Suggestion:", 35, 28);
  text(suggestion, 35, 56);
  textFont(font, 18);
  fill(255, 0, 0);
  // this adds a blinking cursor after your text, at the expense of redrawing everything every frame
  text(processingRoot + (frameCount / 10 % 2 == 0 ? "_" : ""), 35, 100);
  fill(0, 0, 200);
  text("Select nojruby to use jruby-complete by default", 35, 140);
  update(mouseX, mouseY);
  //background(200);

  if (acceptOver) {
    enter.draw(rectHighlight);
    nojruby.draw(rectHighlight2);
  } else {
    enter.draw(rectColor);
    nojruby.draw(rectColor2);
  }
}

void writeRoot() {
  rectColor = selectedColor;
  rectHighlight = selectedColor;
  header.append("PROCESSING_ROOT: \"").append(processingRoot).append("\"\n");
  if (no_jruby) {
    header.append("JRUBY: \'false\'\n");
  } else {
    header.append("JRUBY: \'true\'\n");
  }
  PrintWriter pw = createWriter(home + separator + ".rp5rc");
  pw.append(header);
  pw.flush();
  pw.close();
  processingRoot = done;
}

void keyReleased() {
  if (key != CODED) {
    switch (key) {
    case BACKSPACE:
      processingRoot = processingRoot.substring(0, max(0, processingRoot.length() - 1));
      break;
    case ENTER: // save the processing root to the config file
    case RETURN:
      writeRoot();
      break;
    case ESC:
    case DELETE:
      break;
    default:
      processingRoot += key;
    }
  }
}

void update(float x, float y) {
  acceptOver = enter.overRect();
  noJruby = nojruby.overRect();
}

void mouseClicked() {
  update(mouseX, mouseY);
  if (acceptOver) {
    rectColor = selectedColor;
    rectHighlight = selectedColor;
    writeRoot();
  }
  if (noJruby) {
    rectColor2 = selectedColor;
    rectHighlight2 = selectedColor;
    no_jruby = true;
  }
}

class Button {

  float x, y, w, h;
  String text;

  Button(float x, float y, float w, float h, String text) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.text = text;
  }

  void draw(int col) {
    fill(col);
    rect(x, y, w, h, 20, 20, 20, 20);
    fill(255);
    text(text, x + 8, y + 20);
  }

  boolean overRect() {
    return (mouseX >= x && mouseX <= x + w
      && mouseY >= y && mouseY <= y + h);
  }
}

