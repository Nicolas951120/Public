using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class demo : MonoBehaviour {

	// Use this for initialization
	void Start () {
		IList data = new ArrayList ();
		data.Add (1);data.Add (2);
		foreach (int item in data) {
			Debug.Log (item);
		}
		Dictionary<string,int> map = new Dictionary<string, int> ();
		map ["zs"] = 10;map ["is"] = 20;
		foreach (string key in map.Keys) {
			Debug.Log (map [key]);
		}

		Debug.Log ("============queue============");
		Queue<int> que = new Queue<int> ();
		Debug.Log ("Enqueue 100");
		que.Enqueue (100);
		Debug.Log ("Count:"+que.Count);
		Debug.Log ("Peek:"+que.Peek());
		Debug.Log ("Enqueue 200");
		que.Enqueue (200);
		Debug.Log ("Count:"+que.Count);
		Debug.Log ("Peek:" +que.Peek());
		int k = que.Dequeue();
		Debug.Log ("Dequeue():"+k);
		Debug.Log ("Count:"+que.Count);
		Debug.Log ("Peek:"+que.Peek());
		Debug.Log ("============stack============");
		Stack<int> ss = new Stack<int> ();
		ss.Push (11);ss.Push (22);ss.Push (33);
		Debug.Log ("Push 11,22,33 to queue");
		Debug.Log ("Count:" + ss.Count);
		Debug.Log ("Pop():" + ss.Pop ());
		Debug.Log ("Peek():" + ss.Peek ());
		Debug.Log ("Count:" + ss.Count);
	}
	
	// Update is called once per frame
	void Update () {
	
	}
}
