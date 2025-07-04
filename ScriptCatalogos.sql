USE [Tarea3]
GO
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		DECLARE @lo INT = 1
			, @hi INT
			, @idEmpleado int
			, @Nombre varchar(128)
			, @IdTipoDocumento int
			, @ValorDocumento varchar(128)
			, @FechaNacimiento date
			, @IdDepartamento int
			, @IdPuesto int
			, @idUsuario int
			, @Activo bit

	-- Verifica que las tabla este vacia antes de cargar los datos
    IF EXISTS (SELECT 1 FROM dbo.Empleado)
   

		--Lee el xml y lo carga en xmlData
		DECLARE @xmlData XML

		SET @xmlData = (
			SELECT *
			FROM OPENROWSET (BULK 'C:\Users\HP\OneDrive\Documentos\GitHub\Tarea-3\catalogos.xml', SINGLE_BLOB)
			AS xmlData
		)


			--Se cargan tablas variable

			--Tabla Variable Tipo Doc Id
			DECLARE @TablaTipoDocId TABLE (Id INT
										, Nombre varchar(128))
			INSERT @TablaTipoDocId (Id
										, Nombre)

			SELECT ref.value('(@Id)[1]' , 'int')
					, ref.value('(@Nombre)[1]' , 'varchar(128)')

			FROM @xmlData.nodes('/Catalogo/TiposdeDocumentodeIdentidad/TipoDocuIdentidad') 
			AS xmlData(ref)


			--Tabla Variable Tipo Jornada
			DECLARE @TablaTipoJornada TABLE (Id INT
										, Nombre varchar(128)
										, HoraInicio time
										, HoraFin time)
			INSERT @TablaTipoJornada (Id
									, Nombre
									, HoraInicio
									, HoraFin)

			SELECT ref.value('(@Id)[1]' , 'int')
					, ref.value('(@Nombre)[1]' , 'varchar(128)')
					, ref.value('(@HoraInicio)[1]' , 'time')
					, ref.value('(@HoraFin)[1]' , 'time')

			FROM @xmlData.nodes('/Catalogo/TiposDeJornada/TipoDeJornada') 
			AS xmlData(ref)


			--Tabla Variable Puesto
			DECLARE @TablaPuesto TABLE (Sec int identity(1,1)
										, Nombre varchar(128)
										, SalarioxHora money)
			INSERT @TablaPuesto (Nombre
								, SalarioxHora)

			SELECT ref.value('(@Nombre)[1]', 'varchar(128)')
				   , ref.value('(@SalarioXHora)[1]' , 'money')

			FROM @xmlData.nodes('/Catalogo/Puestos/Puesto') 
			AS xmlData(ref)

			--Tabla Variable Departamento
			DECLARE @TablaDepartamento TABLE (Id INT
										, Nombre varchar(128))
			INSERT @TablaDepartamento (Id
									   , Nombre)

			SELECT ref.value('(@Id)[1]' , 'int')
					, ref.value('(@Nombre )[1]' , 'varchar(128)')

			FROM @xmlData.nodes('/Catalogo/Departamentos/Departamento') 
			AS xmlData(ref)


			--Tabla Variable Feriados
			DECLARE @TablaFeriado TABLE (Id INT 
										 , Nombre varchar(128)
										 , Fecha date)
			INSERT @TablaFeriado (Id
								  , Nombre
								  , Fecha)

			SELECT ref.value('(@Id)[1]', 'int')
				   , ref.value('(@Nombre)[1]', 'varchar(128)')
				   , ref.value('(@Fecha)[1]', 'date')

			FROM @xmlData.nodes('/Catalogo/Feriados/Feriado') 
			AS xmlData(ref)

			--SELECT '@TablaFeriado' AS Tabla, * FROM @TablaFeriado;

			--Tabla Variable Tipo Movimiento
			DECLARE @TablaTipoMovimiento TABLE (Id int
												, Nombre varchar(128))
			INSERT @TablaTipoMovimiento (Id
										, Nombre)

			SELECT ref.value('(@Id)[1]', 'int')
				   , ref.value('(@Nombre)[1]', 'varchar(128)')

			FROM @xmlData.nodes('/Catalogo/TiposDeMovimiento/TipoDeMovimiento') 
			AS xmlData(ref)


			--Tabla Variable Tipo Deduccion
			DECLARE @TablaTipoDeduccion TABLE (Id int
												, Nombre varchar(128)
												, Obligatorio varchar(128)
												, Porcentual varchar(128)
												, Valor REAL)
			INSERT @TablaTipoDeduccion (Id
										, Nombre
										, Obligatorio
										, Porcentual
										, Valor)

			SELECT ref.value('(@Id)[1]', 'int')
				   , ref.value('(@Nombre)[1]', 'varchar(128)')
				   , ref.value('(@Obligatorio)[1]', 'varchar(128)')
				   , ref.value('(@Porcentual)[1]', 'varchar(128)')
				   , ref.value('(@Valor)[1]', 'Real')

			FROM @xmlData.nodes('/Catalogo/TiposDeDeduccion/TipoDeDeduccion') 
			AS xmlData(ref)


			--Tabla Variable Error
			DECLARE @Error TABLE (Sec int identity(1,1)
								, Codigo int
								, Descripcion varchar(MAX))
			INSERT @Error (Codigo
							, Descripcion)

			SELECT ref.value('(@Codigo)[1]', 'int')
				   , ref.value('(@Descripcion)[1]', 'varchar(128)')

			FROM @xmlData.nodes('/Catalogo/Errores/Error') 
			AS xmlData(ref)


			--Tabla Variable Usuario
			DECLARE @TablaUsuario TABLE (Id int
										, Username varchar(128)
										, Password varchar(128)
										, Tipo int)
			INSERT @TablaUsuario (Id
								, Username
								, Password
								, Tipo)

			SELECT ref.value('(@Id)[1]', 'int')
				   , ref.value('(@Username)[1]', 'varchar(128)')
				   , ref.value('(@Password)[1]', 'varchar(128)')
				   , ref.value('(@Tipo)[1]', 'int')

			FROM @xmlData.nodes('/Catalogo/Usuarios/Usuario') 
			AS xmlData(ref)


			--Tabla Variable TipoEvento
			DECLARE @TablaTipoEvento TABLE (Id int
											, Nombre varchar(128))
			INSERT @TablaTipoEvento (Id
									, Nombre)

			SELECT ref.value('(@Id)[1]', 'int')
				   , ref.value('(@Nombre)[1]', 'varchar(128)')

			FROM @xmlData.nodes('/Catalogo/TiposdeEvento/TipoEvento') 
			AS xmlData(ref)


			--Tabla Variable Empleado
			DECLARE @TablaEmpleado TABLE (Sec int identity (1,1)
										, Nombre varchar(128)
										, IdTipoDocumentoIdentidad int
										, ValorDocumentoIdentidad varchar(128)
										, FechaNacimiento date
										, IdDepartamento int
										, NombrePuesto varchar(128)
										, idUsuario varchar(128)
										, Activo bit)
			INSERT @TablaEmpleado (Nombre
									, IdTipoDocumentoIdentidad 
									, ValorDocumentoIdentidad
									, FechaNacimiento
									, IdDepartamento
									, NombrePuesto
									, idUsuario
									, Activo)

			SELECT ref.value('(@Nombre)[1]' , 'varchar(128)')
					, ref.value('(@IdTipoDocumento)[1]' , 'int')
					, ref.value('(@ValorDocumento)[1]' , 'varchar(128)')
					, ref.value('(@FechaNacimiento)[1]' , 'date')
					, ref.value('(@IdDepartamento)[1]' , 'int')
					, ref.value('(@NombrePuesto)[1]' , 'varchar(128)')
					, ref.value('(@IdUsuario)[1]' , 'int')
					, ref.value('(@Activo)[1]' , 'bit')

			FROM @xmlData.nodes('/Catalogo/Empleados/Empleado') 
			AS xmlData(ref)

			SELECT @hi = @@ROWCOUNT

		BEGIN
			BEGIN TRANSACTION tablas

			--Tabla Tipo Doc Id
			INSERT INTO dbo.TipoDocumentoIdentidad(id
										, Nombre)

			SELECT TD.Id
					, TD.Nombre

			FROM @TablaTipoDocId TD


			--Tabla Tipo Jornada
			INSERT dbo.TipoJornada (id
									, Nombre
									, HoraInicio
									, HoraFin)

			SELECT TJ.Id
				, TJ.Nombre
				, TJ.HoraInicio
				, TJ.HoraFin

			FROM @TablaTipoJornada TJ


			--Tabla Puesto
			INSERT INTO [dbo].[Puesto](Nombre
									   , SalarioxHora)
			SELECT P.Nombre
				   , P.SalarioxHora
			FROM @TablaPuesto P

			--Tabla Departamento
			INSERT dbo.Departamento (id
									   , Nombre)

			SELECT D.Id
					, D.Nombre

			FROM @TablaDepartamento D
			
			--Tabla Feriados
			INSERT dbo.Feriado(id
								, Nombre
								, Fecha)

			SELECT F.Id
					, F.Nombre
					, F.Fecha

			FROM @TablaFeriado F

			--Tabla Tipo Movimiento
			INSERT dbo.TipoMovimiento (id
										, Nombre)

			SELECT TM.Id
					, TM.Nombre

			FROM @TablaTipoMovimiento TM


			--Tabla Tipo Deduccion
			INSERT dbo.TipoDeduccion (id
										, Nombre
										, Obligatorio
										, Porcentual
										, Valor)
			SELECT TDE.Id
					, TDE.Nombre
					, CASE
						WHEN TDE.Obligatorio = 'Si'
						THEN 1
						WHEN TDE.Obligatorio = 'No'
						THEN 0
					END
					, CASE
						WHEN TDE.Porcentual = 'Si'
						THEN 1
						WHEN TDE.Porcentual = 'No'
						THEN 0
					END
					, TDE.Valor

			FROM @TablaTipoDeduccion TDE

			--Error
			INSERT INTO dbo.Error(id
								,Codigo
								, Descripcion)

			SELECT ER.Sec
					, ER.Codigo
					, ER.Descripcion

			FROM @Error ER

			--Tabla Usuario
			INSERT dbo.Usuario (Username
								, Password
								, Tipo
								)

			SELECT U.Username
				   , U.Password
				   , U.Tipo


			FROM @TablaUsuario U

			--Tabla TipoEvento
			INSERT dbo.TipoEvento (Id
									, Nombre)

			SELECT TE.id
					, TE.Nombre

			FROM @TablaTipoEvento TE

		WHILE @lo <= @hi
		BEGIN
			SELECT
				  @Nombre = TE.Nombre
				, @IdTipoDocumento = TE.IdTipoDocumentoIdentidad
				, @ValorDocumento = TE.ValorDocumentoIdentidad
				, @FechaNacimiento = TE.FechaNacimiento
				, @IdDepartamento = TE.IdDepartamento
				, @idUsuario = TE.idUsuario
				, @Activo = TE.Activo
			FROM @TablaEmpleado TE
			WHERE TE.Sec = @lo;
    
			SELECT @IdPuesto = P.id
			FROM dbo.Puesto P
			WHERE P.Nombre = (SELECT E.NombrePuesto 
							 FROM @TablaEmpleado E 
							 WHERE Sec = @lo);
    
			-- Insertar empleado
			INSERT INTO [dbo].[Empleado] (
				 Nombre
				, idTipoDocumento
				, ValorDocumento
				, FechaNacimiento
				, idDepartamento
				, idPuesto
				, idUsuario
				, Activo
			)
			VALUES (
				 @Nombre
				, @IdTipoDocumento
				, @ValorDocumento
				, @FechaNacimiento
				, @IdDepartamento
				, @IdPuesto
				, @idUsuario
				, @Activo
			);


			SET @lo = @lo + 1;
		END

	COMMIT TRANSACTION tablas
	END

	END TRY
	BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK;


		INSERT INTO dbo.DBError
				VALUES ( SUSER_NAME()
						, ERROR_NUMBER()
						, ERROR_STATE()
						, ERROR_SEVERITY()
						, ERROR_LINE()
						, 0
						, ERROR_MESSAGE()
						, GETDATE()
						);

						SELECT 
	'ERROR REGISTRADO:' AS Mensaje,
	SUSER_NAME() AS Usuario,
	ERROR_NUMBER() AS NumeroError,
	ERROR_STATE() AS Estado,
	ERROR_SEVERITY() AS Severidad,
	ERROR_LINE() AS Linea,
	0 AS IdProcedimiento,
	ERROR_MESSAGE() AS Mensaje,
	GETDATE() AS Fecha;


    END CATCH

	SET NOCOUNT OFF;
END
