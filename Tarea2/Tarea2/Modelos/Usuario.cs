namespace Tarea2.Modelos
{
    public class Usuario
    {
        public int id { get; set; }
        public string Username { get; set; }
        public string Password { get; set; }
        public int Tipo { get; set; }

        public Usuario()
        {
        }

        public Usuario(int id, string Username, string Password, int Tipo)
        {
            this.id = id;
            this.Username = Username;
            this.Password = Password;
            this.Tipo = Tipo;
        }
    }
}