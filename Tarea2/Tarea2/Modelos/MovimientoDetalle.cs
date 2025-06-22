namespace Tarea2.Modelos
{
    public class MovimientoDetalle
    {
        public int Id { get; set; }                      // índice 0
        public int IdEmpleado { get; set; }              // índice 1
        public int IdTipoMovimiento { get; set; }        // índice 2
        public DateTime Fecha { get; set; }               // índice 3
        public int CantidadHoras { get; set; }            // índice 4
        public decimal Monto { get; set; }                 // índice 5
        public int IdPlanillaSemanal { get; set; }        // índice 6
        public int IdRegistroAsistencia { get; set; }     // índice 7
        public TimeSpan HoraEntrada { get; set; }         // índice 8
        public TimeSpan HoraSalida { get; set; }          // índice 9
        public string Dia { get; set; } = "";              // índice 10
        public string TipoMovimientoNombre { get; set; } = "";  // índice 11

        public MovimientoDetalle() { }

        public MovimientoDetalle(
            int id,
            int idEmpleado,
            int idTipoMovimiento,
            DateTime fecha,
            int cantidadHoras,
            decimal monto,
            int idPlanillaSemanal,
            int idRegistroAsistencia,
            TimeSpan horaEntrada,
            TimeSpan horaSalida,
            string dia,
            string tipoMovimientoNombre)
        {
            Id = id;
            IdEmpleado = idEmpleado;
            IdTipoMovimiento = idTipoMovimiento;
            Fecha = fecha;
            CantidadHoras = cantidadHoras;
            Monto = monto;
            IdPlanillaSemanal = idPlanillaSemanal;
            IdRegistroAsistencia = idRegistroAsistencia;
            HoraEntrada = horaEntrada;
            HoraSalida = horaSalida;
            Dia = dia;
            TipoMovimientoNombre = tipoMovimientoNombre;
        }
    }

}
