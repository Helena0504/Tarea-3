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
                                reader.GetInt32(0),        // id
                                reader.GetInt32(1),        // idPuesto
                                reader.GetInt32(2),        // idDepartamento
                                reader.GetInt32(3),        // idTipoDocumento
                                reader.GetString(4),       // nombre
                                reader.GetString(5),       // valorDocumento
                                reader.GetDateTime(6).Date,// fechaNacimiento
                                reader.GetInt32(7),
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


}


