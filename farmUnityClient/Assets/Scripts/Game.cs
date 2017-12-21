using System;
using System.Linq;
using SimpleJSON;
using UnityEngine;
using UnityEngine.UI;

public class Game : MonoBehaviour
{
    public GridLayoutGroup Commands;
    public GridLayoutGroup Inventory;
    public GridLayoutGroup Shop;
    public GridLayoutGroup Farm;
    public Button Button;
    public Image Image;

    private IScriptHolder _scriptHolder;
    private string[] _commands = {"GET", "BUY", "SELL", "APPLY"};
    private JSONArray _bag;
    private JSONArray _farm;
    private JSONArray _shop;

// Use this for initialization
    void Start()
    {
        LoadData();
        InitializeCommandButtons();
        InitializeInventoryTable();
        InitializeShopTable();
        InitializeFarmTable();
    }

    // Update is called once per frame
    void Update()
    {
    }

    private void LoadData()
    {
        _scriptHolder = new MoonSharpScriptHolder();
        _scriptHolder.GetData();
        var initialData = _scriptHolder.GetData();
        var parsed = JSON.Parse(initialData);
        _bag = parsed["bag"].AsArray;
        _farm = parsed["farm"].AsArray;
        _shop = parsed["shop"].AsArray;
        Debug.Log(initialData);
    }

    private void InitializeCommandButtons()
    {
        foreach (var command in _commands)
        {
            var button = Instantiate(Button);
            button.GetComponentInChildren<Text>().text = command;
            button.transform.SetParent(Commands.transform, false);
        }
    }

    private void InitializeInventoryTable()
    {
        for (var i = 0; i < _bag.Count; i++)
        {
            var image = Instantiate(Image);
            image.transform.SetParent(Inventory.transform, false);
            image.GetComponentInChildren<Text>().text = _bag[i]["item"]["id"];
            image.color = GetBagItemColor(_bag[i]);
        }   
    }

    private void InitializeShopTable()
    {
        for (var i = 0; i < _shop.Count; i++)
        {
            var image = Instantiate(Image);
            image.transform.SetParent(Shop.transform, false);
            image.GetComponentInChildren<Text>().text = _shop[i]["item"]["id"];
            image.color = GetShopItemColor(_shop[i]);
        }   
    }

    private void InitializeFarmTable()
    {
        for (var i = 0; i < _farm.Count; i++)
        {
            for (var j = 0; j < _farm[i].Count; j++)
            {
                var image = Instantiate(Image);
                image.transform.SetParent(Farm.transform, false);
                var farmInfo = _farm[i][j]["id"] + " " + _farm[i][j]["type"];
                image.GetComponentInChildren<Text>().text = farmInfo;
                image.color = GetFarmCellColor(_farm[i][j]);
            }
        }
    }
    
    private Color GetBagItemColor(JSONNode bagItem)
    {
        if (!bagItem["item"]["countable"].AsBool) {
            return new Color(1f, 0.95f, 0.54f);
        }
        if (bagItem["count"].AsInt > 0) {
            return new Color(0.49f, 1f, 0.54f);
        }
        return new Color(0.6f, 0.6f, 0.6f);
    }
    
    private Color GetShopItemColor(JSONNode shopItem)
    {
        var softMoney = FindItem(_bag, it => it["item"]["id"] == "softMoney");
        if (shopItem["buyPrice"].AsInt > softMoney["count"].AsInt) {
            return new Color(1f, 0.61f, 0.6f);
        }
        return new Color(0.49f, 1f, 0.54f);
    }

    private Color GetFarmCellColor(JSONNode farmCell)
    {
        if (farmCell["queue"] == null) {
            return new Color(0.6f, 0.6f, 0.6f);
        }
        if (farmCell["queue"][0] == null) {
            return new Color(0.44f, 0.64f, 1f);
        }
        if (farmCell["endTime"].AsInt > DateTime.Now.Ticks) {
            return new Color(1f, 0.61f, 0.6f);
        }
        return new Color(0.49f, 1f, 0.54f);
    }

    private JSONNode FindItem(JSONArray array, Func<JSONNode, bool> func)
    {
        foreach (var node in array)
        {
            if (func(node))
            {
                return node;
            }
        }
        return null;
    } 
}