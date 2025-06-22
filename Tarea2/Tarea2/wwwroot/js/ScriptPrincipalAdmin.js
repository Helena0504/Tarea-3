/*Variables Globales*/
let empleadoSeleccionado = null;
let filaSeleccionada = null;
var usuario = JSON.parse(localStorage.getItem('usuario'));
localStorage.setItem('usuario', JSON.stringify(usuario));
console.log('usuario: ', usuario);




/*Carga la tabla cuando se corre la pagina*/
document.addEventListener("DOMContentLoaded", function () {
    listarEmpleados(parseInt(usuario.id), "127.0.0.1", new Date().toISOString()); 
    console.log("Script se ha cargado correctamente");
});


/*Carga el filtro*/
document.addEventListener('DOMContentLoaded', function () {
    try {
        const button = document.getElementById('filtro');
        button.addEventListener('click', function () {
            const inFiltro = document.getElementById("inFiltro").value.trim();
            const numRegex = /^\d+$/;
            const letraRegex = /^[a-zA-Z\s\-]+$/;

            if (inFiltro === "") {
                listarEmpleados(parseInt(usuario.id), "127.0.0.1", new Date().toISOString()); 
            } else if (numRegex.test(inFiltro)) {
                filtrarEmpleado(inFiltro, 2, parseInt(usuario.id), "127.0.0.1", new Date().toISOString()); 
            } else if (letraRegex.test(inFiltro)) {
                filtrarEmpleado(inFiltro, 1, parseInt(usuario.id), "127.0.0.1", new Date().toISOString()); 
            } else {
                alert("El filtro por nombre tiene solo letras y el filtro por identificacion solo numeros");
                }
        });
    }
    catch {
        return (null);
    }
});


/*Va a la pantalla Editar Empleado*/
document.getElementById("actualizarBtn").addEventListener("click", () => {
    if (empleadoSeleccionado) {
        localStorage.setItem('empleado', JSON.stringify(empleadoSeleccionado));
        localStorage.setItem('usuario', JSON.stringify(usuario));
        window.location.href = 'ActualizarEmpleado.html';
    }
});



/*Va a la pantalla Insertar Empleado*/
document.getElementById("irInsertarEmpleado").addEventListener("click", () => {
    localStorage.setItem('usuario', JSON.stringify(usuario));
    window.location.href = 'InsertarEmpleado.html';
});


/*Llama a eliminar Empleados*/
document.getElementById("eliminarBtn").addEventListener("click", () => {
    if (empleadoSeleccionado) {
        if (confirm(`Seguro que deseas eliminar al empleado: ${empleadoSeleccionado.nombre} documento de identidad ${empleadoSeleccionado.valorDocumento}?`)) {
            eliminarEmpleado(empleadoSeleccionado.id, parseInt(usuario.id), "127.0.0.1", new Date().toISOString());
        } else {
            alert("Eliminacion cancelada.");
        }

    }
});


/*Impersona Empleado*/
document.getElementById("impersonarEmpleadoBtn").addEventListener("click", () => {
    if (empleadoSeleccionado) {
        localStorage.setItem('empleado', JSON.stringify(empleadoSeleccionado));
        localStorage.setItem('usuario', JSON.stringify(usuario));
        window.location.href = 'ActualizarEmpleado.html';
    }
});

/*Se hace logout*/
document.addEventListener('DOMContentLoaded', function () {
    try {
        const button = document.getElementById('logout');
        button.addEventListener('click', function () {
            //insertarBitacora(2, "", parseInt(usuario.id), "25.55.61.33", new Date())  HACER ALGO
            window.location.href = 'Login.html';
        });
    }
    catch {
        return (null);
    }
});





/*1. Listar Empleados*/
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
            const tbody = document.querySelector("#datosTabla");
            tbody.innerHTML = "";

            if (!datos || datos.length === 0) {
                const trInicio = document.createElement("tr");
                const tdNoData = document.createElement("td");
                tdNoData.colSpan = 5;
                tdNoData.textContent = "La tabla está vacía.";
                trInicio.appendChild(tdNoData);
                tbody.appendChild(trInicio);
            } else {
                console.log(datos);
                datos.forEach((empleado) => {
                    const trInicio = document.createElement("tr");

                    const tdNombre = document.createElement("td");
                    tdNombre.textContent = empleado.nombre || 'N/A';  
                    tdNombre.style.cursor = "pointer";
                    tdNombre.style.color = "steelblue";
                    tdNombre.style.textDecoration = "underline";

                    tdNombre.addEventListener("click", () => {
                        const currentBackground = window.getComputedStyle(tdNombre).backgroundColor;

                        if (filaSeleccionada && filaSeleccionada !== tdNombre) {
                            filaSeleccionada.style.backgroundColor = "#ffffff";
                        }

                        if (currentBackground === "rgb(187, 190, 191)") {
                            tdNombre.style.backgroundColor = "#ffffff";
                            empleadoSeleccionado = null;
                            filaSeleccionada = null;
                        } else {
                            tdNombre.style.backgroundColor = "#bbbebf";
                            empleadoSeleccionado = empleado;
                            filaSeleccionada = tdNombre;
                        }
                        actualizarBotones();
                    });
                    trInicio.appendChild(tdNombre);

                    const tdPuesto = document.createElement("td");
                    tdPuesto.textContent = empleado.puestoNombre || 'N/A';  
                    trInicio.appendChild(tdPuesto);

                    tbody.appendChild(trInicio);
                });
            }
        })
        .catch(error => {
            console.error("Error al cargar empleados:", error);
            const tbody = document.querySelector("#datosTabla");
            tbody.innerHTML = `<tr><td colspan="5">Error al cargar los datos</td></tr>`;
        });
}


/*2. Listar Empleados con Filtro*/
function filtrarEmpleado(busqueda, tipo, idPostByUser, PostInIP, PostTime) {
    fetch('https://localhost:5001/api/BDController/FiltrarEmpleados', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            inBusqueda: busqueda,
            inTipo: tipo,
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
            const tbody = document.querySelector("#datosTabla");
            tbody.innerHTML = "";

            if (!datos || datos.length === 0) {
                const trInicio = document.createElement("tr");
                const tdNoData = document.createElement("td");
                tdNoData.colSpan = 5;
                tdNoData.textContent = "La tabla está vacía.";
                trInicio.appendChild(tdNoData);
                tbody.appendChild(trInicio);
            } else {
                console.log(datos);
                datos.forEach((empleado) => {
                    const trInicio = document.createElement("tr");

                    const tdNombre = document.createElement("td");
                    tdNombre.textContent = empleado.nombre || 'N/A';
                    tdNombre.style.cursor = "pointer";
                    tdNombre.style.color = "steelblue";
                    tdNombre.style.textDecoration = "underline";

                    tdNombre.addEventListener("click", () => {
                        const currentBackground = window.getComputedStyle(tdNombre).backgroundColor;

                        if (filaSeleccionada && filaSeleccionada !== tdNombre) {
                            filaSeleccionada.style.backgroundColor = "#ffffff";
                        }

                        if (currentBackground === "rgb(187, 190, 191)") {
                            tdNombre.style.backgroundColor = "#ffffff";
                            empleadoSeleccionado = null;
                            filaSeleccionada = null;
                        } else {
                            tdNombre.style.backgroundColor = "#bbbebf";
                            empleadoSeleccionado = empleado;
                            filaSeleccionada = tdNombre;
                        }
                        actualizarBotones();
                    });
                    trInicio.appendChild(tdNombre);

                    const tdPuesto = document.createElement("td");
                    tdPuesto.textContent = empleado.puestoNombre || 'N/A';
                    trInicio.appendChild(tdPuesto);

                    tbody.appendChild(trInicio);
                });
            }
        })
        .catch(error => {
            console.log("No se muestra la tabla.");
            console.error(error);
        });
}






/*5. Eliminar empleado*/
const eliminarEmpleado = (id, idPostByUser, PostInIP, PostTime) => {
        fetch('https://localhost:5001/api/BDController/EliminarEmpleado', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                id: id,
                idPostByUser: idPostByUser,
                PostInIP: PostInIP,
                PostTime: PostTime || new Date().toISOString()
            })
        })
        .then(respuesta => {
            if (!respuesta.ok) {
                return respuesta.json().then(errorDetails => {
                    console.log("Codigo de error:", errorDetails.codigoError);
                    console.log("Mensaje de error:", errorDetails.message);
                    throw new Error(`Error: ${errorDetails.message} - Codigo de error: ${errorDetails.codigoError}`);
                });
            }
            return respuesta.json();
        })
        .then(datos => {
            alert("Empleado eliminado exitosamente");
            listarEmpleados(parseInt(usuario.id), "127.0.0.1", new Date().toISOString()); 
        })
        .catch((error) => {
            console.error("Error al intentar eliminar el empleado:", error);
            alert(error.message);
        });
}



/*Le da formato a la fecha*/
function getCurrentDateTime() {
    const now = new Date();
    return now.toISOString(); // Returns ISO format that C# can parse
}


/*Actualiza botones*/
function actualizarBotones() {
    if (empleadoSeleccionado) {
        document.getElementById("actualizarBtn").disabled = false;
        document.getElementById("eliminarBtn").disabled = false;
        document.getElementById("impersonarEmpleadoBtn").disabled = false;
    } else {
        document.getElementById("actualizarBtn").disabled = true;
        document.getElementById("eliminarBtn").disabled = true;
        document.getElementById("impersonarEmpleadoBtn").disabled = true;
    }
}