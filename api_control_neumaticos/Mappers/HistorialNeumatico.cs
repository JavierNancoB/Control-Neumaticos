using AutoMapper;
using api_control_neumaticos.Models;
using api_control_neumaticos.Dtos.HistorialNeumatico;

namespace api_control_neumaticos.Profiles
{
    public class HistorialNeumaticoProfile : Profile
    {
        public HistorialNeumaticoProfile()
        {
            CreateMap<HistorialNeumatico, HistorialNeumaticoDto>();
            CreateMap<CreateHistorialNeumaticoRequestDto, HistorialNeumatico>();
            CreateMap<UpdateHistorialNeumaticoRequestDto, HistorialNeumatico>();
        }
    }
}