using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

public class ConiferController : TreeController {
	private static float prefabHeight = 10f;

	/* Materials */
	public Renderer lod0Rend;
	public Material lod0LeafMaterial;		// Leaf material for LOD 0
	public Renderer lod1Rend;
	public Material lod1LeafMaterial;		// Leaf material for LOD 1
	public Renderer lod2Rend;
	public Material lod2LeafMaterial;		// Leaf material for LOD 2
	public Renderer lodBRend;
	public Material lodBLeafMaterial;		// Leaf material for LOD 2

	/* Initialize conifer */
	public void InitializeConifer () {
		showParticles = false;
		particlesEnabled = false;

		if(transform.parent.name == "LargeTerrain")
			treeFullHeightScale = UnityEngine.Random.Range (0.22f, 0.4f);
		else
			treeFullHeightScale = UnityEngine.Random.Range (0.45f, 0.8f);

        //growthSpeed = 0.1f;

		particleEmissionFactor = 10f;
		maxLeafCarbon = 1.8f;

		GameObject evapTrans = transform.Find("EvapTrans").gameObject;
		etParticles = evapTrans.GetComponent<ParticleSystem>(); 
		if (!showParticles) {
			etParticles.Stop ();
			var emission = etParticles.emission;
			emission.rateOverTime = 0;
			particlesEnabled = false;
		}

		GameObject lod0 = transform.Find("Conifer_LOD0").gameObject;
		lod0Rend = lod0.GetComponent<Renderer>();
		lod0LeafMaterial = lod0Rend.materials[3];
		GameObject lod1 = transform.Find("Conifer_LOD1").gameObject;
		lod1Rend = lod1.GetComponent<Renderer>();
		lod1LeafMaterial = lod1Rend.materials[3];
		GameObject lod2 = transform.Find("Conifer_LOD2").gameObject;
		lod2Rend = lod2.GetComponent<Renderer>();
		lod2LeafMaterial = lod2Rend.materials[2];
		GameObject lodB = transform.Find("Conifer_Billboard").gameObject;
		lodBRend = lodB.GetComponent<Renderer>();
		lodBLeafMaterial = lodBRend.materials[0];

		//growthStartTime = Time.time;
	}

	/* Update size and emission state */
	void Update () {
		//if (Time.time < growthStartTime + 5.0f) {									// Grow conifer
		//	float dist = (Time.time - growthStartTime) * growthSpeed;
		//	transform.localScale = Vector3.Lerp (Vector3.zero, Vector3.one * treeSize, dist);
		//} else if (!showParticles && Time.time + growthStartTime > 5.0f) {
		//	showParticles = true;
		//}

		if(showParticles && !particlesEnabled){

			float emissionRate = transpiration * particleEmissionFactor;
			var emission = etParticles.emission;
			emission.rateOverTime = (int)emissionRate;

			etParticles.Play();
			particlesEnabled = true;
		}

		if(!showParticles && particlesEnabled){
			etParticles.Stop();
			var emission = etParticles.emission;

			emission.rateOverTime = 0;
			particlesEnabled = false;

			//etParticles.Pause();
			//etParticles.Clear();
		}
	}

	/* Update simulation state */
	public void UpdateSimulation(int curTime, float newTranspiration, float newLeafCarbon, float newStemCarbon)
	{
		leafCarbon = newLeafCarbon;
		stemCarbon = newLeafCarbon;
		transpiration = newTranspiration;					// -- Randomize between trees?

		if (leafCarbon < maxLeafCarbon)
//			alphaCutoff = 1f - MapValue (leafCarbon, 0f, maxLeafCarbon, 0f, 0.9f);
			alphaCutoff = 1f - MapValue (leafCarbon, 0f, maxLeafCarbon, 0f, 0.6f);
		else
			alphaCutoff = 0.1f;

		lod0LeafMaterial.SetFloat ("_Cutoff", alphaCutoff);
		lod1LeafMaterial.SetFloat ("_Cutoff", alphaCutoff);
		lod2LeafMaterial.SetFloat ("_Cutoff", alphaCutoff);

		float emissionRate = transpiration * particleEmissionFactor;
		var emission = etParticles.emission;
		emission.rateOverTime = (int)emissionRate;
	}

	/* Set initial simulation values */
	public void UpdateParams(Terrain cubeTerrain, float newTranspiration, float newLeafCarbon, float newStemCarbon)
	{
		var xPos = transform.localPosition.x;
		var yPos = cubeTerrain.SampleHeight (transform.position) + treeFullHeightScale * prefabHeight;	// -- Use localPosition ??
		var zPos = transform.localPosition.z;

		transform.localPosition = new Vector3 (xPos, yPos, zPos);

		transform.localScale = Vector3.zero;								// Start at scale 0

//		timeStepFreq = newTimeStepFreq;
		UpdateSimulation(-1, newTranspiration, newLeafCarbon, newStemCarbon);
	}
}
