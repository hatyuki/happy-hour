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
  }

  void addLogEntry(String message) {
    LIElement entry = new Element.tag("li");
    entry.nodes.add(new Text(message));
    logBox.elements.add(entry);
  }
}
 
void main() {
  new ChatClient().run();
  document.query("#status").innerHTML = "running...";
}
