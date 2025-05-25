namespace Tarea2.Modelos
{
    public class Departamento
    {
        public int id { get; set; }
        public string Nombre { get; set; }

        public Departamento()
        {
        }

        public Departamento(int id, string Nombre)
        {
            this.id = id;
            this.Nombre = Nombre;
        }
    }
}
