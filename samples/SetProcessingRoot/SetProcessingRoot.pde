String processingRoot = "enter your processing root here"; // edit this line in the sketch
String done = "Done";
String OS = System.getProperty("os.name").toLowerCase();
String home, suggestion, separator, root;
PFont font;
StringBuilder header = new StringBuilder(200);

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
  if (OS.indexOf("mac") >= 0) {
    suggestion = "/Applications/Processing.app/Contents/Resources/Java";
  }
  else {
    suggestion = home + separator + "processing-2.2.1";
  }
}

  void draw() {
    background(200);
    fill(0, 0, 200);
    text("Suggestion:", 35, 28);
    text(suggestion, 35, 56);
    textFont(font, 18);
    fill(255, 0, 0);
    // this adds a blinking cursor after your text, at the expense of redrawing everything every frame
    text(processingRoot+(frameCount/10 % 2 == 0 ? "_" : ""), 35, 100);
  }

  void keyReleased() {
    if (key != CODED) {
      switch(key) {
      case BACKSPACE:
        processingRoot = processingRoot.substring(0, max(0, processingRoot.length()-1));
        break;
      case ENTER: // save the processing root to the config file
      case RETURN:
        header.append("PROCESSING_ROOT: \"").append(processingRoot).append("\"\n");
        PrintWriter pw = createWriter(home + separator + ".rp5rc");
        pw.append(header);
        pw.close();
        processingRoot = done;
        break;
      case ESC:
      case DELETE:
        break;
      default:
        processingRoot += key;
      }
    }
  }
