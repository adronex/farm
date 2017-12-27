using SimpleJSON;
using UnityEngine;
using UnityEngine.UI;

public class BagCell : MonoBehaviour
{
	private JSONNode _cellState;
	
	// Use this for initialization
	void Start ()
	{
	}
	
	// Update is called once per frame
	void Update () {
		
	}

	public void SetState(GridLayoutGroup parentBag, JSONNode bagNode)
	{
		_cellState = bagNode;
		transform.SetParent(parentBag.transform, false);
		GetComponentInChildren<Text>().text = GetBagItemText(_cellState);
		GetComponent<Image>().color = GetBagItemColor(_cellState);
		GetComponent<Button>().onClick.AddListener(delegate { OnHandChosen(_cellState["item"]); });
	}
	
	private static Color GetBagItemColor(JSONNode bagItem)
	{
		if (!bagItem["item"]["countable"].AsBool) {
			return new Color(1f, 0.95f, 0.54f);
		}
		if (bagItem["count"].AsInt > 0) {
			return new Color(0.49f, 1f, 0.54f);
		}
		return new Color(0.6f, 0.6f, 0.6f);
	}

	private static string GetBagItemText(JSONNode inventoryItem)
	{
		return inventoryItem["item"]["id"] + "\ncount: " + inventoryItem["count"].AsInt;
	}

	private static void OnHandChosen(JSONNode handNode)
	{
		GameState.GetInstance().Hand = handNode;
	}
}
