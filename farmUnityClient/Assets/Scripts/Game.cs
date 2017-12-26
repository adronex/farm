using System;
using SimpleJSON;
using UnityEngine;
using UnityEngine.UI;

public class Game : MonoBehaviour
{
    private Api _api;
    private IScriptHolder _scriptHolder;
    private readonly string[] _commands = {"GET", "BUY", "SELL", "APPLY"};
    private JSONArray _bag;
    private JSONArray _farm;
    private JSONArray _shop;

    public GridLayoutGroup Commands;
    public GridLayoutGroup Inventory;
    public GridLayoutGroup Shop;
    public GridLayoutGroup Farm;
    public Button Button;
    public Image Image;

    private JSONNode _hand;
    private JSONNode _target;

// Use this for initialization
    void Start()
    {
        _api = gameObject.AddComponent<Api>();
        Initialize();
    }

    // Update is called once per frame
    void Update()
    {
    }

    private void Initialize()
    {
        CallRestApi("GET");
    }

    // todo: execute scripts on client side
    private void DataFromScripts()
    {
        _scriptHolder = new MoonSharpScriptHolder();
        _scriptHolder.GetData();
        var initialData = _scriptHolder.GetData();
        var parsed = JSON.Parse(initialData);
        _bag = parsed["bag"].AsArray;
        _farm = parsed["farm"].AsArray;
        _shop = parsed["shop"].AsArray;
    }

    private void ParseData(string data)
    {
        var parsed = JSON.Parse(data);
        _bag = parsed["bag"].AsArray;
        _farm = parsed["farm"].AsArray;
        _shop = parsed["shop"].AsArray;
        InitializeCommandButtons();
        InitializeInventoryTable();
        InitializeShopTable();
        InitializeFarmTable();
    }

    private void InitializeCommandButtons()
    {
        foreach (Transform child in Commands.transform)
        {
            Destroy(child.gameObject);
        }
        foreach (var command in _commands)
        {
            var button = Instantiate(Button);
            button.name = command;
            button.GetComponentInChildren<Text>().text = command;
            button.transform.SetParent(Commands.transform, false);
            var currentCommand = command;
            button.onClick.AddListener(delegate { OnCommandInvoked(currentCommand); });
        }
    }

    private void InitializeInventoryTable()
    {
        foreach (Transform child in Inventory.transform)
        {
            Destroy(child.gameObject);
        }
        for (var i = 0; i < _bag.Count; i++)
        {
            var image = Instantiate(Image);
            image.transform.SetParent(Inventory.transform, false);
            image.GetComponentInChildren<Text>().text = GetInventoryItemText(_bag[i]);
            image.color = Styles.GetBagItemColor(_bag[i]);
            var index = i;
            image.GetComponent<Button>().onClick.AddListener(delegate { OnHandChosen(_bag[index]["item"]); });
        }
    }

    private void InitializeShopTable()
    {
        foreach (Transform child in Shop.transform)
        {
            Destroy(child.gameObject);
        }
        var softMoney = Utils.FindInJsonArray(_bag, it => it["item"]["id"] == "softMoney");
        for (var i = 0; i < _shop.Count; i++)
        {
            var image = Instantiate(Image);
            image.transform.SetParent(Shop.transform, false);
            image.GetComponentInChildren<Text>().text = GetShopItemText(_shop[i]);
            image.color = Styles.GetShopItemColor(_shop[i], softMoney["count"].AsInt);
            var index = i;
            image.GetComponent<Button>().onClick.AddListener(delegate { OnHandChosen(_shop[index]["item"]); });
        }
    }

    private void InitializeFarmTable()
    {
        foreach (Transform child in Farm.transform)
        {
            Destroy(child.gameObject);
        }
        for (var x = 0; x < _farm.Count; x++)
        {
            for (var y = 0; y < _farm[x].Count; y++)
            {
                _farm[x][y]["x"] = x;
                _farm[x][y]["y"] = y;
                var image = Instantiate(Image);
                image.transform.SetParent(Farm.transform, false);
                var farmInfo = _farm[x][y]["id"] + " " + _farm[x][y]["type"];
                image.GetComponentInChildren<Text>().text = farmInfo;
                image.color = Styles.GetFarmCellColor(_farm[x][y]);
                var row = x;
                var cell = y;
                image.GetComponent<Button>().onClick.AddListener(delegate { OnTargetChosen(_farm[row][cell]); });
            }
        }
    }

    private void OnHandChosen(JSONNode handNode)
    {
        _hand = handNode;
    }

    private void OnTargetChosen(JSONNode targetNode)
    {
        _target = targetNode;
    }

    private void OnCommandInvoked(string command)
    {  
        CallRestApi(command);
    }

    private void CallRestApi(string command)
    {
        var element = new JSONObject();
        element["command"] = command;
        element["hand"] = _hand;
        element["target"] = _target;
        var requestBody = new JSONArray();
        requestBody.Add(element);
        _api.ExecuteCommand(
            requestBody,
            ParseData,
            Debug.LogError
        );
    }

    private static string GetInventoryItemText(JSONNode inventoryItem)
    {
        return inventoryItem["item"]["id"] + "\ncount: " + inventoryItem["count"].AsInt;
    }

    private static string GetShopItemText(JSONNode shopItem)
    {
        return shopItem["item"]["id"] + "\nbuy price: " + shopItem["buyPrice"].AsInt + "\nsell price: " + shopItem["sellPrice"].AsInt;
    }
}