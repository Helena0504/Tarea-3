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
    }
}
