using UnityEngine;

public class CameraController: MonoBehaviour
{
    private const int StepX = 10;
    private const int StepY = 10;

    void Update()
    {
        if (Input.GetKey(KeyCode.W))
        {
            var oldPos = transform.position;
            var newPos = new Vector3(oldPos.x, oldPos.y + StepY, oldPos.z);
            transform.SetPositionAndRotation(newPos, Quaternion.identity);
        }
        if (Input.GetKey(KeyCode.S))
        {
            var oldPos = transform.position;
            var newPos = new Vector3(oldPos.x, oldPos.y - StepY, oldPos.z);
            transform.SetPositionAndRotation(newPos, Quaternion.identity);
        }
        if (Input.GetKey(KeyCode.A))
        {
            var oldPos = transform.position;
            var newPos = new Vector3(oldPos.x - StepX, oldPos.y, oldPos.z);
            transform.SetPositionAndRotation(newPos, Quaternion.identity);
        }
        if (Input.GetKey(KeyCode.D))
        {
            var oldPos = transform.position;
            var newPos = new Vector3(oldPos.x + StepX, oldPos.y, oldPos.z);
            transform.SetPositionAndRotation(newPos, Quaternion.identity);
        }
    }
}