// /**
            //  * Created by Pawel Homenko on 07/2022
            //  */
            
            using System.Collections.Generic;
            using UnityEditor;
            using UnityEngine;
            
            namespace NatureManufacture.RAM.Editor
            {
                /// <summary>
                /// Provides a custom LayerMask field for the Unity Editor, allowing users to select layers
                /// with additional options such as "Nothing" and "Everything".
                /// </summary>
                public static class LayerMaskField
                {
                    /// <summary>
                    /// Displays a custom LayerMask field in the Unity Editor.
                    /// </summary>
                    /// <param name="label">The label to display next to the field.</param>
                    /// <param name="selected">The currently selected LayerMask.</param>
                    /// <param name="showSpecial">Whether to show special options like "Nothing" and "Everything".</param>
                    /// <param name="layerToCheck">An optional layer to check for warnings (-1 to disable).</param>
                    /// <returns>The updated LayerMask after user interaction.</returns>
                    public static LayerMask ShowLayerMaskField(string label, LayerMask selected, bool showSpecial, int layerToCheck = -1)
                    {
                        // List of layer names to display in the dropdown
                        List<string> layers = new List<string>();
                        // Corresponding list of layer numbers
                        List<int> layerNumbers = new List<int>();
            
                        // Tracks the currently selected layers as a string
                        var selectedLayers = "";
            
                        // Iterate through all 32 possible layers
                        for (var i = 0; i < 32; i++)
                        {
                            var layerName = LayerMask.LayerToName(i);
                            if (layerName != "")
                                if (selected == (selected | (1 << i)))
                                {
                                    selectedLayers = selectedLayers == "" ? layerName : "Mixed";
                                }
                        }
            
                        // If the current event is not a mouse click or command execution
                        if (Event.current.type != EventType.MouseDown && Event.current.type != EventType.ExecuteCommand)
                        {
                            // Add default options based on the selected value
                            if (selected.value == 0)
                                layers.Add("Nothing");
                            else if (selected.value == -1)
                                layers.Add("Everything");
                            else
                                layers.Add(selectedLayers);
            
                            layerNumbers.Add(-1);
                        }
            
                        // Add a separator
                        layers.Add("   ");
                        layerNumbers.Add(-4);
            
                        // Add special options if enabled
                        if (showSpecial)
                        {
                            layers.Add((selected.value == 0 ? "[X] " : "      ") + "Nothing");
                            layerNumbers.Add(-2);
            
                            layers.Add((selected.value == -1 ? "[X] " : "      ") + "Everything");
                            layerNumbers.Add(-3);
                        }
            
                        // Add all available layers
                        for (var i = 0; i < 32; i++)
                        {
                            var layerName = LayerMask.LayerToName(i);
            
                            if (layerName != "")
                            {
                                if (selected == (selected | (1 << i)))
                                    layers.Add("[X] " + i + ": " + layerName);
                                else
                                    layers.Add("     " + i + ": " + layerName);
            
                                layerNumbers.Add(i);
                            }
                        }
            
                        // Store the previous GUI state
                        var preChange = GUI.changed;
            
                        GUI.changed = false;
            
                        // Default new selection index
                        var newSelected = 0;
            
                        // Handle mouse click events
                        if (Event.current.type == EventType.MouseDown) newSelected = -1;
            
                        // Display the dropdown and get the new selection
                        newSelected = EditorGUILayout.Popup(label, newSelected, layers.ToArray(), EditorStyles.layerMaskField);
            
                        // Update the selected LayerMask based on user input
                        if (GUI.changed && newSelected >= 0)
                        {
                            if (showSpecial && newSelected == 1)
                            {
                                selected = 0;
                            }
                            else if (showSpecial && newSelected == 2)
                            {
                                selected = -1;
                            }
                            else
                            {
                                if (selected == (selected | (1 << layerNumbers[newSelected])))
                                    selected &= ~(1 << layerNumbers[newSelected]);
                                else
                                    selected = selected | (1 << layerNumbers[newSelected]);
                            }
                        }
                        else
                        {
                            GUI.changed = preChange;
                        }
            
                        // Check if the selected LayerMask includes the specified layer
                        CheckLayer(selected, layerToCheck);
            
                        return selected;
                    }
            
                    /// <summary>
                    /// Checks if the selected LayerMask includes a specific layer and displays a warning if it does.
                    /// </summary>
                    /// <param name="selected">The currently selected LayerMask.</param>
                    /// <param name="layerToCheck">The layer to check (-1 to disable).</param>
                    private static void CheckLayer(LayerMask selected, int layerToCheck)
                    {
                        if (layerToCheck == -1) return;
            
                        if (selected != (selected | (1 << layerToCheck))) return;
            
                        // Display a warning in the Unity Editor
                        EditorGUILayout.HelpBox("This game object is assigned to the selected layer. Raycasts may hit this object.", MessageType.Warning);
            
                        EditorGUILayout.Space();
                    }
                }
            }