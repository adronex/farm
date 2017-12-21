using SimpleJSON;
using UnityEngine;
using UnityEngine.UI;

public class Game : MonoBehaviour
{
    public GridLayoutGroup Inventory;
    public Image Image;

    private IScriptHolder _scriptHolder;
    private string[] _commands = {"GET", "BUY", "SELL", "APPLY"};

// Use this for initialization
    void Start()
    {
        _scriptHolder = new MoonSharpScriptHolder();
        _scriptHolder.GetData();
        string initialData = _scriptHolder.GetData();
        var parsed = JSON.Parse(initialData);
        JSONArray bag = parsed["bag"].AsArray;
        for (int i = 0; i < bag.Count; i++)
        {
            Image image = Instantiate(Image);
            image.transform.parent = Inventory.transform;
            image.GetComponentInChildren<Text>().text= bag[i]["item"]["id"].ToString();
        }
        JSONArray farm = parsed["farm"].AsArray;
        for (int i = 0; i < farm.Count; i++)
        {
            for (int j = 0; j < farm[i].Count; j++)
            {
                Image image = Instantiate(Image);
             //   image.rectTransform.position.Set(i - 5.0F, 4.0F, 0);
            //    image.transform.parent = Inventory.transform;
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