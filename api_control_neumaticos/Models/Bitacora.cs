using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace api_control_neumaticos.Models
{
    public class Bitacora
    {
        public int ID { get; set; }
        public int CODIGO { get; set; }
        public int ID_OBJETO { get; set; }  // Puede ser ID de Neumático, Movil o Usuario

        // Asignar un valor por defecto a TIPO_OBJETO
        private string _tipoObjeto = "Neumatico";  // Valor por defecto
        public string TIPO_OBJETO
        {
            get { return _tipoObjeto; }
            set { _tipoObjeto = value ?? "Neumatico"; }  // Si el valor es nulo, se asigna el valor por defecto
        }

        public int ID_USUARIO { get; set; }
        public DateTime FECHA { get; set; }
        [MaxLength(250)]
        public string OBSERVACION { get; set; } = "";
        public int ESTADO { get; set; }

        public Usuario? Usuario { get; set; }
        public Neumatico? Neumatico { get; set; }
        public Movil? Movil { get; set; }
    }

}
