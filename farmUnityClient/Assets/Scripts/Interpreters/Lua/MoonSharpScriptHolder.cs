using System.Collections.Generic;
using System.Linq;
using MoonSharp.Interpreter;
using MoonSharp.Interpreter.Loaders;
using UnityEngine;

public class MoonSharpScriptHolder : AbstractLuaScriptHolder, IScriptHolder
{
    private Script _script = new Script();

    public override void Eval(string script)
    {
        _script.DoString(script);
    }

    public string GetData()
    {
        return _script.Call(_script.Globals["getDataAsString"]).String;
    }
}