namespace Tarea2.Modelos
{
    public class MovimientoDetalle
    {
        public int Id { get; set; }
        public int IdEmpleado { get; set; }
        public int IdTipoMovimiento { get; set; }
        public string TipoMovimientoNombre { get; set; } = "";
        public DateTime Fecha { get; set; }
        public int CantidadHoras { get; set; }
        public decimal Monto { get; set; }
        public int IdPlanillaSemanal { get; set; }
        public int IdRegistroAsistencia { get; set; }
        public TimeSpan HoraEntrada { get; set; }
        public TimeSpan HoraSalida { get; set; }
        public string Dia { get; set; } = "";
        
        public MovimientoDetalle(int id, int idEmpleado, int idTipoMovimiento, string tipoMovimientoNombre,
                                 DateTime fecha, int cantidadHoras, decimal monto,
                                 int idPlanillaSemanal, int idRegistroAsistencia,
                                 TimeSpan horaEntrada, TimeSpan horaSalida, string dia)
        {
            Id = id;
            IdEmpleado = idEmpleado;
            IdTipoMovimiento = idTipoMovimiento;
            TipoMovimientoNombre = tipoMovimientoNombre;
            Fecha = fecha;
            CantidadHoras = cantidadHoras;
            Monto = monto;
            IdPlanillaSemanal = idPlanillaSemanal;
            IdRegistroAsistencia = idRegistroAsistencia;
            HoraEntrada = horaEntrada;
            HoraSalida = horaSalida;
            Dia = dia;
        }

        
        public MovimientoDetalle() { }
    }
}
