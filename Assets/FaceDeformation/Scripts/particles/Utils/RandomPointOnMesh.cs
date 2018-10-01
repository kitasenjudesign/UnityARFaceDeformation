using UnityEngine;
using System.Collections;

namespace Utils {

    public class RandomPointOnMesh {

        public static Vector3 Sample (Mesh mesh) {
            int[] triangles = mesh.triangles;
            int index = Mathf.FloorToInt(Random.value * (triangles.Length / 3));
            Vector3 v0 = mesh.vertices[triangles[index * 3 + 0]];
            Vector3 v1 = mesh.vertices[triangles[index * 3 + 1]];
            Vector3 v2 = mesh.vertices[triangles[index * 3 + 2]];
            return Vector3.Lerp(v0, Vector3.Lerp(v1, v2, Random.value), Random.value);
        }
        
    }
    
}