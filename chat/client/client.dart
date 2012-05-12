#import("dart:html");
#import("music.dart");
 
class ChatClient {
  WebSocket webSocket;
  UListElement logBox;
  InputElement messageBox;
  ButtonElement sendButton;
  Tone tone;

  List<String> TONES;
  List<String> KEYS;
 
  ChatClient() {
    TONES = ['A', 'As', 'B', 'C', 'Cs', 'D', 'Ds', 'E', 'F', 'Fs', 'G', 'Gs'];
    KEYS = ['A', 'W', 'S', 'D', 'R', 'F', 'T', 'G', 'H', 'U', 'J', 'I'];
    logBox = document.query("#log");
    messageBox = document.query("#message");
    sendButton = document.query("#send");
    sendButton.on.click.add(onSendButtonClick);
    document.body.on.keyDown.add(onKey);
    for (String tone in TONES) {
      ((tone) {
        document.query("#tone${tone}").on.click.add((event){ webSocket.send(tone); });
      })(tone);
    }
  }

  void onKey(Event e) {
    for (int i = 0; i < KEYS.length; ++i) {
      if (e.keyCode == KEYS[i].charCodeAt(0)) {
        webSocket.send(TONES[i]);
      }
    }
  }

  void onSendButtonClick(Event e) {
    String message = messageBox.value;
    if (!message.isEmpty()) {
      webSocket.send(message);
      messageBox.value = "";
    }
  }

  void run() {
    webSocket = new WebSocket("ws://kiri.nya3.jp:41894/");
    this.tone = new Tone( );
    webSocket.on.open.add(onOpen);
    webSocket.on.close.add(onClosed);
    webSocket.on.message.add(onMessage);
  }

  void onOpen(event) {
  }

  void onClosed(event) {
    addLogEntry("*** closed connection ***");
  }

  void onMessage(event) {
    addLogEntry(event.data);
    addSoundPlay(event.data);
  }

  void addLogEntry(String message) {
    LIElement entry = new Element.tag("li");
    entry.nodes.add(new Text(message));
    logBox.elements.add(entry);
  }

  void addSoundPlay(tone) {
    this.tone.generate(tone);
  }

}
 
void main() {
  new ChatClient().run();
  document.query("#status").innerHTML = "running...";
}
