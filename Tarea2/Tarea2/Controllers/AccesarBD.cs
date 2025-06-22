using Microsoft.Data.SqlClient;
using System.Collections.Generic;
using System.Data;
using Tarea2.Modelos;
using Tarea2.Modelos.TuProyecto.Modelos;

public class AccesarBD
{

    /*Funcionalidades de Empleado*/


    /*1. Listar Empleados*/

    public static List<Empleado> ListarEmpleados(int idPostByUser, string PostInIP, DateTime PostTime)
    {
        string StringConexion = "Server=25.55.61.33;Database=Tarea3;Trusted_Connection=True;TrustServerCertificate=True;";
        List<Empleado> empleados = new List<Empleado>();

        try
        {
            using (SqlConnection con = new SqlConnection(StringConexion))
            {
                con.Open();
                using (SqlCommand listar = new SqlCommand("ListarEmpleados", con))
                {
                    listar.CommandType = CommandType.StoredProcedure;

                    listar.Parameters.AddWithValue("@inIdPostByUser", idPostByUser);
                    listar.Parameters.AddWithValue("@inPostInIP", PostInIP);
                    listar.Parameters.AddWithValue("@inPostTime", PostTime);

                    SqlParameter outCodigoError = new SqlParameter("@outCodigoError", SqlDbType.Int)
                    {
                        Direction = ParameterDirection.Output
                    };
                    listar.Parameters.Add(outCodigoError);

                    using (SqlDataReader reader = listar.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            empleados.Add(new Empleado(
                                reader.GetInt32(0),        // id
                                reader.GetInt32(1),        // idPuesto
                                reader.GetInt32(2),        // idDepartamento
                                reader.GetInt32(3),        // idTipoDocumento
                                reader.GetString(4),       // nombre
                                reader.GetString(5),       // valorDocumento
                                reader.GetDateTime(6).Date,// fechaNacimiento
                                reader.GetInt32(7),         //idUsuario
                                reader.GetString(8)        // puestoNombre

                            ));
                        }
                    }

                    int errorCod = (int)outCodigoError.Value;
                    if (errorCod != 0)
                    {
                        Console.WriteLine("Error al listar empleados: " + errorCod);
                    }
                }
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine("Error al listar empleados: " + ex.Message);
        }

        return empleados.OrderBy(e => e.Nombre).ToList(); ;
    }



    /*2. Listar Empleados con Filtro*/

    public static List<Empleado> FiltrarEmpleados(string inBusqueda, int inTipo, int idPostByUser, string PostInIP, DateTime PostTime)
    {
        string StringConexion = "Server=25.55.61.33;Database=Tarea3;Trusted_Connection=True;TrustServerCertificate=True;";
        List<Empleado> empleados = new List<Empleado>();

        try
        {
            using (SqlConnection con = new SqlConnection(StringConexion))
            {
                con.Open();
                using (SqlCommand filtrar = new SqlCommand("FiltrarEmpleados", con))
                {
                    filtrar.CommandType = CommandType.StoredProcedure;

                    filtrar.Parameters.AddWithValue("@inIdPostByUser", idPostByUser);
                    filtrar.Parameters.AddWithValue("@inPostInIP", PostInIP);
                    filtrar.Parameters.AddWithValue("@inPostTime", PostTime);
                    filtrar.Parameters.AddWithValue("@inBusqueda", inBusqueda);
                    filtrar.Parameters.AddWithValue("@inTipo", inTipo);

                    SqlParameter outCodigoError = new SqlParameter("@outCodigoError", SqlDbType.Int)
                    {
                        Direction = ParameterDirection.Output
                    };
                    filtrar.Parameters.Add(outCodigoError);

                    using (SqlDataReader reader = filtrar.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            empleados.Add(new Empleado(
                                reader.GetInt32(0),
                                reader.GetInt32(1),
                                reader.GetInt32(2),
                                reader.GetInt32(3),
                                reader.GetString(4),
                                reader.GetString(5),
                                reader.GetDateTime(6).Date,
                                reader.GetInt32(7),
                                reader.GetString(8)
                            ));
                        }
                    }

                    int errorCod = (int)outCodigoError.Value;
                    if (errorCod != 0)
                    {
                        Console.WriteLine("Error al filtrar empleados: " + errorCod);
                    }
                }
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine("Error al filtrar empleados: " + ex.Message);
        }

        return empleados.OrderBy(e => e.Nombre).ToList(); ;
    }


    /*3. Editar Empleado*/
    public static int EditarEmpleado(int idPostByUser, string postInIP, DateTime postTime,
                            int id, int idPuesto, int idDepartamento, int idTipoDocumento,
                            string nombre, string valorDocumento, DateTime fechaNacimiento)
    {
        // String de conexión a BD
        string StringConexion = "Server=25.55.61.33;" +
            "Database=Tarea3;" +
            "Trusted_Connection=True;" +
            "TrustServerCertificate=True;";

        try
        {
            using (SqlConnection con = new SqlConnection(StringConexion))
            {
                // Abre conexión y se crea el comando para editar
                con.Open();

                using (SqlCommand cmd = new SqlCommand("EditarEmpleado", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    // Envía parámetros de entrada
                    cmd.Parameters.AddWithValue("@inIdPostByUser", idPostByUser);
                    cmd.Parameters.AddWithValue("@inPostInIP", postInIP);
                    cmd.Parameters.AddWithValue("@inPostTime", postTime);
                    cmd.Parameters.AddWithValue("@inId", id);
                    cmd.Parameters.AddWithValue("@inIdPuesto", idPuesto);
                    cmd.Parameters.AddWithValue("@inIdDepartamento", idDepartamento);
                    cmd.Parameters.AddWithValue("@inIdTipoDocumento", idTipoDocumento);
                    cmd.Parameters.AddWithValue("@inNombre", nombre);
                    cmd.Parameters.AddWithValue("@inValorDocumento", valorDocumento);
                    cmd.Parameters.AddWithValue("@inFechaNacimiento", fechaNacimiento);

                    // Recibe el código de error
                    SqlParameter outCodigoError = new SqlParameter("@outCodigoError", SqlDbType.Int)
                    {
                        Direction = ParameterDirection.Output
                    };
                    cmd.Parameters.Add(outCodigoError);

                    // Se ejecuta el Stored Procedure
                    cmd.ExecuteNonQuery();

                    // Devuelve el código de error
                    return (int)outCodigoError.Value;
                }
            }
        }
        catch (Exception ex)
        {
            // Error en capa lógica
            Console.WriteLine($"Error al intentar conectar o ejecutar la consulta: {ex.Message}");
            Console.WriteLine($"Detalles: {ex.StackTrace}");
            return 50025;
        }
    }



    /*4. Insertar Empleado*/
    public static int InsertarEmpleado(int idPostByUser, string postInIP, DateTime postTime,
                            int idPuesto, int idDepartamento, int idTipoDocumento,
                            string nombre, string valorDocumento, DateTime fechaNacimiento)
    {
        // String de conexión a BD
        string StringConexion = "Server=25.55.61.33;" +
            "Database=Tarea3;" +
            "Trusted_Connection=True;" +
            "TrustServerCertificate=True;";

        try
        {
            using (SqlConnection con = new SqlConnection(StringConexion))
            {
                // Abre conexión y se crea el comando para editar
                con.Open();

                using (SqlCommand cmd = new SqlCommand("InsertarEmpleado", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    // Envía parámetros de entrada
                    cmd.Parameters.AddWithValue("@inIdPostByUser", idPostByUser);
                    cmd.Parameters.AddWithValue("@inPostInIP", postInIP);
                    cmd.Parameters.AddWithValue("@inPostTime", postTime);
                    cmd.Parameters.AddWithValue("@inIdPuesto", idPuesto);
                    cmd.Parameters.AddWithValue("@inIdDepartamento", idDepartamento);
                    cmd.Parameters.AddWithValue("@inIdTipoDocumento", idTipoDocumento);
                    cmd.Parameters.AddWithValue("@inNombre", nombre);
                    cmd.Parameters.AddWithValue("@inValorDocumento", valorDocumento);
                    cmd.Parameters.AddWithValue("@inFechaNacimiento", fechaNacimiento);

                    // Recibe el código de error
                    SqlParameter outCodigoError = new SqlParameter("@outCodigoError", SqlDbType.Int)
                    {
                        Direction = ParameterDirection.Output
                    };
                    cmd.Parameters.Add(outCodigoError);

                    // Se ejecuta el Stored Procedure
                    cmd.ExecuteNonQuery();

                    // Devuelve el código de error
                    return (int)outCodigoError.Value;
                }
            }
        }
        catch (Exception ex)
        {
            // Error en capa lógica
            Console.WriteLine($"Error al intentar conectar o ejecutar la consulta: {ex.Message}");
            Console.WriteLine($"Detalles: {ex.StackTrace}");
            return 50025;
        }
    }




    /*5. Eliminar Empleado*/

    public static int EliminarEmpleado(int idPostByUser, string PostInIP, DateTime PostTime, int id)
    {
        //String de conexión a BD
        string StringConexion = "Server=25.55.61.33;" +
            "Database=Tarea3;" +
            "Trusted_Connection=True;" +
            "TrustServerCertificate=True;";
        try
        {
            using (SqlConnection con = new SqlConnection(StringConexion))
            {
                //Abre conexión y se crea el comando insertar
                con.Open();

                using (SqlCommand eliminar = new SqlCommand("EliminarEmpleado", con))
                {
                    eliminar.CommandType = CommandType.StoredProcedure;

                    //Envia parámetros de entrada
                    eliminar.Parameters.AddWithValue("@inIdPostByUser", idPostByUser);
                    eliminar.Parameters.AddWithValue("@inPostInIP", PostInIP);
                    eliminar.Parameters.AddWithValue("@inPostTime", PostTime);
                    eliminar.Parameters.AddWithValue("@inId", id);


                    //Recibe el código de error
                    SqlParameter outCodigoError = new SqlParameter("@outCodigoError", SqlDbType.Int)
                    {
                        Direction = ParameterDirection.Output
                    };
                    eliminar.Parameters.Add(outCodigoError);

                    //Se ejecuta el Stored procedure
                    eliminar.ExecuteNonQuery();

                    //Devuelve el código de error
                    return (int)outCodigoError.Value;
                }
            }
        }
        catch (Exception ex)
        {
            //Error en capa lógica
            Console.WriteLine($"Error al intentar conectar o ejecutar la consulta: {ex.Message}");
            Console.WriteLine($"Detalles: {ex.StackTrace}");
            return 50025;
        }
    }






    /*Auxiliares*/

    /*Cargar Usuarios para LOGIN*/
    public static Usuario VerificarUsuario(string Username, string Password, int idPostByUser, string PostInIP, DateTime PostTime)
    {
        string StringConexion = "Server=25.55.61.33;Database=Tarea3;Trusted_Connection=True;TrustServerCertificate=True;";
        Usuario usuario = null;

        try
        {
            using (SqlConnection con = new SqlConnection(StringConexion))
            {
                con.Open();
                using (SqlCommand verif = new SqlCommand("VerificarUsuario", con))
                {
                    verif.CommandType = CommandType.StoredProcedure;

                    verif.Parameters.AddWithValue("@inUsername", Username);
                    verif.Parameters.AddWithValue("@inPassword", Password);
                    verif.Parameters.AddWithValue("@inIdPostByUser", idPostByUser);
                    verif.Parameters.AddWithValue("@inPostInIP", PostInIP);
                    verif.Parameters.AddWithValue("@inPostTime", PostTime);

                    SqlParameter outCodigoError = new SqlParameter("@outCodigoError", SqlDbType.Int)
                    {
                        Direction = ParameterDirection.Output
                    };
                    verif.Parameters.Add(outCodigoError);

                    using (SqlDataReader reader = verif.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            usuario = new Usuario(
                                reader.GetInt32(0),
                                reader.GetString(1),
                                reader.GetString(2),
                                reader.GetInt32(3)
                            );
                        }
                    }

                    int errorCod = (int)outCodigoError.Value;
                    if (errorCod != 0)
                    {
                        Console.WriteLine("Error al verificar usuario: " + errorCod);
                    }
                }
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine("Error al verificar usuario: " + ex.Message);
        }

        return usuario;
    }





    /*Cargar Puestos para Insertar y Editar*/
    public static List<Puesto> ListarPuestos()
    {
        string StringConexion = "Server=25.55.61.33;" +
            "Database=Tarea3;" +
            "Trusted_Connection=True;" +
            "TrustServerCertificate=True;";

        // Crea una lista de Puestos vacía
        List<Puesto> Puestos = new List<Puesto>();

        try
        {
            using (SqlConnection con = new SqlConnection(StringConexion))
            {
                con.Open();
                using (SqlCommand mostrar = new SqlCommand("ListarPuestos", con))
                {
                    mostrar.CommandType = CommandType.StoredProcedure;

                    // Añadir el parámetro de salida para código de error
                    SqlParameter outCodigoError = new SqlParameter("@outCodigoError", SqlDbType.Int)
                    {
                        Direction = ParameterDirection.Output
                    };
                    mostrar.Parameters.Add(outCodigoError);

                    using (SqlDataReader reader = mostrar.ExecuteReader())
                    {
                        // Mientras haya registros en la tabla, los va almacenando como Puestos
                        while (reader.Read())
                        {
                            Puestos.Add(new Puesto(
                                reader.GetInt32(0),
                                reader.GetString(1),
                                reader.GetDecimal(2)
                            ));
                        }
                    }

                    // Obtener el código de error 
                    int errorCod = (int)outCodigoError.Value;
                    if (errorCod != 0)
                    {
                        // Error en capa lógica
                        Console.WriteLine("Error al mostrar Puestos: " + errorCod);
                    }
                }
            }
        }
        catch (Exception ex)
        {
            // Error en capa lógica
            Console.WriteLine("Error al mostrar Puestos");
        }

        return Puestos;
    }




    /*Cargar Departamentos para Insertar y Editar*/
    public static List<Departamento> ListarDepartamentos()
    {
        string StringConexion = "Server=25.55.61.33;" +
            "Database=Tarea3;" +
            "Trusted_Connection=True;" +
            "TrustServerCertificate=True;";

        // Crea una lista de Deps vacía
        List<Departamento> Departamentos = new List<Departamento>();

        try
        {
            using (SqlConnection con = new SqlConnection(StringConexion))
            {
                con.Open();
                using (SqlCommand mostrar = new SqlCommand("ListarDepartamentos", con))
                {
                    mostrar.CommandType = CommandType.StoredProcedure;

                    // Añadir el parámetro de salida para código de error
                    SqlParameter outCodigoError = new SqlParameter("@outCodigoError", SqlDbType.Int)
                    {
                        Direction = ParameterDirection.Output
                    };
                    mostrar.Parameters.Add(outCodigoError);

                    using (SqlDataReader reader = mostrar.ExecuteReader())
                    {
                        // Mientras haya registros en la tabla, los va almacenando como Puestos
                        while (reader.Read())
                        {
                            Departamentos.Add(new Departamento(
                                reader.GetInt32(0),
                                reader.GetString(1)
                            ));
                        }
                    }

                    // Obtener el código de error 
                    int errorCod = (int)outCodigoError.Value;
                    if (errorCod != 0)
                    {
                        // Error en capa lógica
                        Console.WriteLine("Error al mostrar Departamentos: " + errorCod);
                    }
                }
            }
        }
        catch (Exception ex)
        {
            // Error en capa lógica
            Console.WriteLine("Error al mostrar Departamentos");
        }

        return Departamentos;
    }


    /*Cargar TipoDoc para Insertar y Editar*/
    public static List<TipoDocId> ListarTipoDocIds()
    {
        string StringConexion = "Server=25.55.61.33;" +
            "Database=Tarea3;" +
            "Trusted_Connection=True;" +
            "TrustServerCertificate=True;";

        // Crea una lista de Deps vacía
        List<TipoDocId> TipoDocIds = new List<TipoDocId>();

        try
        {
            using (SqlConnection con = new SqlConnection(StringConexion))
            {
                con.Open();
                using (SqlCommand mostrar = new SqlCommand("ListarTipoDocIds", con))
                {
                    mostrar.CommandType = CommandType.StoredProcedure;

                    // Añadir el parámetro de salida para código de error
                    SqlParameter outCodigoError = new SqlParameter("@outCodigoError", SqlDbType.Int)
                    {
                        Direction = ParameterDirection.Output
                    };
                    mostrar.Parameters.Add(outCodigoError);

                    using (SqlDataReader reader = mostrar.ExecuteReader())
                    {
                        // Mientras haya registros en la tabla, los va almacenando como Puestos
                        while (reader.Read())
                        {
                            TipoDocIds.Add(new TipoDocId(
                                reader.GetInt32(0),
                                reader.GetString(1)
                            ));
                        }
                    }

                    // Obtener el código de error 
                    int errorCod = (int)outCodigoError.Value;
                    if (errorCod != 0)
                    {
                        // Error en capa lógica
                        Console.WriteLine("Error al mostrar TipoDocIds: " + errorCod);
                    }
                }
            }
        }
        catch (Exception ex)
        {
            // Error en capa lógica
            Console.WriteLine("Error al mostrar TipoDocIds");
        }

        return TipoDocIds;
    }



    /*Funcionalidades Planillas*/

    /*1. Planilla Semanal*/
    public static List<PlanillaSemanal> ConsultarPlanillaSemanal(int idEmpleado, int idPostByUser, string postInIP, DateTime postTime)
    {
        List<PlanillaSemanal> planillas = new List<PlanillaSemanal>();
        string conexion = "Server=25.55.61.33;Database=Tarea3;Trusted_Connection=True;TrustServerCertificate=True;";

        try
        {
            using (SqlConnection con = new SqlConnection(conexion))
            {
                con.Open();
                using (SqlCommand cmd = new SqlCommand("ConsultarPlanillaSemanal", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@inIdEmpleado", idEmpleado);
                    cmd.Parameters.AddWithValue("@inIdPostByUser", idPostByUser);
                    cmd.Parameters.AddWithValue("@inPostInIP", postInIP);
                    cmd.Parameters.AddWithValue("@inPostTime", postTime);

                    SqlParameter outCod = new SqlParameter("@outCodigoError", SqlDbType.Int)
                    {
                        Direction = ParameterDirection.Output
                    };
                    cmd.Parameters.Add(outCod);

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            planillas.Add(new PlanillaSemanal(
                                reader.GetInt32(0),  // id
                                reader.GetInt32(1),  // idEmpleado
                                reader.GetInt32(2),  // idSemana
                                reader.GetDecimal(3), // HorasOrdinarias
                                reader.GetDecimal(4), // HorasExtra
                                reader.GetDecimal(5), // HorasExtraDoble
                                reader.GetDecimal(6), // SalarioBruto
                                reader.GetDecimal(7), // SalarioNeto
                                reader.GetDecimal(8), // TotalDeducciones
                                reader.GetDateTime(9), // FechaInicio
                                reader.GetDateTime(10) // FechaFin
                            ));

                        }
                    }

                    int codigoError = (int)outCod.Value;
                    if (codigoError != 0)
                        Console.WriteLine("Error en SP ConsultarPlanillaSemanal: " + codigoError);
                }
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine("Error: " + ex.Message);
        }
        return planillas;
    }



    /*2. Planilla Mensual*/
    public static List<PlanillaMensual> ConsultarPlanillaMensual(int idEmpleado, int idPostByUser, string postInIP, DateTime postTime)
    {
        List<PlanillaMensual> planillas = new List<PlanillaMensual>();
        string conexion = "Server=25.55.61.33;Database=Tarea3;Trusted_Connection=True;TrustServerCertificate=True;";

        try
        {
            Console.WriteLine("Intentando abrir conexión...");
            using (SqlConnection con = new SqlConnection(conexion))
            {
                con.Open();
                Console.WriteLine("Conexión abierta correctamente.");

                using (SqlCommand cmd = new SqlCommand("ConsultarPlanillaMensual", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@inIdEmpleado", idEmpleado);
                    cmd.Parameters.AddWithValue("@inIdPostByUser", idPostByUser);
                    cmd.Parameters.AddWithValue("@inPostInIP", postInIP);
                    cmd.Parameters.AddWithValue("@inPostTime", postTime);

                    SqlParameter outCod = new SqlParameter("@outCodigoError", SqlDbType.Int)
                    {
                        Direction = ParameterDirection.Output
                    };
                    cmd.Parameters.Add(outCod);

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            planillas.Add(new PlanillaMensual(
                                 reader.GetInt32(0),  // id
                                 reader.GetInt32(1),  // idEmpleado
                                 reader.GetInt32(2),  // idMes
                                 reader.GetDecimal(3), // SalarioBruto
                                 reader.GetDecimal(4), // SalarioNeto
                                 reader.GetDecimal(5), // TotalDeducciones
                                 reader.GetDateTime(6), // FechaInicio
                                 reader.GetDateTime(7)  // FechaFin
                             ));

                        }
                    }

                    // Validar código de error solo si fue asignado
                    if (outCod.Value != DBNull.Value)
                    {
                        int codigoError = (int)outCod.Value;
                        if (codigoError != 0)
                            Console.WriteLine("Error en SP ConsultarPlanillaMensual: " + codigoError);
                    }
                    else
                    {
                        Console.WriteLine("Advertencia: el valor de @outCodigoError es NULL.");
                    }
                }
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine("Excepción en ConsultarPlanillaMensual: " + ex.Message);
        }

        return planillas;
    }



    /*3. Consultar Movimientos Salario Bruto*/
    public static List<MovimientoDetalle> ConsultarMovimientos(int idPlanilla, out int codigoError, out string mensajeError, out int filaError)
    {
        List<MovimientoDetalle> movimientos = new List<MovimientoDetalle>();
        string conexion = "Server=25.55.61.33;Database=Tarea3;Trusted_Connection=True;TrustServerCertificate=True;";
        codigoError = 0;
        mensajeError = "";
        filaError = 0;

        try
        {
            using (SqlConnection con = new SqlConnection(conexion))
            {
                con.Open();

                using (SqlCommand cmd = new SqlCommand("ConsultarMovimientos", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@inIdPlanilla", idPlanilla);

                    SqlParameter outCod = new SqlParameter("@outCodigoError", SqlDbType.Int)
                    {
                        Direction = ParameterDirection.Output
                    };
                    cmd.Parameters.Add(outCod);

                    int filaNum = 0;
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            filaNum++;
                            try
                            {
                                movimientos.Add(new MovimientoDetalle
                                {
                                    Id = reader.GetInt32(0),
                                    IdEmpleado = reader.GetInt32(1),
                                    IdTipoMovimiento = reader.GetInt32(2),
                                    Fecha = reader.GetDateTime(3),
                                    CantidadHoras = reader.GetInt32(4),
                                    Monto = reader.GetDecimal(5),
                                    IdPlanillaSemanal = reader.GetInt32(6),
                                    IdRegistroAsistencia = reader.GetInt32(7),
                                    HoraEntrada = reader.GetTimeSpan(8),
                                    HoraSalida = reader.GetTimeSpan(9),
                                    Dia = reader.GetString(10),
                                    TipoMovimientoNombre = reader.GetString(11)
                                });
                            }
                            catch (Exception ex)
                            {
                                // Guardamos info del error
                                codigoError = 50010;
                                mensajeError = $"Error en fila {filaNum}: {ex.Message}";
                                filaError = filaNum;
                                // Lanzamos para que se capture en el controlador y se envíe al frontend
                                throw new Exception(mensajeError, ex);
                            }
                        }
                    }

                    if (outCod.Value != DBNull.Value)
                    {
                        codigoError = (int)outCod.Value;
                        if (codigoError != 0)
                            throw new Exception($"Error en SP ConsultarMovimientos: código {codigoError}");
                    }
                    else
                    {
                        throw new Exception("El parámetro de salida @outCodigoError es NULL");
                    }
                }
            }
        }
        catch (Exception ex)
        {
            if (codigoError != 0) // Si no se definió antes
            {
                codigoError = 50099;
                mensajeError = ex.Message;
            }
            throw new Exception(mensajeError, ex);
        }

        return movimientos;
    }




    /*4. Consultar Asistencia*/
    public static List<RegistroAsistenciaDetalle> ConsultarRegistroAsistencia(int idRegistro, out int codigoError)
    {
        List<RegistroAsistenciaDetalle> registros = new();
        codigoError = 0;
        string conexion = "Server=25.55.61.33;Database=Tarea3;Trusted_Connection=True;TrustServerCertificate=True;";

        try
        {
            Console.WriteLine("Intentando abrir conexión...");
            using (SqlConnection con = new SqlConnection(conexion))
            {
                con.Open();
                Console.WriteLine("Conexión abierta correctamente.");

                using (SqlCommand cmd = new SqlCommand("ConsultarRegistroAsistencia", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@inIdRegistroAsistencia", idRegistro);

                    SqlParameter outCod = new SqlParameter("@outCodigoError", SqlDbType.Int)
                    {
                        Direction = ParameterDirection.Output
                    };
                    cmd.Parameters.Add(outCod);

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            registros.Add(new RegistroAsistenciaDetalle
                            {
                                Id = reader.GetInt32(0),
                                IdEmpleado = reader.GetInt32(1),
                                IdTipoJornada = reader.GetInt32(2),
                                NombreTipoJornada = reader.GetString(3),
                                InicioJornada = reader.GetTimeSpan(4),
                                FinJornada = reader.GetTimeSpan(5),
                                Fecha = reader.GetDateTime(6),
                                HoraEntrada = reader.GetTimeSpan(7),
                                HoraSalida = reader.GetTimeSpan(8),
                                HorasOrdinarias = reader.GetDecimal(9),
                                HorasExtra = reader.GetDecimal(10),
                                Dia = reader.GetString(11),
                                Feriado = reader.GetString(12)
                            });
                        }
                    }

                    // Validar código de error solo si fue asignado
                    if (outCod.Value != DBNull.Value)
                    {
                        codigoError = (int)outCod.Value;
                        if (codigoError != 0)
                            Console.WriteLine("Error en SP ConsultarRegistroAsistencia: " + codigoError);
                    }
                    else
                    {
                        Console.WriteLine("Advertencia: el valor de @outCodigoError es NULL.");
                        codigoError = -1;
                    }
                }
            }
        }
        catch (Exception ex)
        {
            codigoError = 50099;
            Console.WriteLine("Excepción en ConsultarRegistroAsistencia: " + ex.Message);
        }

        return registros;
    }


    /*5. Consultar Deduccion Semanal*/
    public static List<DeduccionSemanal> ConsultarDeduccionesSemanales(int idPlanillaSemanal, out int codigoError)
    {
        List<DeduccionSemanal> deducciones = new();
        codigoError = 0;
        string conexion = "Server=25.55.61.33;Database=Tarea3;Trusted_Connection=True;TrustServerCertificate=True;";

        try
        {
            Console.WriteLine("Intentando abrir conexión...");
            using (SqlConnection con = new SqlConnection(conexion))
            {
                con.Open();
                Console.WriteLine("Conexión abierta correctamente.");

                using (SqlCommand cmd = new SqlCommand("ConsultarDeduccionesSemanal", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@inIdPlanillaSemanal", idPlanillaSemanal);

                    SqlParameter outCod = new SqlParameter("@outCodigoError", SqlDbType.Int)
                    {
                        Direction = ParameterDirection.Output
                    };
                    cmd.Parameters.Add(outCod);

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            deducciones.Add(new DeduccionSemanal
                            (
                                reader.GetInt32(0),
                                reader.GetInt32(1),
                                reader.GetInt32(2),
                                reader.GetString(3),
                                reader.IsDBNull(4) ? null : (float?)reader.GetFloat(4),
                                reader.GetDecimal(5)
                            ));
                        }
                    }

                    if (outCod.Value == DBNull.Value)
                    {
                        throw new Exception("El parámetro de salida @outCodigoError es NULL");
                    }

                    codigoError = (int)outCod.Value;
                    if (codigoError != 0)
                    {
                        throw new Exception($"Error en SP ConsultarDeduccionesSemanal: código {codigoError}");
                    }
                }
            }
        }
        catch (Exception ex)
        {
            codigoError = 50099;
            Console.WriteLine("Excepción en ConsultarDeduccionesSemanales: " + ex.Message);
            throw;  // relanza la excepción para que sea manejada por el controlador
        }

        return deducciones;
    }

    /*6. Consultar Deduccion Mensual*/
    public static List<DeduccionMensual> ConsultarDeduccionesMensuales(int idPlanillaMensual, out int codigoError)
    {
        List<DeduccionMensual> deducciones = new();
        codigoError = 0;
        string conexion = "Server=25.55.61.33;Database=Tarea3;Trusted_Connection=True;TrustServerCertificate=True;";

        try
        {
            Console.WriteLine("Intentando abrir conexión...");
            using (SqlConnection con = new SqlConnection(conexion))
            {
                con.Open();
                Console.WriteLine("Conexión abierta correctamente.");

                using (SqlCommand cmd = new SqlCommand("ConsultarDeduccionesMensual", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@inIdPlanillaMensual", idPlanillaMensual);

                    SqlParameter outCod = new SqlParameter("@outCodigoError", SqlDbType.Int)
                    {
                        Direction = ParameterDirection.Output
                    };
                    cmd.Parameters.Add(outCod);

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            deducciones.Add(new DeduccionMensual
                            (
                                reader.GetInt32(0),
                                reader.GetInt32(1),
                                reader.GetInt32(2),
                                reader.GetString(3),
                                reader.IsDBNull(4) ? null : (float?)reader.GetFloat(4),
                                reader.GetDecimal(5)
                            ));
                        }
                    }

                    if (outCod.Value == DBNull.Value)
                    {
                        throw new Exception("El parámetro de salida @outCodigoError es NULL");
                    }

                    codigoError = (int)outCod.Value;
                    if (codigoError != 0)
                    {
                        throw new Exception($"Error en SP ConsultarDeduccionesMensual: código {codigoError}");
                    }
                }
            }
        }
        catch (Exception ex)
        {
            codigoError = 50099;
            Console.WriteLine("Excepción en ConsultarDeduccionesMensuales: " + ex.Message);
            throw;
        }

        return deducciones;
    }



    /*7. Movimiento Deduccion*/
    public static List<MovimientoPorDeduccionDetalle> ConsultarMovimientosPorDeduccion(int idPlanilla, int idTipoDeduccion, out int codigoError)
    {
        List<MovimientoPorDeduccionDetalle> movimientos = new();
        codigoError = 0;
        string conexion = "Server=25.55.61.33;Database=Tarea3;Trusted_Connection=True;TrustServerCertificate=True;";

        try
        {
            Console.WriteLine("Intentando abrir conexión...");
            using (SqlConnection con = new SqlConnection(conexion))
            {
                con.Open();
                Console.WriteLine("Conexión abierta correctamente.");

                using (SqlCommand cmd = new SqlCommand("ConsultarMovimientosPorDeduccion", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@inIdPlanilla", idPlanilla);
                    cmd.Parameters.AddWithValue("@inIdTipoDeduccion", idTipoDeduccion);

                    SqlParameter outCod = new SqlParameter("@outCodigoError", SqlDbType.Int)
                    {
                        Direction = ParameterDirection.Output
                    };
                    cmd.Parameters.Add(outCod);

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            movimientos.Add(new MovimientoPorDeduccionDetalle(
                                reader.GetInt32(0),     // idMovimiento
                                reader.GetInt32(1),     // idEmpleado
                                reader.GetString(2),    // NombreEmpleado
                                reader.GetInt32(3),     // idTipoMovimiento
                                reader.GetString(4),    // NombreTipoMovimiento
                                reader.GetDecimal(5),   // Monto (posición corregida)
                                reader.GetString(6),    // NombreDeduccion (posición corregida)
                                reader.GetBoolean(7),   // Porcentual (posición corregida)
                                reader.GetDecimal(8)    // PorcentajeDeduccion (posición corregida)
                            ));
                        }
                    }

                    if (outCod.Value == DBNull.Value)
                    {
                        throw new Exception("El parámetro de salida @outCodigoError es NULL");
                    }

                    codigoError = (int)outCod.Value;
                    if (codigoError != 0)
                    {
                        throw new Exception($"Error en SP ConsultarMovimientosPorDeduccion: código {codigoError}");
                    }
                }
            }
        }
        catch (Exception ex)
        {
            codigoError = 50099;
            Console.WriteLine("Excepción en ConsultarMovimientosPorDeduccion: " + ex.Message);
            throw;
        }

        return movimientos;
    }


    /*8. Movimiento Mes Deduccion*/

    public static List<MovimientoPorDeduccionMensualDetalle> ConsultarMovimientosPorPlanillaMensualYTipo(
    int idPlanillaMensual,
    int idTipoDeduccion,
    int idEmpleado,
    out int codigoError)
    {
        List<MovimientoPorDeduccionMensualDetalle> movimientos = new();
        codigoError = 0;
        string conexion = "Server=25.55.61.33;Database=Tarea3;Trusted_Connection=True;TrustServerCertificate=True;";

        try
        {
            using (SqlConnection con = new SqlConnection(conexion))
            {
                con.Open();

                using (SqlCommand cmd = new SqlCommand("ConsultarMovimientosPorPlanillaMensualYTipo", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@inIdPlanillaMensual", idPlanillaMensual);
                    cmd.Parameters.AddWithValue("@inIdTipoDeduccion", idTipoDeduccion);
                    cmd.Parameters.AddWithValue("@inIdEmpleado", idEmpleado);

                    SqlParameter outCod = new SqlParameter("@outCodigoError", SqlDbType.Int)
                    {
                        Direction = ParameterDirection.Output
                    };
                    cmd.Parameters.Add(outCod);

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            movimientos.Add(new MovimientoPorDeduccionMensualDetalle(
                                reader.GetInt32(0),
                                reader.GetInt32(1),
                                reader.GetString(2),
                                reader.GetInt32(3),
                                reader.GetString(4),
                                reader.GetDecimal(5),
                                reader.GetString(6),
                                reader.GetBoolean(7),
                                reader.GetDecimal(8),
                                reader.GetInt32(9)
                            ));
                        }
                    }

                    codigoError = (int)outCod.Value;
                    if (codigoError != 0)
                    {
                        return null;
                    }
                }
            }
        }
        catch (Exception ex)
        {
            codigoError = 50099;
            Console.WriteLine("Error en ConsultarMovimientosPorPlanillaMensualYTipo: " + ex.Message);
            return null;
        }

        return movimientos;
    }

}










