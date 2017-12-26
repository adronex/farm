using System;
using System.Diagnostics;
using SimpleJSON;
using UnityEngine;

public class Styles
{
    public static Color GetBagItemColor(JSONNode bagItem)
    {
        if (!bagItem["item"]["countable"].AsBool) {
            return new Color(1f, 0.95f, 0.54f);
        }
        if (bagItem["count"].AsInt > 0) {
            return new Color(0.49f, 1f, 0.54f);
        }
        return new Color(0.6f, 0.6f, 0.6f);
    }
    
    public static Color GetShopItemColor(JSONNode shopItem, int softMoney)
    {
        if (shopItem["buyPrice"].AsInt > softMoney) {
            return new Color(1f, 0.61f, 0.6f);
        }
        return new Color(0.49f, 1f, 0.54f);
    }

    public static Color GetFarmCellColor(JSONNode farmCell)
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
        
}