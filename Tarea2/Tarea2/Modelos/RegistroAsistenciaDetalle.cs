namespace Tarea2.Modelos
{
    public class RegistroAsistenciaDetalle
    {
        public int Id { get; set; }
        public int IdEmpleado { get; set; }
        public int IdTipoJornada { get; set; }
        public string NombreTipoJornada { get; set; }
        public TimeSpan InicioJornada { get; set; }
        public TimeSpan FinJornada { get; set; }
        public DateTime Fecha { get; set; }
        public TimeSpan HoraEntrada { get; set; }
        public TimeSpan HoraSalida { get; set; }
        public decimal HorasOrdinarias { get; set; }
        public decimal HorasExtra { get; set; }
        public string Dia { get; set; }
        public string Feriado { get; set; }



        // Constructor con parámetros
        public RegistroAsistenciaDetalle(int id, int idEmpleado, int idTipoJornada, string nombreTipoJornada,
                                         TimeSpan inicioJornada, TimeSpan finJornada, DateTime fecha,
                                         TimeSpan horaEntrada, TimeSpan horaSalida,
                                         decimal horasOrdinarias, decimal horasExtra,
                                         string dia, string feriado)
        {
            Id = id;
            IdEmpleado = idEmpleado;
            IdTipoJornada = idTipoJornada;
            NombreTipoJornada = nombreTipoJornada;
            InicioJornada = inicioJornada;
            FinJornada = finJornada;
            Fecha = fecha;
            HoraEntrada = horaEntrada;
            HoraSalida = horaSalida;
            HorasOrdinarias = horasOrdinarias;
            HorasExtra = horasExtra;
            Dia = dia;
            Feriado = feriado;
        }

        // Constructor vacío (recomendado para deserialización JSON o Entity Framework)
        public RegistroAsistenciaDetalle() { }

    }

}
