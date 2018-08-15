using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.XR.iOS;

public class ExampleControl : MonoBehaviour {

    [SerializeField] private Material[] _materials;
    [SerializeField] private Vector3[] _positions;
    [SerializeField] private Vector3[] _scales;
    [SerializeField] private FaceMeshManager _meshManager;

    [SerializeField] private GameObject _target;

    private int _count = 0;

    void Update(){

        if(Input.GetKeyDown(KeyCode.Space)){
            
            _count++;
            _count = _count%_materials.Length;
            _meshManager.SetFaceMat(_materials[_count]);

            _target.transform.localPosition     = _positions[_count];
            _target.transform.localScale        = _scales[_count]; 

        }

    }


}