using Microsoft.ClearScript.V8;

public class ClearScriptHolder : AbstractJsScriptHolder, IScriptHolder
{
    private V8ScriptEngine _engine = new V8ScriptEngine();
    
    public override void Eval(string script)
    {
        _engine.Execute(script);
    }

    public string GetData()
    {
        return ";";
        //return _engine.Script.getData();
    }
}