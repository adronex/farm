using System;
using System.Collections;
using System.Collections.Generic;
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
		Coroutine timer =  StartCoroutine(TimerIenumerator(5f, () => GetFarmCellText(_cellState)));
		//StopCoroutine(timer);
	}
	
	// Update is called once per frame
	void Update () {
		
	}

	public void SetState(GridLayoutGroup parentFarm, JSONNode farmNode)
	{
		_cellState = farmNode;
		transform.SetParent(parentFarm.transform, false);
		var farmInfo = GetFarmCellText(_cellState);
		GetComponentInChildren<Text>().text = farmInfo;
		GetComponentInChildren<Image>().color = GetFarmCellColor(_cellState);
		GetComponent<Button>().onClick.AddListener(delegate { OnTargetChosen(_cellState); });
	}

	private IEnumerator TimerIenumerator(float timer, Action endCallback)
	{
		while (timer > 0)
		{
			timer -= Time.deltaTime;
			yield return null;
		}
		endCallback();
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

	private static string GetFarmCellText(JSONNode farmCell)
	{
		return farmCell["id"] + " " + farmCell["type"] + " " + "\ntime left: " + farmCell["currentProductionTimeLeft"].AsFloat;
	}

	private static void OnTargetChosen(JSONNode targetNode)
	{
		GameState.GetInstance().Target = targetNode;
	}
}
