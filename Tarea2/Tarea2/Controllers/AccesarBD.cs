using Microsoft.Data.SqlClient;
using System.Collections.Generic;
using System.Data;
using Tarea2.Modelos;

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
                                reader.GetInt32(0),
                                reader.GetInt32(1),
                                reader.GetInt32(2),
                                reader.GetInt32(3),
                                reader.GetString(4),
                                reader.GetString(5),
                                reader.GetDateTime(6).Date,
                                reader.GetString(7),
                                reader.GetString(8),
                                reader.GetString(9)
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
                                reader.GetString(7),
                                reader.GetString(8),
                                reader.GetString(9)
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







    public static int InsertarEmpleado(string nombre, string idTipoDocumento, string valorDocumento, DateTime fechaNacimiento, string idDepartamento, string idPuesto, bool esActivo)
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

                using (SqlCommand insertar = new SqlCommand("InsertarEmpleado", con))
                {
                    insertar.CommandType = CommandType.StoredProcedure;

                    //Envia parámetros de entrada
                    insertar.Parameters.Add("@inNombre", SqlDbType.VarChar, 128).Value = nombre;
                    insertar.Parameters.Add("@inIdTipoDocumento", SqlDbType.VarChar, 128).Value = idTipoDocumento;
                    insertar.Parameters.Add("@inValorDocumento", SqlDbType.VarChar, 128).Value = valorDocumento;
                    insertar.Parameters.Add("@inFechaNacimiento", SqlDbType.Date).Value = fechaNacimiento;
                    insertar.Parameters.Add("@inIdDepartamento", SqlDbType.VarChar, 128).Value = idDepartamento;

                    insertar.Parameters.Add("@inIdPuesto", SqlDbType.VarChar, 128).Value = idPuesto;
                    insertar.Parameters.Add("@inEsActivo", SqlDbType.Bit).Value = esActivo;

                    //Recibe el código de error
                    SqlParameter outCodigoError = new SqlParameter("@outCodigoError", SqlDbType.Int)
                    {
                        Direction = ParameterDirection.Output
                    };
                    insertar.Parameters.Add(outCodigoError);

                    //Se ejecuta el Stored procedure
                    insertar.ExecuteNonQuery();

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


    public static int UpdateEmpleado(int id, string nombre, string tipoDocumento, string valorDocumento,
     DateTime fechaNacimiento, string puesto, string departamento, string idUsuario, string ip)
    {
        string StringConexion = "Server=25.55.61.33;Database=Tarea3;Trusted_Connection=True;TrustServerCertificate=True;";

        try
        {
            using (SqlConnection con = new SqlConnection(StringConexion))
            {
                con.Open();

                using (SqlCommand cmd = new SqlCommand("EditarEmpleado", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add("@inId", SqlDbType.Int).Value = id;
                    cmd.Parameters.Add("@inNombre", SqlDbType.VarChar, 128).Value = nombre;
                    cmd.Parameters.Add("@inTipoDocumento", SqlDbType.VarChar, 128).Value = tipoDocumento;
                    cmd.Parameters.Add("@inValorDocumento", SqlDbType.VarChar, 128).Value = valorDocumento;
                    cmd.Parameters.Add("@inFechaNacimiento", SqlDbType.Date).Value = fechaNacimiento;
                    cmd.Parameters.Add("@inPuesto", SqlDbType.VarChar, 128).Value = puesto;
                    cmd.Parameters.Add("@inDepartamento", SqlDbType.VarChar, 128).Value = departamento;
                    cmd.Parameters.Add("@inIdPostByUser", SqlDbType.VarChar, 128).Value = idUsuario;
                    cmd.Parameters.Add("@inPostInIP", SqlDbType.VarChar, 32).Value = ip;

                    SqlParameter outCodigoError = new SqlParameter("@outCodigoError", SqlDbType.Int)
                    {
                        Direction = ParameterDirection.Output
                    };
                    cmd.Parameters.Add(outCodigoError);

                    cmd.ExecuteNonQuery();

                    return (int)outCodigoError.Value;
                }
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error: {ex.Message}");
            Console.WriteLine($"StackTrace: {ex.StackTrace}");
            return 50025;
        }
    }





    public static int CargarDatos()
    {
        string StringConexion = "Server=25.55.61.33;" +
            "Database=Tarea2;" +
            "Trusted_Connection=True;" +
            "TrustServerCertificate=True;";

        try
        {
            using (var con = new SqlConnection(StringConexion))
            {
                con.Open();
                using (var cmd = new SqlCommand("CargarDatos", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    var outParam = new SqlParameter("@outCodigoError", SqlDbType.Int)
                    {
                        Direction = ParameterDirection.Output
                    };
                    cmd.Parameters.Add(outParam);

                    cmd.ExecuteNonQuery();

                    return (int)outParam.Value;
                }
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine("Database Error: " + ex.Message);
            return 50005;
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
    public static List<Puesto> MostrarPuestos()
    {
        string StringConexion = "Server=25.55.61.33;" +
            "Database=Tarea2;" +
            "Trusted_Connection=True;" +
            "TrustServerCertificate=True;";

        // Crea una lista de Puestos vacía
        List<Puesto> Puestos = new List<Puesto>();

        try
        {
            using (SqlConnection con = new SqlConnection(StringConexion))
            {
                con.Open();
                using (SqlCommand mostrar = new SqlCommand("MostrarPuestos", con))
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

}


    