USE [master]
GO
/****** Object:  Database [Tarea3]    Script Date: 6/23/2025 5:19:27 PM ******/
CREATE DATABASE [Tarea3]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Tarea3', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\Tarea3.mdf' , SIZE = 73728KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Tarea3_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\Tarea3_log.ldf' , SIZE = 270336KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [Tarea3] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Tarea3].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Tarea3] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Tarea3] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Tarea3] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Tarea3] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Tarea3] SET ARITHABORT OFF 
GO
ALTER DATABASE [Tarea3] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Tarea3] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Tarea3] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Tarea3] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Tarea3] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Tarea3] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Tarea3] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Tarea3] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Tarea3] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Tarea3] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Tarea3] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Tarea3] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Tarea3] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Tarea3] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Tarea3] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Tarea3] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Tarea3] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Tarea3] SET RECOVERY FULL 
GO
ALTER DATABASE [Tarea3] SET  MULTI_USER 
GO
ALTER DATABASE [Tarea3] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Tarea3] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Tarea3] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Tarea3] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Tarea3] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Tarea3] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'Tarea3', N'ON'
GO
ALTER DATABASE [Tarea3] SET QUERY_STORE = ON
GO
ALTER DATABASE [Tarea3] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [Tarea3]
GO
/****** Object:  Table [dbo].[TipoDeduccion]    Script Date: 6/23/2025 5:19:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoDeduccion](
	[id] [int] NOT NULL,
	[Nombre] [varchar](128) NOT NULL,
	[Obligatorio] [bit] NOT NULL,
	[Porcentual] [bit] NOT NULL,
	[Valor] [real] NOT NULL,
 CONSTRAINT [PK_TipoDeduccion] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Empleado]    Script Date: 6/23/2025 5:19:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Empleado](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idPuesto] [int] NOT NULL,
	[idDepartamento] [int] NOT NULL,
	[idTipoDocumento] [int] NOT NULL,
	[Nombre] [varchar](128) NOT NULL,
	[ValorDocumento] [varchar](128) NOT NULL,
	[FechaNacimiento] [date] NOT NULL,
	[idUsuario] [int] NOT NULL,
	[Activo] [bit] NOT NULL,
 CONSTRAINT [PK_Empleado] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmpleadoDeduccion]    Script Date: 6/23/2025 5:19:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmpleadoDeduccion](
	[idEmpleado] [int] NOT NULL,
	[idTipoDeduccion] [int] NOT NULL,
	[Fecha] [date] NOT NULL,
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Monto] [decimal](10, 2) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[VistaEmpleadoDeducciones]    Script Date: 6/23/2025 5:19:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VistaEmpleadoDeducciones] AS
SELECT 
    e.id AS IdEmpleado,
    e.nombre AS NombreEmpleado,
    td.id AS IdTipoDeduccion,
    td.Nombre AS NombreDeduccion,
    td.Valor AS ValorDeduccion,
    td.Obligatorio,
    td.Porcentual
FROM 
    dbo.EmpleadoDeduccion ed
    INNER JOIN Empleado e ON ed.idEmpleado = e.id
    INNER JOIN TipoDeduccion td ON ed.idTipoDeduccion = td.id;
GO
/****** Object:  Table [dbo].[DBError]    Script Date: 6/23/2025 5:19:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DBError](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [varchar](max) NOT NULL,
	[Number] [int] NOT NULL,
	[State] [int] NOT NULL,
	[Severity] [int] NOT NULL,
	[Line] [int] NOT NULL,
	[Procedure] [varchar](max) NOT NULL,
	[Message] [varchar](max) NOT NULL,
	[DateTime] [datetime] NOT NULL,
 CONSTRAINT [PK_DBError] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Departamento]    Script Date: 6/23/2025 5:19:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Departamento](
	[id] [int] NOT NULL,
	[Nombre] [varchar](128) NOT NULL,
 CONSTRAINT [PK_Departamento] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DetalleDeduccionMensual]    Script Date: 6/23/2025 5:19:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DetalleDeduccionMensual](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idPlanillaMes] [int] NOT NULL,
	[idTipoDeduccion] [int] NOT NULL,
	[Porcentaje] [real] NULL,
	[Monto] [money] NOT NULL,
 CONSTRAINT [PK_DetalleDeduccionMensual] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DetalleDeduccionSemanal]    Script Date: 6/23/2025 5:19:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DetalleDeduccionSemanal](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idPlanillaSemanal] [int] NOT NULL,
	[idTipoDeduccion] [int] NOT NULL,
	[Porcentaje] [real] NULL,
	[Monto] [money] NOT NULL,
 CONSTRAINT [PK_DetalleDeduccionSemanal] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Error]    Script Date: 6/23/2025 5:19:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Error](
	[id] [int] NOT NULL,
	[Codigo] [int] NOT NULL,
	[Descripcion] [varchar](max) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EventoLog]    Script Date: 6/23/2025 5:19:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EventoLog](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idTipoEvento] [int] NOT NULL,
	[Descripcion] [varchar](max) NOT NULL,
	[idPostByUser] [int] NOT NULL,
	[PostInIP] [varchar](32) NOT NULL,
	[PostTime] [datetime] NOT NULL,
 CONSTRAINT [PK_EventoLog] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Feriado]    Script Date: 6/23/2025 5:19:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Feriado](
	[id] [int] NOT NULL,
	[Nombre] [varchar](128) NOT NULL,
	[Fecha] [date] NOT NULL,
 CONSTRAINT [PK_Feriado] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Jornada]    Script Date: 6/23/2025 5:19:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Jornada](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idSemana] [int] NOT NULL,
	[idTipoJornada] [int] NOT NULL,
	[idEmpleado] [int] NOT NULL,
 CONSTRAINT [PK_Jornada] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Mes]    Script Date: 6/23/2025 5:19:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Mes](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[FechaInicio] [date] NOT NULL,
	[FechaFin] [date] NOT NULL,
 CONSTRAINT [PK_Mes] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Movimiento]    Script Date: 6/23/2025 5:19:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Movimiento](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idEmpleado] [int] NOT NULL,
	[idTipoMovimiento] [int] NOT NULL,
	[Fecha] [datetime] NOT NULL,
	[CantidadHoras] [int] NOT NULL,
	[Monto] [money] NOT NULL,
	[idPlanillaSemanal] [int] NULL,
 CONSTRAINT [PK_Movimiento] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MovimientoXDeduccion]    Script Date: 6/23/2025 5:19:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MovimientoXDeduccion](
	[idMovimiento] [int] NOT NULL,
	[idTipoDeduccion] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[idMovimiento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MovimientoXHora]    Script Date: 6/23/2025 5:19:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MovimientoXHora](
	[idMovimiento] [int] NOT NULL,
	[idRegistroAsistencia] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[idMovimiento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PlanillaMes]    Script Date: 6/23/2025 5:19:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PlanillaMes](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idEmpleado] [int] NOT NULL,
	[idMes] [int] NOT NULL,
	[SalarioBruto] [decimal](18, 2) NOT NULL,
	[SalarioNeto] [decimal](18, 2) NOT NULL,
	[TotalDeducciones] [decimal](18, 2) NOT NULL,
	[cantidadSemanas] [int] NOT NULL,
 CONSTRAINT [PK_PlanillaMes] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PlanillaSemanal]    Script Date: 6/23/2025 5:19:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PlanillaSemanal](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idEmpleado] [int] NOT NULL,
	[idSemana] [int] NOT NULL,
	[HorasOrdinarias] [decimal](10, 2) NULL,
	[HorasExtra] [decimal](10, 2) NULL,
	[HorasExtraDoble] [decimal](10, 2) NULL,
	[SalarioBruto] [decimal](18, 2) NULL,
	[TotalDeducciones] [decimal](18, 2) NOT NULL,
	[SalarioNeto] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_PlanillaSemanal] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Puesto]    Script Date: 6/23/2025 5:19:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Puesto](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](128) NOT NULL,
	[SalarioxHora] [money] NOT NULL,
 CONSTRAINT [PK_Puesto] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RegistroAsistencia]    Script Date: 6/23/2025 5:19:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RegistroAsistencia](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idEmpleado] [int] NOT NULL,
	[idTipoJornada] [int] NOT NULL,
	[Fecha] [date] NOT NULL,
	[HoraEntrada] [time](7) NOT NULL,
	[HoraSalida] [time](7) NOT NULL,
	[HorasOrdinarias] [decimal](5, 2) NOT NULL,
	[HorasExtra] [decimal](5, 2) NOT NULL,
	[Dia] [varchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Semana]    Script Date: 6/23/2025 5:19:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Semana](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[FechaInicio] [date] NOT NULL,
	[FechaFin] [date] NOT NULL,
 CONSTRAINT [PK_Semana] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoDocumentoIdentidad]    Script Date: 6/23/2025 5:19:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoDocumentoIdentidad](
	[id] [int] NOT NULL,
	[Nombre] [varchar](128) NOT NULL,
 CONSTRAINT [PK_TipoDocumentoIdentidad] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoEvento]    Script Date: 6/23/2025 5:19:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoEvento](
	[id] [int] NOT NULL,
	[Nombre] [varchar](128) NOT NULL,
 CONSTRAINT [PK_TipoEvento] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoJornada]    Script Date: 6/23/2025 5:19:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoJornada](
	[id] [int] NOT NULL,
	[Nombre] [varchar](128) NOT NULL,
	[HoraInicio] [time](7) NOT NULL,
	[HoraFin] [time](7) NOT NULL,
 CONSTRAINT [PK_TipoJornada] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoMovimiento]    Script Date: 6/23/2025 5:19:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoMovimiento](
	[id] [int] NOT NULL,
	[Nombre] [varchar](128) NOT NULL,
	[TipoOperacion]  AS (case when [Nombre] like 'Credito%' then 'Credito' when [Nombre] like 'Debito%' then 'Debito' else 'Otro' end),
 CONSTRAINT [PK_TipoMovimiento] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Usuario]    Script Date: 6/23/2025 5:19:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Usuario](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Username] [varchar](128) NOT NULL,
	[Password] [varchar](128) NOT NULL,
	[Tipo] [int] NOT NULL,
 CONSTRAINT [PK_Usuario] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EmpleadoDeduccion] ADD  DEFAULT (getdate()) FOR [Fecha]
GO
ALTER TABLE [dbo].[EmpleadoDeduccion] ADD  DEFAULT ((0)) FOR [Monto]
GO
ALTER TABLE [dbo].[RegistroAsistencia] ADD  DEFAULT ((0)) FOR [HorasOrdinarias]
GO
ALTER TABLE [dbo].[RegistroAsistencia] ADD  DEFAULT ((0)) FOR [HorasExtra]
GO
ALTER TABLE [dbo].[DetalleDeduccionMensual]  WITH CHECK ADD  CONSTRAINT [FK_DetalleDeduccionMensual_PlanillaMes] FOREIGN KEY([idPlanillaMes])
REFERENCES [dbo].[PlanillaMes] ([id])
GO
ALTER TABLE [dbo].[DetalleDeduccionMensual] CHECK CONSTRAINT [FK_DetalleDeduccionMensual_PlanillaMes]
GO
ALTER TABLE [dbo].[DetalleDeduccionMensual]  WITH CHECK ADD  CONSTRAINT [FK_DetalleDeduccionMensual_TipoDeduccion] FOREIGN KEY([idTipoDeduccion])
REFERENCES [dbo].[TipoDeduccion] ([id])
GO
ALTER TABLE [dbo].[DetalleDeduccionMensual] CHECK CONSTRAINT [FK_DetalleDeduccionMensual_TipoDeduccion]
GO
ALTER TABLE [dbo].[DetalleDeduccionSemanal]  WITH CHECK ADD  CONSTRAINT [FK_DetalleDeduccionSemanal_PlanillaSemanal] FOREIGN KEY([idPlanillaSemanal])
REFERENCES [dbo].[PlanillaSemanal] ([id])
GO
ALTER TABLE [dbo].[DetalleDeduccionSemanal] CHECK CONSTRAINT [FK_DetalleDeduccionSemanal_PlanillaSemanal]
GO
ALTER TABLE [dbo].[DetalleDeduccionSemanal]  WITH CHECK ADD  CONSTRAINT [FK_DetalleDeduccionSemanal_TipoDeduccion] FOREIGN KEY([idTipoDeduccion])
REFERENCES [dbo].[TipoDeduccion] ([id])
GO
ALTER TABLE [dbo].[DetalleDeduccionSemanal] CHECK CONSTRAINT [FK_DetalleDeduccionSemanal_TipoDeduccion]
GO
ALTER TABLE [dbo].[Empleado]  WITH CHECK ADD  CONSTRAINT [FK_Empleado_Departamento] FOREIGN KEY([idDepartamento])
REFERENCES [dbo].[Departamento] ([id])
GO
ALTER TABLE [dbo].[Empleado] CHECK CONSTRAINT [FK_Empleado_Departamento]
GO
ALTER TABLE [dbo].[Empleado]  WITH CHECK ADD  CONSTRAINT [FK_Empleado_Puesto] FOREIGN KEY([idPuesto])
REFERENCES [dbo].[Puesto] ([id])
GO
ALTER TABLE [dbo].[Empleado] CHECK CONSTRAINT [FK_Empleado_Puesto]
GO
ALTER TABLE [dbo].[Empleado]  WITH CHECK ADD  CONSTRAINT [FK_Empleado_TipoDocumentoIdentidad] FOREIGN KEY([idTipoDocumento])
REFERENCES [dbo].[TipoDocumentoIdentidad] ([id])
GO
ALTER TABLE [dbo].[Empleado] CHECK CONSTRAINT [FK_Empleado_TipoDocumentoIdentidad]
GO
ALTER TABLE [dbo].[Empleado]  WITH CHECK ADD  CONSTRAINT [FK_Empleado_Usuario] FOREIGN KEY([idUsuario])
REFERENCES [dbo].[Usuario] ([id])
GO
ALTER TABLE [dbo].[Empleado] CHECK CONSTRAINT [FK_Empleado_Usuario]
GO
ALTER TABLE [dbo].[EmpleadoDeduccion]  WITH CHECK ADD FOREIGN KEY([idEmpleado])
REFERENCES [dbo].[Empleado] ([id])
GO
ALTER TABLE [dbo].[EmpleadoDeduccion]  WITH CHECK ADD FOREIGN KEY([idTipoDeduccion])
REFERENCES [dbo].[TipoDeduccion] ([id])
GO
ALTER TABLE [dbo].[EventoLog]  WITH CHECK ADD  CONSTRAINT [FK_EventoLog_TipoEvento] FOREIGN KEY([idTipoEvento])
REFERENCES [dbo].[TipoEvento] ([id])
GO
ALTER TABLE [dbo].[EventoLog] CHECK CONSTRAINT [FK_EventoLog_TipoEvento]
GO
ALTER TABLE [dbo].[Jornada]  WITH CHECK ADD  CONSTRAINT [FK_Jornada_Empleado] FOREIGN KEY([idEmpleado])
REFERENCES [dbo].[Empleado] ([id])
GO
ALTER TABLE [dbo].[Jornada] CHECK CONSTRAINT [FK_Jornada_Empleado]
GO
ALTER TABLE [dbo].[Jornada]  WITH CHECK ADD  CONSTRAINT [FK_Jornada_Semana] FOREIGN KEY([idSemana])
REFERENCES [dbo].[Semana] ([id])
GO
ALTER TABLE [dbo].[Jornada] CHECK CONSTRAINT [FK_Jornada_Semana]
GO
ALTER TABLE [dbo].[Jornada]  WITH CHECK ADD  CONSTRAINT [FK_Jornada_TipoJornada] FOREIGN KEY([idTipoJornada])
REFERENCES [dbo].[TipoJornada] ([id])
GO
ALTER TABLE [dbo].[Jornada] CHECK CONSTRAINT [FK_Jornada_TipoJornada]
GO
ALTER TABLE [dbo].[Movimiento]  WITH CHECK ADD  CONSTRAINT [FK_Movimiento_Empleado] FOREIGN KEY([idEmpleado])
REFERENCES [dbo].[Empleado] ([id])
GO
ALTER TABLE [dbo].[Movimiento] CHECK CONSTRAINT [FK_Movimiento_Empleado]
GO
ALTER TABLE [dbo].[Movimiento]  WITH CHECK ADD  CONSTRAINT [FK_Movimiento_PlanillaSemanal] FOREIGN KEY([idPlanillaSemanal])
REFERENCES [dbo].[PlanillaSemanal] ([id])
GO
ALTER TABLE [dbo].[Movimiento] CHECK CONSTRAINT [FK_Movimiento_PlanillaSemanal]
GO
ALTER TABLE [dbo].[Movimiento]  WITH CHECK ADD  CONSTRAINT [FK_Movimiento_TipoMovimiento] FOREIGN KEY([idTipoMovimiento])
REFERENCES [dbo].[TipoMovimiento] ([id])
GO
ALTER TABLE [dbo].[Movimiento] CHECK CONSTRAINT [FK_Movimiento_TipoMovimiento]
GO
ALTER TABLE [dbo].[MovimientoXDeduccion]  WITH CHECK ADD FOREIGN KEY([idMovimiento])
REFERENCES [dbo].[Movimiento] ([id])
GO
ALTER TABLE [dbo].[MovimientoXDeduccion]  WITH CHECK ADD FOREIGN KEY([idTipoDeduccion])
REFERENCES [dbo].[TipoDeduccion] ([id])
GO
ALTER TABLE [dbo].[MovimientoXHora]  WITH CHECK ADD FOREIGN KEY([idMovimiento])
REFERENCES [dbo].[Movimiento] ([id])
GO
ALTER TABLE [dbo].[MovimientoXHora]  WITH CHECK ADD FOREIGN KEY([idRegistroAsistencia])
REFERENCES [dbo].[RegistroAsistencia] ([id])
GO
ALTER TABLE [dbo].[PlanillaMes]  WITH CHECK ADD  CONSTRAINT [FK_PlanillaMes_Empleado] FOREIGN KEY([idEmpleado])
REFERENCES [dbo].[Empleado] ([id])
GO
ALTER TABLE [dbo].[PlanillaMes] CHECK CONSTRAINT [FK_PlanillaMes_Empleado]
GO
ALTER TABLE [dbo].[PlanillaMes]  WITH CHECK ADD  CONSTRAINT [FK_PlanillaMes_Mes] FOREIGN KEY([idMes])
REFERENCES [dbo].[Mes] ([id])
GO
ALTER TABLE [dbo].[PlanillaMes] CHECK CONSTRAINT [FK_PlanillaMes_Mes]
GO
ALTER TABLE [dbo].[PlanillaSemanal]  WITH CHECK ADD  CONSTRAINT [FK_PlanillaSemanal_Empleado] FOREIGN KEY([idEmpleado])
REFERENCES [dbo].[Empleado] ([id])
GO
ALTER TABLE [dbo].[PlanillaSemanal] CHECK CONSTRAINT [FK_PlanillaSemanal_Empleado]
GO
ALTER TABLE [dbo].[PlanillaSemanal]  WITH CHECK ADD  CONSTRAINT [FK_PlanillaSemanal_Semana] FOREIGN KEY([idSemana])
REFERENCES [dbo].[Semana] ([id])
GO
ALTER TABLE [dbo].[PlanillaSemanal] CHECK CONSTRAINT [FK_PlanillaSemanal_Semana]
GO
ALTER TABLE [dbo].[RegistroAsistencia]  WITH CHECK ADD FOREIGN KEY([idEmpleado])
REFERENCES [dbo].[Empleado] ([id])
GO
ALTER TABLE [dbo].[RegistroAsistencia]  WITH CHECK ADD FOREIGN KEY([idEmpleado])
REFERENCES [dbo].[Empleado] ([id])
GO
ALTER TABLE [dbo].[RegistroAsistencia]  WITH CHECK ADD FOREIGN KEY([idTipoJornada])
REFERENCES [dbo].[TipoJornada] ([id])
GO
ALTER TABLE [dbo].[RegistroAsistencia]  WITH CHECK ADD FOREIGN KEY([idTipoJornada])
REFERENCES [dbo].[TipoJornada] ([id])
GO
/****** Object:  StoredProcedure [dbo].[ConsultarDeduccionesAsignadasEmpleado]    Script Date: 6/23/2025 5:19:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[ConsultarDeduccionesAsignadasEmpleado]
    @inIdEmpleado INT,
    @outCodigoError INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        SET @outCodigoError = 0;

        IF @inIdEmpleado IS NULL OR NOT EXISTS (SELECT 1 FROM dbo.Empleado WHERE id = @inIdEmpleado)
        BEGIN
            SET @outCodigoError = 60011; -- Empleado no existe
            RETURN;
        END;

        SELECT 
            IdEmpleado,
            NombreEmpleado,
            IdTipoDeduccion,
            NombreDeduccion,
            ValorDeduccion,
            Obligatorio,
            Porcentual
        FROM dbo.VistaEmpleadoDeducciones
        WHERE IdEmpleado = @inIdEmpleado;
    END TRY
    BEGIN CATCH
        SET @outCodigoError = 50009;
        INSERT INTO dbo.DBError
        VALUES (
            SUSER_NAME(),
            ERROR_NUMBER(),
            ERROR_STATE(),
            ERROR_SEVERITY(),
            ERROR_LINE(),
            ERROR_PROCEDURE(),
            ERROR_MESSAGE(),
            GETDATE()
        );
    END CATCH
    SET NOCOUNT OFF;
END
GO
/****** Object:  StoredProcedure [dbo].[ConsultarDeduccionesMensual]    Script Date: 6/23/2025 5:19:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ConsultarDeduccionesMensual]
    @inIdPlanillaMensual INT,
    @outCodigoError INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        SET @outCodigoError = 0;

        IF NOT EXISTS(SELECT 1 FROM dbo.DetalleDeduccionMensual WHERE idPlanillaMes = @inIdPlanillaMensual)
        BEGIN
            SET @outCodigoError = 50011; 
            RETURN;
        END;

        IF (@inIdPlanillaMensual IS NULL)
        BEGIN
            SET @outCodigoError = 50012; 
            RETURN;
        END;

        IF @outCodigoError = 0
        BEGIN
            SELECT 
                DDM.id,
                DDM.idPlanillaMes,
                DDM.idTipoDeduccion,
                TD.Nombre AS NombreTipoDeduccion,
                DDM.Porcentaje,
                DDM.Monto
            FROM dbo.DetalleDeduccionMensual DDM
            INNER JOIN dbo.TipoDeduccion TD ON TD.id = DDM.idTipoDeduccion
            WHERE DDM.idPlanillaMes = @inIdPlanillaMensual
            ORDER BY TD.Nombre;
        END;
    END TRY

    BEGIN CATCH
        SET @outCodigoError = 50008;


        INSERT INTO dbo.DBError
        VALUES ( SUSER_NAME(),
                 ERROR_NUMBER(),
                 ERROR_STATE(),
                 ERROR_SEVERITY(),
                 ERROR_LINE(),
                 ERROR_PROCEDURE(),
                 ERROR_MESSAGE(),
                 GETDATE()
        );
    END CATCH;

    SET NOCOUNT OFF;
END;
GO
/****** Object:  StoredProcedure [dbo].[ConsultarDeduccionesSemanal]    Script Date: 6/23/2025 5:19:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ConsultarDeduccionesSemanal]
    @inIdPlanillaSemanal INT,
    @outCodigoError INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        SET @outCodigoError = 0;

        IF NOT EXISTS(SELECT 1 FROM dbo.DetalleDeduccionSemanal WHERE idPlanillaSemanal = @inIdPlanillaSemanal)
        BEGIN
            SET @outCodigoError = 50011;
            RETURN;
        END;

        IF (@inIdPlanillaSemanal IS NULL)
        BEGIN
            SET @outCodigoError = 50012; 
            RETURN;
        END;

        IF @outCodigoError = 0
        BEGIN
            SELECT 
                DDS.id,
                DDS.idPlanillaSemanal,
                DDS.idTipoDeduccion,
                TD.Nombre AS NombreTipoDeduccion,
                DDS.Porcentaje,
                DDS.Monto
            FROM dbo.DetalleDeduccionSemanal DDS
            INNER JOIN dbo.TipoDeduccion TD ON TD.id = DDS.idTipoDeduccion
            WHERE DDS.idPlanillaSemanal = @inIdPlanillaSemanal
            ORDER BY TD.Nombre;
        END;
    END TRY

    BEGIN CATCH
        SET @outCodigoError = 50008;
  

        INSERT INTO dbo.DBError
        VALUES ( SUSER_NAME(),
                 ERROR_NUMBER(),
                 ERROR_STATE(),
                 ERROR_SEVERITY(),
                 ERROR_LINE(),
                 ERROR_PROCEDURE(),
                 ERROR_MESSAGE(),
                 GETDATE()
        );
    END CATCH;

    SET NOCOUNT OFF;
END;
GO
/****** Object:  StoredProcedure [dbo].[ConsultarMovimientos]    Script Date: 6/23/2025 5:19:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ConsultarMovimientos] 
    @inIdPlanilla INT,
    @outCodigoError INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY

        SET @outCodigoError = 0;

        IF NOT EXISTS(SELECT 1 FROM dbo.PlanillaSemanal)
        BEGIN
            SET @outCodigoError = 50011;
            RETURN;
        END;

        IF (@inIdPlanilla IS NULL)
        BEGIN
            SET @outCodigoError = 50012;
            RETURN;
        END;

        IF @outCodigoError = 0
        BEGIN
            DECLARE @Movimientos TABLE (
                id INT,
                idEmpleado INT,
                idTipoMovimiento INT,
                NombreTipoMovimiento VARCHAR(100),
                Fecha DATE,
                CantidadHoras INT,
                Monto MONEY,
                idPlanillaSemanal INT,
                idRegistroAsistencia INT,
                HoraEntrada TIME,
                HoraSalida TIME,
                Dia VARCHAR(20)
            );

            INSERT INTO @Movimientos
            SELECT 
                M.id,
                M.idEmpleado,
                M.idTipoMovimiento,
                TM.Nombre, 
                RA.Fecha,
                M.CantidadHoras,
                M.Monto,
                M.idPlanillaSemanal,
                MH.idRegistroAsistencia,
                RA.HoraEntrada,
                RA.HoraSalida,
                RA.Dia
            FROM dbo.Movimiento M
            INNER JOIN MovimientoXHora MH ON MH.idMovimiento = M.id
            INNER JOIN dbo.RegistroAsistencia RA ON RA.id = MH.idRegistroAsistencia
            INNER JOIN dbo.TipoMovimiento TM ON TM.id = M.idTipoMovimiento
            WHERE M.idPlanillaSemanal = @inIdPlanilla;

            -- Retornar todos los movimientos clasificados por día
            SELECT 
                M.id,
                M.idEmpleado,
                M.idTipoMovimiento,
                M.Fecha,
                M.CantidadHoras,
                M.Monto,
                M.idPlanillaSemanal,
				M.idRegistroAsistencia,
                M.HoraEntrada,
                M.HoraSalida,
				M.Dia,
				M.NombreTipoMovimiento
            FROM @Movimientos M
            ORDER BY 
                CASE M.Dia
                    WHEN 'Viernes' THEN 1
                    WHEN 'Sábado' THEN 2
                    WHEN 'Domingo' THEN 3
                    WHEN 'Lunes' THEN 4
                    WHEN 'Martes' THEN 5
                    WHEN 'Miércoles' THEN 6
                    WHEN 'Jueves' THEN 7
                    ELSE 8
                END,
                M.HoraEntrada;
        END;
    END TRY

    BEGIN CATCH
        SET @outCodigoError = 50008;

        INSERT INTO dbo.DBError
        VALUES ( SUSER_NAME(),
                 ERROR_NUMBER(),
                 ERROR_STATE(),
                 ERROR_SEVERITY(),
                 ERROR_LINE(),
                 ERROR_PROCEDURE(),
                 ERROR_MESSAGE(),
                 GETDATE()
        );
    END CATCH;

    SET NOCOUNT OFF;
END;
GO
/****** Object:  StoredProcedure [dbo].[ConsultarMovimientosPorDeduccion]    Script Date: 6/23/2025 5:19:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ConsultarMovimientosPorDeduccion]
    @inIdPlanilla INT,
    @inIdTipoDeduccion INT,
    @outCodigoError INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        SET @outCodigoError = 0;

        -- Validaciones
        IF @inIdPlanilla IS NULL OR @inIdTipoDeduccion IS NULL
        BEGIN
            SET @outCodigoError = 60012;
            RETURN;
        END;

        IF NOT EXISTS(SELECT 1 FROM dbo.PlanillaSemanal WHERE id = @inIdPlanilla)
        BEGIN
            SET @outCodigoError = 60011;
            RETURN;
        END;

        IF NOT EXISTS(SELECT 1 FROM dbo.TipoDeduccion WHERE id = @inIdTipoDeduccion)
        BEGIN
            SET @outCodigoError = 60011; -- Nuevo código para tipo deducción no existe
            RETURN;
        END;

        -- Consulta de movimientos por tipo de deducción
        SELECT 
            M.id AS idMovimiento,
            M.idEmpleado,
            E.Nombre AS NombreEmpleado,
            M.idTipoMovimiento,
            TM.Nombre AS NombreTipoMovimiento,
            CONVERT(DECIMAL(18,3), M.Monto) AS Monto,
            TD.Nombre AS NombreDeduccion,
            TD.Porcentual,
           CONVERT(DECIMAL(18,3), TD.Valor) AS PorcentajeDeduccion 
        FROM dbo.Movimiento M
        INNER JOIN dbo.MovimientoXDeduccion MXD ON MXD.idMovimiento = M.id
        INNER JOIN dbo.TipoDeduccion TD ON TD.id = MXD.idTipoDeduccion
        INNER JOIN dbo.TipoMovimiento TM ON TM.id = M.idTipoMovimiento
        INNER JOIN dbo.Empleado E ON E.id = M.idEmpleado
        WHERE 
            M.idPlanillaSemanal = @inIdPlanilla
            AND MXD.idTipoDeduccion = @inIdTipoDeduccion
        ORDER BY M.Fecha, M.idEmpleado;

    END TRY
    BEGIN CATCH
        SET @outCodigoError = 50008;
        INSERT INTO dbo.DBError
        VALUES (
            SUSER_NAME(),
            ERROR_NUMBER(),
            ERROR_STATE(),
            ERROR_SEVERITY(),
            ERROR_LINE(),
            ERROR_PROCEDURE(),
            ERROR_MESSAGE(),
            GETDATE()
        );
    END CATCH

    SET NOCOUNT OFF;
END;
GO
/****** Object:  StoredProcedure [dbo].[ConsultarMovimientosPorPlanillaMensualYTipo]    Script Date: 6/23/2025 5:19:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[ConsultarMovimientosPorPlanillaMensualYTipo]
    @inIdPlanillaMensual INT,
    @inIdTipoDeduccion INT,
    @inIdEmpleado INT, 
    @outCodigoError INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        SET @outCodigoError = 0;

        -- Validaciones básicas
        IF @inIdPlanillaMensual IS NULL OR @inIdTipoDeduccion IS NULL
        BEGIN
            SET @outCodigoError = 60012; -- Parámetros nulos
            RETURN;
        END;

        -- Verificar existencia de la planilla
        IF NOT EXISTS (SELECT 1 FROM dbo.PlanillaMes WHERE id = @inIdPlanillaMensual)
        BEGIN
            SET @outCodigoError = 60011; -- Planilla no existe
            RETURN;
        END;

        -- Verificar existencia del tipo de deducción
        IF NOT EXISTS (SELECT 1 FROM dbo.TipoDeduccion WHERE id = @inIdTipoDeduccion)
        BEGIN
            SET @outCodigoError = 60013; -- Tipo deducción no existe
            RETURN;
        END;

        -- Verificar existencia del empleado (si se especificó)
        IF @inIdEmpleado IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.Empleado WHERE id = @inIdEmpleado)
        BEGIN
            SET @outCodigoError = 60014; -- Empleado no existe
            RETURN;
        END;

        -- Obtener rango de fechas del mes asociado
        DECLARE @fechaInicio DATE, @fechaFin DATE;
        
        SELECT 
            @fechaInicio = M.FechaInicio,
            @fechaFin = M.FechaFin
        FROM dbo.PlanillaMes PM
        INNER JOIN dbo.Mes M ON PM.idMes = M.id
        WHERE PM.id = @inIdPlanillaMensual;

        -- Consulta principal con filtros
        SELECT 
            MV.id AS idMovimiento,
            MV.idEmpleado,
            E.Nombre AS NombreEmpleado,
            MV.idTipoMovimiento,
            TM.Nombre AS NombreTipoMovimiento,
            CONVERT(DECIMAL(18,3), MV.Monto) AS Monto,
            TD.Nombre AS NombreDeduccion,
            TD.Porcentual,
            CONVERT(DECIMAL(18,3), TD.Valor) AS PorcentajeDeduccion,
            PM.id AS IdPlanillaMensual
        FROM dbo.Movimiento MV
        INNER JOIN dbo.MovimientoXDeduccion MXD ON MXD.idMovimiento = MV.id
        INNER JOIN dbo.TipoDeduccion TD ON TD.id = MXD.idTipoDeduccion
        INNER JOIN dbo.TipoMovimiento TM ON TM.id = MV.idTipoMovimiento
        INNER JOIN dbo.Empleado E ON E.id = MV.idEmpleado
        INNER JOIN dbo.PlanillaMes PM ON PM.id = @inIdPlanillaMensual
        INNER JOIN dbo.Mes ME ON PM.idMes = ME.id
        WHERE 
            MV.Fecha BETWEEN @fechaInicio AND @fechaFin
            AND MXD.idTipoDeduccion = @inIdTipoDeduccion
            AND MV.idEmpleado = @inIdEmpleado 
        ORDER BY 
            MV.Fecha,
            E.Nombre;
    END TRY
    BEGIN CATCH
        SET @outCodigoError = 50008;
        INSERT INTO dbo.DBError
        VALUES (
            SUSER_NAME(),
            ERROR_NUMBER(),
            ERROR_STATE(),
            ERROR_SEVERITY(),
            ERROR_LINE(),
            ERROR_PROCEDURE(),
            ERROR_MESSAGE(),
            GETDATE()
        );
    END CATCH

    SET NOCOUNT OFF;
END;
GO
/****** Object:  StoredProcedure [dbo].[ConsultarPlanillaMensual]    Script Date: 6/23/2025 5:19:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ConsultarPlanillaMensual] 
    @inIdEmpleado INT,
    @inIdPostByUser INT,
    @inPostInIP varchar(32),
    @inPostTime DATETIME,
    @outCodigoError INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY

        SET @outCodigoError = 0;
        -- Variables para fechas
        DECLARE @FechaInicioP DATE, @FechaFinP DATE;

        /*Se verifica que la tabla no esté vacía*/
        IF NOT EXISTS(SELECT 1 FROM dbo.PlanillaMes)
        BEGIN
            SET @outCodigoError = 50011;
            RETURN;
        END;

        /*Se verifica que no haya valores nulos*/
        IF (@inIdEmpleado IS NULL OR @inIdPostByUser IS NULL OR @inPostInIP IS NULL OR @inPostTime IS NULL)
        BEGIN
            SET @outCodigoError = 50012;
            RETURN;
        END;

        IF @outCodigoError = 0
        BEGIN
            -- Declarar tabla variable para guardar las últimas planillas mensuales
            DECLARE @UltimasPlanillas TABLE (
                id INT,
                idEmpleado INT,
                idMes INT,
                SalarioBruto MONEY,
                SalarioNeto MONEY,
                TotalDeducciones MONEY,
                FechaInicio DATE,
                FechaFin DATE
            );

            -- Insertar las últimas 12 planillas mensuales en la tabla variable
            INSERT INTO @UltimasPlanillas
            SELECT TOP 13
                P.id,
                P.idEmpleado,
                P.idMes,
                P.SalarioBruto,
                P.SalarioNeto,
                P.TotalDeducciones,
                M.FechaInicio,
                M.FechaFin
            FROM dbo.PlanillaMes P
            INNER JOIN dbo.Mes M ON M.id = P.idMes
            WHERE P.idEmpleado = @inIdEmpleado
            ORDER BY M.FechaInicio DESC;

			-- Eliminar la fila con la fecha de inicio más reciente (más alta)
			DELETE FROM @UltimasPlanillas
			WHERE FechaInicio = (SELECT MAX(FechaInicio) FROM @UltimasPlanillas);

            -- Asignar fechas usando SELECT INTO variables
            SELECT
                @FechaInicioP = MIN(FechaInicio),
                @FechaFinP = MAX(FechaFin)
            FROM @UltimasPlanillas;

            -- Insertar en EventoLog
            INSERT INTO dbo.EventoLog(idTipoEvento, Descripcion, idPostByUser, PostInIP, PostTime)
            VALUES(
                11,
                CONCAT('Empleado: ', @inIdEmpleado, ', Fecha Inicio: ', CONVERT(varchar(10), @FechaInicioP, 120), ' Fecha Fin: ', CONVERT(varchar(10), @FechaFinP, 120)),
                @inIdPostByUser,
                @inPostInIP,
                @inPostTime
            );

            -- Retornar las planillas mensuales desde la tabla variable
            SELECT 
                id,
                idEmpleado,
                idMes,
                SalarioBruto,
                SalarioNeto,
                TotalDeducciones,
				FechaInicio,
				FechaFin
            FROM @UltimasPlanillas;
        END;
    END TRY

    BEGIN CATCH
        SET @outCodigoError = 50008;


        INSERT INTO dbo.DBError
        VALUES ( SUSER_NAME(),
                 ERROR_NUMBER(),
                 ERROR_STATE(),
                 ERROR_SEVERITY(),
                 ERROR_LINE(),
                 ERROR_PROCEDURE(),
                 ERROR_MESSAGE(),
                 GETDATE()
        );
    END CATCH;

    SET NOCOUNT OFF;
END;
GO
/****** Object:  StoredProcedure [dbo].[ConsultarPlanillaSemanal]    Script Date: 6/23/2025 5:19:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ConsultarPlanillaSemanal] 
    @inIdEmpleado INT,
    @inIdPostByUser INT,
    @inPostInIP varchar(32),
    @inPostTime DATETIME,
    @outCodigoError INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY

        SET @outCodigoError = 0;
        -- Variables para fechas
        DECLARE @FechaInicioP DATE, @FechaFinP DATE;

        /*Se verifica que la tabla no esté vacía*/
        IF NOT EXISTS(SELECT 1 FROM dbo.PlanillaSemanal)
        BEGIN
            SET @outCodigoError = 50011;
            RETURN;
        END;

        /*Se verifica que no haya valores nulos*/
        IF (@inIdEmpleado IS NULL OR @inIdPostByUser IS NULL OR @inPostInIP IS NULL OR @inPostTime IS NULL)
        BEGIN
            SET @outCodigoError = 50012;
            RETURN;
        END;

        IF @outCodigoError = 0
        BEGIN
            -- Declarar tabla variable para guardar las últimas planillas
            DECLARE @UltimasPlanillas TABLE (
                id INT,
                idEmpleado INT,
                idSemana INT,
                HorasOrdinarias DECIMAL(5,2),
                HorasExtra DECIMAL(5,2),
                HorasExtraDoble DECIMAL(5,2),
                SalarioBruto MONEY,
                SalarioNeto MONEY,
                TotalDeducciones MONEY,
                FechaInicio DATE,
                FechaFin DATE
            );

            -- Insertar las últimas 15 planillas en la tabla variable
            INSERT INTO @UltimasPlanillas
			SELECT TOP 16 
				P.id,
				P.idEmpleado,
				P.idSemana,
				P.HorasOrdinarias,
				P.HorasExtra,
				P.HorasExtraDoble,
				P.SalarioBruto,
				P.SalarioNeto,
				P.TotalDeducciones,
				S.FechaInicio,
				S.FechaFin
			FROM dbo.PlanillaSemanal P
			INNER JOIN dbo.Semana S ON S.id = P.idSemana
			WHERE P.idEmpleado = @inIdEmpleado
			ORDER BY S.FechaInicio DESC;

			-- Eliminar la fila con la fecha de inicio más reciente (más alta)
			DELETE FROM @UltimasPlanillas
			WHERE FechaInicio = (SELECT MAX(FechaInicio) FROM @UltimasPlanillas);

            -- Asignar fechas usando SELECT INTO variables
            SELECT
                @FechaInicioP = MIN(FechaInicio),
                @FechaFinP = MAX(FechaFin)
            FROM @UltimasPlanillas;

            -- Insertar en EventoLog
            INSERT INTO dbo.EventoLog(idTipoEvento, Descripcion, idPostByUser, PostInIP, PostTime)
            VALUES(
                10,
                CONCAT('Empleado: ', @inIdEmpleado, ', Fecha Inicio: ', CONVERT(varchar(10), @FechaInicioP, 120), ' Fecha Fin: ', CONVERT(varchar(10), @FechaFinP, 120)),
                @inIdPostByUser,
                @inPostInIP,
                @inPostTime
            );

            -- Retornar las planillas desde la tabla variable
            SELECT 
                id,
                idEmpleado,
                idSemana,
                HorasOrdinarias,
                HorasExtra,
                HorasExtraDoble,
                SalarioBruto,
                SalarioNeto,
                TotalDeducciones,
				FechaInicio,
				FechaFin
            FROM @UltimasPlanillas;
        END;
    END TRY

    BEGIN CATCH
        SET @outCodigoError = 50008;


        INSERT INTO dbo.DBError
        VALUES ( SUSER_NAME(),
                 ERROR_NUMBER(),
                 ERROR_STATE(),
                 ERROR_SEVERITY(),
                 ERROR_LINE(),
                 ERROR_PROCEDURE(),
                 ERROR_MESSAGE(),
                 GETDATE()
        );
    END CATCH;

    SET NOCOUNT OFF;
END;
GO
/****** Object:  StoredProcedure [dbo].[ConsultarRegistroAsistencia]    Script Date: 6/23/2025 5:19:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ConsultarRegistroAsistencia] 
    @inIdRegistroAsistencia INT,
    @outCodigoError INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY

        SET @outCodigoError = 0;

        IF NOT EXISTS(SELECT 1 FROM dbo.PlanillaSemanal)
        BEGIN
            SET @outCodigoError = 50011;
            RETURN;
        END;

        IF (@inIdRegistroAsistencia IS NULL)
        BEGIN
            SET @outCodigoError = 50012;
            RETURN;
        END;

        IF @outCodigoError = 0
        BEGIN
            DECLARE @Movimientos TABLE (
                id INT,
                idEmpleado INT,
                idTipoJornada INT,
                NombreTipoJornada VARCHAR(100),
				InicioJornada TIME,
				FinJornada TIME,
                Fecha DATE,
                HoraEntrada TIME,
                HoraSalida TIME,
				HorasOrdinarias DECIMAL(5,2),
				HorasExtra DECIMAL(5,2),
                Dia VARCHAR(20),
				Feriado VARCHAR(50)
            );

			INSERT INTO @Movimientos
			SELECT 
				RA.id,
				RA.idEmpleado,
				RA.idTipoJornada,
				J.Nombre,
				J.HoraInicio,
				J.HoraFin,
				RA.Fecha,
				RA.HoraEntrada,
				RA.HoraSalida,
				RA.HorasOrdinarias,
				RA.HorasExtra,
				RA.Dia,
				ISNULL(F.Nombre, 'Ninguno') AS Feriado
			FROM dbo.RegistroAsistencia RA
			INNER JOIN dbo.TipoJornada J ON J.id = RA.idTipoJornada
			LEFT JOIN dbo.Feriado F ON F.Fecha = RA.Fecha
			WHERE RA.id = @inIdRegistroAsistencia;

            -- Retornar todos los movimientos clasificados por día
            SELECT 
                M.id,
				M.idEmpleado,
				M.idTipoJornada,
				M.NombreTipoJornada,
				M.InicioJornada,
				M.FinJornada,
				M.Fecha,
				M.HoraEntrada,
				M.HoraSalida,
				M.HorasOrdinarias,
				M.HorasExtra,
				M.Dia,
				M.Feriado
            FROM @Movimientos M
        END;
    END TRY

    BEGIN CATCH
        SET @outCodigoError = 50008;
        

        INSERT INTO dbo.DBError
        VALUES ( SUSER_NAME(),
                 ERROR_NUMBER(),
                 ERROR_STATE(),
                 ERROR_SEVERITY(),
                 ERROR_LINE(),
                 ERROR_PROCEDURE(),
                 ERROR_MESSAGE(),
                 GETDATE()
        );
    END CATCH;

    SET NOCOUNT OFF;
END;
GO
/****** Object:  StoredProcedure [dbo].[EditarEmpleado]    Script Date: 6/23/2025 5:19:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[EditarEmpleado]
				@inIdPostByUser INT
				, @inPostInIP varchar(32)
				, @inPostTime DATETIME
                , @inId int
				, @inIdPuesto int
                , @inIdDepartamento int
				, @inIdTipoDocumento int
                , @inNombre varchar(128)
                , @inValorDocumento varchar(128)
                , @inFechaNacimiento date
                , @outCodigoError INT OUTPUT
AS
BEGIN
SET NOCOUNT ON;

    BEGIN TRY

        SET @outCodigoError = 0;

            /*Validaciones*/
			IF(@inIdPostByUser IS NULL)
				BEGIN
					SET @outCodigoError = 50012;
					RETURN;
				END;

			IF(@inPostInIP IS NULL)
				BEGIN
					SET @outCodigoError = 50012;
					RETURN;
				END;

			IF(@inPostTime  IS NULL)
				BEGIN
					SET @outCodigoError = 50012;
					RETURN;
				END;

            IF(@inId IS NULL)
            BEGIN
                SET @outCodigoError = 50012;
                RETURN;
            END;

            IF(@inNombre IS NULL)
            BEGIN
                SET @outCodigoError = 50012;
                RETURN;
            END;

            IF(@inIdTipoDocumento IS NULL)
            BEGIN
                SET @outCodigoError = 50012;
                RETURN;
            END;

            IF(@inValorDocumento IS NULL)
            BEGIN
                SET @outCodigoError = 50012;
                RETURN;
            END;

            IF(@inFechaNacimiento IS NULL)
            BEGIN
                SET @outCodigoError = 50012;
                RETURN;
            END;

            IF(@inIdPuesto IS NULL)
            BEGIN
                SET @outCodigoError = 50012;
                RETURN;
            END;

            IF(@inIdDepartamento IS NULL)
            BEGIN
                SET @outCodigoError = 50012;
                RETURN;
            END;

            /*Validación de documento repetido*/
            IF EXISTS(SELECT 1 
                      FROM dbo.Empleado E 
                      WHERE E.ValorDocumento = @inValorDocumento
                      AND E.id <> @inId)
            BEGIN
                SET @outCodigoError = 50006;
                RETURN;
            END;

            /*Validación de nombre repetido*/
            IF EXISTS(SELECT 1 
                      FROM dbo.Empleado E 
                      WHERE E.Nombre = @inNombre
                      AND E.id <> @inId)
            BEGIN
                SET @outCodigoError = 50007;
                RETURN;
            END;


		BEGIN TRANSACTION
        /*Actualiza Empleado*/
        IF(@outCodigoError = 0)
		/*Trazabilidad: Se inserta en EventoLog*/
		INSERT INTO dbo.EventoLog(idTipoEvento, Descripcion, idPostByUser, PostInIP, PostTime)
		SELECT 7, CONCAT('Antes: ', E.Nombre, E.idPuesto, E.idDepartamento, E.idTipoDocumento, E.ValorDocumento, E.FechaNacimiento, '. Despues: ', @inNombre, @inIdPuesto, @inIdDepartamento, @inIdTipoDocumento, @inValorDocumento, @inFechaNacimiento), @inIdPostByUser, @inPostInIP, @inPostTime
		FROM dbo.Empleado E
		WHERE E.id = @inId;

        BEGIN
            UPDATE dbo.Empleado 
            SET Nombre = @inNombre
                , idPuesto = @inIdPuesto
                , idDepartamento = @inIdDepartamento
                , idTipoDocumento = @inIdTipoDocumento
                , ValorDocumento = @inValorDocumento
                , FechaNacimiento = @inFechaNacimiento
            WHERE id = @inId;
        END;
		COMMIT

    END TRY

    BEGIN CATCH

        SET @outCodigoError = 50008;
		

		IF @@TRANCOUNT>0
				ROLLBACK

                INSERT INTO dbo.DBError
                VALUES ( SUSER_NAME()
                        , ERROR_NUMBER()
                        , ERROR_STATE()
                        , ERROR_SEVERITY()
                        , ERROR_LINE()
                        , ERROR_PROCEDURE()
                        , ERROR_MESSAGE()
                        , GETDATE()
                        );

    END CATCH;

    SET NOCOUNT OFF;
END;
GO
/****** Object:  StoredProcedure [dbo].[EliminarEmpleado]    Script Date: 6/23/2025 5:19:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[EliminarEmpleado]
			    @inIdPostByUser INT
				, @inPostInIP varchar(32)
				, @inPostTime DATETIME
				, @inId int
				, @outCodigoError INT OUTPUT
AS
BEGIN
SET NOCOUNT ON; /*El usuario no debe ver errores*/

	BEGIN TRY /*Se hace try-catch*/

		SET @outCodigoError = 0; /*No hay errores se pone 0*/

			/*Validaciones*/
			/*Se revisa que no haya valores nulos*/
			IF(@inIdPostByUser IS NULL)
				BEGIN
					SET @outCodigoError = 50002;
					RETURN;
				END;

			IF(@inPostInIP IS NULL)
				BEGIN
					SET @outCodigoError = 50002;
					RETURN;
				END;

			IF(@inPostTime  IS NULL)
				BEGIN
					SET @outCodigoError = 50002;
					RETURN;
				END;

			/*id no debe ser null*/
			IF(@inId IS NULL)
				BEGIN
					SET @outCodigoError = 50002;
					RETURN;
				END;


		BEGIN TRANSACTION
		/*Actualiza Empleado*/
		IF(@outCodigoError = 0)
		BEGIN
			UPDATE dbo.Empleado 
			SET Activo = 0
			WHERE id = @inId;
		END;

		/*Trazabilidad: Se inserta en EventoLog*/
		INSERT INTO dbo.EventoLog(idTipoEvento, Descripcion, idPostByUser, PostInIP, PostTime)
		SELECT 6, CONCAT('ID: ', E.id, 'Nombre: ', E.Nombre, 'FechaNac: ', E.FechaNacimiento, 'IDPuesto: ', E.idPuesto, 'IDDepartamento: ', E.idDepartamento, 'IDTipoDoc: ', E.idTipoDocumento, 'Doc: ', E.ValorDocumento, 'IDUsuario: ', E.idUsuario), @inIdPostByUser, @inPostInIP, @inPostTime
		FROM dbo.Empleado E

		COMMIT

	END TRY

	BEGIN CATCH

		SET @outCodigoError = 50005; /*En caso de error de sistema*/

		IF @@TRANCOUNT>0
				ROLLBACK

				INSERT INTO dbo.DBError
				VALUES ( SUSER_NAME()
						, ERROR_NUMBER()
						, ERROR_STATE()
						, ERROR_SEVERITY()
						, ERROR_LINE()
						, ERROR_PROCEDURE()
						, ERROR_MESSAGE()
						, GETDATE()
						);

	END CATCH;

	SET NOCOUNT OFF; /*Se vuelven a mostrar errores*/
END;
GO
/****** Object:  StoredProcedure [dbo].[FiltrarEmpleados]    Script Date: 6/23/2025 5:19:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[FiltrarEmpleados] 
			    @inIdPostByUser INT
				, @inPostInIP varchar(32)
				, @inPostTime DATETIME
				, @inBusqueda varchar(128)
				, @inTipo INT
				, @outCodigoError INT OUTPUT
AS
BEGIN
SET NOCOUNT ON;

	BEGIN TRY

		SET @outCodigoError = 0;

		/*Se verifica que la tabla no esté vacía*/
		IF NOT EXISTS(SELECT 1 
					FROM dbo.Empleado E)
			BEGIN
				SET @outCodigoError = 50011;
				RETURN;
			END;

		/*Se revisa que no haya valores nulos*/
		IF(@inIdPostByUser IS NULL)
			BEGIN
				SET @outCodigoError = 50012;
				RETURN;
			END;

		IF(@inPostInIP IS NULL)
			BEGIN
				SET @outCodigoError = 50012;
				RETURN;
			END;

		IF(@inPostTime  IS NULL)
			BEGIN
				SET @outCodigoError = 50012;
				RETURN;
			END;

		IF(@inTipo IS NULL)
			BEGIN
				SET @outCodigoError = 50012;
				RETURN;
			END;

		IF(@inBusqueda IS NULL)
			BEGIN
				SET @outCodigoError = 50012;
				RETURN;
			END;



		/*Se hace select del nombre y puesto*/
		IF(@outCodigoError = 0)
		BEGIN

		/*Trazabilidad: Se inserta en EventoLog*/
		INSERT INTO dbo.EventoLog(idTipoEvento, Descripcion, idPostByUser, PostInIP, PostTime)
		VALUES(4, CONCAT('Filtro buscado: ', @inBusqueda), @inIdPostByUser, @inPostInIP, @inPostTime)

			SELECT E.id
					, E.idPuesto
					, E.idDepartamento
					, E.idTipoDocumento
					, E.Nombre
					, E.ValorDocumento
					, E.FechaNacimiento
					, E.idUsuario
					, P.Nombre
			FROM dbo.Empleado E
			INNER JOIN dbo.Puesto P ON E.idPuesto = P.id
			WHERE 
				((@inTipo = 1 AND E.Nombre LIKE '%' + @inBusqueda + '%')
				OR
				(@inTipo = 2 AND E.ValorDocumento LIKE '%' + @inBusqueda + '%'))
				AND E.Activo = 1;
		END;

	END TRY

	BEGIN CATCH

		SET @outCodigoError = 50008;

				INSERT INTO dbo.DBError
				VALUES ( SUSER_NAME()
						, ERROR_NUMBER()
						, ERROR_STATE()
						, ERROR_SEVERITY()
						, ERROR_LINE()
						, ERROR_PROCEDURE()
						, ERROR_MESSAGE()
						, GETDATE()
						);

	END CATCH;

	SET NOCOUNT OFF;
END;
GO
/****** Object:  StoredProcedure [dbo].[InsertarBitacora]    Script Date: 6/23/2025 5:19:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Helena Vargas>
-- Create date: <16-05-25>
-- Description:	<Stored procedure que inserta el event log>
-- =============================================
CREATE PROCEDURE [dbo].[InsertarBitacora]
				@inIdTipoEvento INT
				, @inDescripcion varchar(max)
				, @inIdPostByUser INT
				, @inPostInIP varchar(32)
				, @inPostTime DATETIME
				, @outCodigoError INT OUTPUT
AS
BEGIN
SET NOCOUNT ON; /*El usuario no debe ver errores*/

	BEGIN TRY /*Se hace try-catch*/

		SET @outCodigoError = 0; /*No hay errores se pone 0*/

			/*Validaciones*/

			/*idTipoEvento no debe ser null*/
			IF(@inIdTipoEvento IS NULL)
			BEGIN
				SET @outCodigoError = 50012;  /*Error: No puso un idTipoEvento.*/
				RETURN;
			END;


			/*Docmuento Identidad no debe ser null*/
			IF(@inDescripcion IS NULL)
			BEGIN
				SET @inDescripcion = '';
			END;


			/*IdPostByUser no debe ser null*/
			IF(@inIdPostByUser IS NULL)
			BEGIN
				SET @outCodigoError = 50012;  /*Error: No puso un IdPostByUser.*/
				RETURN;
			END;


			/*inPostInIp no debe ser null*/
			IF(@inPostInIP IS NULL)
			BEGIN
				SET @outCodigoError = 50012;  /*Error: No puso un PostInIp.*/
				RETURN;
			END;

			/*PostTime no debe ser null*/
			IF(@inPostTime IS NULL)
			BEGIN
				SET @outCodigoError = 50012;  /*Error: No puso un PostTime.*/
				RETURN;
			END;


		/*Inserta Evento*/
		IF(@outCodigoError = 0)
		BEGIN
			INSERT INTO dbo.EventoLog(idTipoEvento
									  , Descripcion
									  , idPostByUser
									  , PostInIp
									  , PostTime)	
			VALUES (@inIdTipoEvento
					, @inDescripcion
					, @inIdPostByUser
					, @inPostInIp
					, @inPostTime)
		END;


	END TRY

	BEGIN CATCH

		SET @outCodigoError = 50008; /*En caso de error de sistema*/

				INSERT INTO dbo.DBError
				VALUES ( SUSER_NAME()
						, ERROR_NUMBER()
						, ERROR_STATE()
						, ERROR_SEVERITY()
						, ERROR_LINE()
						, ERROR_PROCEDURE()
						, ERROR_MESSAGE()
						, GETDATE()
						);

	END CATCH;

	SET NOCOUNT OFF; /*Se vuelven a mostrar errores*/
END;

GO
/****** Object:  StoredProcedure [dbo].[InsertarEmpleado]    Script Date: 6/23/2025 5:19:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertarEmpleado]
@inIdPostByUser INT
				, @inPostInIP varchar(32)
				, @inPostTime DATETIME
				, @inIdPuesto int
                , @inIdDepartamento int
				, @inIdTipoDocumento int
                , @inNombre varchar(128)
                , @inValorDocumento varchar(128)
                , @inFechaNacimiento date
                , @outCodigoError INT OUTPUT
AS
BEGIN
SET NOCOUNT ON;

    BEGIN TRY
		DECLARE @id int;

        SET @outCodigoError = 0;

             /*Validaciones*/
			IF(@inIdPostByUser IS NULL)
				BEGIN
					SET @outCodigoError = 50012;
					RETURN;
				END;

			IF(@inPostInIP IS NULL)
				BEGIN
					SET @outCodigoError = 50012;
					RETURN;
				END;

			IF(@inPostTime  IS NULL)
				BEGIN
					SET @outCodigoError = 50012;
					RETURN;
				END;

            IF(@inNombre IS NULL)
            BEGIN
                SET @outCodigoError = 50012;
                RETURN;
            END;

			-- Validar que nombre solo tiene letras (incluye tildes), espacios y guiones
			IF @inNombre COLLATE Latin1_General_BIN LIKE '%[^A-Za-zÁÉÍÓÚáéíóúÑñ -]%'
			BEGIN
				SET @outCodigoError = 50009; 
				RETURN;
			END

            IF(@inIdTipoDocumento IS NULL)
            BEGIN
                SET @outCodigoError = 50012;
                RETURN;
            END;

            IF(@inValorDocumento IS NULL)
            BEGIN
                SET @outCodigoError = 50012;
                RETURN;
            END;
			IF @inValorDocumento COLLATE Latin1_General_BIN LIKE '%[^0-9-]%'
			BEGIN
				SET @outCodigoError = 50010; 
				RETURN;
			END

            IF(@inFechaNacimiento IS NULL)
            BEGIN
                SET @outCodigoError = 50012;
                RETURN;
            END;

            IF(@inIdPuesto IS NULL)
            BEGIN
                SET @outCodigoError = 50012;
                RETURN;
            END;

            IF(@inIdDepartamento IS NULL)
            BEGIN
                SET @outCodigoError = 50012;
                RETURN;
            END;

			BEGIN TRANSACTION 
            /*Validación de documento repetido*/
            IF EXISTS(SELECT 1 
                      FROM dbo.Empleado E 
                      WHERE E.ValorDocumento = @inValorDocumento)
            BEGIN
                DECLARE @estadoActual BIT;
                SELECT TOP 1 @estadoActual = E.Activo
                FROM dbo.Empleado E
                WHERE E.ValorDocumento = @inValorDocumento;

                IF (@estadoActual = 1)
                BEGIN
                    SET @outCodigoError = 50004;
                    RETURN;
                END
                ELSE
                BEGIN
                    UPDATE dbo.Empleado
                    SET Nombre = @inNombre
                        , idTipoDocumento = @inIdTipoDocumento
                        , idPuesto = @inIdPuesto
                        , idDepartamento = @inIdDepartamento
                        , FechaNacimiento = @inFechaNacimiento
                        , Activo = 1
                    WHERE ValorDocumento = @inValorDocumento;

                    RETURN;
                END
            END;

            /*Validación de nombre repetido*/
            IF EXISTS(SELECT 1 
                      FROM dbo.Empleado E 
                      WHERE E.Nombre = @inNombre)
            BEGIN
                DECLARE @estadoActual2 BIT;
                SELECT TOP 1 @estadoActual2 = E.Activo
                FROM dbo.Empleado E
                WHERE E.Nombre = @inNombre;

                IF (@estadoActual2 = 1)
                BEGIN
                    SET @outCodigoError = 50005;
                    RETURN;
                END
                ELSE
                BEGIN
                    UPDATE dbo.Empleado
                    SET Nombre = @inNombre
                        , idTipoDocumento = @inIdTipoDocumento
                        , ValorDocumento = @inValorDocumento
                        , idPuesto = @inIdPuesto
                        , idDepartamento = @inIdDepartamento
                        , FechaNacimiento = @inFechaNacimiento
                        , Activo = 1
                    WHERE Nombre = @inNombre;

                    RETURN;
                END
            END;

        /*Inserta Empleado*/
        IF(@outCodigoError = 0)
        BEGIN

		-- Crear un nuevo usuario aitomaticamente
		DECLARE @UsernameBase VARCHAR(128) = LOWER(REPLACE(@inNombre, ' ', ''));
		DECLARE @Username VARCHAR(128) = @UsernameBase;
		DECLARE @contador INT = 1;

		WHILE EXISTS (SELECT 1 FROM dbo.Usuario WHERE Username = @Username)
		BEGIN
		SET @Username = CONCAT(@UsernameBase, @contador);
		SET @contador += 1;
		END

		-- Insertar usuario
		DECLARE @Password VARCHAR(50) = '1234';

		INSERT INTO dbo.Usuario (Username, Password, Tipo)
		VALUES (@Username, @Password, 2);
		DECLARE @idUsuario INT = SCOPE_IDENTITY();

            INSERT INTO dbo.Empleado (
                idPuesto,
                idDepartamento,
                idTipoDocumento,
                Nombre,
                ValorDocumento,
                FechaNacimiento,
				idUsuario,
                Activo
            )    
            SELECT
                @inIdPuesto,
                @inIdDepartamento,
                @inIdTipoDocumento,
                @inNombre,
                @inValorDocumento,
                @inFechaNacimiento,
				@idUsuario,
                1
        END;

		SET @id=SCOPE_IDENTITY();

		/*Trazabilidad: Se inserta en EventoLog*/
		INSERT INTO dbo.EventoLog(idTipoEvento, Descripcion, idPostByUser, PostInIP, PostTime)
		SELECT 5, CONCAT('Nuevo Empleado: ', E.id, E.Nombre, E.idPuesto, E.idDepartamento, E.idTipoDocumento, E.ValorDocumento, E.FechaNacimiento), @inIdPostByUser, @inPostInIP, @inPostTime
		FROM dbo.Empleado E
		WHERE E.id = @id

		COMMIT

    END TRY

    BEGIN CATCH

        SET @outCodigoError = 50008;

		IF @@TRANCOUNT>0
				ROLLBACK

                INSERT INTO dbo.DBError
                VALUES ( SUSER_NAME()
                        , ERROR_NUMBER()
                        , ERROR_STATE()
                        , ERROR_SEVERITY()
                        , ERROR_LINE()
                        , ERROR_PROCEDURE()
                        , ERROR_MESSAGE()
                        , GETDATE()
                        );

    END CATCH;

    SET NOCOUNT OFF;
END;
GO
/****** Object:  StoredProcedure [dbo].[ListarDepartamentos]    Script Date: 6/23/2025 5:19:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ListarDepartamentos] 
				@outCodigoError INT OUTPUT
AS
BEGIN
SET NOCOUNT ON; /*El usuario NO debe ver el mensaje de error y la fila*/

	BEGIN TRY /*Se hace try-catch*/

		SET @outCodigoError = 0; /*No hay errores*/

		/*La tabla está vacía*/
		IF NOT EXISTS(SELECT 1 
					FROM dbo.Departamento D)
			BEGIN
				SET @outCodigoError = 50011; /*Error: La tabla está vacía*/
				RETURN;
			END;



		/*Listar puestos*/
		IF(@outCodigoError = 0)
		BEGIN
			SELECT D.[id]
					,D.[Nombre]
			FROM dbo.Departamento D 
		END;

	END TRY

	BEGIN CATCH

		SET @outCodigoError = 50008;/*En caso de error de sistema*/

				INSERT INTO dbo.DBError
				VALUES ( SUSER_NAME()
						, ERROR_NUMBER()
						, ERROR_STATE()
						, ERROR_SEVERITY()
						, ERROR_LINE()
						, ERROR_PROCEDURE()
						, ERROR_MESSAGE()
						, GETDATE()
						);

	END CATCH;

	SET NOCOUNT OFF;
END;
GO
/****** Object:  StoredProcedure [dbo].[ListarEmpleados]    Script Date: 6/23/2025 5:19:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ListarEmpleados] 
			    @inIdPostByUser INT
				, @inPostInIP varchar(32)
				, @inPostTime DATETIME
				, @outCodigoError INT OUTPUT
AS
BEGIN
SET NOCOUNT ON;

	BEGIN TRY

		SET @outCodigoError = 0;

		/*Se verifica que la tabla no esté vacía*/
		IF NOT EXISTS(SELECT 1 
					FROM dbo.Empleado E)
			BEGIN
				SET @outCodigoError = 50011;
				RETURN;
			END;

		/*Se verifica que no haya valores nulos*/
		IF(@inIdPostByUser IS NULL)
			BEGIN
				SET @outCodigoError = 50012;
				RETURN;
			END;

		IF(@inPostInIP IS NULL)
			BEGIN
				SET @outCodigoError = 50012;
				RETURN;
			END;

		IF(@inPostTime  IS NULL)
			BEGIN
				SET @outCodigoError = 50012;
				RETURN;
			END;

		/*Se hace select del nombre y puesto*/
		IF(@outCodigoError = 0)
		BEGIN
		/*Trazabilidad: Se inserta en EventoLog*/
		INSERT INTO dbo.EventoLog(idTipoEvento, Descripcion, idPostByUser, PostInIP, PostTime)
		VALUES(3, '', @inIdPostByUser, @inPostInIP, @inPostTime)


			SELECT E.id
					, E.idPuesto
					, E.idDepartamento
					, E.idTipoDocumento
					, E.Nombre
					, E.ValorDocumento
					, E.FechaNacimiento
					, E.idUsuario
					, P.Nombre
			FROM dbo.Empleado E
			INNER JOIN dbo.Puesto P ON E.idPuesto = P.id
			WHERE E.Activo = 1;
		END;

	END TRY

	BEGIN CATCH

		SET @outCodigoError = 50008;

				INSERT INTO dbo.DBError
				VALUES ( SUSER_NAME()
						, ERROR_NUMBER()
						, ERROR_STATE()
						, ERROR_SEVERITY()
						, ERROR_LINE()
						, ERROR_PROCEDURE()
						, ERROR_MESSAGE()
						, GETDATE()
						);

	END CATCH;

	SET NOCOUNT OFF;
END;
GO
/****** Object:  StoredProcedure [dbo].[ListarPuestos]    Script Date: 6/23/2025 5:19:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ListarPuestos] 
				@outCodigoError INT OUTPUT
AS
BEGIN
SET NOCOUNT ON; /*El usuario NO debe ver el mensaje de error y la fila*/

	BEGIN TRY /*Se hace try-catch*/

		SET @outCodigoError = 0; /*No hay errores*/

		/*La tabla está vacía*/
		IF NOT EXISTS(SELECT 1 
					FROM dbo.Puesto P)
			BEGIN
				SET @outCodigoError = 50011; /*Error: La tabla está vacía*/
				RETURN;
			END;



		/*Listar puestos*/
		IF(@outCodigoError = 0)
		BEGIN
			SELECT P.[id]
					,P.[Nombre]
					,P.[SalarioxHora]
			FROM dbo.Puesto P 
		END;

	END TRY

	BEGIN CATCH

		SET @outCodigoError = 50008;/*En caso de error de sistema*/

				INSERT INTO dbo.DBError
				VALUES ( SUSER_NAME()
						, ERROR_NUMBER()
						, ERROR_STATE()
						, ERROR_SEVERITY()
						, ERROR_LINE()
						, ERROR_PROCEDURE()
						, ERROR_MESSAGE()
						, GETDATE()
						);

	END CATCH;

	SET NOCOUNT OFF;
END;
GO
/****** Object:  StoredProcedure [dbo].[ListarTipoDocIds]    Script Date: 6/23/2025 5:19:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ListarTipoDocIds] 
				@outCodigoError INT OUTPUT
AS
BEGIN
SET NOCOUNT ON; /*El usuario NO debe ver el mensaje de error y la fila*/

	BEGIN TRY /*Se hace try-catch*/

		SET @outCodigoError = 0; /*No hay errores*/

		/*La tabla está vacía*/
		IF NOT EXISTS(SELECT 1 
					FROM dbo.TipoDocumentoIdentidad TD)
			BEGIN
				SET @outCodigoError = 50011; /*Error: La tabla está vacía*/
				RETURN;
			END;



		/*Listar puestos*/
		IF(@outCodigoError = 0)
		BEGIN
			SELECT TD.[id]
					,TD.[Nombre]
			FROM dbo.TipoDocumentoIdentidad TD
		END;

	END TRY

	BEGIN CATCH

		SET @outCodigoError = 50008;/*En caso de error de sistema*/

				INSERT INTO dbo.DBError
				VALUES ( SUSER_NAME()
						, ERROR_NUMBER()
						, ERROR_STATE()
						, ERROR_SEVERITY()
						, ERROR_LINE()
						, ERROR_PROCEDURE()
						, ERROR_MESSAGE()
						, GETDATE()
						);

	END CATCH;

	SET NOCOUNT OFF;
END;
GO
/****** Object:  StoredProcedure [dbo].[ManejarError]    Script Date: 6/23/2025 5:19:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Helena Vargas>
-- Create date: <21/06/25>
-- Description:	<Ingresa codigo devuelve mensaje error>
-- =============================================
CREATE PROCEDURE [dbo].[ManejarError] 
			@inCodigoError INT
			, @outCodigoError INT OUTPUT
AS
BEGIN
SET NOCOUNT ON
BEGIN TRY /*Se hace try-catch*/

		SET @outCodigoError = 0; /*No hay errores*/

		/*La tabla está vacía*/
		IF NOT EXISTS(SELECT 1 
					FROM dbo.ERROR E)
			BEGIN
				SET @outCodigoError = 50011; /*Error: La tabla está vacía*/
				RETURN;
			END;

		/*Se verifica que no haya valores nulos*/
		IF(@inCodigoError IS NULL)
			BEGIN
				SET @outCodigoError = 50012;
				RETURN;
			END;

		/*Obtener error*/
		IF(@outCodigoError = 0)
		BEGIN
			SELECT E.[Descripcion]
			FROM dbo.Error E
			WHERE E.Codigo = @inCodigoError
		END;

	END TRY

	BEGIN CATCH

		SET @outCodigoError = 50008;/*En caso de error de sistema*/

				INSERT INTO dbo.DBError
				VALUES ( SUSER_NAME()
						, ERROR_NUMBER()
						, ERROR_STATE()
						, ERROR_SEVERITY()
						, ERROR_LINE()
						, ERROR_PROCEDURE()
						, ERROR_MESSAGE()
						, GETDATE()
						);

	END CATCH;

	SET NOCOUNT OFF;
END;
GO
/****** Object:  StoredProcedure [dbo].[VerificarUsuario]    Script Date: 6/23/2025 5:19:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[VerificarUsuario] 
			    @inIdPostByUser INT
				, @inPostInIP varchar(32)
				, @inPostTime DATETIME
				, @inUsername varchar(128)
				, @inPassword varchar(128)
				, @outCodigoError INT OUTPUT
AS
BEGIN
SET NOCOUNT ON; /*El usuario NO debe ver el mensaje de error y la fila*/

	BEGIN TRY /*Se hace try-catch*/

		SET @outCodigoError = 0; /*No hay errores*/

		/*La tabla está vacía*/
		IF NOT EXISTS(SELECT 1 
					FROM dbo.Usuario U)
			BEGIN
				SET @outCodigoError = 50011;
				RETURN;
			END;

		/*Se verifica que no haya valores nulos*/
		IF(@inIdPostByUser IS NULL)
			BEGIN
				SET @outCodigoError = 50012;
				RETURN;
			END;

		IF(@inPostInIP IS NULL)
			BEGIN
				SET @outCodigoError = 50012;
				RETURN;
			END;

		IF(@inPostTime  IS NULL)
			BEGIN
				SET @outCodigoError = 50012;
				RETURN;
			END;

		IF(@inUsername IS NULL)
			BEGIN
				SET @outCodigoError = 50012;
				RETURN;
			END;

		IF(@inPassword IS NULL)
			BEGIN
				SET @outCodigoError = 50012;
				RETURN;
			END;


		IF EXISTS (SELECT 1 FROM dbo.Usuario U WHERE U.Username = @inUsername)
		BEGIN
			IF EXISTS (SELECT 1 FROM dbo.Usuario U WHERE U.Username = @inUsername AND U.Password = @inPassword)
			BEGIN
			
				/*Trazabilidad: Se inserta en EventoLog*/
				INSERT INTO dbo.EventoLog(idTipoEvento, Descripcion, idPostByUser, PostInIP, PostTime)
				SELECT 1, CONCAT(@inUsername, 'Resultado: Exitoso'), U.id, @inPostInIP, @inPostTime
				FROM dbo.Usuario U 
				WHERE U.Username = @inUsername 
				AND U.Password = @inPassword


				/*Select Usuario*/
				IF(@outCodigoError = 0)
				BEGIN
					SELECT U.id
						   , U.Username
						   , U.Password
						   , U.Tipo
					FROM dbo.Usuario U 
					WHERE U.Username = @inUsername 
					AND U.Password = @inPassword
				END;
			END
			ELSE
			BEGIN
				INSERT INTO dbo.EventoLog(idTipoEvento, Descripcion, idPostByUser, PostInIP, PostTime)
				VALUES(1, CONCAT(@inUsername, 'Resultado: NO Exitoso, Password Incorrecto'), 5, @inPostInIP, @inPostTime)

				SET @outCodigoError = 50002;
				RETURN;
			END
		END
		ELSE
		BEGIN
			INSERT INTO dbo.EventoLog(idTipoEvento, Descripcion, idPostByUser, PostInIP, PostTime)
			VALUES(1, CONCAT(@inUsername, 'Resultado: NO Exitoso, Username no existe'), 5, @inPostInIP, @inPostTime)

				SET @outCodigoError = 50001;
			RETURN;
		END

		

	END TRY

	BEGIN CATCH

		SET @outCodigoError = 50008;/*En caso de error de sistema*/


				INSERT INTO dbo.DBError
				VALUES ( SUSER_NAME()
						, ERROR_NUMBER()
						, ERROR_STATE()
						, ERROR_SEVERITY()
						, ERROR_LINE()
						, ERROR_PROCEDURE()
						, ERROR_MESSAGE()
						, GETDATE()
						);

	END CATCH;

	SET NOCOUNT OFF;
END;
GO
USE [master]
GO
ALTER DATABASE [Tarea3] SET  READ_WRITE 
GO
