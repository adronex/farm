using System;
using System.Collections;
using SimpleJSON;
using UnityEngine;
using UnityEngine.UI;

public class FarmCell : MonoBehaviour
{
    private JSONNode _cellState;
    private Coroutine _timer;

    public float CurrentTimer = -1;

    // Use this for initialization
    void Start()
    {
    }

    // Update is called once per frame
    void Update()
    {
    }

    public void SetState(GridLayoutGroup parentFarm, JSONNode farmNode)
    {
        _cellState = farmNode;
        transform.SetParent(parentFarm.transform, false);
        GetComponentInChildren<Text>().text = GetFarmCellText(_cellState);
        GetComponentInChildren<Image>().color = GetFarmCellColor(_cellState);
        GetComponent<Button>().onClick.RemoveAllListeners();
        GetComponent<Button>().onClick.AddListener(delegate { OnTargetChosen(_cellState); });
        if (_cellState["currentProductionTimeLeft"] != null)
        {
            CurrentTimer = _cellState["currentProductionTimeLeft"].AsFloat / 1000;
        }
        _timer = StartCoroutine(TimerIenumerator());
    }

    private IEnumerator TimerIenumerator()
    {
        while (CurrentTimer > 0)
        {
            CurrentTimer -= Time.deltaTime;
            GetComponentInChildren<Text>().text = GetFarmCellText(_cellState);
            yield return null;
        }
        CurrentTimer = 0;
        _cellState["currentProductionTimeLeft"] = 0;
        GetComponentInChildren<Text>().text = GetFarmCellText(_cellState);
        GetComponentInChildren<Image>().color = GetFarmCellColor(_cellState);
    }

    private static Color GetFarmCellColor(JSONNode farmCell)
    {
//        var selected = farmCell["x"] == GameState.GetInstance().Target["x"] &&
//                       farmCell["y"] == GameState.GetInstance().Target["y"];
//        var alpha = selected ? 0.6f : 1f;
        if (farmCell["id"] == "ground")
        {
            return new Color(0.86f, 0.86f, 0.86f);
        }
        if (farmCell["id"] == "road")
        {
            return new Color(0.54f, 0.54f, 0.54f);
        }
        if (farmCell["id"] == "field")
        {
            return new Color(0.59f, 0.39f, 0.25f);
        }
        if (farmCell["id"] == "carrotSpawnBox")
        {
            return new Color(1f, 0.57f, 0.87f);
        }
        if (farmCell["id"] == "caravanParkingPlace")
        {
            return new Color(0.53f, 0.8f, 1f);
        }
        if (farmCell["id"] == "basketStand")
        {
            return new Color(1f, 0.78f, 0.64f);
        }
        return Color.black;
    }

    private string GetFarmCellText(JSONNode farmCell)
    {
        string id = farmCell["id"];
        switch (id)
        {
            case "ground":
            case "road":
            case "basketStand":
                return "id: " + farmCell["id"];
            case "field":
                return "id: " + farmCell["id"] + "\ncd: " + farmCell["productionTimeLeft"] + "\nplant: " +
                       farmCell["plant"]["id"]; 
            case "carrotSpawnBox":
                return "id: " + farmCell["id"] + "\nobject: " + farmCell["spawnObjectId"] + "\nprice: " +
                       farmCell["buyPrice"]; 
            case "caravanParkingPlace":
                var response = "id: " + farmCell["id"];
                if (farmCell["caravan"]["orders"] != null)
                {
                    foreach (JSONNode order in farmCell["caravan"]["orders"].AsArray)
                    {
                        response += "\n" + order["itemId"] + ": " + order["currentCount"] + "/" + order["requiredCount"];
                    }
                }
                return response;
            default:
                return "";
        }
    }

    private void OnTargetChosen(JSONNode targetNode)
    {
        GameState.GetInstance().Target = targetNode;
        GetComponentInParent<Game>().InitializeDynamicData();
    }
}