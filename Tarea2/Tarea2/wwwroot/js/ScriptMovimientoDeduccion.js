let usuario = JSON.parse(localStorage.getItem("usuario"));
let empleado = JSON.parse(localStorage.getItem("empleado"));
let idPlanilla = parseInt(localStorage.getItem("idPlanillaSeleccionada"));
let idTipoDeduccion = parseInt(localStorage.getItem("idTipoDeduccionSeleccionada")); // Debe estar guardado previamente

document.getElementById('btnRegresar').addEventListener('click', () => {
    localStorage.setItem('usuario', JSON.stringify(usuario));
    localStorage.setItem('empleado', JSON.stringify(empleado));
    localStorage.setItem('idPlanillaSeleccionada', idPlanilla.toString());
    window.location.href = 'DeduccionesSemanales.html';
});

document.addEventListener("DOMContentLoaded", () => {
    document.addEventListener("DOMContentLoaded", () => {
        const loader = document.getElementById('loader');
        const usuario = JSON.parse(localStorage.getItem("usuario"));
        const empleado = JSON.parse(localStorage.getItem("empleado"));
        const idPlanilla = parseInt(localStorage.getItem("idPlanillaSeleccionada"));
        const idTipoDeduccion = parseInt(localStorage.getItem("idTipoDeduccionSeleccionada"));

    // Verificar si loader existe
    if (loader) {
        loader.style.display = 'block';
    }
    // Validar datos antes de hacer la petición
    if (!idPlanilla || !idTipoDeduccion) {
        mostrarError("Faltan datos necesarios para la consulta");
        return;
    }

    fetch("https://localhost:5001/api/BDController/ConsultarMovimientosPorDeduccion", {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
            "Authorization": `Bearer ${usuario.Token}` // Si usas autenticación
        },
        body: JSON.stringify({
            IdPlanilla: idPlanilla,
            IdTipoDeduccion: idTipoDeduccion
        })
    })
        .then(resp => {
            if (!resp.ok) {
                return resp.json().then(err => { throw new Error(err.mensaje || "Error en la solicitud"); });
            }
            return resp.json();
        })
        .then(data => {
            if (!data || data.length === 0) {
                mostrarMensaje("No se encontraron movimientos para esta deducción");
                return;
            }
            renderizarMovimientos(data);
        })
        .catch(err => {
            mostrarError(err.message);
        })
        .finally(() => {
            document.getElementById('loader').style.display = 'none';
        });
});

function renderizarMovimientos(movimientos) {
    const tbody = document.querySelector("#tablaMovimientosDeduccion");
    tbody.innerHTML = "";

    movimientos.forEach(m => {
        const tr = document.createElement("tr");

        // Agregar celdas
        const celdas = [
            m.NombreEmpleado,
            m.NombreTipoMovimiento,
            m.NombreDeduccion,
            m.Monto.toFixed(2),
            m.Porcentual ? "Sí" : "No",
            m.PorcentajeDeduccion.toFixed(2) + (m.Porcentual ? "%" : "")
        ];

        celdas.forEach(texto => {
            const td = document.createElement("td");
            td.textContent = texto;
            tr.appendChild(td);
        });

        tbody.appendChild(tr);
    });
}

function mostrarError(mensaje) {
    const tbody = document.querySelector("#tablaMovimientosDeduccion");
    tbody.innerHTML = `<tr><td colspan="6" class="error">${mensaje}</td></tr>`;
}

function mostrarMensaje(mensaje) {
    const tbody = document.querySelector("#tablaMovimientosDeduccion");
    tbody.innerHTML = `<tr><td colspan="6" class="info">${mensaje}</td></tr>`;
}
