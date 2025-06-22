/* Variables Globales */
let filaSeleccionada = null;
var usuario = JSON.parse(localStorage.getItem('usuario'));
localStorage.setItem('usuario', JSON.stringify(usuario));
console.log('usuario: ', usuario);

let empleado = null; //

/* Carga cuando se corre la página */
document.addEventListener("DOMContentLoaded", function () {
    listarEmpleados(parseInt(usuario.id), "127.0.0.1", new Date().toISOString());
    if (parseInt(usuario.tipo) === 2) {
        document.getElementById('RegresarAdmin').style.display = 'none';
    }
    else {
        empleado = JSON.parse(localStorage.getItem('empleado'));
        document.getElementById('logout').style.display = 'none';
    }
    if (empleado && empleado.nombre) {
        document.getElementById("tituloPlanillas").textContent = `Planillas Empleado ${empleado.nombre}`;
    }
    console.log("Script se ha cargado correctamente");
});

/* Boton Planilla Semanal */
document.addEventListener('DOMContentLoaded', function () {
    try {
        const button = document.getElementById('PlanillaSemanal');
        button.addEventListener('click', function () {
            document.getElementById('tablaSemanalContainer').style.display = 'table';
            document.getElementById('tablaMensualContainer').style.display = 'none';
            consultarPlanillaSemanal(parseInt(empleado.id), parseInt(usuario.id), "127.0.0.1");
        });
    } catch {
        return null;
    }
});


/* Boton Planilla Mensual */
document.addEventListener('DOMContentLoaded', function () {
    try {
        const button = document.getElementById('PlanillaMensual');
        button.addEventListener('click', function () {
            document.getElementById('tablaSemanalContainer').style.display = 'none';
            document.getElementById('tablaMensualContainer').style.display = 'table';
            consultarPlanillaMensual(parseInt(empleado.id), parseInt(usuario.id), "127.0.0.1");
        });
    } catch {
        return null;
    }
});


/* Regresar a Admin */
document.addEventListener('DOMContentLoaded', function () {
    try {
        const button = document.getElementById('RegresarAdmin');
        button.addEventListener('click', function () {
            localStorage.setItem('usuario', JSON.stringify(usuario));
            window.location.href = 'PrincipalAdmin.html';
        });
    } catch {
        return null;
    }
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
            if (empleado && empleado.nombre) {
                document.getElementById("tituloPlanillas").textContent = `Planillas Empleado ${empleado.nombre}`;
            }
            consultarPlanillaSemanal(parseInt(empleado.id), parseInt(usuario.id), "127.0.0.1");
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
        tbody.innerHTML = "<tr><td colspan='8'>No hay planillas semanales.</td></tr>";
        return;
    }

    planillas.forEach(p => {
        const tr = document.createElement("tr");

        // Columna Semana (FechaInicio - FechaFin)
        const tdSemana = document.createElement("td");
        tdSemana.innerHTML = `Inicio: ${new Date(p.fechaInicio).toLocaleDateString()}<br>Fin: ${new Date(p.fechaFin).toLocaleDateString()}`;

        const tdOrdinarias = document.createElement("td");
        tdOrdinarias.textContent = p.horasOrdinarias;

        const tdExtra = document.createElement("td");
        tdExtra.textContent = p.horasExtra;

        const tdExtraDoble = document.createElement("td");
        tdExtraDoble.textContent = p.horasExtraDoble;

        const tdBruto = document.createElement("td");
        tdBruto.textContent = p.salarioBruto.toFixed(2);
        tdBruto.style.cursor = "pointer";
        tdBruto.onclick = () => {
            localStorage.setItem("idPlanillaSeleccionada", p.id);
            console.log("idPlanillaSeleccionada guardado:", p.id);
            localStorage.setItem("empleado", JSON.stringify(empleado));
            localStorage.setItem('usuario', JSON.stringify(usuario));
            window.location.href = "Movimientos.html";
        };

        const tdDeducciones = document.createElement("td");
        tdDeducciones.textContent = p.totalDeducciones.toFixed(2);
        tdDeducciones.style.cursor = "pointer";
        tdDeducciones.onclick = () => {
            console.log("Clic en Total Deducciones:", p);
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

        // Nueva columna: Fecha Inicio / Fin del mes
        const tdMes = document.createElement("td");
        tdMes.innerHTML = `Inicio: ${new Date(pm.fechaInicio).toLocaleDateString()}<br>Fin: ${new Date(pm.fechaFin).toLocaleDateString()}`;

        // Columna Salario Bruto (clicable)
        const tdBruto = document.createElement("td");
        tdBruto.textContent = pm.salarioBruto.toFixed(2);
        tdBruto.style.cursor = "pointer";

        // Columna Total Deducciones (clicable)
        const tdDeducciones = document.createElement("td");
        tdDeducciones.textContent = pm.totalDeducciones.toFixed(2);
        tdDeducciones.style.cursor = "pointer";
        tdDeducciones.onclick = () => {
            console.log("Clic en Total Deducciones:", pm);
        };

        // Columna Salario Neto
        const tdNeto = document.createElement("td");
        tdNeto.textContent = pm.salarioNeto.toFixed(2);

        // Agregar columnas a la fila
        tr.appendChild(tdMes);
        tr.appendChild(tdBruto);
        tr.appendChild(tdDeducciones);
        tr.appendChild(tdNeto);

        tbody.appendChild(tr);
    });
}




/*Le da formato a la fecha*/
function getCurrentDateTime() {
    const now = new Date();
    return now.toISOString(); // Returns ISO format that C# can parse
}

