using System.IO;
using Jurassic;
using UnityEngine;

public class ScriptHolder
{
    private readonly ScriptEngine _engine = new ScriptEngine();

    public ScriptHolder()
    {
        _engine.Evaluate(ReadScript("api"));
        _engine.Evaluate(ReadScript("item"));
        _engine.Evaluate(ReadScript("staticData"));
        _engine.Evaluate(ReadScript("shop"));
        _engine.Evaluate(ReadScript("bag"));
        _engine.Evaluate(ReadScript("farm"));
    }

    public string GetData()
    {
        return _engine.CallGlobalFunction<string>("getDataAsString");
    }
    
    private string ReadScript(string path)
    {
        var asset = Resources.Load(path) as TextAsset;
        return asset?.text;
    }
}