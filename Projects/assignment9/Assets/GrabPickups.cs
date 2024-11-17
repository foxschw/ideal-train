using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class GrabPickups : MonoBehaviour {

	private AudioSource pickupSoundSource;

	// reference to level number
	public static int currentLevel = 1;

	void Awake() {
		pickupSoundSource = DontDestroy.instance.GetComponents<AudioSource>()[1];
	}

	void OnControllerColliderHit(ControllerColliderHit hit) {
		// ensure coin hasn't been picked up already
		if (hit.gameObject.tag == "Pickup" && LevelGenerator.coinPickedUp == false) {
			// set boolean to true to prevent multiple pickups
			LevelGenerator.coinPickedUp = true;
			pickupSoundSource.Play();
			// increment current level
			currentLevel++;
			SceneManager.LoadScene("Play");
		}
	}
}
