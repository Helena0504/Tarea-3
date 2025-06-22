namespace Tarea2.Modelos
{
    public class PlanillaMensual
    {
        public int Id { get; set; }
        public int IdEmpleado { get; set; }
        public int IdMes { get; set; }
        public decimal SalarioBruto { get; set; }
        public decimal SalarioNeto { get; set; }
        public decimal TotalDeducciones { get; set; }
    }

}
