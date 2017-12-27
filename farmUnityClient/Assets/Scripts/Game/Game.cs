using SimpleJSON;
using UnityEngine;
using UnityEngine.UI;

public class Game : MonoBehaviour
{
    private Api _api;
    private IScriptHolder _scriptHolder;
    private readonly string[] _commands = {"GET", "BUY", "SELL", "APPLY"};

    public GridLayoutGroup Commands;
    public GridLayoutGroup Bag;
    public GridLayoutGroup Shop;
    public GridLayoutGroup Farm;
    public Button Button;
    public Image BagCell;
    public Image ShopCell;
    public Image FarmCell;

    private JSONArray _executedCommands = new JSONArray();
    private const int CommandsToSynchronize = 10;
    
    // Use this for initialization
    void Start()
    {
        _api = gameObject.AddComponent<Api>();
        _scriptHolder = new MoonSharpScriptHolder();
        InitializeCommandButtons();
        _scriptHolder.SetState(new JSONObject());
        OnCommandInvoked("GET");
    }

    // Update is called once per frame
    void Update()
    {
    }

    // todo: execute scripts on client side
//    private void DataFromScripts()
//    {
//        _scriptHolder = new MoonSharpScriptHolder();
//        _scriptHolder.ExecuteCommand();
//        var initialData = _scriptHolder.ExecuteCommand();
//        var parsed = JSON.Parse(initialData);
//        GameState.GetInstance().SetState(parsed);
//    }

    private void ParseData(string data)
    {
        var parsed = JSON.Parse(data);
        GameState.GetInstance().SetState(parsed);
        _scriptHolder.SetState(parsed.AsObject);
        InitializeDynamicData();
    }

    public void InitializeDynamicData()
    {
        InitializeBagTable();
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

    private void InitializeBagTable()
    {
        foreach (Transform child in Bag.transform)
        {
            Destroy(child.gameObject);
        }
        var bag = GameState.GetInstance().Bag;
        for (var i = 0; i < bag.Count; i++)
        {
            var bagCell = Instantiate(BagCell);
            bagCell.GetComponent<BagCell>().SetState(Bag, bag[i]);
        }
    }

    private void InitializeShopTable()
    {
        foreach (Transform child in Shop.transform)
        {
            Destroy(child.gameObject);
        }
        var bag = GameState.GetInstance().Bag;
        var shop = GameState.GetInstance().Shop;
        var softMoney = Utils.FindInJsonArray(bag, it => it["item"]["id"] == "softMoney");
        for (var i = 0; i < shop.Count; i++)
        {
            var shopCell = Instantiate(ShopCell);
            shopCell.GetComponent<ShopCell>().SetState(Shop, shop[i], softMoney);
        }
    }

    private void InitializeFarmTable()
    {
        foreach (Transform child in Farm.transform)
        {
            Destroy(child.gameObject);
        }
        var farm = GameState.GetInstance().Farm;
        for (var x = 0; x < farm.Count; x++)
        {
            for (var y = 0; y < farm[x].Count; y++)
            {
                farm[x][y]["x"] = x;
                farm[x][y]["y"] = y;
                var farmCell = Instantiate(FarmCell);
                farmCell.GetComponent<FarmCell>().SetState(Farm, farm[x][y]);
            }
        }
    }

    private void OnCommandInvoked(string command)
    {  
        var commandJsonObject = new JSONObject();
        commandJsonObject["command"] = command;
        commandJsonObject["hand"] = GameState.GetInstance().Hand;
        commandJsonObject["target"] = GameState.GetInstance().Target;
        _executedCommands.Add(commandJsonObject);
        var synchNeeded = command == "GET" || _executedCommands.Count >= CommandsToSynchronize;
        if (!synchNeeded)
        {
            CallClientSideApi(commandJsonObject);        
        }
        else
        { 
            CallRestApi();
        }
    }

    private void CallClientSideApi(JSONObject commandJsonObject)
    {
        var arrayWrapper = new JSONArray();
        arrayWrapper.Add(commandJsonObject);
        var apiResponse = _scriptHolder.ExecuteCommands(arrayWrapper);
        ParseData(apiResponse);
    }

    private void CallRestApi()
    {
        _api.ExecuteCommand(
            _executedCommands,
            ParseData,
            Debug.LogError
        );
        _executedCommands = new JSONArray();
    }
}