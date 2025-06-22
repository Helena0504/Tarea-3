let usuario = JSON.parse(localStorage.getItem("usuario"));
let empleado = JSON.parse(localStorage.getItem("empleado"));
let idPlanilla = parseInt(localStorage.getItem("idPlanillaSeleccionada"));

document.getElementById('btnRegresar').addEventListener('click', () => {
    localStorage.setItem('usuario', JSON.stringify(usuario));
    localStorage.setItem('empleado', JSON.stringify(empleado));
    localStorage.setItem('idPlanillaSeleccionada', idPlanilla.toString());
    window.location.href = 'PrincipalEmplea.html';
});

document.addEventListener("DOMContentLoaded", () => {
    if (!idPlanilla) {
        document.querySelector("#tablaDeduccionesMensuales tbody").innerHTML = `<tr><td colspan="2">No hay planilla seleccionada.</td></tr>`;
        return;
    }

    fetch("https://localhost:5001/api/BDController/ConsultarDeduccionesMensuales", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ IdPlanilla: idPlanilla })
    })
        .then(resp => {
            if (!resp.ok) throw new Error("Error al obtener deducciones mensuales.");
            return resp.json();
        })
        .then(data => {
            const tbody = document.querySelector("#tablaDeduccionesMensuales tbody");
            tbody.innerHTML = "";

            if (data.length === 0) {
                tbody.innerHTML = `<tr><td colspan="2">No hay deducciones mensuales.</td></tr>`;
                return;
            }

            data.forEach(d => {
                const tr = document.createElement("tr");
                tr.style.cursor = "pointer"; // Cambia el cursor a mano al pasar sobre la fila

                const tdNombre = document.createElement("td");
                tdNombre.textContent = d.nombreTipoDeduccion || d.NombreTipoDeduccion || "N/A";

                const tdMonto = document.createElement("td");
                const monto = typeof d.monto === "number" ? d.monto : parseFloat(d.Monto);
                tdMonto.textContent = monto.toFixed(2);

                tr.appendChild(tdNombre);
                tr.appendChild(tdMonto);

                // Evento click en la fila
                tr.addEventListener('click', () => {
                    // Guardar datos básicos
                    localStorage.setItem('usuario', JSON.stringify(usuario));
                    localStorage.setItem('empleado', JSON.stringify(empleado));
                    localStorage.setItem('idPlanillaSeleccionada', idPlanilla.toString());

                    // Obtener y validar el ID de deducción
                    const idDeduccion = d.idTipoDeduccion || d.IdTipoDeduccion || d.id || d.Id;

                    if (!idDeduccion) {
                        console.error('No se encontró ID de deducción en los datos:', d);
                        alert('No se pudo identificar la deducción seleccionada');
                        return;
                    }

                    // Guardar ID de deducción y nombre (si está disponible)
                    localStorage.setItem('idTipoDeduccionSeleccionada', idDeduccion.toString());

                    // Redirige a la página de detalle de movimientos
                    window.location.href = 'MovimientoDeduccionMes.html';
                });

                tbody.appendChild(tr);
            });
        })
        .catch(err => {
            document.querySelector("#tablaDeduccionesMensuales tbody").innerHTML = `<tr><td colspan="2">${err.message}</td></tr>`;
            console.error("Error al cargar deducciones:", err);
        });
});