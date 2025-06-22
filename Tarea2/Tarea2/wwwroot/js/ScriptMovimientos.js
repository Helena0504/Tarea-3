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
    fetch("https://localhost:5001/api/BDController/ConsultarMovimientos", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ IdPlanilla: idPlanilla })
    })
        .then(resp => {
            if (!resp.ok) {
                return resp.text().then(textoError => {
                    throw new Error(textoError);
                });
            }
            return resp.json();
        })
        .then(movimientos => {
            console.log("Datos movimientos recibidos:", movimientos);
            mostrarMovimientosPorDia(movimientos);
        })
        .catch(err => {
            console.error("Error al consultar movimientos:", err.message);
            const contenedor = document.getElementById("contenedorDias");
            if (contenedor) {
                contenedor.innerHTML = `<p>${err.message}</p>`;
            }
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

                    localStorage.setItem('usuario', JSON.stringify(usuario));
                    localStorage.setItem('empleado', JSON.stringify(empleado));
                    localStorage.setItem('idPlanillaSeleccionada', idPlanilla.toString());
                    localStorage.setItem('idRegistroAsistencia', mov.idRegistroAsistencia.toString());

                    window.location.href = 'Asistencia.html';
                };


                tbody.appendChild(tr);
            });

            seccion.appendChild(tabla);
            contenedor.appendChild(seccion);
        }
    });
}