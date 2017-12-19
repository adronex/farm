using System.Collections.Generic;
using UnityEngine;

public abstract class AbstractJsScriptHolder
{
    protected List<string> scripts = new List<string>();
    
    protected AbstractJsScriptHolder()
    {
        scripts.Add(ReadScript("api"));
        scripts.Add(ReadScript("item"));
        scripts.Add(ReadScript("staticData"));
        scripts.Add(ReadScript("shop"));
        scripts.Add(ReadScript("bag"));
        scripts.Add(ReadScript("farm"));
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