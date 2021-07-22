using System;

//Is dotNet Uwp / Core
#if UNITY_WINRT
//Is dotNet Classic / Framework
#else
using System.Threading;

namespace OPS.Serialization.IO
{
    public static class SerializerAsync
    {
        /// <summary>
        /// Serialize an _Object async.
        /// When the serialization process is finished, the action method _CalledWhenFinished get called.
        /// _CalledWhenFinished has as parameter the _Object you want to serialize and the serialized byte array.
        /// </summary>
        /// <param name="_CalledWhenFinished"></param>
        /// <param name="_Object"></param>
        /// <param name="_Compress"></param>
        /// <param name="_Encrypt"></param>
        /// <param name="_EncryptionKey"></param>
        public static void Serialize(Action<Object, byte[]> _CalledWhenFinished, Object _Object, bool _Compress = false, bool _Encrypt = false, String _EncryptionKey = "")
        {
            ThreadPool.QueueUserWorkItem(delegate { SerializeAndCall(_CalledWhenFinished, _Object, _Compress, _Encrypt, _EncryptionKey); });
        }

        private static void SerializeAndCall(Action<Object, byte[]> _CalledWhenFinished, Object _Object, bool _Compress, bool _Encrypt, String _EncryptionKey)
        {
            if(_CalledWhenFinished == null)
            {
                throw new ArgumentNullException("_CalledWhenFinished");
            }

            //Serialize
            byte[] var_SerializedBytes = OPS.Serialization.IO.Serializer.Serialize(_Object, _Compress, _Encrypt, _EncryptionKey);

            //Call action
            _CalledWhenFinished(_Object, var_SerializedBytes);
        }

        /// <summary>
        /// Deserialize an _Bytes array to an Object.
        /// When the deserialization process is finished, the action method _CalledWhenFinished get called.
        /// _CalledWhenFinished has as parameter the deserialized Object.
        /// </summary>
        /// <param name="_CalledWhenFinished"></param>
        /// <param name="_Type"></param>
        /// <param name="_Bytes"></param>
        /// <param name="_Uncompress"></param>
        /// <param name="_Decrypt"></param>
        /// <param name="_DecryptionKey"></param>
        public static void Deserialize(Action<Object> _CalledWhenFinished, Type _Type, byte[] _Bytes, bool _Uncompress = false, bool _Decrypt = false, String _DecryptionKey = "")
        {
            ThreadPool.QueueUserWorkItem(delegate { DeserializeAndCall(_CalledWhenFinished, _Type, _Bytes, _Uncompress, _Decrypt, _DecryptionKey); });
        }

        private static void DeserializeAndCall(Action<Object> _CalledWhenFinished, Type _Type, byte[] _Bytes, bool _Uncompress, bool _Decrypt, String _DecryptionKey)
        {
            if (_CalledWhenFinished == null)
            {
                throw new ArgumentNullException("_CalledWhenFinished");
            }

            //Deserialize
            Object var_DeserializedObject = OPS.Serialization.IO.Serializer.DeSerialize(_Type, _Bytes, _Uncompress, _Decrypt, _DecryptionKey);

            //Call action
            _CalledWhenFinished(var_DeserializedObject);
        }

        /// <summary>
        /// Deserialize an _Bytes array to an Object.
        /// When the deserialization process is finished, the action method _CalledWhenFinished get called.
        /// _CalledWhenFinished has as parameter the deserialized Object.
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="_CalledWhenFinished"></param>
        /// <param name="_Bytes"></param>
        /// <param name="_Uncompress"></param>
        /// <param name="_Decrypt"></param>
        /// <param name="_DecryptionKey"></param>
        public static void Deserialize<T>(Action<T> _CalledWhenFinished, byte[] _Bytes, bool _Uncompress = false, bool _Decrypt = false, String _DecryptionKey = "")
        {
            ThreadPool.QueueUserWorkItem(delegate { DeserializeAndCall<T>(_CalledWhenFinished, _Bytes, _Uncompress, _Decrypt, _DecryptionKey); });
        }

        private static void DeserializeAndCall<T>(Action<T> _CalledWhenFinished, byte[] _Bytes, bool _Uncompress, bool _Decrypt, String _DecryptionKey)
        {
            if (_CalledWhenFinished == null)
            {
                throw new ArgumentNullException("_CalledWhenFinished");
            }

            //Deserialize
            Object var_DeserializedObject = OPS.Serialization.IO.Serializer.DeSerialize<T>(_Bytes, _Uncompress, _Decrypt, _DecryptionKey);

            //Call action
            _CalledWhenFinished((T)var_DeserializedObject);
        }
    }
}
#endif