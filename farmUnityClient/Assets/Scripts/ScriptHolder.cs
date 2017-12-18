using System.IO;
using Jurassic;

public class ScriptHolder
{
    private readonly ScriptEngine _engine = new ScriptEngine();
    private static readonly string Path = "Assets/Resources/";
    private static readonly string Extension = ".jslib";

    public ScriptHolder()
    {
        _engine.Evaluate(ReadScript(Path + "api" + Extension));
        _engine.Evaluate(ReadScript(Path + "item" + Extension));
        _engine.Evaluate(ReadScript(Path + "staticData" + Extension));
        _engine.Evaluate(ReadScript(Path + "shop" + Extension));
        _engine.Evaluate(ReadScript(Path + "bag" + Extension));
        _engine.Evaluate(ReadScript(Path + "farm" + Extension));
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