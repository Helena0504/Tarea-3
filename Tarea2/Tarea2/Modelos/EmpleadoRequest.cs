namespace Tarea2.Modelos
{
    public class EmpleadoRequest
    {
        public int idEmpleado { get; set; }
        public int idPostByUser { get; set; }
        public string PostInIP { get; set; }
        public string PostTime { get; set; }  // ISO 8601 formato de fecha (desde JavaScript)
    }
}
