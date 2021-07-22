using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

namespace OPS.Serialization.IO.Helper
{
    public class SerializerAsyncRequest : CustomYieldInstruction
    {
        private bool serialize;

        /// <summary>
        /// True: Is serializing
        /// False: Is deserializing
        /// </summary>
        public bool IsSerialize
        {
            get
            {
                return serialize;
            }
        }

        private bool isFinished = false;

        /// <summary>
        /// Deserialized Object
        /// </summary>
        public System.Object Object;

        /// <summary>
        /// Serialized Bytes
        /// </summary>
        public byte[] Bytes;

        public override bool keepWaiting
        {
            get
            {
                return !this.isFinished;
            }
        }

        public SerializerAsyncRequest(System.Object _Object, bool _Compress = false, bool _Encrypt = false, String _EncryptionKey = "")
        {
            this.serialize = true;

            SerializerAsync.Serialize(this.OnSerialize, _Object, _Compress, _Encrypt, _EncryptionKey);
        }

        public SerializerAsyncRequest(Type _Type, byte[] _Bytes, bool _Uncompress = false, bool _Decrypt = false, String _DecryptionKey = "")
        {
            this.serialize = false;

            SerializerAsync.Deserialize(this.OnDeserialize, _Type, _Bytes, _Uncompress, _Decrypt, _DecryptionKey);
        }

        private void OnSerialize(System.Object _Object, byte[] _Bytes)
        {
            this.Object = _Object;
            this.Bytes = _Bytes;
            this.isFinished = true;
        }

        private void OnDeserialize(System.Object _Object)
        {
            this.Object = _Object;
            this.isFinished = true;
        }
    }
}
