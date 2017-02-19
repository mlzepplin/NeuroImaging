using UnityEngine;
using System.Collections;

public class DoorAnimation : MonoBehaviour {

    // Whether or not a key is required.
    public bool requireKey;
    // Clip to play when the doors open or close.
    public AudioClip doorSwishClip;
    // Clip to play when the player doesn't have the key for the door.
    public AudioClip accessDeniedClip;

    // Reference to the animator component.
    Animator anim;
    // Reference to the HashIDs script.				
    HashIDs hash;
    // Reference to the player GameObject.			
    int count;								

    void Awake() {
        // Setting up the references.
        anim = GetComponent<Animator>();
        hash = GameObject.FindGameObjectWithTag(Tags.gameController).GetComponent<HashIDs>();
    }

    void Update() {
        // Set the open parameter.
        anim.SetBool(hash.openBool, count > 0);

        // If the door is opening or closing...
        if (anim.IsInTransition(0) && !GetComponent<AudioSource>().isPlaying) {
            // ... play the door swish audio clip.
            AudioManager.instance.PlaySound(GetComponent<AudioSource>(), doorSwishClip);
        }
    }
}
