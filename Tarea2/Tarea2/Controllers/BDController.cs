using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity.Data;
using Microsoft.AspNetCore.Mvc;
using Tarea2.Modelos;

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






        [HttpPost("InsertarControlador")]
        public ActionResult<int> InsertarEmpleado([FromBody] Empleado empleado)
        {
            try
            {
                int result = AccesarBD.InsertarEmpleado(empleado.Nombre, empleado.IdTipoDocumento, empleado.ValorDocumento, empleado.FechaNacimiento, empleado.IdDepartamento, empleado.IdPuesto, empleado.EsActivo);
                if (result == 0) // El stored procedure devuelve 0 todo está bien
                {
                    return Ok(result);
                }
                else
                {
                    return BadRequest(new { message = "Error al insertar empleado", codigoError = result });
                }
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = "Error en servidor", exception = ex.Message });
            }
        }
        [HttpPost("InsertarMovimiento")]
        public async Task<ActionResult<int>> InsertarMovimiento([FromBody] Movimiento movimiento)
        {
            try
            {
                // Validación manual para campos requeridos
                if (movimiento.IdEmpleado <= 0 || movimiento.IdTipoMovimiento <= 0)
                    return BadRequest("IDs deben ser mayores a 0");

                if (movimiento.Monto <= 0)
                    return BadRequest("El monto debe ser positivo");

                int result = await AccesarBD.InsertarMovimiento(
                    movimiento.IdEmpleado,
                    movimiento.IdTipoMovimiento,
                    movimiento.Fecha,
                    movimiento.Monto,
                    movimiento.NuevoSaldo,
                    movimiento.IdPostByUser,
                    movimiento.PostInIp,
                    movimiento.PostTime
                );

                if (result == 0)
                    return Ok(result);
                else
                    return BadRequest(new
                    {
                        message = "Error en validación de datos",
                        codigoError = result
                    });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new
                {
                    message = "Error interno del servidor",
                    details = ex.Message
                });
            }
        }

        [HttpPost("ContarLoginsFallidos")]
        public ActionResult<LoginFallidosResponse> ContarLoginsFallidos([FromBody] LoginReq request)
        {
            try
            {
                int conteo = 0;
                int fueUsuario = 0;
                int codigoError = 0;

                int result = AccesarBD.ContarLoginsFallidos(
                    request.Username,
                    request.Password,
                    request.IPAddress,
                    out conteo,
                    out fueUsuario,
                    out codigoError
                );

                // Siempre devolvemos 200 OK, aunque haya error controlado
                return Ok(new LoginFallidosResponse
                {
                    Conteo = conteo,
                    FueUsuario = fueUsuario,
                    CodigoError = codigoError
                });
            }
            catch (Exception ex)
            {
                // Aquí sí error grave de servidor (excepción)
                return StatusCode(500, new
                {
                    message = "Error en servidor",
                    exception = ex.Message
                });
            }
        }



        [HttpPost("VerificarDeshabilitado")]
        public ActionResult<VerificacionDeshabilitadoResponse> VerificarDeshabilitado([FromBody] VerificacionDeshabilitadoRequest request)
        {
            try
            {
                bool deshabilitado = false;
                int codigoError = 0;

                int result = AccesarBD.VerificarDeshabilitado(
                    request.Username,
                    out deshabilitado,
                    out codigoError
                );

                if (codigoError == 0) // Todo está bien
                {
                    return Ok(new VerificacionDeshabilitadoResponse
                    {
                        Deshabilitado = deshabilitado,
                        CodigoError = codigoError
                    });
                }
                else
                {
                    return BadRequest(new
                    {
                        message = "Error al verificar estado de usuario",
                        codigoError = codigoError
                    });
                }
            }
            catch (Exception ex)
            {
                return StatusCode(500, new
                {
                    message = "Error en servidor",
                    exception = ex.Message
                });
            }
        }


        [HttpPost("InsertarBitacora")]
        public ActionResult<int> InsertarBitacora([FromBody] Bitacora bitacora)
        {
            try
            {
                int result = AccesarBD.InsertarBitacora(bitacora.idTipoEvento, bitacora.Descripcion, bitacora.idPostByUser, bitacora.PostInIp, bitacora.PostTime);
                if (result == 0) // El stored procedure devuelve 0 todo está bien
                {
                    return Ok(result);
                }
                else
                {
                    return BadRequest(new { message = "Error al insertar evento", codigoError = result });
                }
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = "Error en servidor", exception = ex.Message });
            }
        }


        [HttpPost("UpdateControlador")]
        public ActionResult<int> UpdateEmpleado([FromBody] Empleado empleado)
        {
            try
            {
                int result = AccesarBD.UpdateEmpleado(
                    empleado.id,
                    empleado.Nombre,
                    empleado.IdTipoDocumento,
                    empleado.ValorDocumento,
                    empleado.FechaNacimiento,
                    empleado.IdPuesto,
                    empleado.IdDepartamento,
                    empleado.IdPuesto,
                    empleado.IP 
                );

                if (result == 0)
                {
                    return Ok(result);
                }
                else
                {
                    return BadRequest(new { message = "Error al actualizar empleado", codigoError = result });
                }
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = "Error en servidor", exception = ex.Message });
            }
        }



        [AllowAnonymous]
        [HttpPost("MostrarMovimientosControlador")]
        public ActionResult<List<Movimiento>> MostrarMovimientos([FromBody] MovimientoRequest request)
        {
            try
            {
                var movimientos = AccesarBD.MostrarMovimientos(request.IdEmpleado);

                if (movimientos == null || movimientos.Count == 0)
                {
                    return Ok(new
                    {
                        message = "No se encontraron movimientos para este empleado",
                        data = new List<Movimiento>()
                    });
                }

                return Ok(movimientos);
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error al mostrar movimientos: " + ex.Message);
                return StatusCode(500, new
                {
                    message = "Error interno al obtener movimientos",
                    error = ex.Message
                });
            }
        }


        [AllowAnonymous]
        [HttpGet("CargarControlador")]
        public IActionResult CargarControlador()
        {
            try
            {
                int result = AccesarBD.CargarDatos();

                return result switch
                {
                    0 => Ok(new { success = true, message = "Datos cargados exitosamente" }),
                    1 => Ok(new { success = true, message = "Los datos ya existían" }),
                    _ => BadRequest(new { success = false, message = $"Error al cargar datos (Código: {result})" })
                };
            }
            catch (Exception ex)
            {
                return StatusCode(500, new
                {
                    success = false,
                    message = "Error interno del servidor",
                    error = ex.Message
                });
            }
        }


        [HttpPost("ManejarError")]
        public ActionResult<ManejoErrorResponse> ManejarError([FromBody] ManejoErrorRequest request)
        {
            try
            {
                string descripcion = string.Empty;
                int codigoErrorSalida = 0;

                int result = AccesarBD.ManejarError(
                    request.CodigoError,
                    out descripcion,
                    out codigoErrorSalida
                );

                if (codigoErrorSalida == 0) // Todo está bien
                {
                    return Ok(new ManejoErrorResponse
                    {
                        Descripcion = descripcion,
                        CodigoError = codigoErrorSalida
                    });
                }
                else
                {
                    return BadRequest(new
                    {
                        message = "Error al manejar el código de error",
                        codigoError = codigoErrorSalida
                    });
                }
            }
            catch (Exception ex)
            {
                return StatusCode(500, new
                {
                    message = "Error en servidor",
                    exception = ex.Message
                });
            }
        }



        //Un controller de tipo GET para recibir la información de la lista de Puestos
        [HttpGet("MostrarPuestoControlador")]
        public ActionResult<List<Puesto>> MostrarPuestos()
        {
            try
            {
                var puestos = AccesarBD.MostrarPuestos();
                if (puestos.Count == 0) 
                {
                    return Ok(new { message = "La tabla está vacía", empleados = new List<Puesto>() });
                }
                return Ok(puestos);
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error al obtener los puestos: {ex.Message}");
                return StatusCode(500, new { message = "Error en el servidor" });
            }
        }



        [HttpGet("MostrarUsuarioControlador")]
        public ActionResult<List<Usuario>> MostrarUsuarios()
        {
            try
            {
                var Usuarios = AccesarBD.MostrarUsuarios();
                if (Usuarios.Count == 0) //No hay Usuarios en la tabla
                {
                    return BadRequest(new { message = "La tabla se encuentra vacía" });
                }
                return Ok(Usuarios);//El stored procedure devuelve la lista de Usuarios
            }
            catch
            {
                Console.WriteLine("No hay usuarios");
                return (null);
            }
        }


        [AllowAnonymous]
        //Un controller de tipo GET para recibir la información de la lista de empleados
        [HttpGet("MostrarTiposMovimientosControlador")]
        public ActionResult<IEnumerable<TipoMovimiento>> MostrarTiposMovimientos()
        {
            try
            {
                int codigoError;
                var tipos = AccesarBD.MostrarTiposMovimientos(out codigoError);

                if (codigoError != 0)
                {
                    return StatusCode(500, new { error = "Error al obtener tipos" });
                }

                return Ok(tipos); // Devuelve directamente el array
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { error = ex.Message });
            }
        }

    }
}

