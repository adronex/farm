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
        GameState.GetInstance().SetState(parsed);
    }

    private void ParseData(string data)
    {
        var parsed = JSON.Parse(data);
        GameState.GetInstance().SetState(parsed);
        InitializeCommandButtons();
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

    private static void OnHandChosen(JSONNode handNode)
    {
        GameState.GetInstance().Hand = handNode;
    }

    private void OnCommandInvoked(string command)
    {  
        CallRestApi(command);
    }

    private void CallRestApi(string command)
    {
        var element = new JSONObject();
        element["command"] = command;
        element["hand"] = GameState.GetInstance().Hand;
        element["target"] = GameState.GetInstance().Target;
        var requestBody = new JSONArray();
        requestBody.Add(element);
        _api.ExecuteCommand(
            requestBody,
            ParseData,
            Debug.LogError
        );
    }
}