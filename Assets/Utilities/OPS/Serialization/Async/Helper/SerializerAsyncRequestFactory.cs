using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace OPS.Serialization.IO.Helper
{
    public static class SerializerAsyncRequestFactory
    {
        /// <summary>
        /// Create an async serialization request, to use in unity coroutines.
        /// </summary>
        /// <param name="_Object"></param>
        /// <param name="_Compress"></param>
        /// <param name="_Encrypt"></param>
        /// <param name="_EncryptionKey"></param>
        /// <returns></returns>
        public static SerializerAsyncRequest CreateSerializerAsyncRequest(Object _Object, bool _Compress = false, bool _Encrypt = false, String _EncryptionKey = "")
        {
            return new SerializerAsyncRequest(_Object, _Compress, _Encrypt, _EncryptionKey);
        }

        /// <summary>
        /// Create an async deserialization request, to use in unity coroutines.
        /// </summary>
        /// <param name="_Type"></param>
        /// <param name="_Bytes"></param>
        /// <param name="_Uncompress"></param>
        /// <param name="_Decrypt"></param>
        /// <param name="_DecryptionKey"></param>
        /// <returns></returns>
        public static SerializerAsyncRequest CreateDeserializerAsyncRequest(Type _Type, byte[] _Bytes, bool _Uncompress = false, bool _Decrypt = false, String _DecryptionKey = "")
        {
            return new SerializerAsyncRequest(_Type, _Bytes, _Uncompress, _Decrypt, _DecryptionKey);
        }
    }
}
