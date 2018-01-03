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
        var selected = farmCell["x"] == GameState.GetInstance().Target["x"] &&
                       farmCell["y"] == GameState.GetInstance().Target["y"];
        var alpha = selected ? 0.6f : 1f;
        if (farmCell["plant"] == null)
        {
            return new Color(0.86f, 0.86f, 0.86f, alpha);
        }
        if (farmCell["plant"]["id"] == null)
        {
            return new Color(0.44f, 0.64f, 1f, alpha);
        }
        if (farmCell["endTime"].AsDouble > Utils.Now())
        {
            return new Color(1f, 0.61f, 0.6f, alpha);
        }
        return new Color(0.49f, 1f, 0.54f, alpha);
    }

    private string GetFarmCellText(JSONNode farmCell)
    {
        return "id: " + farmCell["id"] + "\ntype: " + farmCell["type"] + "\ntime left: " +
               CurrentTimer.ToString("0.00");
    }

    private void OnTargetChosen(JSONNode targetNode)
    {
        GameState.GetInstance().Target = targetNode;
        GetComponentInParent<Game>().InitializeDynamicData();
    }
}