using AutoMapper;
using api_control_neumaticos.Models;
using api_control_neumaticos.Dtos.HistorialMovil;

namespace api_control_neumaticos.Profiles
{
    public class HistorialMovilProfile : Profile
    {
        public HistorialMovilProfile()
        {
            CreateMap<HistorialMovil, HistorialMovilDto>();
            CreateMap<CreateHistorialMovilRequestDto, HistorialMovil>();
            CreateMap<UpdateHistorialMovilRequestDto, HistorialMovil>();
        }
    }
}