using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ArrayCreator : MonoBehaviour {
	public int xCount;
	public int zCount;

	public float separation;
	public GameObject target;

	void Start () {
		for(int x=0; x<xCount; x++){
			for (int z = 0; z < zCount; z++) {
				GameObject child = Instantiate(target, this.transform);
				child.transform.localPosition = new Vector3( (x - xCount / 2) * separation , 0, (z- zCount / 2) * separation );
			}
		}
	}
	
}
