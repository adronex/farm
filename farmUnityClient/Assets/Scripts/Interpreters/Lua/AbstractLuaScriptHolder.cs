using System.Collections.Generic;
using UnityEngine;

public abstract class AbstractLuaScriptHolder
{
    protected readonly List<string> _scripts = new List<string>();
    
    protected AbstractLuaScriptHolder()
    {
        _scripts.Add(ReadScript("lua/libs/json"));
        _scripts.Add(ReadScript("lua/utils"));
        _scripts.Add(ReadScript("lua/item"));
        _scripts.Add(ReadScript("lua/staticData"));
        _scripts.Add(ReadScript("lua/bag"));
        _scripts.Add(ReadScript("lua/farm"));
        _scripts.Add(ReadScript("lua/shop"));
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