namespace Tarea2.Modelos
{
    public class Empleado
    {
        public int id { get; set; }
        public string Nombre { get; set; }
        public string IdTipoDocumento { get; set; }
        public string ValorDocumento { get; set; }
        public DateTime FechaNacimiento { get; set; }
        public string IdDepartamento { get; set; }
        public string IdPuesto { get; set; }
        public bool EsActivo { get; set; }
        public string IP { get; set; }
        public string Usuario { get; set; }
        public string Password { get; set; }
        public string PuestoNombre { get; set; } // Para almacenar P.Nombre

        public Empleado()
        {
        }

        public Empleado(int id, string nombre, string idTipoDocumento, string valorDocumento, DateTime fechaNacimiento, string idDepartamento, string idPuesto, bool esActivo)
        {
            this.id = id;
            this.Nombre = nombre;
            this.IdTipoDocumento = idTipoDocumento;
            this.ValorDocumento = valorDocumento;
            this.FechaNacimiento = fechaNacimiento;
            this.IdDepartamento = idDepartamento;
            this.IdPuesto = idPuesto;
            this.EsActivo = esActivo;
        }

        public Empleado(string nombre, string idPuesto, bool esActivo)
        {
            this.Nombre = nombre;
            this.IdPuesto = idPuesto;
            this.EsActivo = esActivo;
        }

        public Empleado(int id, string nombre, string idTipoDocumento, string valorDocumento, DateTime fechaNacimiento, string idDepartamento, string idPuesto, string ip)
        {
            this.id = id;
            this.Nombre = nombre;
            this.IdTipoDocumento = idTipoDocumento;
            this.ValorDocumento = valorDocumento;
            this.FechaNacimiento = fechaNacimiento;
            this.IdDepartamento = idDepartamento;
            this.IdPuesto = idPuesto;
            this.IP = ip;
        }

        public Empleado(int id, int idPuesto, int idDepartamento, int idTipoDocumento, string nombre, string valorDocumento, DateTime fechaNacimiento, string usuario, string password, string puestoNombre)
        {
            this.id = id;
            this.IdPuesto = idPuesto.ToString();
            this.IdDepartamento = idDepartamento.ToString();
            this.IdTipoDocumento = idTipoDocumento.ToString();
            this.Nombre = nombre;
            this.ValorDocumento = valorDocumento;
            this.FechaNacimiento = fechaNacimiento;
            this.Usuario = usuario;
            this.Password = password;
            this.PuestoNombre = puestoNombre;
        }
    }
}