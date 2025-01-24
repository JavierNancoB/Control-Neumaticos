using AutoMapper;
using api_control_neumaticos.Models;
using api_control_neumaticos.Dtos.Kilometros;

namespace api_control_neumaticos.Mappers
{
    public class KilometrosProfile : Profile
    {
        public KilometrosProfile()
        {
            CreateMap<CreateKilometrosRequestDto, Kilometros>();
            CreateMap<Kilometros, KilometrosDto>();
            CreateMap<UpdateKilometrosRequestDto, Kilometros>();
            // Agregar este mapeo
            CreateMap<KilometrosDto, Kilometros>();
        }
    }
}