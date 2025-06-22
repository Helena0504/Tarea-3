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
        body: JSON.stringify({ IdPlanilla: idPlanilla })  // Aquí envías el objeto correctamente
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
                const tdNombre = document.createElement("td");
                tdNombre.textContent = d.nombreTipoDeduccion || d.NombreTipoDeduccion || "N/A";

                const tdMonto = document.createElement("td");
                // Asegúrate de que monto sea número antes de usar toFixed
                const monto = typeof d.monto === "number" ? d.monto : parseFloat(d.Monto);
                tdMonto.textContent = monto.toFixed(2);

                tr.appendChild(tdNombre);
                tr.appendChild(tdMonto);
                tbody.appendChild(tr);
            });
        })
        .catch(err => {
            document.querySelector("#tablaDeduccionesMensuales tbody").innerHTML = `<tr><td colspan="2">${err.message}</td></tr>`;
        });
});
