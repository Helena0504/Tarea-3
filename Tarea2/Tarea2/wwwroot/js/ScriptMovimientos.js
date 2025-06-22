let usuario = JSON.parse(localStorage.getItem("usuario"));
let empleado = JSON.parse(localStorage.getItem("empleado"));
let idPlanilla = parseInt(localStorage.getItem("idPlanillaSeleccionada"));
console.log(idPlanilla);

document.addEventListener("DOMContentLoaded", function () {
    consultarMovimientos(idPlanilla);
});


/* Regresar */
document.addEventListener('DOMContentLoaded', function () {
    try {
        const button = document.getElementById('Regresar');
        button.addEventListener('click', function () {
            localStorage.setItem('usuario', JSON.stringify(usuario));
            localStorage.setItem('empleado', JSON.stringify(empleado));
            window.location.href = 'PrincipalEmplea.html';
        });
    } catch {
        return null;
    }
});

function consultarMovimientos(idPlanilla) {
    // 1. Verifica que el idPlanilla sea válido
    console.log("ID Planilla a enviar:", idPlanilla);

    // 2. Asegura el formato correcto del body
    const requestBody = JSON.stringify({ IdPlanilla: idPlanilla });
    console.log("Request body:", requestBody);

    fetch("https://localhost:5001/api/BDController/ConsultarMovimientos", {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
            "Accept": "application/json"
        },
        body: requestBody
    })
        .then(resp => {
            console.log("Status code:", resp.status);
            if (!resp.ok) {
                // Intenta leer el mensaje de error
                return resp.text().then(text => { throw new Error(text) });
            }
            return resp.json();
        })
        .then(movimientos => {
            // Moved inside the promise chain
            mostrarMovimientosPorDia(movimientos);
        })
        .catch(err => {
            console.error("Error al consultar movimientos:", err);
            const contenedor = document.getElementById("contenedorDias");
            if (contenedor) contenedor.innerHTML = "<p>Error al cargar movimientos.</p>";
        });
}

function mostrarMovimientosPorDia(movimientos) {
    const contenedor = document.getElementById("contenedorDias");
    contenedor.innerHTML = "";

    const diasOrden = ["Viernes", "Sábado", "Domingo", "Lunes", "Martes", "Miércoles", "Jueves"];

    diasOrden.forEach(dia => {
        const movimientosDelDia = movimientos.filter(m => m.dia === dia);

        if (movimientosDelDia.length > 0) {
            const seccion = document.createElement("div");
            seccion.classList.add("dia-section");

            const titulo = document.createElement("h3");
            titulo.textContent = `${dia}`;
            seccion.appendChild(titulo);

            const tabla = document.createElement("table");
            tabla.innerHTML = `
                <thead>
                    <tr>
                        <th>Hora Entrada</th>
                        <th>Hora Salida</th>
                        <th>Tipo Movimiento</th>
                        <th>Horas</th>
                        <th>Monto</th>
                    </tr>
                </thead>
                <tbody></tbody>
            `;

            const tbody = tabla.querySelector("tbody");

            movimientosDelDia.forEach(mov => {
                const tr = document.createElement("tr");

                const tdEntrada = document.createElement("td");
                tdEntrada.textContent = mov.horaEntrada;

                const tdSalida = document.createElement("td");
                tdSalida.textContent = mov.horaSalida;

                const tdTipo = document.createElement("td");
                tdTipo.textContent = mov.tipoMovimientoNombre || `Tipo ${mov.idTipoMovimiento}`;

                const tdHoras = document.createElement("td");
                tdHoras.textContent = mov.cantidadHoras;

                const tdMonto = document.createElement("td");
                tdMonto.textContent = mov.monto.toFixed(2);

                tr.appendChild(tdEntrada);
                tr.appendChild(tdSalida);
                tr.appendChild(tdTipo);
                tr.appendChild(tdHoras);
                tr.appendChild(tdMonto);

                tr.onclick = () => {
                    alert(`ID Movimiento: ${mov.id}, ID RegistroAsistencia: ${mov.idRegistroAsistencia}`);
                    // Aquí puedes redirigir a otra vista si es necesario
                };

                tbody.appendChild(tr);
            });

            seccion.appendChild(tabla);
            contenedor.appendChild(seccion);
        }
    });
}