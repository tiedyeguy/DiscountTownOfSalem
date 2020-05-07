import java.util.ArrayList;

class Verdict {
  public static final String ABSTAIN = "ABSTAIN"; 
  public static final String GUILTY = "GUILTY"; 
  public static final String INNOCENT = "INNOCENT"; 
  public String value;
  public Verdict(String verd){
    value=verd;
  }
}

class Player{
  private String username;
  private boolean isPlayerAlive;
  private ArrayList<String> effectList;
  private String vote;
  private Verdict personalVerdict;
  private JSONObject playerJSON;

  /**
   * Constructs a nameless player, should use setName() at some point to provide a name
   */
  public Player(){
    this("");  
  }
  
  /**
   * Constructs a player with the given username 
   * @param username The username is the name used to describe the player
   */
  public Player(String username){
    this.username = username;  
    personalVerdict = new Verdict(Verdict.ABSTAIN);
    vote = "";
    isPlayerAlive = true;
    writeAllDataToJSON();
  }
  
  /**
   * This method writes all variables into the JSON object. This is inefficient to call everytime there is an update, but it is used in initialization
   */
  private void writeAllDataToJSON(){
    playerJSON.setString("Username", username);
    playerJSON.setBoolean("isAlive", isPlayerAlive);
    playerJSON.setString("Verdict", personalVerdict.value);
    playerJSON.setString("Vote", "");
    JSONArray JSONEffectList = new JSONArray();
    for(int i = 0; i < effectList.size(); i++) {
      JSONObject tempJSON = new JSONObject();
      tempJSON.setString("Name", effectList.get(i));
      JSONEffectList.setJSONObject(i,tempJSON);
    }
    playerJSON.setJSONArray("Effects", JSONEffectList);    
  }
  
  /**
   * setUsername sets the username of the player to the given parameter
   * @param name The new name for this player
   */
  public void setUsername(String name) {
    username = name;
    playerJSON.setString("Username", username);
  }
  
  
  /**
   * Gets the username of this player
   * @return The current name (username) of this player
   */
  public String getUsername(){
    return username;
  }
  
  /**
   * Standard getter, check to see if player is still alive or if it has died by call to die()
   * @return Ttrue iff this player is alive, false if dead
   */
  public boolean isAlive(){
    return isPlayerAlive;
  }
  
  /**
   * 'Kills' player, which mostly means that all effects are cancelled and isAlive() will return false
   */
  public void die(){
    isPlayerAlive = false;
    playerJSON.setBoolean("isAlive", isPlayerAlive);
  }
  
  /**
   * Gets all effects on this player, including such effects as "Silenced" or "Healed" or "Attacked"
   * @return An ArrayList in no guarenteed order of all accumulated effects since last resetEffects() call
   */
  public ArrayList<String> getEffects() {
    return effectList;
  }
  
  /**
   * Removes one specific effect from the player, if it was there
   * @return True iff the specified effect was found in the list and removed
   */
  public boolean removeEffect(String e) {
    boolean isEffectRemoved = effectList.remove(e);
    if(isEffectRemoved) {
      JSONArray JSONEffectList = new JSONArray();
      for(int i = 0; i < effectList.size(); i++) {
        JSONObject tempJSON = new JSONObject();
        tempJSON.setString("Name", effectList.get(i));
        JSONEffectList.setJSONObject(i,tempJSON);
      }
      playerJSON.setJSONArray("Effects", JSONEffectList);
    }
    return isEffectRemoved;
  }
  
  /**
   * Clears away all effects from this player, likely should happen at the beginning of the night phase
   */
  public void resetEffects() {
    playerJSON.setJSONArray("Effects", new JSONArray());
    effectList.clear();
  }

  /**
   * Sets who this player is voting for
   * @param username The valid username of another Player or the empty string
   */
  public void setVote(String username){
    vote = username;
    playerJSON.setString("Vote", vote);
  }
  
  /**
   * Gets who this player is voting for, namely the username of that player or the empty string
   * @return The username of the player that this player is voting for, or "" if they have no vote
   */
  public String getVote() {
    return vote;
  }
 
  /**
   * Gets the verdict of this player
   * @return A verdict object, with value of "INNOCENT", "GUILTY", or "ABSTAIN"
   */
  public Verdict getVerdict() {
    return personalVerdict;
  }
  
  /**
   * Set the verdict of this player with a verdict object
   * @param v Should be a non-null Verdict object with a value of "INNOCENT", "GUILTY", or "ABSTAIN"
   */
  public void setVerdict(Verdict v){
    personalVerdict = v;
    playerJSON.setString("Verdict", v.value);
  }
  
  /**
   * Sets the verdict of this player with the given string
   * @param v Must be one of "INNOCENT", "GUILTY", or "ABSTAIN"
   */
  public void setVerdict(String v){
    if(v.equals(Verdict.INNOCENT) || v.equals(Verdict.GUILTY) || v.equals(Verdict.ABSTAIN)) {
      personalVerdict.value = v;
      playerJSON.setString("Verdict", v);
    }
  }
  
  /**
   * Returns the Player object as a JSON object
   * @return A JSONObject with updated player data
   */
  public JSONObject getPlayerJSON(){
     return playerJSON;   
  }
}
