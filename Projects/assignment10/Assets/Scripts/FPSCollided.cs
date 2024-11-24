using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class FPSCollided : MonoBehaviour
{
    public Text text;

    private bool collided;


    // Start is called before the first frame update
    void Start()
    {
        collided = false;
        // Set the text color to visible
        text.color = new Color(0, 0, 0, 0);
    }

    // Update is called once per frame
    void Update()
    {
        if (collided) {
            if (Input.GetButtonDown("Submit")) {
                // reload entire scene, starting music over again, refreshing score, etc.
                SceneManager.LoadScene("Assignment10");
            }
        }
    }
    void OnTriggerEnter(Collider collision)
{
    if (collision.gameObject.name == "Finish")
    {
        collided = true;
        // Set the text color to visible
        text.color = new Color(0, 0, 0, 1);
    }
}
}
