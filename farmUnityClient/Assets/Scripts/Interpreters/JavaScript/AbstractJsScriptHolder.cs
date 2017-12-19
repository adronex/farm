using System.Collections.Generic;
using UnityEngine;

public abstract class AbstractJsScriptHolder
{
    protected List<string> scripts = new List<string>();
    
    protected AbstractJsScriptHolder()
    {
        scripts.Add(ReadScript("js/api"));
        scripts.Add(ReadScript("js/item"));
        scripts.Add(ReadScript("js/staticData"));
        scripts.Add(ReadScript("js/shop"));
        scripts.Add(ReadScript("js/bag"));
        scripts.Add(ReadScript("js/farm"));
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