using System.Collections.Generic;
using UnityEngine;

public abstract class AbstractLuaScriptHolder
{
    protected readonly List<string> _scripts = new List<string>();
    
    protected AbstractLuaScriptHolder()
    {
        _scripts.Add(ReadScript("lua/libs/json"));
        _scripts.Add(ReadScript("lua/api"));
        foreach (var script in _scripts)
        {
            Eval(script);
        }
    }

    private string ReadScript(string path)
    {
        var asset = Resources.Load(path) as TextAsset;
        return asset.text;
    }
    
    public abstract void Eval(string script);
}