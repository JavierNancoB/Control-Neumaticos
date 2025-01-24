using System;
using System.Collections.Generic;

namespace api_control_neumaticos.Models;

public partial class Tabla
{
    public int CodTabla { get; set; }

    public int Codigo { get; set; }

    public string? Descripcion { get; set; }

    public int? Estado { get; set; }
}
