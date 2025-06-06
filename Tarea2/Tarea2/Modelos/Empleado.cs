namespace Tarea2.Modelos
{
    public class Empleado
    {
        public int id { get; set; }
        public string Nombre { get; set; }
        public string ValorDocumento { get; set; }
        public int IdTipoDocumento { get; set; }
        public int IdDepartamento { get; set; }
        public int IdPuesto { get; set; }
        public DateTime FechaNacimiento { get; set; }
        public bool EsActivo { get; set; }
        public string IP { get; set; }
        public int IdUsuario { get; set; }    // Cambié Usuario por IdUsuario
        public string PuestoNombre { get; set; }

        public Empleado()
        {
        }

        // Constructor sin password ni usuario
        public Empleado(int id, int idPuesto, int idDepartamento, int idTipoDocumento, string nombre, string valorDocumento, DateTime fechaNacimiento, int idUsuario, string puestoNombre)
        {
            this.id = id;
            this.IdPuesto = idPuesto;
            this.IdDepartamento = idDepartamento;
            this.IdTipoDocumento = idTipoDocumento;
            this.Nombre = nombre;
            this.ValorDocumento = valorDocumento;
            this.FechaNacimiento = fechaNacimiento;
            this.IdUsuario = idUsuario;
            this.PuestoNombre = puestoNombre;
        }
    }

}