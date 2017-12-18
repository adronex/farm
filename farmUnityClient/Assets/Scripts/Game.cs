using System;
using System.IO;
using UnityEngine;

public class Game : MonoBehaviour
{

    // Use this for initialization
    void Start()
    {
        var engine = new Jurassic.ScriptEngine();
        engine.Evaluate(ReadScript("Resources/api.js"));
        engine.Evaluate(ReadScript("Resources/item.js"));
        engine.Evaluate(ReadScript("Resources/staticData.js"));
        engine.Evaluate(ReadScript("Resources/shop.js"));
        engine.Evaluate(ReadScript("Resources/bag.js"));
        engine.Evaluate(ReadScript("Resources/farm.js"));
        string initialData = engine.CallGlobalFunction<string>("getDataAsString");
        Debug.Log(initialData);
    }

    // Update is called once per frame
    void Update()
    {
    }
	
    private string ReadScript(string path)
    {
        StreamReader reader = new StreamReader(path);
        string scriptAsString = reader.ReadToEnd();
        reader.Close();
        return scriptAsString;
    }
}