using System;
using System.Collections.Generic;

namespace api_control_neumaticos.Models;

public partial class Neumatico
{
    public int ID_NEUMATICO { get; set; }
    public int CODIGO { get; set; }
    public int UBICACION { get; set; }

    // Relación con Movil, Movil puede ser nulo
    public int? ID_MOVIL { get; set; }
    public virtual Movil? MOVIL_ASIGNADO { get; set; }

    // Relación con Bodega
    public int ID_BODEGA { get; set; }
    public virtual required Bodega BODEGA { get; set; }

    public DateTime FECHA_INGRESO { get; set; }
    public DateTime? FECHA_SALIDA { get; set; }
    public int ESTADO { get; set; }
    public int KM_TOTAL { get; set; }
    public int TIPO_NEUMATICO { get; set; }
}

