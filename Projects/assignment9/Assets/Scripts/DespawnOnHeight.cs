using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class DespawnOnHeight : MonoBehaviour {

    // reference to FPS Controller
    public GameObject characterController;

    // establish a variable for the previously indestructable audio to be destroyed
    public GameObject whisperAudio;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        // if character drops below zero on Y axis, destroy the scene audio and launch Game Over scene
        if (characterController.transform.position.y < 0) {
            Destroy(whisperAudio);
            SceneManager.LoadScene("GameOver");
        }
    }
}
