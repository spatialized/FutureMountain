/* 
*   NatCorder
*   Copyright (c) 2019 Yusuf Olokoba
*/

namespace NatCorder.Clocks {

    using System;
    using System.Runtime.CompilerServices;
    using Internal;
    using Stopwatch = System.Diagnostics.Stopwatch;

    /// <summary>
    /// Realtime clock for generating timestamps
    /// </summary>
    [Doc(@"RealtimeClock")]
    public sealed class RealtimeClock : IClock {

        /// <summary>
        /// Current timestamp in nanoseconds.
        /// The very first value reported by this property will always be zero.
        /// </summary>
        [Doc(@"Timestamp")]
        public long Timestamp {
            [MethodImpl(MethodImplOptions.Synchronized)] get { return stopwatch.Elapsed.Ticks * 100L; }
        }

        /// <summary>
        /// Is the clock paused?
        /// </summary>
        [Doc(@"RealtimeClockPaused")]
        public bool Paused {
            get { return !stopwatch.IsRunning; }
            set { (value ? (Action)stopwatch.Stop : stopwatch.Start)(); }
        }

        public RealtimeClock () {
            this.stopwatch = Stopwatch.StartNew();
        }

        private readonly Stopwatch stopwatch;
    }
}