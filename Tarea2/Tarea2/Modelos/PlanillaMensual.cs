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

        // Constructor con 6 parámetros
        public PlanillaMensual(int id, int idEmpleado, int idMes,
                               decimal salarioBruto, decimal salarioNeto,
                               decimal totalDeducciones)
        {
            Id = id;
            IdEmpleado = idEmpleado;
            IdMes = idMes;
            SalarioBruto = salarioBruto;
            SalarioNeto = salarioNeto;
            TotalDeducciones = totalDeducciones;
        }

      
        public PlanillaMensual() { }
    }
}
