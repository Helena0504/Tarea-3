namespace Tarea2.Modelos
{
    public class DeduccionSemanal
    {
        public int Id { get; set; }
        public int IdPlanillaSemanal { get; set; }
        public int IdTipoDeduccion { get; set; }
        public string NombreTipoDeduccion { get; set; }
        public float? Porcentaje { get; set; }
        public decimal Monto { get; set; }

        public DeduccionSemanal() { }

        public DeduccionSemanal(int id, int idPlanillaSemanal, int idTipoDeduccion, string nombreTipoDeduccion, float? porcentaje, decimal monto)
        {
            Id = id;
            IdPlanillaSemanal = idPlanillaSemanal;
            IdTipoDeduccion = idTipoDeduccion;
            NombreTipoDeduccion = nombreTipoDeduccion;
            Porcentaje = porcentaje;
            Monto = monto;
        }
    }
}
