// TODO: SOMETHING (BUTTON PRESS?) SHOULD START THE GAME AFTER DESIRED PLAYERS HAVE ENTERED
// (in initGame() probably)

import processing.net.*;

// game modes (in order):
final byte NIGHT = 0;
final byte ANNOUNCEMENT = 1; 
final byte GAMEOVER = 2; 
final byte DISCUSSION = 3; // includes voting people up
final byte SPEAKER = 4;
final byte VOTING = 5; // specifically innocent, guilty or abstaining

// Network stuff
Server server;
Client client;

String inString; // raw data from clients

// JSON stuff
JSONObject json; // JSON representing gamestate
JSONObject inJsonPlayer; // the JSON representing the current player
JSONArray jsonPlayers; // JSON Array representing players

// Game stuff
Gamestate gs;

void setup() {
  frameRate(5);
  server = new Server(this, 12345);
  json = new JSONObject();
  jsonPlayers = new JSONArray();

  initGame();
}

void draw() {
  server.write(json.toString()); // write to clients

  readFromClients();

  updateGame();
}

void initGame() {
  json.setInt("game_mode", NIGHT);
  json.setInt("remaining_time", Gamestate.TOTAL_TIMES[NIGHT]);
  json.setInt("remaining_time_speaker", 0);
  json.setJSONArray("players", jsonPlayers);

  gs = new Gamestate(json, 6);
}

void readFromClients() {
  int playersRead = 0;

  client = server.available();

  while (client != null) {
    inString = client.readString();
    inJsonPlayer = parseJSONObject(inString);

    jsonPlayers.setJSONObject(playersRead++, inJsonPlayer);

    client = server.available();
  }
}

void updateGame() {
  if (gs.getModeRemainingTime() <= 0) {
    if (gs.getGameMode() == SPEAKER) {
      gs.backToDiscussion();
    } else {
      gs.nextGameMode();
    }
  }

  switch(gs.getGameMode()) {
  case NIGHT:
    handleNight();
    break;
  case ANNOUNCEMENT:
    handleAnnouncement();
    break;
  case GAMEOVER:
    handleGameOver();
    break;
  case DISCUSSION:
    handleDiscussion();
    break;
  case SPEAKER:
    handleSpeaker();
    break;
  case VOTING:
    handleVoting();
    break;
  }
}

///////////////////////// MODE HANDLER FUNCTIONS /////////////////////////

void handleNight(){
  
}

void handleAnnouncement(){
  
}

void handleGameOver(){
  
}

void handleDiscussion(){
  
}

void handleSpeaker(){
  
}

void handleVoting(){
  
}
