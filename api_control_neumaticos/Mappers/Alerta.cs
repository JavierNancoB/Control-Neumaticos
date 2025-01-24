using AutoMapper;
using api_control_neumaticos.Models;
using api_control_neumaticos.Dtos.Alertas;

namespace api_control_neumaticos.Mappers
{
    public class AlertaProfile : Profile
    {
        public AlertaProfile()
        {
            CreateMap<Alerta, AlertaDto>();
            CreateMap<CreateAlertaRequestDto, Alerta>();
            CreateMap<UpdateAlertaRequestDto, Alerta>();
        }
    }
}