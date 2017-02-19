using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class guardAi : MonoBehaviour {

	public float targetDistance;
	public float visibilityDistance;
	public float attackDistance;
	public float targetMovementSpeed;
	public float damping;
	public Transform target;
	Rigidbody body;
	Renderer myRenderer;


	// Use this for initialization
	void Start () {

		myRenderer = GetComponent<Renderer>();
		body = GetComponent<Rigidbody> ();

	}

	// Update is called once per frame
	void FixedUpdate () {
		targetDistance = Vector3.Distance (target.position,transform.position);

		//ALERT STATE
		if (targetDistance < visibilityDistance) {
			myRenderer.material.color = Color.yellow;
			alert();

			//ATTACK STATE
			if (targetDistance < attackDistance) {
				myRenderer.material.color = Color.red;
				attack ();
			}

		}

	
		//PATROL STATE
		else {
			myRenderer.material.color = Color.green;
		}
	}

	void alert(){
		Quaternion rotation = Quaternion.LookRotation (target.position - transform.position);
		transform.rotation = Quaternion.Slerp (transform.rotation, rotation, Time.deltaTime * damping);
	}

	void attack(){
		
		body.AddForce (transform.forward * targetMovementSpeed);
	}



}

