using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FaceData {

	//texture wo 

	public Mesh mesh;
	public Material material;
	private Matrix4x4 _faceMatrix;
	private Matrix4x4 _displayMatrix;
	public RenderTexture renderTexture;

	public Vector3 position;
	public Quaternion rotation;

	public Vector3 velocity;

	public FaceData(Shader shader)
    {
		position = Vector3.zero;
		rotation = Quaternion.identity;

        renderTexture = new RenderTexture(1218,512,0);
		material = new Material(shader);

		velocity=Vector3.zero;
		
		//mesh = new Mesh();
    }

	public void DrawTexture(RenderTexture src){
		
		Graphics.Blit(src,renderTexture);
		material.mainTexture = renderTexture;

	}

	public void UpdateMesh(Mesh tgt){
		
		mesh.vertices 	= tgt.vertices;
		
        /*
        var mesh = new Mesh();
        mesh.name = name;
        mesh.vertices = m.vertices;
        mesh.uv = m.uv;
        mesh.SetIndices(m.triangles, MeshTopology.Triangles,0 );
		 */
    
	}

	public void SetPosition(
		Vector3 pos, 
		Quaternion rot, 
		Matrix4x4 faceMatrix, 
		Matrix4x4 displayMatrix
	){
		
		position = pos;
		rotation = rot;
		_faceMatrix = faceMatrix;
		_displayMatrix = displayMatrix;

		material.SetMatrix("_faceMatrix",		_faceMatrix);
		material.SetMatrix("_displayMatrix",	_displayMatrix);

	}

	public void Update(){
		position += velocity;
	}


	public void DrawMesh(){
		
		if(_faceMatrix!=null && mesh !=null){
			//Graphics.DrawMesh(	mesh,faceMatrix,material,0,Camera.main,0,null,false,false);
			Graphics.DrawMesh( mesh, position, rotation, material, 0, Camera.main, 0, null, false, false);
		}

	}

}
