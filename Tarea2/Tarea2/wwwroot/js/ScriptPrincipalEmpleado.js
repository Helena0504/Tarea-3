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
function consultarPlanillaSemanal(idEmpleado, idPostByUser, ip, timestamp) {
    fetch('https://localhost:5001/api/BDController/ConsultarPlanillaSemanal', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
            idEmpleado: idEmpleado,
            idPostByUser: idPostByUser,
            PostInIP: ip,
            PostTime: timestamp || new Date().toISOString()
        })
    })
        .then(res => res.json())
        .then(data => {
            const tbody = document.querySelector("#tablaPlanillaSemanal");
            tbody.innerHTML = "";

            data.forEach(planilla => {
                const row = document.createElement("tr");

                row.innerHTML = `
                <td>${planilla.id}</td>
                <td>${planilla.horasOrdinarias}</td>
                <td>${planilla.horasExtra}</td>
                <td>${planilla.horasExtraDoble}</td>
                <td class="click-bruto" style="color:blue; cursor:pointer;">${planilla.salarioBruto.toFixed(2)}</td>
                <td>${planilla.salarioNeto.toFixed(2)}</td>
                <td class="click-deduccion" style="color:red; cursor:pointer;">${planilla.totalDeducciones.toFixed(2)}</td>
            `;

                row.querySelector(".click-bruto").addEventListener("click", () => {
                    alert("Salario Bruto clicado: " + planilla.salarioBruto);
                    // lógica adicional aquí...
                });

                row.querySelector(".click-deduccion").addEventListener("click", () => {
                    alert("Deducciones clicadas: " + planilla.totalDeducciones);
                    // lógica adicional aquí...
                });

                tbody.appendChild(row);
            });
        })
        .catch(err => console.error("Error al consultar planilla semanal:", err));
}



/*Le da formato a la fecha*/
function getCurrentDateTime() {
    const now = new Date();
    return now.toISOString(); // Returns ISO format that C# can parse
}

