// -----------------------------------------------------------------------
// <copyright file="ILog.cs" company="">
// Triangle.NET code by Christian Woltering, http://triangle.codeplex.com/
// </copyright>
// -----------------------------------------------------------------------

using System.Collections.Generic;

namespace TriangleNet.Logging
{
    public enum LogLevel
    {
        Info = 0,
        Warning = 1,
        Error = 2
    }

    /// <summary>
    ///     A basic log interface.
    /// </summary>
    public interface ILog<T> where T : ILogItem
    {
        IList<T> Data { get; }

        LogLevel Level { get; }
        void Add(T item);
        void Clear();

        void Info(string message);
        void Error(string message, string info);
        void Warning(string message, string info);
    }
}