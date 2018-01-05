using SimpleJSON;
using UnityEngine;
using UnityEngine.UI;

public class GameController : MonoBehaviour
{
    private Api _api;
    private IScriptHolder _scriptHolder;
    private readonly string[] _commands = {"GET"};
    private readonly string[] _movements = {"UP", "DOWN", "LEFT", "RIGHT"};

    public GridLayoutGroup Commands;
    public GameObject Movements;
    public GridLayoutGroup Bag;
    public GridLayoutGroup Shop;
    public GridLayoutGroup Farm;
    public GridLayoutGroup Hands;
    public Button Button;
    public Image BagCell;
    public Image HandCell;
    public Image ShopCell;
    public Image FarmCell;

    private JSONArray _executedCommands = new JSONArray();
    private const int CommandsToSynchronize = 1;
    
    // Use this for initialization
    void Start()
    {
        _api = gameObject.AddComponent<Api>();
        _scriptHolder = new MoonSharpScriptHolder();
        SetCommandButtons();
        _scriptHolder.SetState(new JSONObject());
        OnHandTargetCommandInvoked("GET");
    }

    // Update is called once per frame
    void Update()
    {
    }

    private void InstantiateGameCells(int dataCount, GridLayoutGroup parent, Image cell)
    {
        var tooMuchToBear = 0;
        var gameObjectsCount = parent.GetComponentsInChildren<Image>().Length;
        while (gameObjectsCount > dataCount && tooMuchToBear < 150)
        {
            var images = parent.GetComponentsInChildren<Image>();
            Destroy(images[gameObjectsCount - 1].gameObject);
            gameObjectsCount--;
            tooMuchToBear++;
            if (tooMuchToBear == 150)
            {
                Debug.LogError("Loop iterations limit was reached.");
            }
        }
        tooMuchToBear = 0;
        while (gameObjectsCount < dataCount && tooMuchToBear < 150)
        {
            var image = Instantiate(cell);
            image.transform.SetParent(parent.transform, false);
            gameObjectsCount = parent.GetComponentsInChildren<Image>().Length;
            tooMuchToBear++;
            if (tooMuchToBear == 150)
            {
                Debug.LogError("Loop iterations limit was reached.");
            }
        }
    }

    private void ParseData(string data)
    {
        var parsed = JSON.Parse(data);
        GameState.GetInstance().SetState(parsed);
        _scriptHolder.SetState(parsed.AsObject);
        InitializeDynamicData();
//        Debug.Log(parsed["workers"][0]["position"]);
//        Debug.Log(parsed["workers"][0]["hand"]);
    }

    public void InitializeDynamicData()
    {
        StopAllCoroutines();
        SetBagTable();
        SetShopTable();
        SetHandsTable();
        SetFarmTable();
        SetWorkers();
    }

    private void SetCommandButtons()
    {
        var commandButtons = Commands.GetComponentsInChildren<Button>();
        for (var i = 0; i < _commands.Length; i++)
        {
            var button = commandButtons[i];
            var command = _commands[i];
            button.name = command;
            button.GetComponentInChildren<Text>().text = command;
            var currentCommand = command;
            button.onClick.AddListener(delegate { OnHandTargetCommandInvoked(currentCommand); });
        }
        var movementButtons = Movements.GetComponentsInChildren<Button>();
        for (var i = 0; i < _movements.Length; i++)
        {
            var button = movementButtons[i];
            var movement = _movements[i];
            button.name = movement;
            button.GetComponentInChildren<Text>().text = movement;
            var currentCommand = movement;
            button.onClick.AddListener(delegate { OnDirectionCommandInvoked(currentCommand); });
        }
    }

    private void SetBagTable()
    {
        InstantiateGameCells(GameState.GetInstance().Bag.Count, Bag, BagCell);
        var bagData = GameState.GetInstance().Bag;
        var bagCells = Bag.GetComponentsInChildren<Image>();
        for (var i = 0; i < bagData.Count; i++)
        {
            bagCells[i].GetComponent<BagCell>().SetState(Bag, bagData[i]);
        }
    }

    private void SetShopTable()
    {
        InstantiateGameCells(GameState.GetInstance().Shop.Count, Shop, ShopCell);
        var bagData = GameState.GetInstance().Bag;
        var softMoney = Utils.FindInJsonArray(bagData, it => it["item"]["id"] == "softMoney");
        var shopData = GameState.GetInstance().Shop;
        var shopCells = Shop.GetComponentsInChildren<Image>();
        for (var i = 0; i < shopData.Count; i++)
        {
            shopCells[i].GetComponent<ShopCell>().SetState(Shop, shopData[i], softMoney);
        }
    }

    private void SetHandsTable()
    {
        InstantiateGameCells(GameState.GetInstance().Workers.Count, Hands, HandCell);
        var workersData = GameState.GetInstance().Workers;
        var handsCells = Hands.GetComponentsInChildren<Image>();
        for (var i = 0; i < workersData.Count; i++)
        {
            handsCells[i].GetComponent<HandCell>().SetState(Hands, workersData[i]);
        }
    }

    private void SetFarmTable()
    {
        var farmData = GameState.GetInstance().Farm;
        var farmDataObjectsCount = 0;
        for (var x = 0; x < farmData.Count; x++)
        {
            for (var y = 0; y < farmData[x].Count; y++)
            {
                farmDataObjectsCount = farmData.Count * farmData[x].Count;
                Farm.constraintCount = farmData[x].Count;
                break;
            }
        }            
        InstantiateGameCells(farmDataObjectsCount, Farm, FarmCell);
        var farmCells = Farm.GetComponentsInChildren<Image>();
        for (var x = 0; x < farmData.Count; x++)
        {
            for (var y = 0; y < farmData[x].Count; y++)
            {
                farmData[x][y]["x"] = x;
                farmData[x][y]["y"] = y;
                var cellIndex = x * farmData[x].Count + y;
                farmCells[cellIndex].GetComponent<FarmCell>().SetState(Farm, farmData[x][y]);
            }
        }
    }

    private void SetWorkers()
    {
        
        var workersData = GameState.GetInstance().Workers;
        var farmData = GameState.GetInstance().Farm;
        var farmCells = Farm.GetComponentsInChildren<Image>();
        for (var i = 0; i < workersData.Count; i++)
        {
            if (workersData[i]["position"]["col"] && workersData[i]["position"]["row"])
            {
                var x = workersData[i]["position"]["row"].AsInt - 1; // lua arrays start from 1
                var y = workersData[i]["position"]["col"].AsInt - 1; // lua arrays start from 1
                var cellIndex = x * farmData[x].Count + y;
                farmCells[cellIndex].color = Color.green;
            }
        }
    }

    private void OnHandTargetCommandInvoked(string command)
    {  
        var commandJsonObject = new JSONObject();
        commandJsonObject["command"] = command;
        commandJsonObject["timestamp"] = Utils.RandomSeed();
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

    private void OnDirectionCommandInvoked(string direction)
    {  
        var commandJsonObject = new JSONObject();
        commandJsonObject["command"] = "MOVE";
        commandJsonObject["timestamp"] = Utils.RandomSeed();
        commandJsonObject["direction"] = direction;
        commandJsonObject["workerId"] = "Uasya";
        _executedCommands.Add(commandJsonObject);
        var synchNeeded = _executedCommands.Count >= CommandsToSynchronize;
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
            response =>
            {
                ParseData(response);
                Debug.Log(response);
            },
            Debug.LogError
        );
        _executedCommands = new JSONArray();
    }
}