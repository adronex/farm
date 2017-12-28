using System.Collections.Generic;
using System.Linq;
using MoonSharp.Interpreter;
using MoonSharp.Interpreter.Loaders;
using SimpleJSON;
using UnityEngine;

public class MoonSharpScriptHolder : IScriptHolder
{
    private Script _script;
    private readonly List<string> _scriptsAsStrings = new List<string>();

    public MoonSharpScriptHolder()
    {
        var mods = Resources.LoadAll<TextAsset>("lua");
        Script.DefaultOptions.ScriptLoader =
            new UnityAssetsScriptLoader(mods.ToDictionary(mod => mod.name, mod => mod.text));
        _script = new Script();
        LoadScripts();
    }

    private void LoadScripts()
    {
        _scriptsAsStrings.Add(ReadScript("lua/libs/json"));
        _scriptsAsStrings.Add(ReadScript("lua/utils"));
        _scriptsAsStrings.Add(ReadScript("lua/item"));
        _scriptsAsStrings.Add(ReadScript("lua/staticData"));
        _scriptsAsStrings.Add(ReadScript("lua/bag"));
        _scriptsAsStrings.Add(ReadScript("lua/farm"));
        _scriptsAsStrings.Add(ReadScript("lua/shop"));
        _scriptsAsStrings.Add(ReadScript("lua/api"));
        foreach (var script in _scriptsAsStrings)
        {
            Eval(script);
        }
    }
    
    private string ReadScript(string path)
    {
        var asset = Resources.Load(path) as TextAsset;
        return asset.text;
    }

    private void Eval(string script)
    {
        _script.DoString(script);
    }

    public void SetState(JSONObject oldState)
    {
        _script.Call(_script.Globals["setState"], oldState.ToString());
    }

    public string ExecuteCommands(JSONArray commandsArray)
    {
        return _script.Call(_script.Globals["commandHandler"], commandsArray.ToString()).String;
    }
}