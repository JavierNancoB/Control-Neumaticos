using AutoMapper;
using api_control_neumaticos.Models;
using api_control_neumaticos.Dtos.Bitacora;

namespace api_control_neumaticos.Mappers
{
    public class BitacoraProfile : Profile
    {
        public BitacoraProfile()
        {
            CreateMap<Bitacora, BitacoraDto>();
            CreateMap<CreateBitacoraRequestDto, Bitacora>();
            CreateMap<UpdateBitacoraRequestDto, Bitacora>();
        }
    }
}