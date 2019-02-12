using System.Collections;
using System.Runtime.InteropServices;
using UnityEngine;
using UnityEngine.Rendering;

public class FaceDots : MonoBehaviour{

    struct DotData
    {
        public Vector3 position;
        public Vector3 velocity;
        public Vector4 color;
        public Vector3 basePos;
        public Vector3 scale;
        public Vector2 uv;
        //public Vector3 rotation;
        public float time;        
    }

    [SerializeField] private Mesh _posMesh;
    [SerializeField] int _num = 10000;
    [SerializeField] int _numX = 256; 
    [SerializeField] int _numY = 256;
    //[SerializeField] Texture2D _src;
    [SerializeField] float width;
    [SerializeField,Range(0.001f,1f)] float _size;//_Size ("_Size", Range(0.04,0.1)) = 0.04

    int ThreadBlockSize = 64;//256;

    ComputeBuffer _cubeDataBuffer;
    ComputeBuffer _argsBuffer;
    private uint[] _args = new uint[5] { 0, 0, 0, 0, 0 };
    [SerializeField] private Mesh _mesh;
    [SerializeField] ComputeShader _computeShader;
    [SerializeField] private Material _material;
    [SerializeField] private FaceMeshManager _faceManager;
    [SerializeField] private RenderTexture _tex;
    private float _time = 0;

    private Vector4[] _positions;
    private int _count = 0;

    void Start(){

        //yatteikou

        _num = _numX * _numY;

        _cubeDataBuffer = new ComputeBuffer(_num, Marshal.SizeOf(typeof(DotData)));
        _argsBuffer = new ComputeBuffer(1, _args.Length * sizeof(uint), ComputeBufferType.IndirectArguments);

        var dataArr = new DotData[_num];

        //float width = 10f;
        float height = width * (float)_numY / _numX;

        int idx = 0;
        for (int i = 0; i < _numX; ++i){
            for (int j = 0; j < _numY; ++j){

                float rx = (float)i/(_numX-1);
                float ry = (float)j/(_numY-1);
                dataArr[idx] = new DotData();
                dataArr[idx].position = new Vector3(
                    (rx-0.5f) * width,
                    (ry-0.5f) * height,
                    0
                );
                dataArr[idx].scale = Vector3.one;
                dataArr[idx].basePos = new Vector3(
                    (rx-0.5f) * width,
                    (ry-0.5f) * height,
                    0
                );
                dataArr[idx].velocity = new Vector3(
                    0.01f * ( Random.value - 0.5f ),
                    0.01f * ( Random.value - 0.5f ),
                    0.01f * ( Random.value - 0.5f )
                );

                dataArr[idx].time = Random.value * 2f;

                //dataArr[idx].rotation = Vector3.zero;

                dataArr[idx].color = new Vector4(
                    0,
                    0,
                    0,
                    1f
                );

                dataArr[idx].uv = new Vector2(
                    (float) i / (_numX),
                    (float) j / (_numY)
                );
                idx++;
            }
        }
        _cubeDataBuffer.SetData(dataArr);
        
        _positions = new Vector4[3000];
        
        


    }


    void Update(){
        
        //computeShaderに値を渡す

            //重くなければ。
            if(_faceManager.faceMesh ){
                for(int i=0;i<200;i++){

                    Vector3 vv = Utils.RandomPointOnMesh.Sample( _faceManager.faceMesh );
                    _positions[_count] = new Vector4(
                        vv.x,
                        vv.y,
                        vv.z,
                        0
                    );
                    _count++;
                    _count = _count % _positions.Length;
                }
            }

            // ComputeShader

            int kernelId = _computeShader.FindKernel("MainCS");
            _computeShader.SetTexture(kernelId, "_Tex", _tex);

            _computeShader.SetMatrix("_viewMatrix", Camera.main.worldToCameraMatrix );
            _computeShader.SetMatrix("_projMatrix", Camera.main.projectionMatrix );
            _computeShader.SetMatrix("_modelMatrix", transform.localToWorldMatrix );
            
            _computeShader.SetFloat("_DeltaTime", Time.deltaTime);
            _computeShader.SetVectorArray("_Positions", _positions);
            _computeShader.SetBuffer(kernelId, "_CubeDataBuffer", _cubeDataBuffer);
            _computeShader.Dispatch(kernelId, (Mathf.CeilToInt(_num / ThreadBlockSize) + 1), 1, 1);

            _args[0] = (uint)_mesh.GetIndexCount(0);
            _args[1] = (uint)_num;
            _args[2] = (uint)_mesh.GetIndexStart(0);
            _args[3] = (uint)_mesh.GetBaseVertex(0);

            _argsBuffer.SetData(_args);

            // GPU Instaicing
            _material.SetBuffer("_CubeDataBuffer", _cubeDataBuffer);//データを渡す
            //_material.SetVector("_DokabenMeshScale", this._DokabenMeshScale);
            _material.SetMatrix("_modelMatrix", transform.localToWorldMatrix );
            _material.SetFloat("_Size",_size);
            _material.SetVector("_Num",new Vector4(_numX,_numY,0,0));
            
            Graphics.DrawMeshInstancedIndirect(
                _mesh,
                0, 
                _material, 
                new Bounds(Vector3.zero, new Vector3(32f, 32f, 32f)), 
                _argsBuffer,//Indirectには必要なんか
                0,
                null,
                ShadowCastingMode.Off,
                false
            );
            
            //gameObject.transform.Rotate(new Vector3(0.01f,0.005f,0));

    }

}