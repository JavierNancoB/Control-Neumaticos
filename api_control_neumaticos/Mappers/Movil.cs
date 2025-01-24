using AutoMapper;
using api_control_neumaticos.Models;
using api_control_neumaticos.Dtos.Movil;

public class MovilProfile : Profile
{
    public MovilProfile()
    {
        CreateMap<CreateMovilRequestDto, Movil>()
            .ForMember(dest => dest.Patente, opt => opt.MapFrom(src => src.PATENTE))
            .ForMember(dest => dest.Marca, opt => opt.MapFrom(src => src.MARCA))
            .ForMember(dest => dest.Modelo, opt => opt.MapFrom(src => src.MODELO))
            .ForMember(dest => dest.Ejes, opt => opt.MapFrom(src => src.EJES))
            .ForMember(dest => dest.TipoMovil, opt => opt.MapFrom(src => src.TIPO_MOVIL))
            .ForMember(dest => dest.ID_BODEGA, opt => opt.MapFrom(src => src.ID_BODEGA))
            .ForMember(dest => dest.CantidadNeumaticos, opt => opt.MapFrom(src => src.CANTIDAD_NEUMATICOS))
            .ForMember(dest => dest.Estado, opt => opt.MapFrom(src => src.ESTADO));

        CreateMap<UpdateMovilRequestDto, Movil>()
            .ForMember(dest => dest.Patente, opt => opt.MapFrom(src => src.Patente))
            .ForMember(dest => dest.Marca, opt => opt.MapFrom(src => src.Marca))
            .ForMember(dest => dest.Modelo, opt => opt.MapFrom(src => src.Modelo))
            .ForMember(dest => dest.Ejes, opt => opt.MapFrom(src => src.Ejes))
            .ForMember(dest => dest.TipoMovil, opt => opt.MapFrom(src => src.TipoMovil))
            .ForMember(dest => dest.ID_BODEGA, opt => opt.MapFrom(src => src.ID_BODEGA))
            .ForMember(dest => dest.CantidadNeumaticos, opt => opt.MapFrom(src => src.CantidadNeumaticos))
            .ForMember(dest => dest.Estado, opt => opt.MapFrom(src => src.Estado));

        CreateMap<Movil, MovilDto>()
            .ForMember(dest => dest.ID_MOVIL, opt => opt.MapFrom(src => src.IdMovil))
            .ForMember(dest => dest.PATENTE, opt => opt.MapFrom(src => src.Patente))
            .ForMember(dest => dest.MARCA, opt => opt.MapFrom(src => src.Marca))
            .ForMember(dest => dest.MODELO, opt => opt.MapFrom(src => src.Modelo))
            .ForMember(dest => dest.EJES, opt => opt.MapFrom(src => src.Ejes))
            .ForMember(dest => dest.TIPO_MOVIL, opt => opt.MapFrom(src => src.TipoMovil))
            .ForMember(dest => dest.ID_BODEGA, opt => opt.MapFrom(src => src.ID_BODEGA))
            .ForMember(dest => dest.CANTIDAD_NEUMATICOS, opt => opt.MapFrom(src => src.CantidadNeumaticos))
            .ForMember(dest => dest.ESTADO, opt => opt.MapFrom(src => src.Estado));
    }
}


