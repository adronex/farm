using System.IO;
using Jurassic;

public class ScriptHolder
{
    private readonly ScriptEngine _engine = new ScriptEngine();

    public ScriptHolder()
    {
        _engine.Evaluate(ReadScript("Resources/api.js"));
        _engine.Evaluate(ReadScript("Resources/item.js"));
        _engine.Evaluate(ReadScript("Resources/staticData.js"));
        _engine.Evaluate(ReadScript("Resources/shop.js"));
        _engine.Evaluate(ReadScript("Resources/bag.js"));
        _engine.Evaluate(ReadScript("Resources/farm.js"));
    }

    public string GetData()
    {
        return _engine.CallGlobalFunction<string>("getDataAsString");
    }
    private string ReadScript(string path)
    {
        StreamReader reader = new StreamReader(path);
        string scriptAsString = reader.ReadToEnd();
        reader.Close();
        return scriptAsString;
    }
}