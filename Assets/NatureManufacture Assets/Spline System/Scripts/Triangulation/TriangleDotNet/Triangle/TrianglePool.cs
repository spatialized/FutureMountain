// -----------------------------------------------------------------------
// <copyright file="TrianglePool.cs" company="">
// Triangle.NET code by Christian Woltering, http://triangle.codeplex.com/
// </copyright>
// -----------------------------------------------------------------------

using System;
using System.Collections;
using System.Collections.Generic;
using TriangleNet.Geometry;
using TriangleNet.Topology;

namespace TriangleNet
{
    public class TrianglePool : ICollection<Triangle>
    {
        // Determines the size of each block in the pool.
        private const int BLOCKSIZE = 1024;

        // The number of triangles currently used.
        private int count;

        // The pool.
        private Triangle[][] pool;

        // The total number of currently allocated triangles.
        private int size;

        // A stack of free triangles.
        private readonly Stack<Triangle> stack;

        public TrianglePool()
        {
            size = 0;

            // On startup, the pool should be able to hold 2^16 triangles.
            int n = Math.Max(1, 65536 / BLOCKSIZE);

            pool = new Triangle[n][];
            pool[0] = new Triangle[BLOCKSIZE];

            stack = new Stack<Triangle>(BLOCKSIZE);
        }

        public void Add(Triangle item)
        {
            //throw new NoImplementedException();
        }

        public void Clear()
        {
            stack.Clear();

            int blocks = size / BLOCKSIZE + 1;

            for (int i = 0; i < blocks; i++)
            {
                Triangle[] block = pool[i];

                // Number of triangles in current block:
                int length = (size - i * BLOCKSIZE) % BLOCKSIZE;

                for (int j = 0; j < length; j++) block[j] = null;
            }

            size = count = 0;
        }

        public bool Contains(Triangle item)
        {
            int i = item.hash;

            if (i < 0 || i > size) return false;

            return pool[i / BLOCKSIZE][i % BLOCKSIZE].hash >= 0;
        }

        public void CopyTo(Triangle[] array, int index)
        {
            IEnumerator<Triangle> enumerator = GetEnumerator();

            while (enumerator.MoveNext())
            {
                array[index] = enumerator.Current;
                index++;
            }
        }

        public int Count => count - stack.Count;

        public bool IsReadOnly => true;

        public bool Remove(Triangle item)
        {
            //throw new NoImplementedException();
            return false;
        }

        public IEnumerator<Triangle> GetEnumerator()
        {
            return new Enumerator(this);
        }

        IEnumerator IEnumerable.GetEnumerator()
        {
            return GetEnumerator();
        }

        /// <summary>
        ///     Gets a triangle from the pool.
        /// </summary>
        /// <returns></returns>
        public Triangle Get()
        {
            Triangle triangle;

            if (stack.Count > 0)
            {
                triangle = stack.Pop();
                triangle.hash = -triangle.hash - 1;

                Cleanup(triangle);
            }
            else if (count < size)
            {
                triangle = pool[count / BLOCKSIZE][count % BLOCKSIZE];
                triangle.id = triangle.hash;

                Cleanup(triangle);

                count++;
            }
            else
            {
                triangle = new Triangle();
                triangle.hash = size;
                triangle.id = triangle.hash;

                int block = size / BLOCKSIZE;

                if (pool[block] == null)
                {
                    pool[block] = new Triangle[BLOCKSIZE];

                    // Check if the pool has to be resized.
                    if (block + 1 == pool.Length) Array.Resize(ref pool, 2 * pool.Length);
                }

                // Add triangle to pool.
                pool[block][size % BLOCKSIZE] = triangle;

                count = ++size;
            }

            return triangle;
        }

        public void Release(Triangle triangle)
        {
            stack.Push(triangle);

            // Mark the triangle as free (used by enumerator).
            triangle.hash = -triangle.hash - 1;
        }

        /// <summary>
        ///     Restart the triangle pool.
        /// </summary>
        public TrianglePool Restart()
        {
            foreach (Triangle triangle in stack)
                // Reset hash to original value.
                triangle.hash = -triangle.hash - 1;

            stack.Clear();

            count = 0;

            return this;
        }

        /// <summary>
        ///     Samples a number of triangles from the pool.
        /// </summary>
        /// <param name="k">The number of triangles to sample.</param>
        /// <param name="random"></param>
        /// <returns></returns>
        internal IEnumerable<Triangle> Sample(int k)
        {
            int i, count = Count;

            if (k > count) k = count;

            Triangle t;

            int test = 10000;
            while (k > 0)
            {
                i = test > 0 ? Polygon.GetRandomNext(0, count) : Polygon.GetRandomNextFull(0, count);

                t = pool[i / BLOCKSIZE][i % BLOCKSIZE];

                if (t.hash >= 0)
                {
                    k--;
                    yield return t;
                }

                test--;
                if (test == 0)
                {
                    break;
                }
            }
        }

        private void Cleanup(Triangle triangle)
        {
            triangle.label = 0;
            triangle.area = 0.0;
            triangle.infected = false;

            for (int i = 0; i < 3; i++)
            {
                triangle.vertices[i] = null;

                triangle.subsegs[i] = default;
                triangle.neighbors[i] = default;
            }
        }

        private class Enumerator : IEnumerator<Triangle>
        {
            private readonly int count;

            private int index, offset;

            private readonly Triangle[][] pool;

            public Enumerator(TrianglePool pool)
            {
                count = pool.Count;
                this.pool = pool.pool;

                index = 0;
                offset = 0;
            }

            public Triangle Current { get; private set; }

            public void Dispose()
            {
            }

            object IEnumerator.Current => Current;

            public bool MoveNext()
            {
                while (index < count)
                {
                    Current = pool[offset / BLOCKSIZE][offset % BLOCKSIZE];

                    offset++;

                    if (Current.hash >= 0)
                    {
                        index++;
                        return true;
                    }
                }

                return false;
            }

            public void Reset()
            {
                index = offset = 0;
            }
        }
    }
}