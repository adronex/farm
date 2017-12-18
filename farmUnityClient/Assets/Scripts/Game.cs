using System;
using System.Collections.Generic;
using System.IO;
using SimpleJSON;
using UnityEngine;

public class Game : MonoBehaviour
{
    public GameObject Cell;
    
    private readonly ScriptHolder _scriptHolder = new ScriptHolder();

    // Use this for initialization
    void Start()
    {
        string initialData = _scriptHolder.GetData();
        var parsed = JSON.Parse(initialData);
        JSONArray bag = parsed["bag"].AsArray;
        for (int i = 0; i < bag.Count; i++)
        {
            Instantiate(Cell, new Vector3(i - 5.0F, 4.0F, 0), Quaternion.identity);
        }
        JSONArray farm = parsed["farm"].AsArray;
        for (int i = 0; i < farm.Count; i++)
        {
            for (int j = 0; j < farm[i].Count; j++)
            {
                Instantiate(Cell, new Vector3(i - 5.0F, 3.0F - j * 0.7F, 0), Quaternion.identity);
            }
        }
        JSONArray shop = parsed["shop"].AsArray;
        Debug.Log(initialData);
    }

    // Update is called once per frame
    void Update()
    {
    }
}