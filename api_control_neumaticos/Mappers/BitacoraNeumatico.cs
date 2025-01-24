using AutoMapper;
using api_control_neumaticos.Models;
using api_control_neumaticos.Dtos.BitacoraNeumatico;

namespace api_control_neumaticos.Profiles
{
    public class BitacoraNeumaticoProfile : Profile
    {
        public BitacoraNeumaticoProfile()
        {
            CreateMap<BitacoraNeumatico, BitacoraNeumaticoDto>();
            CreateMap<CreateBitacoraNeumaticoRequestDto, BitacoraNeumatico>();
            CreateMap<UpdateBitacoraNeumaticoRequestDto, BitacoraNeumatico>();
        }
    }
}