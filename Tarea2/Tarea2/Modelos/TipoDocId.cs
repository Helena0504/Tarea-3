namespace Tarea2.Modelos
{
    public class TipoDocId
    {
        public int id { get; set; }
        public string Nombre { get; set; }

        public TipoDocId()
        {
        }

        public TipoDocId(int id, string Nombre)
        {
            this.id = id;
            this.Nombre = Nombre;
        }
    }
}
