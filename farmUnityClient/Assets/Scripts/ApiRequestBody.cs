using System;
using SimpleJSON;

[Serializable]
public class ApiRequestBody
{
    public string command;
    public JSONNode hand;
    public JSONNode target;

//    [Serializable]
//    public class Hand
//    {
//        public string itemId;
//
//        public Hand(string itemId)
//        {
//            this.itemId = itemId;
//        }
//    }
//
//    [Serializable]
//    public class Target
//    {
//        public int x;
//        public int y;
//        
//        public Target(int x, int y)
//        {
//            this.x = x;
//            this.y = y;
//        }
//    }
   
    public ApiRequestBody(string command, JSONNode hand, JSONNode target)
    {
        this.command = command;
        this.hand = hand;
        this.target = target;
//        hand = new Hand(handItemId);
//        target = new Target(targetX, targetY);
    }
}