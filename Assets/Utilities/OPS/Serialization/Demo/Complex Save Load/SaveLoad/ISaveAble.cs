using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

/// <summary>
/// Attack to a class to make it save and load able.
/// </summary>
public interface ISaveAble
{
    void OnSave(SaveMetaData _SaveMetaData);
    void OnLoad(SaveMetaData _SaveMetaData);
}
