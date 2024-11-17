using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class CurrentLevelText : MonoBehaviour
{
   
   // variable for the text to show what level we're on
   public Text levelText;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        // formulate the text
        levelText.text = "Maze: " + GrabPickups.currentLevel.ToString();
    }
}
