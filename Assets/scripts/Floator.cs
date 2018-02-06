using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Floator : MonoBehaviour {
	public float amplitude;
	public float speed;

	private Vector3 startPosition;
	private float offset;
	
	void Start () {
		startPosition = transform.position;
		offset = 0;
	}
	
	
	void Update () {
		offset = amplitude * Mathf.Sin(Time.fixedTime * 2 * Mathf.PI * speed);
		transform.position = startPosition + new Vector3(0, offset, 0);
	}
}
