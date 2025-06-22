let usuario = JSON.parse(localStorage.getItem("usuario"));
let empleado = JSON.parse(localStorage.getItem("empleado"));
let idPlanilla = parseInt(localStorage.getItem("idPlanillaSeleccionada"));
let idTipoDeduccion = parseInt(localStorage.getItem("idTipoDeduccionSeleccionada"));

document.getElementById('btnRegresar').addEventListener('click', () => {
    localStorage.setItem('usuario', JSON.stringify(usuario));
    localStorage.setItem('empleado', JSON.stringify(empleado));
    localStorage.setItem('idPlanillaSeleccionada', idPlanilla.toString());
    window.location.href = 'DeduccionesSemanales.html';
});

document.addEventListener("DOMContentLoaded", () => {
    if (!idPlanilla || !idTipoDeduccion) {
        document.querySelector("#tablaMovimientosDeduccion").innerHTML = `<tr><td colspan="5">Faltan parámetros requeridos.</td></tr>`;
        return;
    }

    fetch("https://localhost:5001/api/BDController/ConsultarMovimientosPorDeduccion", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
            IdPlanilla: idPlanilla,
            IdTipoDeduccion: idTipoDeduccion
        })
    })
        .then(resp => {
            if (!resp.ok) throw new Error("Error al obtener movimientos por deducción.");
            return resp.json();
        })
        .then(data => {
            console.log(data);
            const tbody = document.querySelector("#tablaMovimientosDeduccion");
            tbody.innerHTML = "";

            if (data.length === 0) {
                tbody.innerHTML = `<tr><td colspan="5">No hay movimientos para esta deducción.</td></tr>`;
                return;
            }

            data.forEach(m => {
                const tr = document.createElement("tr");

                const tdTipoMovimiento = document.createElement("td");
                tdTipoMovimiento.textContent = m.nombreTipoMovimiento || "N/A";

                const tdNombreDeduccion = document.createElement("td");
                tdNombreDeduccion.textContent = m.nombreDeduccion || "N/A";

                const tdMonto = document.createElement("td");
                const montoValor = typeof m.monto === "number" ? m.monto : parseFloat(m.monto || m.Monto || 0);
                tdMonto.textContent = montoValor.toFixed(2);  // Mantenemos 2 decimales para montos
                tdMonto.classList.add("text-right", "currency");

                const tdPorcentual = document.createElement("td");
                tdPorcentual.textContent = m.porcentual ? "Sí" : "No";

                const tdPorcentaje = document.createElement("td");
                const porcentajeValor = typeof m.porcentajeDeduccion === "number" ? m.porcentajeDeduccion :
                    parseFloat(m.porcentajeDeduccion || m.PorcentajeDeduccion || 0);
                tdPorcentaje.textContent = m.porcentual ?
                    `${porcentajeValor.toFixed(3)}%` :  // 3 decimales para porcentajes
                    porcentajeValor.toFixed(2);         // 2 decimales para valores fijos
                tdPorcentaje.classList.add("text-right", porcentajeValor > 0 ? "positive" : "negative");

                tr.appendChild(tdTipoMovimiento);
                tr.appendChild(tdNombreDeduccion);
                tr.appendChild(tdMonto);
                tr.appendChild(tdPorcentual);
                tr.appendChild(tdPorcentaje);

                tbody.appendChild(tr);
            });
        })
        .catch(err => {
            document.querySelector("#tablaMovimientosDeduccion").innerHTML = `<tr><td colspan="5">${err.message}</td></tr>`;
        });
});