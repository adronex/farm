using SimpleJSON;
using UnityEngine;
public class Api: MonoBehaviour
{
    private HttpRequestHandler _requestHandler = new HttpRequestHandler();

    private void Start()
    {
        ExecuteCommand();
    }

    public void ExecuteCommand()
    {
        StartCoroutine(_requestHandler.PostRequest(HttpRequestHandler.ServerUrl + "/game/execute", "[{\"command\": \"GET\"}]"));
    }
}