namespace Tarea2.Modelos
{
    public class DeduccionMensual
    {
        public int Id { get; set; }
        public int IdPlanillaMensual { get; set; }
        public int IdTipoDeduccion { get; set; }
        public string NombreTipoDeduccion { get; set; }
        public float? Porcentaje { get; set; }
        public decimal Monto { get; set; }

        public DeduccionMensual() { }

        public DeduccionMensual(int id, int idPlanillaMensual, int idTipoDeduccion, string nombreTipoDeduccion, float? porcentaje, decimal monto)
        {
            Id = id;
            IdPlanillaMensual = idPlanillaMensual;
            IdTipoDeduccion = idTipoDeduccion;
            NombreTipoDeduccion = nombreTipoDeduccion;
            Porcentaje = porcentaje;
            Monto = monto;
        }
    }
}
