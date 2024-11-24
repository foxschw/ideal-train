using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MovingBall : MonoBehaviour
{
    // object speed
    public float speed = 2.0f;
    // boundaries for moving object
    public float minZ = -11f;
    public float maxZ = -7f;

    public GameObject movingBall;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
       
        // calculate the Z position between minZ and maxZ
        float zPosition = Mathf.PingPong(Time.time * speed, maxZ - minZ) + minZ;

        // move the ball
        movingBall.transform.position = new Vector3(
            movingBall.transform.position.x, 
            movingBall.transform.position.y, 
            zPosition
        );

    }
}
