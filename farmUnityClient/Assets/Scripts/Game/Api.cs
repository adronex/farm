using System;
using SimpleJSON;
using UnityEngine;

public class Api : MonoBehaviour
{
    private HttpRequestHandler _requestHandler = new HttpRequestHandler();

    public void ExecuteCommand(JSONNode requestBody, Action<string> successCallback, Action<string> errorCallback)
    {
        Debug.Log(requestBody.ToString());
        StartCoroutine(
            _requestHandler.PostRequest(
                HttpRequestHandler.ServerUrl + "/game/execute", requestBody.ToString(),
                successCallback,
                errorCallback
            )
        );
    }
}