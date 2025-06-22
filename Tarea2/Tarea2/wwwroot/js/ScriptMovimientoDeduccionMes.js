let usuario = JSON.parse(localStorage.getItem("usuario"));
let empleado = JSON.parse(localStorage.getItem("empleado"));
let idPlanillaMensual = parseInt(localStorage.getItem("idPlanillaSeleccionada"));
let idTipoDeduccion = parseInt(localStorage.getItem("idTipoDeduccionSeleccionada"));

document.getElementById('btnRegresar').addEventListener('click', () => {
    localStorage.setItem('usuario', JSON.stringify(usuario));
    localStorage.setItem('empleado', JSON.stringify(empleado));
    localStorage.setItem('idPlanillaSeleccionada', idPlanillaMensual.toString());
    window.location.href = 'DeduccionesMensuales.html';
});

document.addEventListener("DOMContentLoaded", () => {
    if (!idPlanillaMensual || !idTipoDeduccion) {
        document.querySelector("#tablaMovimientosDeduccion").innerHTML = `<tr><td colspan="5">Faltan parámetros requeridos.</td></tr>`;
        return;
    }

    fetch("https://localhost:5001/api/BDController/ConsultarMovimientosPorPlanillaMensualYTipo", {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
            "Authorization": `Bearer ${usuario?.Token || ''}`
        },
        body: JSON.stringify({
            IdPlanillaMensual: idPlanillaMensual,
            IdTipoDeduccion: idTipoDeduccion,
            IdEmpleado: parseInt(empleado.id)
        })
    })
        .then(resp => {
            if (!resp.ok) throw new Error("Error al obtener movimientos por deducción mensual.");
            return resp.json();
        })
        .then(data => {
            console.log("Datos recibidos:", data);
            const tbody = document.querySelector("#tablaMovimientosDeduccion");
            tbody.innerHTML = "";

            if (!data || data.length === 0) {
                tbody.innerHTML = `<tr><td colspan="5">No hay movimientos para esta deducción en el periodo seleccionado.</td></tr>`;
                return;
            }

            data.forEach(m => {
                const tr = document.createElement("tr");
                tr.classList.add("fila-deduccion");

                // Función para manejar valores nulos/undefined
                const safeValue = (value, defaultValue = "N/A") => {
                    return value ?? defaultValue;
                };

                // Función para manejar valores numéricos
                const safeNumber = (value, decimals = 2) => {
                    const num = parseFloat(value);
                    return isNaN(num) ? 0 : parseFloat(num.toFixed(decimals));
                };

                // Tipo Movimiento
                const tdTipoMovimiento = document.createElement("td");
                tdTipoMovimiento.textContent = safeValue(m.nombreTipoMovimiento);

                // Nombre Deducción
                const tdNombreDeduccion = document.createElement("td");
                tdNombreDeduccion.textContent = safeValue(m.nombreDeduccion);

                // Monto
                const tdMonto = document.createElement("td");
                const monto = safeNumber(m.monto);
                tdMonto.textContent = monto.toFixed(2);
                tdMonto.classList.add("text-right", "currency");

                // Porcentual
                const tdPorcentual = document.createElement("td");
                tdPorcentual.textContent = m.porcentual ? "Sí" : "No";

                // Porcentaje/Valor
                const tdValor = document.createElement("td");
                const valor = safeNumber(m.porcentajeDeduccion, 3);
                tdValor.textContent = m.porcentual ? `${valor.toFixed(3)}%` : valor.toFixed(2);
                tdValor.classList.add("text-right", valor >= 0 ? "positive" : "negative");

                // Agregar celdas a la fila
                tr.appendChild(tdTipoMovimiento);
                tr.appendChild(tdNombreDeduccion);
                tr.appendChild(tdMonto);
                tr.appendChild(tdPorcentual);
                tr.appendChild(tdValor);

                tbody.appendChild(tr);
            });
        })
        .catch(err => {
            console.error("Error:", err);
            document.querySelector("#tablaMovimientosDeduccion").innerHTML =
                `<tr><td colspan="5">Error al cargar datos: ${err.message}</td></tr>`;
        });
});