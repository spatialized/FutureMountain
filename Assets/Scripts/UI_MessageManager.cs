using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using UnityEngine.UI;
using UnityEngine.Assertions;

public class UI_MessageManager
{
    private List<UI_Message> messages;                             // List of messages to display
    private List<UI_Message> fireMessages;                         // List of fire messages to display
    private List<UI_Message> currentMessages;                      // List of messages currently displayed
    private Text[] messageTexts;                                   // Message text boxes
    private GameObject[] cubeLabels;                               // Cube labels (A-F) to hide / show
    public GameObject messagePanel { get; set; }                   // Message panel object

    /// <summary>
    /// Constructor for UI Message Manager
    /// </summary>
    public UI_MessageManager()
    {
        messagePanel = GameObject.Find("MessagePanel").gameObject;
        Assert.IsNotNull(messagePanel);
        messagePanel.SetActive(false);

        messageTexts = new Text[4];

        GameObject txtObj = messagePanel.transform.Find("MessageText1").gameObject;
        messageTexts[0] = txtObj.GetComponent<Text>() as Text;
        txtObj = messagePanel.transform.Find("MessageText2").gameObject;
        messageTexts[1] = txtObj.GetComponent<Text>() as Text;
        txtObj = messagePanel.transform.Find("MessageText3").gameObject;
        messageTexts[2] = txtObj.GetComponent<Text>() as Text;
        txtObj = messagePanel.transform.Find("MessageText4").gameObject;
        messageTexts[3] = txtObj.GetComponent<Text>() as Text;

        Assert.IsNotNull(messageTexts[0]);
        Assert.IsNotNull(messageTexts[1]);
        Assert.IsNotNull(messageTexts[2]);
        Assert.IsNotNull(messageTexts[3]);

        // -- TESTING
        //messageTexts[0].text = "123456";
        //messageTexts[1].text = "ABCDEF";
        currentMessages = new List<UI_Message>();
    }

    /// <summary>
    /// Initializes the Message Manager.
    /// </summary>
    /// <param name="newMessages">New messages.</param>
    /// <param name="newFireMessages">New fire messages.</param>
    /// <param name="newCubeLabels">Cube labels object array.</param>
    public void Initialize(List<UI_Message> newMessages, List<UI_Message> newFireMessages, GameObject[] newCubeLabels)
    {
        messages = newMessages;
        fireMessages = newFireMessages;
        cubeLabels = newCubeLabels;
        currentMessages = new List<UI_Message>();
    }

    /// <summary>
    /// Updates simulation messages.
    /// </summary>
    /// <param name="curTimeIdx">Current time index.</param>
    /// <param name="curYear">Current year.</param>
    /// <param name="curMonth">Current month.</param>
    /// <param name="curDay">Current day.</param>
    /// <param name="timeStep">Time step.</param>
    /// <param name="paused">If set to <c>true</c> paused.</param>
    /// <param name="warmingDegrees">Warming degrees.</param>
    public void UpdateSimulation(int curTimeIdx, int curYear, int curMonth, int curDay, int timeStep, bool paused, int warmingDegrees)  // Update messages
    {
        int count = 0;
        foreach(UI_Message message in messages)                    // Display general messages
        {
            if (!message.visible)
            {
                if (curTimeIdx == message.GetTimeIdx())
                {
                    //Debug.Log("Current warmingIdx:" + warmingIdx);
                    if (message.AppliesToWarmingDegrees(warmingDegrees))
                        DisplayMessage(message, curTimeIdx);
                }
                else if (timeStep > 1)
                {
                    for (int i = curTimeIdx; i > curTimeIdx - timeStep; i--)
                    {
                        if (i == message.GetTimeIdx())
                        {
                            //Debug.Log("2 Current warmingIdx:" + warmingIdx);
                            if (message.AppliesToWarmingDegrees(warmingDegrees))
                                DisplayMessage(message, curTimeIdx);
                        }
                    }
                }
            }
            count++;
        }
        foreach (UI_Message message in fireMessages)                    // Display fire messages
        {
            if (!message.visible)
            {
                if (curTimeIdx == message.GetTimeIdx())
                {
                    Debug.Log("3 Current warmingIdx:" + warmingDegrees);
                    if (message.AppliesToWarmingDegrees(warmingDegrees))
                        DisplayMessage(message, curTimeIdx);
                }
                else if (timeStep > 1)
                {
                    for (int i = curTimeIdx; i > curTimeIdx - timeStep; i--)
                    {
                        if (i == message.GetTimeIdx())
                        {
                            if (message.AppliesToWarmingDegrees(warmingDegrees))
                                DisplayMessage(message, curTimeIdx);
                        }
                    }
                }
            }
        }

        List<UI_Message> removeList = new List<UI_Message>();   // List of messages to remove

        foreach (UI_Message message in currentMessages)
        {
            float start = message.startTime;
            float end = start + message.GetLength();
            float startFrame = message.startFrame;
            float endFrame = startFrame + message.GetFrameLength();

            if (!paused && curTimeIdx >= endFrame)     // Check if message time expired
            {
                if (Time.time > end)
                {
                    //Debug.Log("will HideMessage():" + message.GetMessageTextIdx() + " curTimeIdx:" + curTimeIdx + " endFrame:" + endFrame);

                    HideMessage(message);
                    removeList.Add(message);
                }
            }

            //if (!paused)
            //{
            //    if(Time.time >= end)
            //    {
            //        HideMessage(message);
            //        removeList.Add(message);
            //    }
            //}
        }

        if (removeList.Count == 0)
            return;

        for(int i=removeList.Count-1; i>=0; i--)                // Remove expired messages
        {
            currentMessages.Remove(removeList[i]);
        }
    }

    /// <summary>
    /// Displays the message.
    /// </summary>
    /// <param name="message">Message.</param>
    public void DisplayDebugMessage(UI_Message message, int curTimeIdx)
    {
        if (currentMessages.Count <= 4 && !currentMessages.Contains(message))
        {
            int id = message.Display(currentMessages, Time.time, curTimeIdx);

            if(id != -1)
            {
                messageTexts[id].text = message.GetMessage();        // Set message text
                currentMessages.Add(message);
                Debug.Log("DisplayDebugMessage()... id:"+ id + "... currentMessages.Count:" + currentMessages.Count + " message:" + message);
            }

            //foreach (int i in message.cubeIdxList)
            //{
            //    if (i >= 0 && i < 6)
            //        cubeLabels[i].SetActive(true);
            //}
        }
    }

    /// <summary>
    /// Displays the message.
    /// </summary>
    /// <param name="message">Message.</param>
    public void DisplayMessage(UI_Message message, int curTimeIdx)
    {
        if (currentMessages.Count <= 4 && !currentMessages.Contains(message))
        {
            int id = message.Display(currentMessages, Time.time, curTimeIdx);

            if (id >= 0 && id < messageTexts.Length)
                messageTexts[id].text = message.GetMessage();        // Set message text
            else
                Debug.Log("ERROR messageTexts.Length:" + messageTexts.Length + " < id:" + id);

            currentMessages.Add(message);
            foreach (int i in message.cubeIdxList)
            {
                if(i >= 0 && i < 6)
                    cubeLabels[i].SetActive(true);
            }
        }
    }

    /// <summary>
    /// Hides the message.
    /// </summary>
    /// <param name="message">Message.</param>
    private void HideMessage(UI_Message message)
    {
        message.Hide();
        int id = message.GetMessageTextIdx();
        messageTexts[id].text = "";                     // Clear message text

        if (message.cubeIdxList == null)
            return;

        foreach(int i in message.cubeIdxList)
        {
            if (i >= 0 && i < 6)
                cubeLabels[i].SetActive(false);
        }
    }


    /// <summary>
    /// Get all fire messages
    /// </summary>
    /// <returns></returns>
    public List<UI_Message> GetMessages()
    {
        return messages;
    }

    /// <summary>
    /// Get all messages, including fire messages
    /// </summary>
    /// <returns></returns>
    public List<UI_Message> GetAllMessages()
    {
        List<UI_Message> msgs = new List<UI_Message>(messages);
        foreach(UI_Message msg in fireMessages)
        {
            msgs.Add(msg);
        }
        msgs.Sort();
        return msgs;
    }

    /// <summary>
    /// Get all fire messages
    /// </summary>
    /// <returns></returns>
    public List<UI_Message> GetFireMessages()
    {
        return fireMessages;
    }

    /// <summary>
    /// Get all messages
    /// </summary>
    /// <returns>Message corresponding to given year and warming degrees</returns>
    public UI_Message GetMessageForYearAndWarmDegrees(int year, int warmingDegrees)
    {
        foreach(UI_Message message in messages)
        {
            if ((int)message.GetDate().z == year && message.AppliesToWarmingDegrees(warmingDegrees))
                return message;
        }

        return null;
    }

    /// <summary>
    /// Clears the message texts.
    /// </summary>
    public void ClearMessages()
    {
        if (messageTexts == null)
            return;

        foreach (Text text in messageTexts)
        {
            text.text = "";
        }
    }

    public void ClearLabels()
    {
        for(int i = 0; i < 6; i++)
        {
            if (i >= 0 && i < 6)
                cubeLabels[i].SetActive(false);
        }
    }
}
