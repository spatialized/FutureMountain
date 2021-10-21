using UnityEngine;
using System;  
using System.Collections;
using System.Collections.Generic;

public class UI_Message : IComparable<UI_Message>
{
    private string message = "<Message Text>";
    private int messageTextIdx;                 // Index of message text object in which this UI_Message is displayed 
    public int startFrame { get; set; } = -1;              // Start time
    public float startTime { get; set; } = -1f;              // Start time
    public bool visible { get; set; } = false;

    private Vector3 date;                       // Date of message
    private int timeIdx;                        // Time index at which message is triggered
    public List<int> cubeIdxList { get; set; }
    private List<int> warmingIdxList;
    private int frameLength;
    private float length;
    private UI_MessageType type;

    /// <summary>
    /// User interface message type enum.
    /// </summary>
    public enum UI_MessageType
    {
        general = 0,
        fire = 1,
        debug = 2
    }

    /// <summary>
    /// Display this message.
    /// </summary>
    /// <returns>The display.</returns>
    /// <param name="currentMessages">Currently visible message list.</param>
    /// <param name="newStartTime">New start time.</param>
    /// <param name="curTimeIdx">Current time index.</param>
    public int Display(List<UI_Message> currentMessages, float newStartTime, int curTimeIdx)
    {
        List<int> available = new List<int>();
        for(int i=0; i<4; i++)
        {
            available.Add(i);
        }
        foreach(UI_Message msg in currentMessages)
        {
            int idx = msg.GetMessageTextIdx();
            bool removed = available.Remove(idx);
            if (!removed)
                Debug.Log("ERROR: idx:" + idx + " not in available list!");
        }

        if (available == null)
            return -1;

        if (available.Count == 0)
            return -1;

        int newIdx = available[0];

        visible = true;
        messageTextIdx = newIdx;

        startTime = newStartTime;
        startFrame = curTimeIdx;
        //Debug.Log("UI_Message.Display()... :" + message + " available.Count:" + available.Count+ " startTime:"+ startTime + " warmingIdxList[0]:" + warmingIdxList[0] + " curTimeIdx:" + curTimeIdx+ " messageTextIdx:"+ messageTextIdx);

        return messageTextIdx;
    }

    /// <summary>
    /// Hide this instance.
    /// </summary>
    public void Hide()
    {
        visible = false;
    }

    /// <summary>
    /// Compares frame of message to given message's frame.
    /// </summary>
    /// <returns>The comparison result.</returns>
    /// <param name="that">Patch to compare to.</param>
    public int CompareTo(UI_Message that)
    {
        return this.timeIdx.CompareTo(that.timeIdx);
    }

    public List<int> GetWarmingIdxList()
    {
        return warmingIdxList;
    }

    /// <summary>
    /// UI Message Constructor
    /// </summary>
    /// <param name="newMessage">Messagew text</param>
    /// <param name="newDate">Date</param>
    /// <param name="newTimeIdx">Time idx.</param>
    /// <param name="newWarmingIdxList">Warming idx.</param>
    /// <param name="newFrameLength">Length in frames</param>
    /// <param name="newLength">Min. length in sec.</param>
    /// <param name="newType"></param>
    public UI_Message( string newMessage, Vector3 newDate, int newTimeIdx, List<int> newWarmingIdxList, int newFrameLength, float newLength,
                       List<int> newCubeIdxList, UI_MessageType newType )
    {
        message = newMessage;
        frameLength = newFrameLength;
        length = newLength;
        type = newType;

        if (newType == UI_MessageType.debug)
            return;

        date = newDate;
        timeIdx = newTimeIdx;
        warmingIdxList = newWarmingIdxList;
        cubeIdxList = newCubeIdxList;
    }

    /// <summary>
    /// Get message text
    /// </summary>
    /// <returns>Message text</returns>
    public string GetMessage()
    {
        return message;
    }
    public Vector3 GetDate()
    {
        return date;
    }
    public int GetMessageTextIdx()
    {
        return messageTextIdx;
    }
    public int GetTimeIdx()
    {
        return timeIdx;
    }
    public float GetFrameLength()
    {
        return frameLength;
    }
    public float GetLength()
    {
        return length;
    }
    public List<int> GetCubeIDList()
    {
        return cubeIdxList;
    }
    public bool AppliesToWarmingDegrees(int warmingIdx)
    {
        if (warmingIdx == -1)
            return true;

        if (warmingIdxList.Contains(warmingIdx))
            return true;
        else
            return false;
    }
}
