using System.Collections.Generic;
using UnityEngine;
using UnityEngine.XR;


namespace DynamicFogAndMist {

    public static class VRCheck {

#if UNITY_2019_3_OR_NEWER

        static List<XRDisplaySubsystemDescriptor> displaysDescs = new List<XRDisplaySubsystemDescriptor>();
        static List<XRDisplaySubsystem> displays = new List<XRDisplaySubsystem>();

    public static bool IsActive() {
        displaysDescs.Clear();
        SubsystemManager.GetSubsystemDescriptors(displaysDescs);

        // If there are registered display descriptors that is a good indication that VR is most likely "enabled"
        return displaysDescs.Count > 0;
    }

    public static bool IsVrRunning() {
        bool vrIsRunning = false;
        displays.Clear();
        SubsystemManager.GetInstances(displays);
        foreach (var displaySubsystem in displays) {
            if (displaySubsystem.running) {
                vrIsRunning = true;
                break;
            }
        }

        return vrIsRunning;
    }
#else
        public static bool IsActive() {
            return UnityEngine.XR.XRSettings.enabled;
        }

        public static bool IsVrRunning() {
            return Application.isPlaying && UnityEngine.XR.XRSettings.enabled;
        }
#endif

    }

}