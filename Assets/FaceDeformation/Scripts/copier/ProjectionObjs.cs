using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ProjectionObjs : MonoBehaviour {

	[SerializeField] private ProjObj _src;
	[SerializeField] private Camera _projectionCam;
	[SerializeField] private Camera _camera;
	[SerializeField] private RenderTexture _camTex;

	private List<ProjObj> _objs;

	void Start () {
		_objs = new List<ProjObj>();

		for(int i=0;i<5;i++){

			var gen = Instantiate(_src,transform,false);
			gen.gameObject.SetActive(true);
			_objs.Add(gen);

			Debug.Log("gen");
		}

	}
	


	// Update is called once per frame
	void Update () {
		

        if (Input.touchCount > 0)
        {
            Touch touch = Input.GetTouch(0);
            if (touch.phase == TouchPhase.Began)// || touch.phase==TouchPhase.Stationary)
            {
				_Cap();
			}
		}

		if(Input.GetKeyDown(KeyCode.Space)){
			_Cap();
		}

		//_material.SetMatrix("_tMat", 		_tMat );
		//_material.SetMatrix("_projMat", 	_projMat);//_projectionCam.projectionMatrix );
		//_material.SetMatrix("_viewMat", 	_viewMat);
		//_material.SetTexture("_MainTex", _renderTexture );

	}

	void _Cap(){


			var projMat = _projectionCam.projectionMatrix;
			var viewMat = _projectionCam.worldToCameraMatrix;

			for(int i=0; i<_objs.Count;i++){
				var gen = _objs[i];
				float r = 0.05f * Random.value;
				gen.transform.localScale = new Vector3(0.3f,0.3f,0.3f);

				var offset = new Vector3(
					0,//0.07f*( Random.value-0.5f ),
					(float)(i-2f)/15f,//0.07f*( Random.value-0.5f ),
					0//-0.05f*( Random.value )
				);

				gen.transform.localPosition = Vector3.zero + offset;//_camera.transform.position + _camera.transform.forward*0.7f + offset;
				//gen.transform.LookAt( _camera.transform );
				//gen.transform.localRotation = Quaternion.Euler(0,((float)i-4.5f)*90f,0);
				gen.Init(projMat,viewMat,_camTex);
			}

	}


}
