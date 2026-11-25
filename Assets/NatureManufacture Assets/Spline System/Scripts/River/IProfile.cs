// /**
//  * Created by Pawel Homenko on  05/2023
//  */

namespace NatureManufacture.RAM
{
    public interface IProfile<in T>
    {
        void SetProfileData(T otherProfile);
        bool CheckProfileChange(T otherProfile);
    }
}