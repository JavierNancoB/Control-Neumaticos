using AutoMapper;
using api_control_neumaticos.Models;
using api_control_neumaticos.Dtos.Bodega;

namespace api_control_neumaticos.Mappers
{
    public class BodegaProfile : Profile
    {
        public BodegaProfile()
        {
            CreateMap<Bodega, BodegaDto>();
            CreateMap<CreateBodegaRequestDto, Bodega>();
            CreateMap<UpdateBodegaRequestDto, Bodega>();
        }
    }
}