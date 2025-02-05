using AutoMapper;
using api_control_neumaticos.Models;
using api_control_neumaticos.Dtos.Usuario;

public class UsuarioProfile : Profile
{
    public UsuarioProfile()
    {
        CreateMap<CreateUsuarioRequestDto, UsuarioDto>();
        CreateMap<UpdateUsuarioRequestDto, UsuarioDto>();
        CreateMap<UsuarioDto, UsuarioDto>();

        CreateMap<UsuarioDto, Usuario>()
            .ForMember(dest => dest.IdUsuario, opt => opt.MapFrom(src => src.ID_USUARIO))
            .ForMember(dest => dest.Nombres, opt => opt.MapFrom(src => src.NOMBRES))
            .ForMember(dest => dest.Apellidos, opt => opt.MapFrom(src => src.APELLIDOS))
            .ForMember(dest => dest.Correo, opt => opt.MapFrom(src => src.CORREO))
            .ForMember(dest => dest.Clave, opt => opt.MapFrom(src => src.CLAVE))
            .ForMember(dest => dest.CodigoPerfil, opt => opt.MapFrom(src => src.CODIGO_PERFIL))
            .ForMember(dest => dest.CodEstado, opt => opt.MapFrom(src => src.COD_ESTADO))
            .ForMember(dest => dest.ID_BODEGA, opt => opt.MapFrom(src => src.ID_BODEGA)) // Se agrega la propiedad ID_BODEGA
            .ForMember(dest => dest.FechaClave, opt => opt.MapFrom(src => src.FECHA_CLAVE))
            .ForMember(dest => dest.IntentosFallidos, opt => opt.MapFrom(src => src.INTENTOS_FALLIDOS));

        CreateMap<Usuario, UsuarioDto>()
            .ForMember(dest => dest.ID_USUARIO, opt => opt.MapFrom(src => src.IdUsuario))
            .ForMember(dest => dest.NOMBRES, opt => opt.MapFrom(src => src.Nombres))
            .ForMember(dest => dest.APELLIDOS, opt => opt.MapFrom(src => src.Apellidos))
            .ForMember(dest => dest.CORREO, opt => opt.MapFrom(src => src.Correo))
            .ForMember(dest => dest.CLAVE, opt => opt.MapFrom(src => src.Clave))
            .ForMember(dest => dest.CODIGO_PERFIL, opt => opt.MapFrom(src => src.CodigoPerfil))
            .ForMember(dest => dest.COD_ESTADO, opt => opt.MapFrom(src => src.CodEstado))
            .ForMember(dest => dest.ID_BODEGA, opt => opt.MapFrom(src => src.ID_BODEGA)) // Se agrega la propiedad ID_BODEGA
            .ForMember(dest => dest.FECHA_CLAVE, opt => opt.MapFrom(src => src.FechaClave))
            .ForMember(dest => dest.INTENTOS_FALLIDOS, opt => opt.MapFrom(src => src.IntentosFallidos));
    }
}
