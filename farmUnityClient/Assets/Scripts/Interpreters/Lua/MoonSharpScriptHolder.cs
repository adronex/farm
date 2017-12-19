using MoonSharp.Interpreter;
using MoonSharp.Interpreter.Loaders;

public class MoonSharpScriptHolder: AbstractLuaScriptHolder, IScriptHolder
{
    private Script _script = new Script();

    public MoonSharpScriptHolder()
    {
        _script.Options.ScriptLoader = new EmbeddedResourcesScriptLoader();
    }

    public override void Eval(string script)
    {
        _script.DoString(script);
    }

    public string GetData()
    {
        return _script.Call(_script.Globals["getDataAsString"]).String;
    }
}