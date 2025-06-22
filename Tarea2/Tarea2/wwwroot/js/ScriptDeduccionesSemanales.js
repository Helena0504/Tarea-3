let usuario = JSON.parse(localStorage.getItem("usuario"));
let empleado = JSON.parse(localStorage.getItem("empleado"));
let idPlanilla = parseInt(localStorage.getItem("idPlanillaSeleccionada"));

document.getElementById('btnRegresar').addEventListener('click', () => {
    localStorage.setItem('usuario', JSON.stringify(usuario));
    localStorage.setItem('empleado', JSON.stringify(empleado));
    localStorage.setItem('idPlanillaSeleccionada', idPlanilla.toString());
    window.location.href = 'PrincipalEmplea.html'; // o la página a la que quieras regresar
});

document.addEventListener("DOMContentLoaded", () => {
    if (!idPlanilla) {
        document.querySelector("#tablaDeduccionesSemanales tbody").innerHTML = `<tr><td colspan="2">No hay planilla seleccionada.</td></tr>`;
        return;
    }

    fetch("https://localhost:5001/api/BDController/ConsultarDeduccionesSemanales", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ IdPlanilla: idPlanilla })
    })
        .then(resp => {
            if (!resp.ok) throw new Error("Error al obtener deducciones semanales.");
            return resp.json();
        })
        .then(data => {
            const tbody = document.querySelector("#tablaDeduccionesSemanales tbody");
            tbody.innerHTML = "";

            if (data.length === 0) {
                tbody.innerHTML = `<tr><td colspan="2">No hay deducciones semanales.</td></tr>`;
                return;
            }

            data.forEach(d => {
                const tr = document.createElement("tr");

                // Nombre de la deducción
                const tdNombre = document.createElement("td");
                tdNombre.textContent = d.nombreTipoDeduccion || d.NombreTipoDeduccion || "N/A";

                // Monto, formateado con 2 decimales
                const tdMonto = document.createElement("td");
                tdMonto.textContent = (typeof d.monto === "number" ? d.monto : parseFloat(d.Monto)).toFixed(2);

                tr.appendChild(tdNombre);
                tr.appendChild(tdMonto);

                // Evento click en fila
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

                    // Redirige a la página que usará esos datos
                    window.location.href = 'MovimientoDeduccion.html';
                });

                tbody.appendChild(tr);
            });
        })
        .catch(err => {
            document.querySelector("#tablaDeduccionesSemanales tbody").innerHTML = `<tr><td colspan="2">${err.message}</td></tr>`;
        });
});