using System;
using SimpleJSON;

public class Utils
{

    public static JSONNode FindInJsonArray(JSONArray array, Func<JSONNode, bool> func)
    {
        foreach (var node in array)
        {
            if (func(node))
            {
                return node;
            }
        }
        return null;
    }

    public static long Now()
    {
        return DateTime.Now.Subtract(new DateTime(1970, 1, 1, 0, 0, 0, DateTimeKind.Utc)).Ticks /
               TimeSpan.TicksPerMillisecond;
    }
}