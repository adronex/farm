using SimpleJSON;

public interface IScriptHolder
{
    void SetState(JSONObject oldState);
    
    string ExecuteCommands(JSONArray jsonArray);
}