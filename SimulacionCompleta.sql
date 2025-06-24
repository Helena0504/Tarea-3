USE Tarea3

BEGIN
BEGIN TRY

SET NOCOUNT ON
DECLARE @lo INT = 1
		, @hi INT
		, @FechaOperacion DATE
DECLARE @idMes INT;



-- 1. Leer XML
        DECLARE @xmlData XML;
        SET @xmlData = (
            SELECT *
            FROM OPENROWSET(BULK 'C:\Users\HP\OneDrive\Documentos\GitHub\Tarea-3\operacion.xml', SINGLE_BLOB) 
			AS xmlData
        );

	-- 2. Extraer fechas de operación
        DECLARE @TablaFechas TABLE (Sec INT IDENTITY(1,1)
									, Fecha DATE);

        INSERT INTO @TablaFechas (Fecha)
        SELECT DISTINCT ref.value('@Fecha', 'DATE')
        FROM @xmlData.nodes('/Operacion/FechaOperacion') 
		AS op(ref)

        SET @hi = @@ROWCOUNT; 

		
		DECLARE @QSemanas INT = 0;	




        WHILE @lo <= @hi
        BEGIN
		SELECT @FechaOperacion = Fecha FROM @TablaFechas WHERE Sec = @lo;
		
		IF(@QSemanas = 0)
		BEGIN
			SET @QSemanas = 4
		END


			-- 3. Preprocesar nuevos empleados y empleados eliminados
			--Tabla Variable Nuevos Usuarios
			DECLARE @TablaUsuario TABLE (Sec int identity(1,1)
										, Username varchar(128)
										, Password varchar(128)
										, Tipo int)
			INSERT @TablaUsuario (Username
								, Password
								, Tipo)
			SELECT ref.value('(@Usuario)[1]', 'varchar(128)')
				   , ref.value('(@Password)[1]', 'varchar(128)')
				   , 2

			FROM @xmlData.nodes('/Operacion/FechaOperacion[@Fecha=sql:variable("@FechaOperacion")]') AS fecha(fecha)
			CROSS APPLY fecha.nodes('NuevosEmpleados/NuevoEmpleado') AS sub(ref)



			--Tabla Variable Empleado
			DECLARE @TablaEmpleado TABLE (Sec int identity (1,1)
										, Nombre varchar(128)
										, IdTipoDocumentoIdentidad int
										, ValorDocumentoIdentidad varchar(128)
										, FechaNacimiento date
										, IdDepartamento int
										, NombrePuesto varchar(128)
										, Activo bit)
			INSERT @TablaEmpleado (Nombre
									, IdTipoDocumentoIdentidad 
									, ValorDocumentoIdentidad
									, FechaNacimiento
									, IdDepartamento
									, NombrePuesto
									, Activo)

			SELECT ref.value('(@Nombre)[1]' , 'varchar(128)')
					, ref.value('(@IdTipoDocumento)[1]' , 'int')
					, ref.value('(@ValorTipoDocumento)[1]' , 'varchar(128)')
					, ref.value('(@FechaNacimiento)[1]' , 'date')
					, ref.value('(@IdDepartamento)[1]' , 'int')
					, ref.value('(@NombrePuesto)[1]' , 'varchar(128)')
					, 1

			FROM @xmlData.nodes('/Operacion/FechaOperacion[@Fecha=sql:variable("@FechaOperacion")]') AS fecha(fecha)
			CROSS APPLY fecha.nodes('NuevosEmpleados/NuevoEmpleado') AS sub(ref)

			--Tabla Variable Empleados Eliminados
			DECLARE @TablaEmpleadoEliminado TABLE (Sec int identity (1,1)
										, ValorDocumentoIdentidad varchar(128))
			INSERT @TablaEmpleadoEliminado (ValorDocumentoIdentidad)
			SELECT ref.value('(@ValorTipoDocumento)[1]', 'varchar(128)')

			FROM @xmlData.nodes('/Operacion/FechaOperacion[@Fecha=sql:variable("@FechaOperacion")]') AS fecha(fecha)
			CROSS APPLY fecha.nodes('EliminarEmpleados/EliminarEmpleado') AS sub(ref)


			-- 4. Preprocesar desasociacion y asociacion
			-- Tabla Variable Asociar Deduccion
			DECLARE @TablaDeduccion TABLE (Sec int identity (1,1)
										, idTipoDeduccion int
										, ValorDocumento varchar(128)
										, Monto decimal(10,2)
										, Porcentaje decimal(10,2))
			INSERT @TablaDeduccion (idTipoDeduccion 
									, ValorDocumento
									, Monto
									, Porcentaje)
			SELECT ref.value('(@IdTipoDeduccion)[1]' , 'int')
					, ref.value('(@ValorTipoDocumento)[1]' , 'varchar(128)')
					, ref.value('(@Monto)[1]' , 'decimal(10,2)')
					, TD.Valor
			FROM @xmlData.nodes('/Operacion/FechaOperacion[@Fecha=sql:variable("@FechaOperacion")]') AS fecha(fecha)
			CROSS APPLY fecha.nodes('AsociacionEmpleadoDeducciones/AsociacionEmpleadoConDeduccion') AS sub(ref)
			INNER JOIN dbo.TipoDeduccion TD ON ref.value('(@IdTipoDeduccion)[1]' , 'int') = TD.id

			-- Tabla Variable Desasociar Deducción
			DECLARE @TablaNoDeduccion TABLE (Sec int identity (1,1)
										, idTipoDeduccion int
										, ValorDocumento varchar(128))
			INSERT @TablaNoDeduccion (idTipoDeduccion 
									, ValorDocumento)
			SELECT ref.value('(@IdTipoDeduccion)[1]' , 'int')
					, ref.value('(@ValorTipoDocumento)[1]' , 'varchar(128)')
			FROM @xmlData.nodes('/Operacion/FechaOperacion[@Fecha=sql:variable("@FechaOperacion")]') AS fecha(fecha)
			CROSS APPLY fecha.nodes('DesasociacionEmpleadoDeducciones/DesasociacionEmpleadoConDeduccion') AS sub(ref)



			--5. Preprocesar Jornadas y Marcas de Asistencia
			

			-- Tabla Variable Marcas Asistencia
			DECLARE @TablaMarcasAsistencia TABLE (Sec int identity (1,1)
										, ValorDocumento varchar(128)
										, HoraEntrada datetime
										, HoraSalida datetime)
			INSERT @TablaMarcasAsistencia (ValorDocumento
									, HoraEntrada
									, HoraSalida)
			SELECT ref.value('(@ValorTipoDocumento)[1]' , 'varchar(128)')
					, ref.value('(@HoraEntrada)[1]' , 'datetime')
					, ref.value('(@HoraSalida)[1]' , 'datetime')
			FROM @xmlData.nodes('/Operacion/FechaOperacion[@Fecha=sql:variable("@FechaOperacion")]') AS fecha(fecha)
			CROSS APPLY fecha.nodes('MarcasAsistencia/MarcaDeAsistencia') AS sub(ref)









			DECLARE 
				@Nombre VARCHAR(128) = NULL,
				@IdTipoDocumento INT = 0,
				@ValorDocumento VARCHAR(128) = NULL,
				@FechaNacimiento DATE = NULL,
				@IdDepartamento INT = 0,
				@Activo BIT = 0,
				@Username VARCHAR(128) = NULL,
				@Password VARCHAR(128) = NULL,
				@Tipo INT = 0,
				@UltimoUsuario INT = 0,
				@IdPuesto INT = 0;

			DECLARE @hiE INT, @loE INT
			--Insertar Empleados
			SELECT 
				@hiE = MAX(Sec), 
				@loE = MIN(Sec)
			FROM @TablaEmpleado;

			WHILE @loE <= @hiE
			BEGIN
				SELECT
					  @Nombre = TE.Nombre
					, @IdTipoDocumento = TE.IdTipoDocumentoIdentidad
					, @ValorDocumento = TE.ValorDocumentoIdentidad
					, @FechaNacimiento = TE.FechaNacimiento
					, @IdDepartamento = TE.IdDepartamento
					, @Activo = TE.Activo
				FROM @TablaEmpleado TE
				WHERE TE.Sec = @loE;

				IF NOT EXISTS (
					SELECT 1 
					FROM dbo.Empleado E 
					WHERE E.ValorDocumento = @ValorDocumento
					  AND E.idTipoDocumento = @IdTipoDocumento
				)
				BEGIN
					SELECT
						  @Username = TU.Username
						, @Password = TU.Password
						, @Tipo = TU.Tipo
					FROM @TablaUsuario TU
					WHERE TU.Sec = @loE;

					INSERT INTO dbo.Usuario (Username, Password, Tipo)
					VALUES (@Username, @Password, @Tipo);

					SET @UltimoUsuario = SCOPE_IDENTITY();

					SELECT @IdPuesto = P.Id
					FROM dbo.Puesto P
					WHERE P.Nombre = (SELECT E.NombrePuesto 
									  FROM @TablaEmpleado E 
									  WHERE E.Sec = @loE);
					
					INSERT INTO dbo.Empleado (
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
						, @UltimoUsuario
						, @Activo
					);
				END

				SET @loE = @loE + 1;
			END
			DELETE FROM @TablaUsuario
			DELETE FROM @TablaEmpleado


			--Eliminar Empleados

			UPDATE E
			SET E.Activo = 0
			FROM dbo.Empleado E
			INNER JOIN @TablaEmpleadoEliminado T
			ON E.ValorDocumento = T.ValorDocumentoIdentidad;
		
			DELETE FROM @TablaEmpleadoEliminado



			-- Asociar Deducción
			DECLARE 
				@hiD INT,
				@loD INT,
				@idEmpleado INT,
				@idTipoDeduccion INT,
				@Porcentual BIT,
				@MontoD DECIMAL(10,2); 

			-- Obtener el mínimo y máximo Sec existentes en la tabla
			SELECT 
				@loD = MIN(Sec),
				@hiD = MAX(Sec)
			FROM @TablaDeduccion;

			WHILE @loD <= @hiD
			BEGIN
				-- Obtener datos
				SELECT 
					@idEmpleado = E.id,
					@idTipoDeduccion = TD.idTipoDeduccion,
					@Porcentual = TD.Porcentaje,
					@MontoD = ISNULL(TD.Monto, 0) -- <== Cambiado aquí
				FROM @TablaDeduccion TD
				JOIN dbo.Empleado E ON E.ValorDocumento = TD.ValorDocumento
				WHERE TD.Sec = @loD;

				IF @idEmpleado IS NOT NULL
				BEGIN
					-- Insertar con MontoD si no es porcentual
					IF @Porcentual = 0
					BEGIN
						INSERT INTO dbo.EmpleadoDeduccion (idEmpleado, idTipoDeduccion, Fecha, Monto)
						VALUES (@idEmpleado, @idTipoDeduccion, @FechaOperacion, @MontoD); -- 
					END
					ELSE
					BEGIN
						INSERT INTO dbo.EmpleadoDeduccion (idEmpleado, idTipoDeduccion, Fecha, Monto)
						VALUES (@idEmpleado, @idTipoDeduccion, @FechaOperacion, 0); -- 
					END

					-- Log
					INSERT INTO dbo.EventoLog(idTipoEvento, Descripcion, idPostByUser, PostInIP, PostTime)
					VALUES (
						8,
						CONCAT(@idEmpleado, '-', @idTipoDeduccion, 
						   ' % ', CAST(@Porcentual AS INT),  
						   ' $ ', FORMAT(@MontoD, '0.##')),
						5,
						'25.55.61.33',
						GETDATE()
					);
				END
				SET @loD += 1;
			END
			DELETE FROM @TablaDeduccion
			


			--Desasociar Deduccion
			DECLARE 
				@hiND INT,
				@loND INT;

			-- Obtener el mínimo y máximo Sec reales en la tabla (aunque haya huecos)
			SELECT 
				@loND = MIN(Sec),
				@hiND = MAX(Sec)
			FROM @TablaNoDeduccion;


			WHILE @loND <= @hiND
			BEGIN
				DELETE ED
				FROM dbo.EmpleadoDeduccion ED
				INNER JOIN dbo.Empleado E ON ED.idEmpleado = E.id
				WHERE E.ValorDocumento = (SELECT TD.ValorDocumento 
											FROM @TablaNoDeduccion TD 
											WHERE TD.Sec = @loND)
				  AND ED.idTipoDeduccion = (SELECT TD.idTipoDeduccion 
											FROM @TablaNoDeduccion TD 
											WHERE TD.Sec = @loND)
				  AND ED.Fecha = @FechaOperacion;

				  -- Insertar evento tipo 9
				INSERT INTO dbo.EventoLog(idTipoEvento, Descripcion, idPostByUser, PostInIP, PostTime)
				SELECT 
					9,
					CONCAT(E.id, '-', TD.idTipoDeduccion),
					5,
					'25.55.61.33',
					GETDATE()
				FROM @TablaNoDeduccion TD
				INNER JOIN dbo.Empleado E ON E.ValorDocumento = TD.ValorDocumento
				WHERE TD.Sec = @loND;


				SET @loND += 1;
			END
			DELETE FROM @TablaNoDeduccion


			-- Procesar Marcas de Asistencia
			-- Solo procesar marcas de asistencia que no estén en la tabla de empleados validada
			IF EXISTS (
				SELECT 1
				FROM @TablaMarcasAsistencia MA
				JOIN dbo.Empleado E ON E.ValorDocumento = MA.ValorDocumento
				WHERE NOT EXISTS (
					SELECT 1 FROM @TablaEmpleado TE WHERE TE.ValorDocumentoIdentidad = MA.ValorDocumento
				)
			)
			BEGIN
				INSERT INTO dbo.RegistroAsistencia (
					idEmpleado,
					idTipoJornada,
					Fecha,
					HoraEntrada,
					HoraSalida,
					HorasOrdinarias,
					HorasExtra,
					Dia
				)
				SELECT 
					E.id,                   -- idEmpleado
					J.idTipoJornada,        -- idTipoJornada
					@FechaOperacion,        -- Fecha
					MA.HoraEntrada,         -- HoraEntrada
					MA.HoraSalida,          -- HoraSalida

					-- Cálculo Horas Ordinarias
					CASE 
						WHEN CA.HoraSalidaCompleta <= CA.HoraInicioJornada OR CA.HoraEntradaCompleta >= CA.HoraFinJornada THEN 0
						ELSE FLOOR(
							DATEDIFF(
								MINUTE,
								CASE WHEN CA.HoraEntradaCompleta > CA.HoraInicioJornada THEN CA.HoraEntradaCompleta ELSE CA.HoraInicioJornada END,
								CASE WHEN CA.HoraSalidaCompleta < CA.HoraFinJornada THEN CA.HoraSalidaCompleta ELSE CA.HoraFinJornada END
							) / 60.0
						)
					END AS HorasOrdinarias,

					-- Cálculo Horas Extra
					FLOOR((
						CASE WHEN CA.HoraEntradaCompleta < CA.HoraInicioJornada THEN DATEDIFF(MINUTE, CA.HoraEntradaCompleta, CA.HoraInicioJornada) ELSE 0 END +
						CASE WHEN CA.HoraSalidaCompleta > CA.HoraFinJornada THEN DATEDIFF(MINUTE, CA.HoraFinJornada, CA.HoraSalidaCompleta) ELSE 0 END
					) / 60.0) AS HorasExtra,

					-- Columna Dia con nombre del día en español
					CASE DATENAME(WEEKDAY, @FechaOperacion)
						WHEN 'Monday' THEN 'Lunes'
						WHEN 'Tuesday' THEN 'Martes'
						WHEN 'Wednesday' THEN 'Miércoles'
						WHEN 'Thursday' THEN 'Jueves'
						WHEN 'Friday' THEN 'Viernes'
						WHEN 'Saturday' THEN 'Sábado'
						WHEN 'Sunday' THEN 'Domingo'
					END AS Dia

				FROM @TablaMarcasAsistencia MA
				INNER JOIN dbo.Empleado E ON E.ValorDocumento = MA.ValorDocumento
				INNER JOIN dbo.Jornada J ON J.idEmpleado = E.id
				INNER JOIN dbo.Semana S ON S.id = J.idSemana
				INNER JOIN dbo.TipoJornada TJ ON TJ.Id = J.idTipoJornada

				CROSS APPLY (
					SELECT
						-- Hora inicio jornada (con posible cruce de medianoche)
						CASE 
							WHEN TJ.Id = 3 THEN DATEADD(HOUR, 22, CAST(@FechaOperacion AS DATETIME)) -- 10 PM
							WHEN TJ.Id = 2 THEN DATEADD(HOUR, 14, CAST(@FechaOperacion AS DATETIME)) -- 2 PM
							ELSE DATEADD(HOUR, 6, CAST(@FechaOperacion AS DATETIME))                 -- 6 AM
						END AS HoraInicioJornada,

						-- Hora fin jornada (considerando cruce de medianoche)
						CASE 
							WHEN TJ.Id = 3 THEN DATEADD(DAY, 1, DATEADD(HOUR, 6, CAST(@FechaOperacion AS DATETIME))) -- 6 AM siguiente día
							WHEN TJ.Id = 2 THEN DATEADD(HOUR, 22, CAST(@FechaOperacion AS DATETIME)) -- 10 PM
							ELSE DATEADD(HOUR, 14, CAST(@FechaOperacion AS DATETIME))                -- 2 PM
						END AS HoraFinJornada,

						-- Hora completa de entrada (ajustada para cruce medianoche)
						DATEADD(
							SECOND,
							DATEDIFF(SECOND, 0, CAST(MA.HoraEntrada AS TIME)),
							CAST(CASE 
								WHEN TJ.Id = 3 AND CAST(MA.HoraEntrada AS TIME) < '12:00' THEN DATEADD(DAY, 1, @FechaOperacion)
								ELSE @FechaOperacion
							END AS DATETIME)
						) AS HoraEntradaCompleta,

						-- Hora completa de salida (ajustada para cruce medianoche)
						DATEADD(
							SECOND,
							DATEDIFF(SECOND, 0, CAST(MA.HoraSalida AS TIME)),
							CAST(CASE 
								WHEN CAST(MA.HoraSalida AS TIME) < CAST(MA.HoraEntrada AS TIME) THEN DATEADD(DAY, 1, @FechaOperacion)
								ELSE @FechaOperacion
							END AS DATETIME)
						) AS HoraSalidaCompleta
				) AS CA

				WHERE 
					@FechaOperacion BETWEEN S.FechaInicio AND S.FechaFin
					AND NOT EXISTS (
						SELECT 1 
						FROM @TablaEmpleado TE 
						WHERE TE.ValorDocumentoIdentidad = MA.ValorDocumento
					);

				-- Insertar en EventoLog por cada registro insertado
				INSERT INTO dbo.EventoLog(idTipoEvento, Descripcion, idPostByUser, PostInIP, PostTime)
				SELECT 
					14,
					CONCAT(E.id, ' - Entrada: ', MA.HoraEntrada, ', Salida: ', MA.HoraSalida),
					5,
					'25.55.61.33',
					@FechaOperacion
				FROM @TablaMarcasAsistencia MA
				JOIN dbo.Empleado E ON E.ValorDocumento = MA.ValorDocumento
				WHERE NOT EXISTS (
					SELECT 1 FROM @TablaEmpleado TE WHERE TE.ValorDocumentoIdentidad = MA.ValorDocumento
				);
			END;

			-- Limpiar tabla temporal de marcas para la siguiente operación
			DELETE FROM @TablaMarcasAsistencia;






			--Transaccion Planilla y Movimientos
			IF DATEPART(WEEKDAY, @FechaOperacion) = 5 -- jueves
			BEGIN


				DECLARE @FechaInicioS DATE = NULL;  
				DECLARE @FechaFin DATE = NULL; 
				DECLARE @IdSemana INT = 0


				-- Si Semana está vacía, calcular fechas y agregar una semana
				IF NOT EXISTS (SELECT 1 FROM dbo.Semana)
				BEGIN
					-- Calcular viernes pasado
					SET @FechaFin = @FechaOperacion;
					SET @FechaInicioS = DATEADD(DAY, -((DATEPART(WEEKDAY, @FechaFin) + @@DATEFIRST + 1) % 7 + 1), @FechaFin); -- Viernes anterior

					-- Insertar en Semana
					INSERT INTO dbo.Semana (FechaInicio, FechaFin)
					VALUES (@FechaInicioS, @FechaFin);
				END
				ELSE
				BEGIN
					-- Obtener última semana (suponiendo que ya existe)
					SELECT TOP 1 
						@IdSemana = S.id
						, @FechaInicioS = S.FechaInicio
						, @FechaFin = S.FechaFin
					FROM dbo.Semana S
					ORDER BY S.id DESC;
				END

				-- Obtener ID de la semana que vamos a trabajar (ya insertada o ya existente)
				IF @IdSemana IS NULL
				BEGIN
					SELECT TOP 1 @IdSemana = S.id
					FROM dbo.Semana S
					WHERE S.FechaInicio = @FechaInicioS AND S.FechaFin = @FechaFin;
				END


				BEGIN TRANSACTION;

					-- Obtener FechaInicio de la semana donde @FechaOperacion es FechaFin
					DECLARE @FechaInicio DATE = NULL;
					SELECT TOP 1 @FechaInicio = S.FechaInicio
					FROM dbo.Semana S
					WHERE S.FechaFin = @FechaOperacion;

					-- Tabla de empleados con asistencia esa semana, con SEC para iteración
						DECLARE @EmpleadosSemana TABLE (
							SEC INT IDENTITY(1,1),
							idEmpleado INT 
						);

						INSERT INTO @EmpleadosSemana(idEmpleado)
						SELECT RA.idEmpleado
						FROM dbo.RegistroAsistencia RA
						WHERE RA.Fecha BETWEEN @FechaInicio AND @FechaOperacion
							AND RA.idEmpleado IS NOT NULL
						GROUP BY RA.idEmpleado;



					DECLARE @loM INT, @hiM INT;

					SELECT 
						@loM = MIN(Sec),
						@hiM = MAX(Sec)
					FROM @EmpleadosSemana;

					-- Variables internas por empleado
					DECLARE 
						@idEmpleadoRA INT = 0,
						@idPlanillaSemanal INT = 0,
						@SalarioHora MONEY = 0,
						@HorasOrdinarias DECIMAL(6,2) = 0,
						@HorasExtra DECIMAL(6,2) = 0,
						@Monto DECIMAL(18,2) = 0,
						@idRegistroAsistencia INT = 0,
						@Fecha DATE = NULL,
						@UltimoMovimiento INT = 0;

					WHILE @loM <= @hiM
					BEGIN
						-- Obtener idEmpleado correspondiente al SEC actual
						SELECT @idEmpleadoRA = ES.idEmpleado
						FROM @EmpleadosSemana ES
						WHERE ES.SEC = @loM;

						-- Obtener planilla semanal de ese empleado en esa semana
						SELECT TOP 1 @idPlanillaSemanal = PS.id
						FROM dbo.PlanillaSemanal PS
						INNER JOIN dbo.Semana S ON S.id = PS.idSemana
						WHERE PS.idEmpleado = @idEmpleadoRA 
						AND S.FechaFin = @FechaOperacion;

						-- Obtener salario por hora
						SELECT @SalarioHora = P.SalarioxHora
						FROM dbo.Empleado E
						INNER JOIN dbo.Puesto P ON E.idPuesto = P.id
						WHERE E.id = @idEmpleadoRA;

						-- Registros de asistencia de la semana para este empleado
						DECLARE @Registros TABLE (
							SEC INT IDENTITY(1,1)
							, idRegistroAsistencia INT
							, Fecha DATE
							, HorasOrdinarias DECIMAL(6,2)
							, HorasExtra DECIMAL(6,2)
						);

						INSERT INTO @Registros(idRegistroAsistencia, Fecha, HorasOrdinarias, HorasExtra)
						SELECT RA.id
								, RA.Fecha
								, RA.HorasOrdinarias
								, RA.HorasExtra
						FROM dbo.RegistroAsistencia RA
						WHERE RA.idEmpleado = @idEmpleadoRA 
						AND RA.Fecha BETWEEN @FechaInicio AND @FechaOperacion;


						DECLARE @loRA INT, @hiRA INT;

						SELECT 
							@loRA = MIN(Sec),
							@hiRA = MAX(Sec)
						FROM @Registros;


						WHILE @loRA <= @hiRA
						BEGIN
							SELECT 
								@idRegistroAsistencia = R.idRegistroAsistencia
								, @Fecha = R.Fecha
								, @HorasOrdinarias = R.HorasOrdinarias
								, @HorasExtra = R.HorasExtra
							FROM @Registros R
							WHERE R.SEC = @loRA;

							-- Horas Ordinarias
							SET @Monto = @HorasOrdinarias * @SalarioHora;
							IF @Monto > 0
							BEGIN
								INSERT INTO dbo.Movimiento (idEmpleado
															, idTipoMovimiento
															, Fecha
															, CantidadHoras
															, Monto
															, idPlanillaSemanal)
								VALUES (@idEmpleadoRA
										, 1
										, @FechaOperacion
										, @HorasOrdinarias
										, @Monto
										, @idPlanillaSemanal);

								SET @UltimoMovimiento = SCOPE_IDENTITY();
								INSERT INTO dbo.MovimientoXHora (idMovimiento
																, idRegistroAsistencia)
								VALUES (@UltimoMovimiento
										, @idRegistroAsistencia);
							END



							-- Horas Extra (NO feriado y NO domingo)
							IF NOT EXISTS (SELECT 1 FROM dbo.Feriado F WHERE F.Fecha = @Fecha) AND DATEPART(WEEKDAY, @Fecha) <> 1
							BEGIN
								SET @Monto = @HorasExtra * @SalarioHora * 1.5;
								IF @Monto > 0
								BEGIN
									INSERT INTO dbo.Movimiento (idEmpleado
																, idTipoMovimiento
																, Fecha
																, CantidadHoras
																, Monto
																, idPlanillaSemanal)
									VALUES (@idEmpleadoRA
											, 2
											, @FechaOperacion
											, @HorasExtra
											, @Monto
											, @idPlanillaSemanal);

									SET @UltimoMovimiento = SCOPE_IDENTITY();
									INSERT INTO dbo.MovimientoXHora (idMovimiento
																	, idRegistroAsistencia)
									VALUES (@UltimoMovimiento
											, @idRegistroAsistencia);
								END
							END
							ELSE -- Extra doble (feriado o domingo)
							BEGIN
								SET @Monto = @HorasExtra * @SalarioHora * 2;
								IF @Monto > 0
								BEGIN
									INSERT INTO dbo.Movimiento (idEmpleado
																, idTipoMovimiento
																, Fecha
																, CantidadHoras
																, Monto
																, idPlanillaSemanal)
									VALUES (@idEmpleadoRA
											, 3
											, @FechaOperacion
											, @HorasExtra
											, @Monto
											, @idPlanillaSemanal);

									SET @UltimoMovimiento = SCOPE_IDENTITY();
									INSERT INTO dbo.MovimientoXHora (idMovimiento
																	, idRegistroAsistencia)
									VALUES (@UltimoMovimiento
											, @idRegistroAsistencia);
								END
							END

							SET @loRA = @loRA + 1;
						END
						DELETE FROM @Registros


						-- Actualizar PlanillaSemanal con totales
						UPDATE PS
						SET
							HorasOrdinarias = ISNULL((
								SELECT CAST(SUM(M.CantidadHoras) AS DECIMAL(10,2))
								FROM dbo.Movimiento M
								WHERE M.idEmpleado = @idEmpleadoRA 
								AND M.idPlanillaSemanal = PS.id 
								AND M.idTipoMovimiento = 1
							), 0),

							HorasExtra = ISNULL((
								SELECT CAST(SUM(M.CantidadHoras) AS DECIMAL(10,2))
								FROM dbo.Movimiento M
								WHERE M.idEmpleado = @idEmpleadoRA 
								AND M.idPlanillaSemanal = PS.id 
								AND M.idTipoMovimiento = 2
							), 0),

							HorasExtraDoble = ISNULL((
								SELECT CAST(SUM(M.CantidadHoras) AS DECIMAL(10,2))
								FROM dbo.Movimiento M
								WHERE M.idEmpleado = @idEmpleadoRA 
								AND M.idPlanillaSemanal = PS.id 
								AND M.idTipoMovimiento = 3
							), 0),

							SalarioBruto = ISNULL((
								SELECT CAST(SUM(M.Monto) AS DECIMAL(18,2))
								FROM dbo.Movimiento M
								WHERE M.idEmpleado = @idEmpleadoRA 
								AND M.idPlanillaSemanal = PS.id
								AND EXISTS (
									SELECT 1
									FROM dbo.MovimientoXHora MXH
									WHERE MXH.idMovimiento = M.id
								) 
							), 0) 
						FROM dbo.PlanillaSemanal PS
						WHERE PS.id = @idPlanillaSemanal;



						-- Tabla de deducciones del empleado durante la semana
						DECLARE @DeduccionesEmpleado TABLE (
							SEC INT IDENTITY(1,1),
							idTipoDeduccion INT,
							Valor DECIMAL(10,4),
							Obligatoria BIT,
							Porcentual BIT
						);

						-- Insertar deducciones válidas según la fecha
						INSERT INTO @DeduccionesEmpleado (
							idTipoDeduccion,
							Valor,
							Obligatoria,
							Porcentual
						)
						SELECT 
							ED.idTipoDeduccion,
							-- Si es porcentual, usar valor de TipoDeduccion; si no, usar el monto específico del empleado
							CASE 
								WHEN TD.Porcentual = 1 THEN TD.Valor
								ELSE ISNULL(ED.Monto, 0)
							END AS Valor,
							TD.Obligatorio,
							TD.Porcentual
						FROM dbo.EmpleadoDeduccion ED
						INNER JOIN dbo.TipoDeduccion TD ON TD.id = ED.idTipoDeduccion
						WHERE ED.idEmpleado = @idEmpleadoRA
						  AND ED.Fecha BETWEEN @FechaInicio AND @FechaOperacion;


							-- Luego, forzar agregar deducción obligatoria si no está
							IF NOT EXISTS (
								SELECT 1 FROM @DeduccionesEmpleado WHERE idTipoDeduccion = 1 
							)
							BEGIN
								DECLARE @ValorObligatorio DECIMAL(10,4);

								SELECT @ValorObligatorio = Valor FROM dbo.TipoDeduccion WHERE id = 1;

								INSERT INTO @DeduccionesEmpleado (idTipoDeduccion, Valor, Obligatoria, Porcentual)
								VALUES (1, ISNULL(@ValorObligatorio, 0), 1, 1);
							END


							-- Variables iniciales
							DECLARE @loDE INT, @hiDE INT;
							DECLARE @Valor DECIMAL(10,4) = 0,
									@Obligatoria BIT = 0,
									@TipoMovimiento INT = 0

							-- Obtener SalarioBruto
							DECLARE @SalarioBruto DECIMAL(18,2);

							SELECT @SalarioBruto = ISNULL(PS.SalarioBruto, 0)
							FROM dbo.PlanillaSemanal PS
							WHERE PS.id = @idPlanillaSemanal;

							-- Rango de deducciones a iterar
							SELECT @loDE = MIN(SEC), @hiDE = MAX(SEC) FROM @DeduccionesEmpleado;

							WHILE @loDE <= @hiDE
							BEGIN
								SELECT 
									@idTipoDeduccion = DE.idTipoDeduccion,
									@Valor = DE.Valor,
									@Obligatoria = DE.Obligatoria,
									@Porcentual = DE.Porcentual
								FROM @DeduccionesEmpleado DE
								WHERE DE.SEC = @loDE;

								-- Definir tipo de movimiento según obligatoriedad
								IF @Obligatoria = 1
									SET @TipoMovimiento = 4; -- Obligatoria
								ELSE
									SET @TipoMovimiento = 5; -- No obligatoria

								-- Calcular monto
								IF @Porcentual = 1
								BEGIN
									SET @Monto = @SalarioBruto * ISNULL(@Valor, 0);
								END
								ELSE
								BEGIN
									IF ISNULL(@QSemanas, 0) = 0
										SET @Monto = 0;
									ELSE
										SET @Monto = ISNULL(@Valor, 0) / @QSemanas;
								END

								-- Insertar movimiento
								INSERT INTO dbo.Movimiento (
									idEmpleado,
									idTipoMovimiento,
									Fecha,
									CantidadHoras,
									Monto,
									idPlanillaSemanal
								)
								VALUES (
									@idEmpleadoRA,
									@TipoMovimiento,
									@FechaOperacion,
									0,
									@Monto,
									@idPlanillaSemanal
								);

								SET @UltimoMovimiento = SCOPE_IDENTITY();

								-- Asociar movimiento con tipo deducción
								INSERT INTO dbo.MovimientoXDeduccion (idMovimiento, idTipoDeduccion)
								VALUES (@UltimoMovimiento, @idTipoDeduccion);

								SET @loDE = @loDE + 1;
							END

							-- Limpiar tabla temporal
							DELETE FROM @DeduccionesEmpleado;

							-- Calcular total deducciones para actualizar planilla
							DECLARE @TotalDeducciones DECIMAL(18,2) = 0;
							SELECT @TotalDeducciones = ISNULL(SUM(M.Monto), 0)
							FROM dbo.Movimiento M
							INNER JOIN dbo.MovimientoXDeduccion MXD ON MXD.idMovimiento = M.id
							WHERE M.idEmpleado = @idEmpleadoRA
							  AND M.idPlanillaSemanal = @idPlanillaSemanal;

							-- Actualizar planilla semanal
							UPDATE dbo.PlanillaSemanal
							SET 
								TotalDeducciones = CAST(ISNULL(@TotalDeducciones, 0) AS DECIMAL(18,2)),
								SalarioNeto = CAST(ISNULL(@SalarioBruto, 0) - ISNULL(@TotalDeducciones, 0) AS DECIMAL(18,2))
							WHERE id = @idPlanillaSemanal;



							--Detalle semanal de deducciones
							DECLARE @Deducciones TABLE (
								SEC INT IDENTITY(1,1)
								, TipoDeduccion INT 
								, TotalMonto MONEY
							);

							-- Insertar resumen de montos por tipo deducción
							INSERT INTO @Deducciones (TipoDeduccion, TotalMonto)
							SELECT 
								MD.idTipoDeduccion,
								SUM(M.Monto)
							FROM dbo.Movimiento M
							JOIN dbo.MovimientoXDeduccion MD ON MD.idMovimiento = M.id
							WHERE M.idPlanillaSemanal = @idPlanillaSemanal 
							GROUP BY MD.idTipoDeduccion;



							DECLARE @loDD INT, @hiDD INT;

							SELECT 
								@loDD = MIN(Sec),
								@hiDD = MAX(Sec)
							FROM @Deducciones;

							DECLARE 
								@TipoDeduccion INT = 0,
								@TotalMonto MONEY = 0;


							WHILE @loDD <= @hiDD
							BEGIN
								SELECT 
									@TipoDeduccion = TipoDeduccion,
									@TotalMonto = TotalMonto
								FROM @Deducciones DE
								WHERE DE.SEC = @loDD;

								INSERT INTO dbo.DetalleDeduccionSemanal (
									idPlanillaSemanal,
									idTipoDeduccion,
									Porcentaje,
									Monto
								)
								SELECT 
									@idPlanillaSemanal,
									@TipoDeduccion,
									ISNULL(TD.Valor, 0),
									ISNULL(@TotalMonto, 0)
								FROM  dbo.TipoDeduccion TD 
								WHERE TD.id = @TipoDeduccion

								SET @loDD = @loDD + 1;
							END
							DELETE FROM @Deducciones

						SET @loM = @loM + 1;
					END
					DELETE FROM @EmpleadosSemana

					--Apertura de semana

					SET @FechaInicio = DATEADD(DAY, 1, @FechaOperacion); -- viernes
					SET @FechaFin = DATEADD(DAY, 6, @FechaInicio); -- jueves siguiente

					-- Insertar en tabla Semana
					INSERT INTO dbo.Semana (FechaInicio
											, FechaFin)
					VALUES (@FechaInicio
							, @FechaFin);
					SET @IdSemana = SCOPE_IDENTITY();

					
					--Se lee la jornada para la proxima semana
					DECLARE @TablaJornada TABLE (Sec int identity (1,1)
											, ValorDocumento varchar(128)
											, IdTipoJornada int)
					INSERT INTO @TablaJornada (ValorDocumento, IdTipoJornada)
					SELECT
						ref.value('(@ValorTipoDocumento)[1]', 'varchar(128)'),
						ref.value('(@IdTipoJornada)[1]', 'int')
					FROM @xmlData.nodes('/Operacion/FechaOperacion[@Fecha=sql:variable("@FechaOperacion")]') AS fecha(fecha)
					CROSS APPLY fecha.nodes('JornadasProximaSemana/TipoJornadaProximaSemana') AS sub(ref);

					-- Insertar en PlanillaSemanal para cada empleado de @TablaJornada

					INSERT INTO dbo.PlanillaSemanal (
						idEmpleado
						, idSemana
						, HorasOrdinarias
						, HorasExtra
						, HorasExtraDoble
						, SalarioBruto
						, TotalDeducciones
						, SalarioNeto
					)
					SELECT 
						E.id
						, @IdSemana
						, 0.0 -- HorasOrdinarias
						, 0.0 -- HorasExtra
						, 0.0 -- HorasExtraDoble
						, 0.0 -- SalarioBruto
						, 0.0 -- TotalDeducciones
						, 0.0  -- SalarioNeto
					FROM @TablaJornada TJ
					INNER JOIN dbo.Empleado E ON E.ValorDocumento = TJ.ValorDocumento;

					-- Insertar jornada definitiva en tabla fija

					INSERT INTO dbo.Jornada (idSemana, idTipoJornada, idEmpleado)
					SELECT 
						@IdSemana,
						TJ.IdTipoJornada,
						E.id
					FROM @TablaJornada TJ
					INNER JOIN dbo.Empleado E ON E.ValorDocumento = TJ.ValorDocumento
					WHERE NOT EXISTS (
						SELECT 1 
						FROM dbo.Jornada J 
						WHERE J.idSemana = @IdSemana 
							AND J.idEmpleado = E.id
					);
					
					-- Insertar en EventoLog por cada jornada insertada
					INSERT INTO dbo.EventoLog(idTipoEvento, Descripcion, idPostByUser, PostInIP, PostTime)
					SELECT 
						15,
						CONCAT(E.id, '-', TJ.IdTipoJornada),
						5,
						'25.55.61.33',
						@FechaOperacion
					FROM @TablaJornada TJ
					INNER JOIN dbo.Empleado E ON E.ValorDocumento = TJ.ValorDocumento
					WHERE NOT EXISTS (
						SELECT 1 
						FROM dbo.Jornada J 
						WHERE J.idSemana = @IdSemana 
							AND J.idEmpleado = E.id
					);


					DELETE FROM @TablaJornada




				-- Cierre y apertura de mes
				DECLARE @Manana DATE = DATEADD(DAY, 1, @FechaOperacion);
				DECLARE @DiaHoy INT = DAY(@FechaOperacion);
				DECLARE @EsJueves BIT = CASE WHEN DATEPART(WEEKDAY, @FechaOperacion) = 5 THEN 1 ELSE 0 END; -- Asumiendo @@DATEFIRST = 1 (Lunes=1)
				DECLARE @DiaManana INT = DAY(@Manana);
				DECLARE @DiaSemanaManana INT = DATEPART(WEEKDAY, @Manana);
				DECLARE @PrimerDiaMesActual DATE = DATEFROMPARTS(YEAR(@FechaOperacion), MONTH(@FechaOperacion), 1);
				DECLARE @PrimerDiaMesSiguiente DATE = DATEFROMPARTS(YEAR(DATEADD(MONTH, 1, @FechaOperacion)), MONTH(DATEADD(MONTH, 1, @FechaOperacion)), 1);
				DECLARE @PrimerDiaMesSiguienteSiguiente DATE = DATEFROMPARTS(YEAR(DATEADD(MONTH, 2, @FechaOperacion)), MONTH(DATEADD(MONTH, 2, @FechaOperacion)), 1);

				-- Buscar primer viernes de un mes dado
				DECLARE @PrimerViernesMesActual DATE;
				DECLARE @PrimerViernesMesAnterior DATE;
				DECLARE @PrimerViernesMesSiguiente DATE;
				DECLARE @PrimerViernesMesSiguienteSiguiente DATE;
				DECLARE @FechaInicioM DATE, @FechaFinM DATE;
				DECLARE @idEmpleadoM INT

				DECLARE @DeduccionesMensuales TABLE (
						Sec INT IDENTITY(1,1),
						idEmpleado INT,
						TipoDeduccion INT,
						TotalMonto MONEY
					);

				DECLARE @loDDM INT, @hiDDM INT;
				DECLARE @idPlanillaMensual INT
				DECLARE 
						@TipoDeduccionM INT = 0,
						@TotalMontoM MONEY = 0;

				-- Encuentra el primer viernes de un mes
				DECLARE @i INT = 1;
				WHILE @i <= 7
				BEGIN
					IF DATEPART(WEEKDAY, DATEADD(DAY, @i - 1, @PrimerDiaMesActual)) = 6 -- Viernes
					BEGIN
						SET @PrimerViernesMesActual = DATEADD(DAY, @i - 1, @PrimerDiaMesActual);
						BREAK;
					END
					SET @i += 1;
				END

				SET @i = 1;
				WHILE @i <= 7
				BEGIN
					IF DATEPART(WEEKDAY, DATEADD(DAY, @i - 1, DATEADD(MONTH, -1, @PrimerDiaMesActual))) = 6
					BEGIN
						SET @PrimerViernesMesAnterior = DATEADD(DAY, @i - 1, DATEADD(MONTH, -1, @PrimerDiaMesActual));
						BREAK;
					END
					SET @i += 1;
				END

				SET @i = 1;
				WHILE @i <= 7
				BEGIN
					IF DATEPART(WEEKDAY, DATEADD(DAY, @i - 1, @PrimerDiaMesSiguiente)) = 6
					BEGIN
						SET @PrimerViernesMesSiguiente = DATEADD(DAY, @i - 1, @PrimerDiaMesSiguiente);
						BREAK;
					END
					SET @i += 1;
				END

				SET @i = 1;
				WHILE @i <= 7
				BEGIN
					IF DATEPART(WEEKDAY, DATEADD(DAY, @i - 1, @PrimerDiaMesSiguienteSiguiente)) = 6
					BEGIN
						SET @PrimerViernesMesSiguienteSiguiente = DATEADD(DAY, @i - 1, @PrimerDiaMesSiguienteSiguiente);
						BREAK;
					END
					SET @i += 1;
				END

				-- ============================
				-- 1. Primera Semana del Mes + Mañana es Primer Viernes
				-- ============================
				IF @EsJueves = 1 AND @Manana = @PrimerViernesMesActual AND @DiaHoy <= 6
				BEGIN
					-- Si dbo.Mes está vacío
					IF NOT EXISTS (SELECT 1 FROM dbo.Mes)
					BEGIN
						INSERT INTO dbo.Mes (FechaInicio, FechaFin)
						VALUES (@PrimerViernesMesAnterior, @FechaOperacion);
					END
					SELECT @idMes = MAX(id) FROM dbo.Mes;

					SELECT 
						@FechaInicioM = FechaInicio,
						@FechaFinM = FechaFin
					FROM dbo.Mes
					WHERE id = @idMes;

					SET @QSemanas = (
							SELECT COUNT(*)
							FROM (
								SELECT TOP (DATEDIFF(DAY, @FechaInicioM, @FechaFinM) + 1)
									DATEADD(DAY, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1, @FechaInicioM) AS Fecha
								FROM sys.all_objects
							) AS Dias
							WHERE DATENAME(WEEKDAY, Fecha) = 'Friday'
						);

					UPDATE PM
						SET 
								PM.SalarioBruto = PS.SalarioBruto,
								PM.TotalDeducciones = PS.TotalDeducciones,
								PM.SalarioNeto = PS.SalarioNeto,
								PM.cantidadSemanas = @QSemanas
							FROM dbo.PlanillaMes PM
							INNER JOIN (
								SELECT 
									E.id AS idEmpleado,
									SUM(PS.SalarioBruto) AS SalarioBruto,
									SUM(PS.TotalDeducciones) AS TotalDeducciones,
									SUM(PS.SalarioNeto) AS SalarioNeto
								FROM dbo.Empleado E
								INNER JOIN dbo.PlanillaSemanal PS ON PS.idEmpleado = E.id
								INNER JOIN dbo.Semana S ON S.id = PS.idSemana
								INNER JOIN dbo.Mes M ON M.id = @idMes
								WHERE S.FechaInicio >= M.FechaInicio
								AND S.FechaFin <= M.FechaFin
								GROUP BY E.id
							) AS PS ON PM.idEmpleado = PS.idEmpleado
							WHERE PM.idMes = @idMes;

					-- Detalle mensual de deducciones
					-- Insertar las deducciones mensuales agrupadas por empleado y tipo
					INSERT INTO @DeduccionesMensuales (idEmpleado, TipoDeduccion, TotalMonto)
					SELECT 
						PM.idEmpleado,
						MD.idTipoDeduccion,
						SUM(M.Monto)
					FROM dbo.Movimiento M
					JOIN dbo.MovimientoXDeduccion MD ON MD.idMovimiento = M.id
					JOIN dbo.PlanillaSemanal PS ON PS.id = M.idPlanillaSemanal
					JOIN dbo.Semana S ON S.id = PS.idSemana
					JOIN dbo.PlanillaMes PM ON PM.idEmpleado = PS.idEmpleado AND PM.idMes = @idMes
					WHERE S.FechaInicio >= (SELECT FechaInicio FROM dbo.Mes WHERE id = @idMes)
					  AND S.FechaFin <= (SELECT FechaFin FROM dbo.Mes WHERE id = @idMes)
					GROUP BY PM.idEmpleado, MD.idTipoDeduccion;
					SELECT 
						@loDDM = MIN(Sec),
						@hiDDM = MAX(Sec)
					FROM @DeduccionesMensuales;

					WHILE @loDDM <= @hiDDM
					BEGIN
						SELECT 
							@idEmpleadoM = idEmpleado,
							@TipoDeduccionM = TipoDeduccion,
							@TotalMontoM = TotalMonto
						FROM @DeduccionesMensuales DM
						WHERE DM.Sec = @loDDM;

						INSERT INTO dbo.DetalleDeduccionMensual (
							idPlanillaMes,
							idTipoDeduccion,
							Porcentaje,
							Monto
						)
						SELECT 
							PM.id,
							@TipoDeduccionM,
							ISNULL(TD.Valor, 0),
							ISNULL(@TotalMontoM, 0)
						FROM dbo.TipoDeduccion TD
						INNER JOIN dbo.PlanillaMes PM ON PM.idMes = @idMes AND PM.idEmpleado = @idEmpleadoM
						WHERE TD.id = @TipoDeduccionM;

						SET @loDDM = @loDDM + 1;
					END

					DELETE FROM @DeduccionesMensuales;



					-- Insertar nuevo mes
					DECLARE @NuevaFechaInicio DATE = @Manana;
					DECLARE @NuevaFechaFin DATE = DATEADD(DAY, -1, @PrimerViernesMesSiguiente);

					INSERT INTO dbo.Mes (FechaInicio, FechaFin)
					VALUES (@NuevaFechaInicio, @NuevaFechaFin);

					-- Obtener nuevo idMes
					SELECT @idMes = MAX(id) FROM dbo.Mes;

					SELECT 
						@QSemanas = DATEDIFF(WEEK, FechaInicio, FechaFin) + 1
					FROM dbo.Mes
					WHERE id = @idMes;

					-- Insertar planillas en 0
					INSERT INTO dbo.PlanillaMes (idEmpleado
												, idMes
												, SalarioBruto
												, TotalDeducciones
												, SalarioNeto
												, cantidadSemanas)
					SELECT 
						id
						, @idMes
						, 0.0
						, 0.0
						, 0.0
						, @QSemanas
					FROM dbo.Empleado
					WHERE Activo = 1;
				END

				-- ============================
				-- 2. Último Día del Mes + Mañana es Primer Viernes
				-- ============================
				ELSE IF @EsJueves = 1 AND @Manana = @PrimerViernesMesSiguiente AND DAY(EOMONTH(@FechaOperacion)) = @DiaHoy
				BEGIN
					-- Si dbo.Mes está vacío
					IF NOT EXISTS (SELECT 1 FROM dbo.Mes)
					BEGIN
						INSERT INTO dbo.Mes (FechaInicio, FechaFin)
						VALUES (@PrimerViernesMesActual, @FechaOperacion);
					END
					SELECT @idMes = MAX(id) FROM dbo.Mes;

					SELECT 
						@FechaInicioM = FechaInicio,
						@FechaFinM = FechaFin
					FROM dbo.Mes
					WHERE id = @idMes;

					SET @QSemanas = (
							SELECT COUNT(*)
							FROM (
								SELECT TOP (DATEDIFF(DAY, @FechaInicioM, @FechaFinM) + 1)
									DATEADD(DAY, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1, @FechaInicioM) AS Fecha
								FROM sys.all_objects
							) AS Dias
							WHERE DATENAME(WEEKDAY, Fecha) = 'Friday'
						);

					UPDATE PM
						SET 
								PM.SalarioBruto = PS.SalarioBruto,
								PM.TotalDeducciones = PS.TotalDeducciones,
								PM.SalarioNeto = PS.SalarioNeto,
								PM.cantidadSemanas = @QSemanas
							FROM dbo.PlanillaMes PM
							INNER JOIN (
								SELECT 
									E.id AS idEmpleado,
									SUM(PS.SalarioBruto) AS SalarioBruto,
									SUM(PS.TotalDeducciones) AS TotalDeducciones,
									SUM(PS.SalarioNeto) AS SalarioNeto
								FROM dbo.Empleado E
								INNER JOIN dbo.PlanillaSemanal PS ON PS.idEmpleado = E.id
								INNER JOIN dbo.Semana S ON S.id = PS.idSemana
								INNER JOIN dbo.Mes M ON M.id = @idMes
								WHERE S.FechaInicio >= M.FechaInicio
								AND S.FechaFin <= M.FechaFin
								GROUP BY E.id
							) AS PS ON PM.idEmpleado = PS.idEmpleado
							WHERE PM.idMes = @idMes;


					-- Detalle mensual de deducciones
					-- Insertar la suma mensual de deducciones agrupadas por empleado y tipo deducción
					INSERT INTO @DeduccionesMensuales (idEmpleado, TipoDeduccion, TotalMonto)
					SELECT 
						PM.idEmpleado,
						MD.idTipoDeduccion,
						SUM(M.Monto)
					FROM dbo.Movimiento M
					JOIN dbo.MovimientoXDeduccion MD ON MD.idMovimiento = M.id
					JOIN dbo.PlanillaSemanal PS ON PS.id = M.idPlanillaSemanal
					JOIN dbo.Semana S ON S.id = PS.idSemana
					JOIN dbo.Mes MS ON S.FechaInicio >= MS.FechaInicio AND S.FechaFin <= MS.FechaFin
					JOIN dbo.PlanillaMes PM ON PM.idMes = MS.id AND PM.idEmpleado = PS.idEmpleado
					WHERE MS.FechaFin = @FechaOperacion
					GROUP BY PM.idEmpleado, MD.idTipoDeduccion;

					SELECT 
						@loDDM = MIN(Sec),
						@hiDDM = MAX(Sec)
					FROM @DeduccionesMensuales;

					WHILE @loDDM <= @hiDDM
					BEGIN
						SELECT 
							@idEmpleadoM = idEmpleado,
							@TipoDeduccionM = TipoDeduccion,
							@TotalMontoM = TotalMonto
						FROM @DeduccionesMensuales DM
						WHERE DM.Sec = @loDDM;

						INSERT INTO dbo.DetalleDeduccionMensual (
							idPlanillaMes,
							idTipoDeduccion,
							Porcentaje,
							Monto
						)
						SELECT 
							PM.id,
							@TipoDeduccionM,
							ISNULL(TD.Valor, 0),
							ISNULL(@TotalMontoM, 0)
						FROM dbo.TipoDeduccion TD
						INNER JOIN dbo.PlanillaMes PM ON PM.idMes = @idMes AND PM.idEmpleado = @idEmpleadoM
						WHERE TD.id = @TipoDeduccionM;

						SET @loDDM = @loDDM + 1;
					END

					DELETE FROM @DeduccionesMensuales;



					-- Insertar nuevo mes: mañana hasta día antes del primer viernes del mes siguiente-siguiente
					DECLARE @NuevaFechaInicio2 DATE = @Manana;
					DECLARE @NuevaFechaFin2 DATE = DATEADD(DAY, -1, @PrimerViernesMesSiguienteSiguiente);

					INSERT INTO dbo.Mes (FechaInicio, FechaFin)
					VALUES (@NuevaFechaInicio2, @NuevaFechaFin2);

					SELECT @idMes = MAX(id) FROM dbo.Mes;

					SELECT 
						@QSemanas = DATEDIFF(WEEK, FechaInicio, FechaFin) + 1
					FROM dbo.Mes
					WHERE id = @idMes;

					-- Insertar planillas en 0
					INSERT INTO dbo.PlanillaMes (idEmpleado
												, idMes
												, SalarioBruto
												, TotalDeducciones
												, SalarioNeto
												, cantidadSemanas)
					SELECT 
						id
						, @idMes
						, 0.0
						, 0.0
						, 0.0
						, @QSemanas
					FROM dbo.Empleado
					WHERE Activo = 1;
				END

				COMMIT TRANSACTION;
				
			END

			SET @lo=@lo+1
			RAISERROR('Avance WHILE: @lo = %d', 0, 1, @lo) WITH NOWAIT;
			
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

	SET NOCOUNT OFF
END