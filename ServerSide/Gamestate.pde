class Player {
}

public class Gamestate {
  private static final int[] TOTAL_TIMES = {20000, 3000, 0, 120000, 20000, 10000};
  // the total (max) time that can be taken in each game mode, in order

  private int gameMode;
  private int modeStartTime; // holds when the current mode started
  private int speakerStartTime; // holds when the 20 second speaker started
  private ArrayList<Player> players; // holds all players
  private final int MAX_PLAYERS; // max number of players in this game

  public Gamestate(JSONObject json, int maxPlayers) {
    gameMode = json.getInt("game_mode");
    modeStartTime = millis();
    speakerStartTime = json.getInt("remaining_time_speaker");
    players = new ArrayList<Player>();
    MAX_PLAYERS = maxPlayers;
  }

  public void addPlayer(Player p) {
    if (players.size() >= MAX_PLAYERS) {
      throw new IllegalArgumentException("Game is already at full capacity");
    } else {
      players.add(p);
    }
  }

  public void removePlayer(String username) {
    players.remove(getPlayer(username));
  }

  // should this return a copy of player?
  public Player getPlayer(String username) {
    for (int i = 0; i < players.size(); i++) {
      if (players.get(i).getUsername().equals(username)) {
        return players.get(i);
      }
    }

    throw new IndexOutOfBoundsException("Username does not exist");
  }

  // should this return a deep copy of the list?
  public ArrayList<Player> getAllPlayers() {
    return players;
  }

  public int getGameMode() {
    return gameMode;
  }

  public void nextGameMode() {
    setGameMode(gameMode++);
  }
  
  public void backToDiscussion(){
    gameMode = DISCUSSION;
  }
  
  public void setGameMode(int mode){
    if(mode == SPEAKER){
      speakerStartTime = millis();
    }
    else{
      modeStartTime = millis();
    }
    
    gameMode = mode;
  }

  public int getModeRemainingTime() {
    if(gameMode == SPEAKER){
      return TOTAL_TIMES[SPEAKER] - (millis() - speakerStartTime);
    }
    
    return TOTAL_TIMES[gameMode] - (millis() - modeStartTime);
  }
}
