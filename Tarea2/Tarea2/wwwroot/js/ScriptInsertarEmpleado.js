﻿
var usuario = JSON.parse(localStorage.getItem('usuario'));


/*Variables Globales, cargado de datos inicial*/
document.addEventListener("DOMContentLoaded", function () {
    mostrarPuestos();
    mostrarDepartamentos();
    mostrarTiposDocumento();
});


/*Llamar a editar empleado*/

document.getElementById('accionInsertar').addEventListener('click', function () {
    this.disabled = true;
    document.getElementById('regresarInsertarVista').disabled = true;

    const nombre = document.getElementById('nombre').value.trim();
    const docId = document.getElementById('docId').value.trim();
    const puesto = document.getElementById('puesto').value;
    const departamento = document.getElementById('departamento').value;
    const tipoDocumento = document.getElementById('tipoDocumento').value;
    const fechaNacimiento = document.getElementById('fechaNacimiento').value;

    if (!validarCampos(nombre, docId, puesto, departamento, tipoDocumento, fechaNacimiento)) {
        this.disabled = false;
        document.getElementById('regresarInsertarVista').disabled = false;
        return;
    }

    insertarEmpleado(
        nombre,
        parseInt(tipoDocumento),
        docId,
        fechaNacimiento,
        parseInt(puesto),
        parseInt(departamento)
    );
});

document.getElementById('regresarInsertarVista').addEventListener('click', function () {
    window.location.href = 'PrincipalAdmin.html';
});



/*4. Insertar Empleado*/

const insertarEmpleado = (nombre, idTipoDocumento, valorDocumento, fechaNacimiento, idPuesto, idDepartamento) => {
    const usuario = JSON.parse(localStorage.getItem('usuario'));
    const postTime = new Date().toISOString();

    fetch('https://localhost:5001/api/BDController/InsertarEmpleado', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            idPostByUser: usuario.id,
            PostInIP: "25.55.61.33",
            PostTime: postTime,
            Nombre: nombre,
            idTipoDocumento: parseInt(idTipoDocumento),
            ValorDocumento: valorDocumento,
            FechaNacimiento: fechaNacimiento,
            idPuesto: parseInt(idPuesto),
            idDepartamento: parseInt(idDepartamento)
        })
    })
        .then(response => {
            if (!response.ok) {
                return response.json().then(error => {
                    console.error("Error del servidor:", error);
                    throw new Error(error.message || "Error al insertar empleado");
                });
            }
            return response.json();
        })
        .then(data => {
            if (data === 0) {
               
                alert("Empleado insertado exitosamente");
                window.location.href = 'PrincipalAdmin.html';
            } else {
                throw new Error(`Error del servidor: Código ${data}`);
            }
        })
        .catch(error => {
            console.error("Ya existe un empleado con este nombre o documento de identidad");
            alert(error.message);
        })
        .finally(() => {
            document.getElementById('accionInsertar').disabled = false;
            document.getElementById('regresarInsertarVista').disabled = false;
        });
};

/*Auxiliares*/

/*Validar el formato de los campos*/
function validarCampos(nombre, docId, idPuesto, idDepartamento, idTipoDocumento, fechaNacimiento) {
    if (!nombre || nombre.trim() === '') {
        alert("El nombre no puede estar vacío");
        return false;
    }

    if (!/^[a-zA-Z\s\-]+$/.test(nombre)) {
        alert("El nombre solo puede contener letras, espacios y guiones");
        return false;
    }

    if (!docId || docId.trim() === '') {
        alert("El documento de identidad no puede estar vacío");
        return false;
    }

    if (!/^[\d-]{7,11}$/.test(docId)) {
        alert("El documento debe tener entre 7 y 11 dígitos numéricos");
        return false;
    }

    if (!idPuesto || idPuesto === '') {
        alert("Debe seleccionar un puesto");
        return false;
    }

    if (!idDepartamento || idDepartamento === '') {
        alert("Debe seleccionar un departamento");
        return false;
    }

    if (!idTipoDocumento || idTipoDocumento === '') {
        alert("Debe seleccionar un tipo de documento");
        return false;
    }

    if (!fechaNacimiento) {
        alert("Debe ingresar una fecha de nacimiento");
        return false;
    }

    if (isNaN(new Date(fechaNacimiento).getTime())) {
        alert("La fecha de nacimiento no tiene un formato válido");
        return false;
    }

    return true;
}

/*Seleccion de puestos*/
function mostrarPuestos() {
    fetch('https://localhost:5001/api/BDController/ListarPuestos')
        .then(response => response.json())
        .then(data => {
            const select = document.getElementById("puesto");
            select.innerHTML = '<option value="">Seleccione un puesto</option>';
            data.forEach(item => {
                const option = document.createElement("option");
                option.value = item.id;
                option.textContent = item.nombre;
                
                select.appendChild(option);
            });
        });
}


/*Seleccion de departamentos*/
function mostrarDepartamentos() {
    fetch('https://localhost:5001/api/BDController/ListarDepartamentos')
        .then(response => response.json())
        .then(data => {
            const select = document.getElementById("departamento");
            select.innerHTML = '<option value="">Seleccione un departamento</option>';
            data.forEach(item => {
                const option = document.createElement("option");
                option.value = item.id;
                option.textContent = item.nombre;
                
                select.appendChild(option);
            });
        });
}



/*Seleccion de tipo de documento*/
function mostrarTiposDocumento() {
    fetch('https://localhost:5001/api/BDController/ListarTipoDocIds')
        .then(response => response.json())
        .then(data => {
            const select = document.getElementById("tipoDocumento");
            select.innerHTML = '<option value="">Seleccione un tipo</option>';
            data.forEach(item => {
                const option = document.createElement("option");
                option.value = item.id;
                option.textContent = item.nombre;
                
                select.appendChild(option);
            });
        });
}


