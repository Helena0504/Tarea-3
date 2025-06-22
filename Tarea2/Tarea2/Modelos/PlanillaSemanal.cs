namespace Tarea2.Modelos
{
    public class PlanillaSemanal
    {
        public int Id { get; set; }
        public int IdEmpleado { get; set; }
        public int IdSemana { get; set; }
        public decimal HorasOrdinarias { get; set; }
        public decimal HorasExtra { get; set; }
        public decimal HorasExtraDoble { get; set; }
        public decimal SalarioBruto { get; set; }
        public decimal SalarioNeto { get; set; }
        public decimal TotalDeducciones { get; set; }
        public DateTime FechaInicio { get; set; }
        public DateTime FechaFin { get; set; }


        // Constructor con 9 parámetros
        public PlanillaSemanal(int id, int idEmpleado, int idSemana, decimal horasOrdinarias,
                       decimal horasExtra, decimal horasExtraDoble, decimal salarioBruto,
                       decimal salarioNeto, decimal totalDeducciones,
                       DateTime fechaInicio, DateTime fechaFin)
        {
            Id = id;
            IdEmpleado = idEmpleado;
            IdSemana = idSemana;
            HorasOrdinarias = horasOrdinarias;
            HorasExtra = horasExtra;
            HorasExtraDoble = horasExtraDoble;
            SalarioBruto = salarioBruto;
            SalarioNeto = salarioNeto;
            TotalDeducciones = totalDeducciones;
            FechaInicio = fechaInicio;
            FechaFin = fechaFin;
        }


        public PlanillaSemanal() { }
    }
}
