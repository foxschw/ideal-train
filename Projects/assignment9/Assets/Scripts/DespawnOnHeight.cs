using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class DespawnOnHeight : MonoBehaviour {

    // reference to FPS Controller
    public GameObject characterController;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        // if character drops below zero on Y axis, launch Game Over scene
        if (characterController.transform.position.y < 0) {
            SceneManager.LoadScene("GameOver");
        }
    }
}
