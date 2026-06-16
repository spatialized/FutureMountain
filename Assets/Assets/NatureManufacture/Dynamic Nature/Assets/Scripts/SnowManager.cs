using UnityEngine;
using System.Collections;
using System.Collections.Generic;

[ExecuteInEditMode]
public class SnowManager : MonoBehaviour
{

	public float particleTurnOn = 0.0001f;
	public List< ParticleSystem > particles;
	public List< Material > materials;

	public int particlesSize;
	public bool particlesCollapsed;

	public int materialsSize;
	public bool materialsCollapsed;

	public float snowValue;
	public float snowValueOld;

	public float seasonValue;
	public float seasonValueOld;

	public float snowGrassValue;
	public float snowGrassValueOld;

	public float snowGrassValueMax = 1;
	public float snowGrassValueOldMax;

	public Texture2D snowGrassTex;
	public Texture2D snowGrassTexOld;

	public float snowX;
	public float snowXOld;
	public float snowY;
	public float snowYOld;


	public void Start ()
	{
		Shader.SetGlobalFloat ("_Snow_Amount", Mathf.Clamp (snowValue * snowGrassValue, 0, snowGrassValueMax));
		Shader.SetGlobalFloat ("_Season", seasonValue);
		Shader.SetGlobalTexture ("_SnowTex", snowGrassTex);

	}

	public void Update ()
	{
		if (seasonValue != seasonValueOld) {


			Shader.SetGlobalFloat ("_Season", seasonValue);

		}

		if (snowGrassTex != snowGrassTexOld) {

			snowGrassTexOld = snowGrassTex;
			Shader.SetGlobalTexture ("_SnowTex", snowGrassTex);

		}

		if (seasonValue != seasonValueOld || snowGrassValue != snowGrassValueOld || snowGrassValueMax != snowGrassValueOldMax || snowValue != snowValueOld) {

			snowValueOld = snowValue;
			seasonValueOld = seasonValue;
			snowGrassValueOld = snowGrassValue;
			snowGrassValueOldMax = snowGrassValueMax;
			Shader.SetGlobalFloat ("_Snow_Amount", Mathf.Clamp (snowValue * snowGrassValue, 0, snowGrassValueMax));




			foreach (var item in materials) {
				if (item != null) { 
					item.SetFloat ("_Snow_Amount", snowValue);
					item.SetFloat ("_Season", seasonValue);
				}
			}

			if (snowValue > particleTurnOn) {
				foreach (var item in particles) {
					if (item != null && !item.gameObject.activeSelf)
						item.gameObject.SetActive (true);
				}
			} else {
				foreach (var item in particles) {
					if (item != null && item.gameObject.activeSelf)
						item.gameObject.SetActive (false);
				}
			}


		}

	}

}