using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

namespace NatureManufacture.RAM
{
    public interface IGenerationEvents
    {
        public UnityEvent OnGenerationEnded { get; set; }
        public UnityEvent OnGenerationStarted { get; set; }
    }
}