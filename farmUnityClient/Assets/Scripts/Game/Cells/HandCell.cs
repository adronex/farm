using SimpleJSON;
using UnityEngine;
using UnityEngine.UI;

public class HandCell : MonoBehaviour
{
	private JSONNode _cellState;
	
	// Use this for initialization
	void Start ()
	{
	}
	
	// Update is called once per frame
	void Update () {
		
	}

	public void SetState(GridLayoutGroup parentShop, JSONNode workerNode)
	{
		_cellState = workerNode;
		transform.SetParent(parentShop.transform, false);
		GetComponentInChildren<Text>().text = GetShopItemText(_cellState);
		GetComponent<Image>().color = GetShopItemColor(_cellState);
		GetComponent<Button>().onClick.RemoveAllListeners();
		GetComponent<Button>().onClick.AddListener(delegate { OnHandChosen(_cellState["item"]); });
	}
    
	private static Color GetShopItemColor(JSONNode handItem)
	{
		return new Color(0.49f, 1f, 0.54f);
	}

	private static string GetShopItemText(JSONNode workerItem)
	{
		if (workerItem["hand"]["id"] == "basket")
		{
			return "worker: " +  workerItem["id"] + "\nhand: " + workerItem["hand"]["id"] + "\nobjects: " + workerItem["hand"]["objects"].Count;
		}
		return "worker: " + workerItem["id"] + "\nhand: " + workerItem["hand"]["id"];
	}

	private void OnHandChosen(JSONNode handNode)
	{
		GameState.GetInstance().Hand = handNode;
		GetComponentInParent<Game>().InitializeDynamicData();
	}
}
