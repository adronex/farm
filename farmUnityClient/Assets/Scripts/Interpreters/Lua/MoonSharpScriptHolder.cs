using MoonSharp.Interpreter;
using SimpleJSON;

public class MoonSharpScriptHolder : AbstractLuaScriptHolder, IScriptHolder
{
    private Script _script = new Script();

    public override void Eval(string script)
    {
        _script.DoString(script);
    }

    public void SetState(JSONObject oldState)
    {
        _script.Call(_script.Globals["setState"], oldState.ToString());
    }

    public string ExecuteCommands(JSONArray commandsArray)
    {
        return _script.Call(_script.Globals["commandHandler"], commandsArray.ToString()).String;
    }
}