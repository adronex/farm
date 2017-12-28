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
//        DestroyAll();
        InstantiateButtons();
        SetCommandButtons();
        _scriptHolder.SetState(new JSONObject());
        OnCommandInvoked("GET");
    }

    // Update is called once per frame
    void Update()
    {
    }

    private void InstantiateButtons()
    {
        var tooMuchToBear = 0;
        var gameObjectsCount = Commands.GetComponentsInChildren<Button>().Length;
        while (gameObjectsCount < _commands.Length && tooMuchToBear < 50)
        {
            var button = Instantiate(Button);
            button.transform.SetParent(Commands.transform, false);
            gameObjectsCount = Commands.GetComponentsInChildren<Button>().Length;
            tooMuchToBear++;
            if (tooMuchToBear == 50)
            {
                Debug.LogError("Loop iterations limit was reached.");
            }
        }
        tooMuchToBear = 0;
        while (gameObjectsCount > _commands.Length && tooMuchToBear < 50)
        {
            var buttons = Commands.GetComponentsInChildren<Button>();
            Destroy(buttons[buttons.Length - 1].gameObject);
            gameObjectsCount = Commands.GetComponentsInChildren<Button>().Length;
            tooMuchToBear++;
            if (tooMuchToBear == 50)
            {
                Debug.LogError("Loop iterations limit was reached.");
            }
        }
    }

    private void InstantiateGameCells(int dataCount, GridLayoutGroup parent, Image cell)
    {
        var tooMuchToBear = 0;
        var gameObjectsCount = parent.GetComponentsInChildren<Image>().Length;
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
        tooMuchToBear = 0;
        while (gameObjectsCount > dataCount && tooMuchToBear < 150)
        {
            var images = parent.GetComponentsInChildren<Image>();
            Destroy(images[images.Length - 1].gameObject);
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
    }

    public void InitializeDynamicData()
    {
        StopAllCoroutines();
        SetBagTable();
        SetShopTable();
        SetFarmTable();
    }

    private void SetCommandButtons()
    {
        var buttons = Commands.GetComponentsInChildren<Button>();
        for (var i = 0; i < _commands.Length; i++)
        {
            var button = buttons[i];
            var command = _commands[i];
            button.name = command;
            button.GetComponentInChildren<Text>().text = command;
            var currentCommand = command;
            button.onClick.AddListener(delegate { OnCommandInvoked(currentCommand); });
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

    private void SetFarmTable()
    {
        InstantiateGameCells(100, Farm, FarmCell);
        var farmData = GameState.GetInstance().Farm;
        var farmCells = Farm.GetComponentsInChildren<Image>();
        for (var x = 0; x < farmData.Count; x++)
        {
            for (var y = 0; y < farmData[x].Count; y++)
            {
                farmData[x][y]["x"] = x;
                farmData[x][y]["y"] = y;
                var cellIndex = x * farmData.Count + y;
                farmCells[cellIndex].GetComponent<FarmCell>().SetState(Farm, farmData[x][y]);
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