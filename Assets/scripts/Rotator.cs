using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Rotator : MonoBehaviour {

	public GameObject target;
	public float distance;
	public float rotationSpeed;

	public float polarAngle;

	private float azimuthalAngle;

	void Start () {
		azimuthalAngle = 0;
	}
	
	void Update () {
		azimuthalAngle += Time.deltaTime * rotationSpeed;

		float x = target.transform.position.x + distance * Mathf.Cos(azimuthalAngle) * Mathf.Sin(polarAngle);
		float y = target.transform.position.y - distance * Mathf.Cos(polarAngle);
		float z = target.transform.position.z + distance * Mathf.Sin(azimuthalAngle) * Mathf.Sin(polarAngle);

		transform.position = new Vector3(x, y, z);

		transform.LookAt(target.transform);
	}
}
