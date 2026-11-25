// -----------------------------------------------------------------------
// <copyright file="Log.cs" company="">
// Triangle.NET code by Christian Woltering, http://triangle.codeplex.com/
// </copyright>
// -----------------------------------------------------------------------

using System.Collections.Generic;
using TriangleNet.Logging;

namespace TriangleNet
{
    /// <summary>
    ///     A simple logger, which logs messages to a List.
    /// </summary>
    /// <remarks>
    ///     Using singleton pattern as proposed by Jon Skeet.
    ///     http://csharpindepth.com/Articles/General/Singleton.aspx
    /// </remarks>
    public sealed class Log : ILog<LogItem>
    {
        private readonly List<LogItem> log = new();

        /// <summary>
        ///     Log detailed information.
        /// </summary>
        public static bool Verbose { get; set; }

        public void Add(LogItem item)
        {
            log.Add(item);
        }

        public void Clear()
        {
            log.Clear();
        }

        public void Info(string message)
        {
            log.Add(new LogItem(LogLevel.Info, message));
        }

        public void Warning(string message, string location)
        {
            log.Add(new LogItem(LogLevel.Warning, message, location));
        }

        public void Error(string message, string location)
        {
            log.Add(new LogItem(LogLevel.Error, message, location));
        }

        public IList<LogItem> Data => log;

        public LogLevel Level { get; } = LogLevel.Info;

        #region Singleton pattern

        private static readonly Log instance = new();

        // Explicit static constructor to tell C# compiler
        // not to mark type as beforefieldinit
        static Log()
        {
        }

        private Log()
        {
        }

        public static ILog<LogItem> Instance => instance;

        #endregion
    }
}