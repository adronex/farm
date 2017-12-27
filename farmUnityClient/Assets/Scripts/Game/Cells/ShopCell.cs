using SimpleJSON;
using UnityEngine;
using UnityEngine.UI;

public class ShopCell : MonoBehaviour
{
	private JSONNode _cellState;
	
	// Use this for initialization
	void Start ()
	{
	}
	
	// Update is called once per frame
	void Update () {
		
	}

	public void SetState(GridLayoutGroup parentShop, JSONNode shopNode, JSONNode softMoney)
	{
		_cellState = shopNode;
		transform.SetParent(parentShop.transform, false);
		GetComponentInChildren<Text>().text = GetShopItemText(_cellState);
		GetComponent<Image>().color = GetShopItemColor(_cellState, softMoney["count"].AsInt);
		GetComponent<Button>().onClick.AddListener(delegate { OnHandChosen(_cellState["item"]); });
	}
    
	private static Color GetShopItemColor(JSONNode shopItem, int softMoney)
	{
		if (shopItem["buyPrice"].AsInt > softMoney) {
			return new Color(1f, 0.61f, 0.6f);
		}
		return new Color(0.49f, 1f, 0.54f);
	}

	private static string GetShopItemText(JSONNode shopItem)
	{
		return shopItem["item"]["id"] + "\nbuy price: " + shopItem["buyPrice"].AsInt + "\nsell price: " + shopItem["sellPrice"].AsInt;
	}

	private static void OnHandChosen(JSONNode handNode)
	{
		GameState.GetInstance().Hand = handNode;
	}
}
