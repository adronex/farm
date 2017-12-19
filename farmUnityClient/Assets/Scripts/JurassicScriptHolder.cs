using Jurassic;
using UnityEngine;

public class JurassicScriptHolder : AbstractJsScriptHolder, IScriptHolder
{
    private readonly ScriptEngine _engine = new ScriptEngine();

    public string GetData()
    {
        return _engine.CallGlobalFunction<string>("getDataAsString");
    }

    public override void Eval(string script)
    {
        _engine.Evaluate(script);
    }
}