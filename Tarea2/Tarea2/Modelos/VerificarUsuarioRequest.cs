namespace Tarea2.Modelos
{
    public class VerificarUsuarioRequest
    {
        public string Username { get; set; }

        public string Password { get; set; }
        public int idPostByUser { get; set; }
        public string PostInIP { get; set; }
        public string PostTime { get; set; }
    }

}
