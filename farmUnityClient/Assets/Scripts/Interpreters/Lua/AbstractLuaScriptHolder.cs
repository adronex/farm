using System.Collections.Generic;
using UnityEngine;

public abstract class AbstractLuaScriptHolder
{
    protected List<string> scripts = new List<string>();
    
    protected AbstractLuaScriptHolder()
    {
        scripts.Add(ReadScript("lua/libs/json"));
        scripts.Add(ReadScript("lua/api"));
        foreach (string script in scripts)
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