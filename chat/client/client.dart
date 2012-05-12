#import("dart:html");
 
class ChatClient {
  WebSocket webSocket;
  UListElement logBox;
  InputElement messageBox;
  ButtonElement sendButton;
 
  ChatClient() {
    logBox = document.query("#log");
    messageBox = document.query("#message");
    sendButton = document.query("#send");
    sendButton.on.click.add(onSendButtonClick);
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
    addSoundPlay();
  }

  void addLogEntry(String message) {
    LIElement entry = new Element.tag("li");
    entry.nodes.add(new Text(message));
    logBox.elements.add(entry);
  }

  void addSoundPlay() {
    AudioContext audioContext = new AudioContext();
    final int SAMPLE_RATE = 44100;
    final double PI_2 = Math.PI * 2;
    final int BUFFER_SIZE = 4096;
    AudioBuffer audioBuffer = audioContext.createBuffer(1, BUFFER_SIZE, SAMPLE_RATE);
    
    Float32Array buf = audioBuffer.getChannelData(0);
   
    for (int i = 0; i < 4096; ++i) {
      buf[i] = Math.sin(440 * PI_2 * i / SAMPLE_RATE);
    }

     AudioBufferSourceNode source = audioContext.createBufferSource(); 
     source.buffer = audioBuffer;
     source.connect(audioContext.destination, 0);
     source.noteOn(0);
  }

}
 
void main() {
  new ChatClient().run();
  document.query("#status").innerHTML = "running...";
}
