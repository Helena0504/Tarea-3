using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity.Data;
using Microsoft.AspNetCore.Mvc;
using Tarea2.Modelos;
using static AccesarBD;

//Esta api controller se encarga de conectar la capa usuario con la capa de acceso a BD
//Es decir, ahora las stored procedures se pueden llamar desde la vista usuario, pero no se puede ver su contenido
//El api es de  ASP.NET Core , y expone por medio de https solicitudes a la capa de ususario

namespace Tarea2.Controllers
{
    [Route("api/BDController")]
    [ApiController]

    public class BDController : ControllerBase
    {

        /*Funcionalidades de Empleado*/

        /*1. Listar Empleados*/

        [AllowAnonymous]
        [HttpPost("ListarEmpleados")]
        public ActionResult<List<Empleado>> ListarEmpleados([FromBody] UserRequest request)
        {
            try
            {
                DateTime postTime; /*Arreglar formato de fecha*/
                if (!DateTime.TryParse(request.PostTime, out postTime))
                {
                    postTime = DateTime.Now;
                }

                var empleados = AccesarBD.ListarEmpleados(
                    request.idPostByUser,
                    request.PostInIP,
                    postTime
                );

                return Ok(empleados);
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error al listar empleados: " + ex.Message);
                return StatusCode(500, "Error interno");
            }
        }



        /*2. Listar Empleados con Filtro*/

        [AllowAnonymous]
        [HttpPost("FiltrarEmpleados")]
        public ActionResult<List<Empleado>> FiltrarEmpleados([FromBody] FiltroRequest filtro)
        {
            try
            {
                DateTime postTime; /*Arreglar formato de fecha*/
                if (!DateTime.TryParse(filtro.PostTime, out postTime))
                {
                    postTime = DateTime.Now;
                }

                var empleados = AccesarBD.FiltrarEmpleados(
                    filtro.inBusqueda,
                    filtro.inTipo,
                    filtro.idPostByUser,
                    filtro.PostInIP,
                    postTime
                );

                return Ok(empleados);
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error al listar empleados con filtro: " + ex.Message);
                return StatusCode(500, "Error interno");
            }
        }

        /*3. Editar Empleado*/

        [HttpPost("EditarEmpleado")]
        public ActionResult<int> UpdateEmpleado([FromBody] EditarRequest request)
        {
            try
            {
                DateTime postTime;
                if (!DateTime.TryParse(request.PostTime, out postTime))
                {
                    postTime = DateTime.Now;
                }

                int result = AccesarBD.EditarEmpleado(
                    request.idPostByUser,
                    request.PostInIP,
                    postTime,
                    request.id,
                    request.idPuesto,
                    request.idDepartamento,
                    request.idTipoDocumento,
                    request.Nombre,
                    request.ValorDocumento,
                    request.FechaNacimiento
                );

                if (result == 0)
                {
                    return Ok(result);
                }
                else
                {
                    return BadRequest(new
                    {
                        message = "Error al actualizar empleado",
                        codigoError = result,
                    });
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error al Actualizar Empleado: " + ex.Message);
                return StatusCode(500, new
                {
                    message = "Error en servidor",
                    exception = ex.Message,
                    stackTrace = ex.StackTrace
                });
            }
        }



        /*4. Insertar Empleado*/

        [HttpPost("InsertarEmpleado")]
        public ActionResult<int> InsertarEmpleado([FromBody] InsertarRequest request)
        {
            try
            {
                DateTime postTime;
                if (!DateTime.TryParse(request.PostTime, out postTime))
                {
                    postTime = DateTime.Now;
                }

                int result = AccesarBD.InsertarEmpleado(
                    request.idPostByUser,
                    request.PostInIP,
                    postTime,
                    request.idPuesto,
                    request.idDepartamento,
                    request.idTipoDocumento,
                    request.Nombre,
                    request.ValorDocumento,
                    request.FechaNacimiento
                );

                if (result == 0)
                {
                    return Ok(result);
                }
                else
                {
                    return BadRequest(new
                    {
                        message = "Error al insertar empleado",
                        codigoError = result,
                    });
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error al Insertar Empleado: " + ex.Message);
                return StatusCode(500, new
                {
                    message = "Error en servidor",
                    exception = ex.Message,
                    stackTrace = ex.StackTrace
                });
            }
        }



        /*5. Eliminar Empleado*/

        [HttpPost("EliminarEmpleado")]
        public ActionResult<int> EliminarEmpleado([FromBody] EliminarRequest eliminar)
        {
            try
            {
                DateTime postTime; /*Arreglar formato de fecha*/
                if (!DateTime.TryParse(eliminar.PostTime, out postTime))
                {
                    postTime = DateTime.Now;
                }

                var empleados = AccesarBD.EliminarEmpleado(
                    eliminar.idPostByUser,
                    eliminar.PostInIP,
                    postTime,
                    eliminar.id
                );

                return Ok(empleados);
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error al Eliminar Empleado: " + ex.Message);
                return StatusCode(500, "Error interno");
            }
        }




        /*Auxiliares*/

        /*Cargar Usuarios para LOGIN*/
        [AllowAnonymous]
        [HttpPost("VerificarUsuario")]
        public ActionResult<Usuario> VerificarUsuario([FromBody] VerificarUsuarioRequest request)
        {
            try
            {
                DateTime postTime;
                if (!DateTime.TryParse(request.PostTime, out postTime))
                {
                    postTime = DateTime.Now;
                }

                var usuario = AccesarBD.VerificarUsuario(
                    request.Username,
                    request.Password,
                    request.idPostByUser,
                    request.PostInIP,
                    postTime
                );

                if (usuario == null)
                {
                    return BadRequest(new { message = "Usuario o contraseña incorrectos" });
                }

                return Ok(usuario);
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error al verificar Usuario: " + ex.Message);
                return StatusCode(500, new { message = "Error interno" });
            }
        }


        /*Listar Puestos para Insertar y Editar*/
        [HttpGet("ListarPuestos")]
        public ActionResult<List<Puesto>> ListarPuestos()
        {
            try
            {
                var puestos = AccesarBD.ListarPuestos();
                if (puestos.Count == 0)
                {
                    return Ok(new { message = "La tabla está vacía", puestos = new List<Puesto>() });
                }
                return Ok(puestos);
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error al obtener los puestos: {ex.Message}");
                return StatusCode(500, new { message = "Error en el servidor" });
            }
        }

        /*Listar Puestos para Insertar y Editar*/
        [HttpGet("ListarDepartamentos")]
        public ActionResult<List<Puesto>> ListarDepartamentos()
        {
            try
            {
                var puestos = AccesarBD.ListarDepartamentos();
                if (puestos.Count == 0)
                {
                    return Ok(new { message = "La tabla está vacía", puestos = new List<Departamento>() });
                }
                return Ok(puestos);
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error al obtener los departamentos: {ex.Message}");
                return StatusCode(500, new { message = "Error en el servidor" });
            }
        }


        /*Listar Puestos para Insertar y Editar*/
        [HttpGet("ListarTipoDocIds")]
        public ActionResult<List<Puesto>> ListarTipoDocIds()
        {
            try
            {
                var puestos = AccesarBD.ListarTipoDocIds();
                if (puestos.Count == 0)
                {
                    return Ok(new { message = "La tabla está vacía", puestos = new List<TipoDocId>() });
                }
                return Ok(puestos);
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error al obtener los tipos doc id: {ex.Message}");
                return StatusCode(500, new { message = "Error en el servidor" });
            }
        }




        /*Funcionalidades de Planillas*/
        /*Planilla Semanal*/
        [HttpPost("ConsultarPlanillaSemanal")]
        public ActionResult<List<PlanillaSemanal>> ConsultarPlanillaSemanal([FromBody] EmpleadoRequest request)
        {
            try
            {
                if (!DateTime.TryParse(request.PostTime, out DateTime postTime))
                    postTime = DateTime.Now;

                var resultado = AccesarBD.ConsultarPlanillaSemanal(request.idEmpleado, request.idPostByUser, request.PostInIP, postTime);
                return Ok(resultado);
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error en API ConsultarPlanillaSemanal: " + ex.Message);
                return StatusCode(500, "Error interno");
            }
        }



        /*Planilla Mensual*/
        [HttpPost("ConsultarPlanillaMensual")]
        public ActionResult<List<PlanillaMensual>> ConsultarPlanillaMensual([FromBody] EmpleadoRequest request)
        {
            try
            {
                DateTime parsedTime = DateTime.TryParse(request.PostTime, out var pt) ? pt : DateTime.Now;

                var result = AccesarBD.ConsultarPlanillaMensual(
                    request.idEmpleado,
                    request.idPostByUser,
                    request.PostInIP,
                    parsedTime
                );

                return Ok(result);
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error API mensual: " + ex.Message);
                return StatusCode(500, "Error interno");
            }
        }



        /*3. Consultar Movimientos Salario Bruto*/
        [HttpPost("ConsultarMovimientos")]
        public ActionResult<List<MovimientoDetalle>> ConsultarMovimientos([FromBody] MovimientoRequest request)
        {
            try
            {
                int codigoError;
                string mensajeError;
                int filaError;

                var resultado = AccesarBD.ConsultarMovimientos(request.IdPlanilla, out codigoError, out mensajeError, out filaError);
                return Ok(resultado);
            }
            catch (Exception ex)
            {
                // Puedes personalizar el mensaje que envías al frontend
                return StatusCode(500, new { mensaje = ex.Message });
            }
        }



        /*4. Consultar Asistencia*/

        [HttpPost]
        [Route("ConsultarRegistroAsistencia")]
        public IActionResult ConsultarRegistroAsistencia([FromBody] int idRegistro)
        {
            int codigoError;
            var resultado = AccesarBD.ConsultarRegistroAsistencia(idRegistro, out codigoError);

            if (codigoError != 0)
                return BadRequest(new { mensaje = "Error en SP", codigoError });

            return Ok(resultado);
        }


        /*5. Consultar Deducciones Semanales*/
        [HttpPost]
        [Route("ConsultarDeduccionesSemanales")]
        public IActionResult ConsultarDeduccionesSemanales([FromBody] PlanillaRequest request)
        {
            int codigoError;
            var resultado = AccesarBD.ConsultarDeduccionesSemanales(request.IdPlanilla, out codigoError);

            if (codigoError != 0)
                return BadRequest(new { mensaje = "Error en SP", codigoError });

            // Retornar todo el resultado completo
            return Ok(resultado);
        }

        /*6. Consultar Deducciones Mensuales*/
        [HttpPost]
        [Route("ConsultarDeduccionesMensuales")]
        public IActionResult ConsultarDeduccionesMensuales([FromBody] PlanillaRequest request)
        {
            int codigoError;
            var resultado = AccesarBD.ConsultarDeduccionesMensuales(request.IdPlanilla, out codigoError);

            if (codigoError != 0)
                return BadRequest(new { mensaje = "Error en SP", codigoError });

            // Retornar todo el resultado completo
            return Ok(resultado);
        }

        /*7. Movimiento Deduccion*/

        [HttpPost]
        [Route("ConsultarMovimientosPorDeduccion")]
        public IActionResult ConsultarMovimientosPorDeduccion([FromBody] MovimientoPorDeduccionRequest request)
        {
            int codigoError;
            var resultado = AccesarBD.ConsultarMovimientosPorDeduccion(request.IdPlanilla, request.IdTipoDeduccion, out codigoError);

            if (codigoError != 0)
                return BadRequest(new { mensaje = "Error en SP", codigoError });

            return Ok(resultado);
        }



        /*8. Movimeintos Mes deduccion*/
        [HttpPost]
        [Route("ConsultarMovimientosPorPlanillaMensualYTipo")]
        public IActionResult ConsultarMovimientosPorPlanillaMensualYTipo([FromBody] MovimientoPorDeduccionMensualRequest request)
        {
            int codigoError;
            var resultado = AccesarBD.ConsultarMovimientosPorPlanillaMensualYTipo(
                request.IdPlanillaMensual,
                request.IdTipoDeduccion,
                request.IdEmpleado,
                out codigoError);

            if (codigoError != 0)
                return BadRequest(new { mensaje = "Error en SP", codigoError });

            return Ok(resultado);
        }

    }
}