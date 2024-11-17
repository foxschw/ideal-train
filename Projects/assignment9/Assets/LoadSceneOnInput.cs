using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class LoadSceneOnInput : MonoBehaviour {
	
    // establish a variable for the previously indestructable audio to be destroyed
    private GameObject whisperSource;
	
	// Use this for initialization
	void Start () {
		// since the game object is not accessible from the gameover scene, find it.
		whisperSource = GameObject.Find("WhisperSource");
	}
	
	// Update is called once per frame
	void Update () {
		if (Input.GetAxis("Submit") == 1) {
			if (SceneManager.GetActiveScene().name == "GameOver") {
				Destroy(whisperSource);
				SceneManager.LoadScene("Title");

			} else {
			SceneManager.LoadScene("Play");
			}
		}
	}
}
