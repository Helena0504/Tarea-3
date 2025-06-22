namespace Tarea2.Modelos
{
    public class MovimientoPorDeduccionDetalle
    {
        public int IdMovimiento { get; set; }
        public int IdEmpleado { get; set; }
        public string NombreEmpleado { get; set; }
        public int IdTipoMovimiento { get; set; }
        public string NombreTipoMovimiento { get; set; }
        public DateTime Fecha { get; set; }
        public decimal Monto { get; set; }
        public string NombreDeduccion { get; set; }
        public bool Porcentual { get; set; }
        public decimal PorcentajeDeduccion { get; set; }

        // Constructor con parámetros
        public MovimientoPorDeduccionDetalle(
            int idMovimiento,
            int idEmpleado,
            string nombreEmpleado,
            int idTipoMovimiento,
            string nombreTipoMovimiento,
            decimal monto,
            string nombreDeduccion,
            bool porcentual,
            decimal porcentajeDeduccion)
        {
            IdMovimiento = idMovimiento;
            IdEmpleado = idEmpleado;
            NombreEmpleado = nombreEmpleado;
            IdTipoMovimiento = idTipoMovimiento;
            NombreTipoMovimiento = nombreTipoMovimiento;
            Monto = monto;
            NombreDeduccion = nombreDeduccion;
            Porcentual = porcentual;
            PorcentajeDeduccion = porcentajeDeduccion;
        }

        // Constructor vacío opcional (para inicializar sin parámetros)
        public MovimientoPorDeduccionDetalle() { }
    }

}
