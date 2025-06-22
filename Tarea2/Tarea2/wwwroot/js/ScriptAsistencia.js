let usuario = JSON.parse(localStorage.getItem("usuario"));
let empleado = JSON.parse(localStorage.getItem("empleado"));
let idPlanilla = parseInt(localStorage.getItem("idPlanillaSeleccionada"));


  document.getElementById('btnRegresar').addEventListener('click', () => {
    // Suponiendo que empleado, usuario y idPlanillaSeleccionada están definidos globalmente
    localStorage.setItem('usuario', JSON.stringify(usuario));
    localStorage.setItem('empleado', JSON.stringify(empleado));
    localStorage.setItem('idPlanillaSeleccionada', idPlanilla.toString());

    window.location.href = 'Movimientos.html';
  });



document.addEventListener("DOMContentLoaded", () => {
    const idRegistro = parseInt(localStorage.getItem("idRegistroAsistencia"));
    if (!idRegistro) return;

    fetch("https://localhost:5001/api/BDController/ConsultarRegistroAsistencia", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(idRegistro)
    })
        .then(resp => {
            if (!resp.ok) throw new Error("Error al obtener datos.");
            return resp.json();
        })
        .then(data => {
            const tbody = document.querySelector("#tablaRegistro tbody");
            tbody.innerHTML = "";

            data.forEach(r => {
                const tr = document.createElement("tr");

                // Información Jornada (en una sola celda)
                const tdJornada = document.createElement("td");
                tdJornada.innerHTML = `
                    <strong>${r.nombreTipoJornada}</strong><br>
                    Inicio: ${r.inicioJornada}<br>
                    Fin: ${r.finJornada}
                `;

                // Marca de Asistencia (en una sola celda)
                const tdMarca = document.createElement("td");
                tdMarca.innerHTML = `
                    Entrada: ${r.horaEntrada}<br>
                    Salida: ${r.horaSalida}
                `;

                const tdOrdinarias = document.createElement("td");
                tdOrdinarias.textContent = r.horasOrdinarias;

                const tdExtra = document.createElement("td");
                tdExtra.textContent = r.horasExtra;

                const tdDia = document.createElement("td");
                tdDia.textContent = r.dia;

                const tdFeriado = document.createElement("td");
                tdFeriado.textContent = r.feriado;

                tr.appendChild(tdJornada);
                tr.appendChild(tdMarca);
                tr.appendChild(tdOrdinarias);
                tr.appendChild(tdExtra);
                tr.appendChild(tdDia);
                tr.appendChild(tdFeriado);

                tbody.appendChild(tr);
            });
        })
        .catch(err => {
            document.querySelector("#tablaRegistro tbody").innerHTML = `<tr><td colspan="6">${err.message}</td></tr>`;
        });
});
