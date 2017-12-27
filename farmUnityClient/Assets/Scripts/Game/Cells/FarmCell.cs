using System.Collections;
using SimpleJSON;
using UnityEngine;
using UnityEngine.UI;

public class FarmCell : MonoBehaviour
{
	private JSONNode _cellState;
	
	public float CurrentTimer;
	
	// Use this for initialization
	void Start ()
	{
	}
	
	// Update is called once per frame
	void Update () {
		
	}

	public void SetState(GridLayoutGroup parentFarm, JSONNode farmNode)
	{
		_cellState = farmNode;
		transform.SetParent(parentFarm.transform, false);
		GetComponentInChildren<Text>().text = GetFarmCellText(_cellState);
		GetComponentInChildren<Image>().color = GetFarmCellColor(_cellState);
		GetComponent<Button>().onClick.AddListener(delegate { OnTargetChosen(_cellState); });
		CurrentTimer = _cellState["currentProductionTimeLeft"].AsFloat / 1000;
		StartCoroutine(TimerIenumerator());
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
		GetComponentInChildren<Text>().text = GetFarmCellText(_cellState);
		GetComponentInChildren<Image>().color = GetFarmCellColor(_cellState);
	}

	private static Color GetFarmCellColor(JSONNode farmCell)
	{
		if (farmCell["queue"] == null) {
			return new Color(0.6f, 0.6f, 0.6f);
		}
		if (farmCell["queue"][0] == null) {
			return new Color(0.44f, 0.64f, 1f);
		}
		if (farmCell["endTime"].AsDouble > Utils.Now()) {
			return new Color(1f, 0.61f, 0.6f);
		}
		return new Color(0.49f, 1f, 0.54f);
	}

	private string GetFarmCellText(JSONNode farmCell)
	{
		return "id: " + farmCell["id"] + "\ntype: " + farmCell["type"] + "\ntime left: " + CurrentTimer.ToString("0.00");
	}

	private static void OnTargetChosen(JSONNode targetNode)
	{
		GameState.GetInstance().Target = targetNode;
	}
}
