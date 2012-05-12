#import("dart:io");

// A WebSocket handler for chat server.
class ChatHandler {
  WebSocketHandler webSocketHandler;
  List<WebSocketConnection> connections;

  ChatHandler() {
    webSocketHandler = new WebSocketHandler();
    connections = new List<WebSocketConnection>();
    webSocketHandler.onOpen = onOpen;
  }

  void addToHttpServer(HttpServer server) {
    server.addRequestHandler(shouldHandleRequest, onRequest);
  }

  bool shouldHandleRequest(HttpRequest request) => true;

  void onRequest(HttpRequest request, HttpResponse response) {
    webSocketHandler.onRequest(request, response);
  }

  void onOpen(WebSocketConnection connection) {
    onJoin(connection);

    connection.onMessage = (message) { onMessage(connection, message); };
    connection.onClosed = (int status, String reason) { onClosed(connection); };
    connection.onError = (e) { onError(connection, e); };
  }

  // Broadcasts the message to all clients.
  void sendToAll(message) {
    for (WebSocketConnection connection in connections) {
      connection.send(message);
    }
    print(message);
  }

  // Called when a new client joined.
  void onJoin(WebSocketConnection new_connection) {
    // Add to the list of available connections.
    connections.add(new_connection);

    // Greet the new client and notify all others.
    new_connection.send("Welcome to Happy Chat Server!");
    sendToAll("A new user joined. The current number of clients: ${connections.length}");
  }

  void onMessage(WebSocketConnection connection, message) {
    // From http://api.dartlang.org/io/WebSocketConnection.html :
    //   The type on message is either String or List<int> depending on whether
    //   it is a text or binary message. If the message is empty message will be
    //   null.

    // Just replicate the message to all clients.
    sendToAll(message);
  }

  void onClosed(WebSocketConnection connection) {
    connections.removeRange(connections.indexOf(connection), 1);
    sendToAll("A user quitted. The current number of clients: ${connections.length}");
  }

  void onError(WebSocketConnection connection, e) {
    onClosed(connection);
    print("Connection error: $e");
  }
}

void main() {
  HttpServer httpServer = new HttpServer();
  ChatHandler chatHandler = new ChatHandler();
  chatHandler.addToHttpServer(httpServer);
  httpServer.listen("0.0.0.0", 41894);
  print("running...");
}
