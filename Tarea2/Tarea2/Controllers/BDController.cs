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



        /*Auxiliares*/

        /*Cargar Usuarios para LOGIN*/
        [AllowAnonymous]
        [HttpPost("VerificarUsuario")]
        public ActionResult<Usuario> VerificarUsuario([FromBody] VerificarUsuarioRequest request)
        {
            try
            {
                DateTime postTime; /*Arreglar formato de fecha*/
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

                return Ok(usuario);
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error al verificar Usuario: " + ex.Message);
                return StatusCode(500, "Error interno");
            }
        }


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


    }
}