using System;
using System.Collections;
using SimpleJSON;
using UnityEngine;
using UnityEngine.Networking;

public class HttpRequestHandler
{
    private const string Protocol = "http";
    private const string Host = "localhost";
    private const string Port = "4567";
    public const string ServerUrl = Protocol + "://" + Host + ":" + Port;

    public IEnumerator GetRequest(string uri)
    {
        var uwr = UnityWebRequest.Get(uri);
        yield return uwr.SendWebRequest();

        if (uwr.isNetworkError)
        {
            Debug.Log("Error While Sending: " + uwr.error);
        }
        else
        {
            Debug.Log("Received: " + uwr.downloadHandler.text);
        }
    }
    
    public IEnumerator PostRequest(string url, string requestBody, Action<string> successCallback, Action<string> errorCallback)
    {
        var uwr = new UnityWebRequest(url, "POST");
        var jsonToSend = new System.Text.UTF8Encoding().GetBytes(requestBody);
        uwr.uploadHandler = new UploadHandlerRaw(jsonToSend);
        uwr.downloadHandler = new DownloadHandlerBuffer();
        uwr.SetRequestHeader("Content-Type", "application/json");

        //Send the request then wait here until it returns
        yield return uwr.SendWebRequest();

        if (uwr.isNetworkError || uwr.isHttpError)
        {
            errorCallback(uwr.error);
        }
        else
        {
            successCallback(uwr.downloadHandler.text);
        }
    }
}