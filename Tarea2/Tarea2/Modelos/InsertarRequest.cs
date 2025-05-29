namespace Tarea2.Modelos
{
    public class InsertarRequest
    {
        public int idPostByUser { get; set; }
        public string PostInIP { get; set; }
        public string PostTime { get; set; }
        public int idPuesto { get; set; }
        public int idDepartamento { get; set; }
        public int idTipoDocumento { get; set; }
        public string Nombre { get; set; }
        public string ValorDocumento { get; set; }
        public DateTime FechaNacimiento { get; set; }
    }
}
