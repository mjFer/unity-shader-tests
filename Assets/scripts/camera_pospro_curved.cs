using UnityEngine;
using System.Collections;

public class camera_pospro_curved : MonoBehaviour {



    public Material mat;
    void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        Graphics.Blit(src, dest, mat);
    }
}
