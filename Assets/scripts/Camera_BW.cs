using UnityEngine;
using System.Collections;


[ExecuteInEditMode]
public class Camera_BW : MonoBehaviour
{

    public float intensity;
    private Material material;

    public bool auto;
    public float frecuency;
    private float time;

    // Creates a private material used to the effect
    void Awake()
    {
        material = new Material(Shader.Find("Custom/BWShader"));
        time = 0;
    }

    // Postprocess the image
    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (auto)
        {
            time += Time.deltaTime;
            intensity = Mathf.Sin(time * frecuency * 2 * Mathf.PI);
        }

        if (intensity == 0)
        {
            Graphics.Blit(source, destination);
            return;
        }

        material.SetFloat("_bwBlend", intensity);
        Graphics.Blit(source, destination, material);
    }
}