using SimpleJSON;

public class GameState
{
    private static GameState _gameState;

    private JSONArray _staticData;
    private JSONArray _bag;
    private JSONArray _farm;
    private JSONArray _shop;
    
    public static GameState GetInstance()
    {
        if (_gameState == null)
        {
            _gameState = new GameState();
        }
        return _gameState;
    }

    public void SetState(JSONNode state)
    {
        _staticData = state["staticData"].AsArray;
        _bag = state["bag"].AsArray;
        _farm = state["farm"].AsArray;
        _shop = state["shop"].AsArray;
    }
}