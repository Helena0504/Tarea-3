/* Variables Globales */
let filaSeleccionada = null;
var usuario = JSON.parse(localStorage.getItem('usuario'));
localStorage.setItem('usuario', JSON.stringify(usuario));
console.log('usuario: ', usuario);

let empleado = null; // ← variable global para guardar el empleado correspondiente

/* Carga cuando se corre la página */
document.addEventListener("DOMContentLoaded", function () {
    listarEmpleados(parseInt(usuario.id), "127.0.0.1", new Date().toISOString());
    console.log("Script se ha cargado correctamente");
});

/* Se hace logout */
document.addEventListener('DOMContentLoaded', function () {
    try {
        const button = document.getElementById('logout');
        button.addEventListener('click', function () {
            // Aquí se podría insertar bitácora si se desea
            window.location.href = 'Login.html';
        });
    } catch {
        return null;
    }
});

/* 1. Listar Empleados */
function listarEmpleados(idPostByUser, PostInIP, PostTime) {
    fetch('https://localhost:5001/api/BDController/ListarEmpleados', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            idPostByUser: idPostByUser,
            PostInIP: PostInIP,
            PostTime: PostTime || new Date().toISOString()
        })
    })
        .then(respuesta => {
            if (!respuesta.ok) {
                throw new Error(`Error HTTP: ${respuesta.status}`);
            }
            return respuesta.json();
        })
        .then(datos => {
            if (Array.isArray(datos)) {
                // Buscar el empleado que pertenece al usuario actual
                const emp = datos.find(e => e.idUsuario === usuario.id);

                if (emp) {
                    empleado = emp; // guardar como variable global
                    console.log("Empleado asignado al usuario:", empleado);
                } else {
                    console.warn("No se encontró un empleado asociado al usuario");
                }
            }
        })
        .catch(error => {
            console.error("Error al cargar empleados:", error);
            const tbody = document.querySelector("#datosTabla");
            if (tbody) {
                tbody.innerHTML = `<tr><td colspan="5">Error al cargar los datos</td></tr>`;
            }
        });
}


/*Planilla Semanal*/
function consultarPlanillaSemanal(idEmpleado, idPostByUser, postInIP) {
    fetch("https://localhost:5001/api/BDController/ConsultarPlanillaSemanal", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
            idEmpleado: idEmpleado,
            idPostByUser: idPostByUser,
            PostInIP: postInIP,
            PostTime: new Date().toISOString()
        })
    })
        .then(resp => {
            if (!resp.ok) throw new Error("Error HTTP: " + resp.status);
            return resp.json();
        })
        .then(planillas => {
            acomodarPlanillasSemanales(planillas);
        })
        .catch(err => {
            console.error("Error al consultar planilla semanal:", err);
            const tbody = document.getElementById("tablaSemanal");
            tbody.innerHTML = `<tr><td colspan="7">Error al cargar las planillas.</td></tr>`;
        });
}

function acomodarPlanillasSemanales(planillas) {
    const tbody = document.getElementById("tablaSemanal");
    tbody.innerHTML = "";

    if (!planillas || planillas.length === 0) {
        tbody.innerHTML = "<tr><td colspan='7'>No hay planillas semanales.</td></tr>";
        return;
    }

    planillas.forEach(p => {
        const tr = document.createElement("tr");

        // Columna Semana (ID o podría ser formato FechaInicio - FechaFin si lo incluyes)
        const tdSemana = document.createElement("td");
        tdSemana.textContent = p.idSemana;

        const tdOrdinarias = document.createElement("td");
        tdOrdinarias.textContent = p.horasOrdinarias;

        const tdExtra = document.createElement("td");
        tdExtra.textContent = p.horasExtra;

        const tdExtraDoble = document.createElement("td");
        tdExtraDoble.textContent = p.horasExtraDoble;

        // Columna Salario Bruto (clicable)
        const tdBruto = document.createElement("td");
        tdBruto.textContent = p.salarioBruto.toFixed(2);
        tdBruto.style.cursor = "pointer";
        tdBruto.style.color = "steelblue";
        tdBruto.onclick = () => {
            console.log("Clic en Salario Bruto:", p);
            // Aquí puedes ejecutar acciones adicionales con p.id, p.idSemana, etc.
        };

        // Columna Total Deducciones (clicable)
        const tdDeducciones = document.createElement("td");
        tdDeducciones.textContent = p.totalDeducciones.toFixed(2);
        tdDeducciones.style.cursor = "pointer";
        tdDeducciones.style.color = "darkred";
        tdDeducciones.onclick = () => {
            console.log("Clic en Total Deducciones:", p);
            // Acción específica para mostrar detalle de deducciones
        };

        const tdNeto = document.createElement("td");
        tdNeto.textContent = p.salarioNeto.toFixed(2);

        tr.appendChild(tdSemana);
        tr.appendChild(tdOrdinarias);
        tr.appendChild(tdExtra);
        tr.appendChild(tdExtraDoble);
        tr.appendChild(tdBruto);
        tr.appendChild(tdDeducciones);
        tr.appendChild(tdNeto);

        tbody.appendChild(tr);
    });
}




function consultarPlanillaMensual(idEmpleado, idPostByUser, postInIP) {
    fetch("https://localhost:5001/api/BDController/ConsultarPlanillaMensual", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
            idEmpleado: idEmpleado,
            idPostByUser: idPostByUser,
            PostInIP: postInIP,
            PostTime: new Date().toISOString()
        })
    })
        .then(resp => {
            if (!resp.ok) throw new Error("Error HTTP: " + resp.status);
            return resp.json();
        })
        .then(planillas => {
            acomodarPlanillasMensuales(planillas);
        })
        .catch(err => {
            console.error("Error al consultar planilla mensual:", err);
            const tbody = document.getElementById("tablaMensual");
            tbody.innerHTML = `<tr><td colspan="4">Error al cargar las planillas.</td></tr>`;
        });
}

function acomodarPlanillasMensuales(planillas) {
    const tbody = document.getElementById("tablaMensual");
    tbody.innerHTML = "";

    if (!planillas || planillas.length === 0) {
        tbody.innerHTML = "<tr><td colspan='4'>No hay planillas mensuales.</td></tr>";
        return;
    }

    planillas.forEach(pm => {
        const tr = document.createElement("tr");

        // Columna Mes (ID del mes)
        const tdMes = document.createElement("td");
        tdMes.textContent = pm.idMes;

        // Columna Salario Bruto (con acción al dar clic)
        const tdBruto = document.createElement("td");
        tdBruto.textContent = pm.salarioBruto.toFixed(2);
        tdBruto.style.cursor = "pointer";
        tdBruto.style.color = "steelblue";
        tdBruto.onclick = () => {
            console.log("Clic en Salario Bruto:", pm);
            // Aquí puedes ejecutar una acción específica
        };

        // Columna Total Deducciones (con acción al dar clic)
        const tdDeducciones = document.createElement("td");
        tdDeducciones.textContent = pm.totalDeducciones.toFixed(2);
        tdDeducciones.style.cursor = "pointer";
        tdDeducciones.style.color = "darkred";
        tdDeducciones.onclick = () => {
            console.log("Clic en Total Deducciones:", pm);
            // Aquí puedes ejecutar una acción específica
        };

        // Columna Salario Neto
        const tdNeto = document.createElement("td");
        tdNeto.textContent = pm.salarioNeto.toFixed(2);

        // Agregar todas las columnas a la fila
        tr.appendChild(tdMes);
        tr.appendChild(tdBruto);
        tr.appendChild(tdDeducciones);
        tr.appendChild(tdNeto);

        // Agregar fila a la tabla
        tbody.appendChild(tr);
    });
}


/*Le da formato a la fecha*/
function getCurrentDateTime() {
    const now = new Date();
    return now.toISOString(); // Returns ISO format that C# can parse
}

