using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.XR.iOS;

public class FaceDuplicator : MonoBehaviour {

	[SerializeField] private UnityARVideo _arVideo;
	[SerializeField] private FaceMeshManager _faceManager;
	[SerializeField] private Shader _faceShader;
	[SerializeField] private RenderTexture _renderTexture;

	public const int MAX = 30;
	private List<FaceData> _faceList;

	private int _counter = 0;

	void Start () {
		
		Debug.Log("Start");
		_faceList = new List<FaceData>();
		for(int i=0;i<MAX;i++){
			_faceList.Add( new FaceData(_faceShader) );
		}

		UpdateFace();

	}
	
	void UpdateFace(){
		
		if( _faceManager.faceMesh == null ){			
			Invoke("UpdateFace",0.1f);
			return;
		}

		int len = _faceList.Count;

		if(_faceList[_counter%len].mesh==null){
			_faceList[_counter%len].mesh = Instantiate( _faceManager.faceMesh );
		}else{
			_faceList[_counter%len].UpdateMesh( _faceManager.faceMesh );
		}
		
		_faceList[_counter%len].velocity.x = 0.008f * Mathf.Cos(_counter/7f);
		_faceList[_counter%len].velocity.y = 0.008f * Mathf.Sin(_counter/7f);
		_faceList[_counter%len].velocity.z -= 0.0002f;
		_faceList[_counter%len].DrawTexture(_renderTexture);
		_faceList[_counter%len].SetPosition( 
			_faceManager.transform.position,
			_faceManager.transform.rotation,
			_faceManager.faceMatrix,
			_arVideo._displayTransform
		);
		_counter++;

		Invoke("UpdateFace",0.1f);

	}

	void Update () {
		
		if(_faceManager==null){
			return;
		}

		for(int i=0;i<_faceList.Count;i++){
			_faceList[i].Update();
			_faceList[i].DrawMesh();
		}

	}
}
