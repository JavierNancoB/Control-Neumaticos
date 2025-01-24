using AutoMapper;
using api_control_neumaticos.Models;
using api_control_neumaticos.Dtos.Neumaticos;
using api_control_neumaticos.Dtos.Movil;
using api_control_neumaticos.Dtos.Bodega;

namespace api_control_neumaticos.Mappers
{
    public class NeumaticosProfile : Profile
    {
        public NeumaticosProfile()
        {
            CreateMap<CreateNeumaticoRequestDto, Neumatico>();
            CreateMap<UpdateNeumaticoRequestDto, Neumatico>();
            CreateMap<Neumatico, NeumaticosDto>();
        }
    }
}