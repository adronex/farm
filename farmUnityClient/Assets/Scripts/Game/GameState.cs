using SimpleJSON;

public class GameState
{
    private static readonly GameState State = new GameState();

    private JSONArray _staticData;
    private JSONArray _bag;
    private JSONArray _farm;
    private JSONArray _shop;
    
    public JSONNode Hand = new JSONObject();
    public JSONNode Target = new JSONObject();
    
    public static GameState GetInstance()
    {
        return State;
    }

    public void SetState(JSONNode state)
    {
        _staticData = state["staticData"].AsArray;
        _bag = state["bag"].AsArray;
        _farm = state["farm"].AsArray;
        _shop = state["shop"].AsArray;
    }

    public override string ToString()
    {
        var jsonObject = new JSONObject();
        jsonObject["staticData"] = _staticData;
        jsonObject["bag"] = _bag;
        jsonObject["farm"] = _farm;
        jsonObject["shop"] = _shop;
        return jsonObject.ToString();
    }

    public JSONArray StaticData
    {
        get { return _staticData; }
    }

    public JSONArray Bag
    {
        get { return _bag; }
    }

    public JSONArray Farm
    {
        get { return _farm; }
    }

    public JSONArray Shop
    {
        get { return _shop; }
    }
}