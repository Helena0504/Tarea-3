document.addEventListener("DOMContentLoaded", function () {
    var empleado = JSON.parse(localStorage.getItem('empleado'));
    var usuario = JSON.parse(localStorage.getItem('usuario'));

    document.getElementById('docId').value = empleado.valorDocumento.trim();
    document.getElementById('nombre').value = empleado.nombre.trim();
    document.getElementById('fechaNacimiento').value = empleado.fechaNacimiento.split('T')[0];

    mostrarPuestos();
    mostrarDepartamentos();
    mostrarTiposDocumento();
});

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

    const empleado = JSON.parse(localStorage.getItem('empleado'));
    updateEmpleado(
        empleado.id,
        nombre,
        parseInt(tipoDocumento),
        docId,
        fechaNacimiento,
        parseInt(puesto),
        parseInt(departamento)
    );
});

document.getElementById('regresarInsertarVista').addEventListener('click', function () {
    window.location.href = 'VistaUsuario.html';
});

function validarCampos(nombre, docId, puesto, departamento, tipoDocumento, fechaNacimiento) {
    const nameRegex = /^[a-zA-Z\s\-]+$/;
    const docRegex = /^\d{7,9}$/;

    if (!nombre || !nameRegex.test(nombre)) {
        alert("Nombre no válido");
        return false;
    }
    if (!docId || !docRegex.test(docId)) {
        alert("Documento no válido");
        return false;
    }
    if (!puesto) {
        alert("Seleccione un puesto");
        return false;
    }
    if (!departamento) {
        alert("Seleccione un departamento");
        return false;
    }
    if (!tipoDocumento) {
        alert("Seleccione un tipo de documento");
        return false;
    }
    if (!fechaNacimiento) {
        alert("Fecha de nacimiento requerida");
        return false;
    }
    return true;
}

function mostrarPuestos() {
    fetch('https://localhost:5001/api/BDController/MostrarPuestoControlador')
        .then(response => response.json())
        .then(data => {
            const select = document.getElementById("puesto");
            select.innerHTML = '<option value="">Seleccione un puesto</option>';
            data.forEach(item => {
                const option = document.createElement("option");
                option.value = item.id;
                option.textContent = item.nombre;
                if (item.id === empleado.idPuesto) option.selected = true;
                select.appendChild(option);
            });
        });
}

function mostrarDepartamentos() {
    fetch('https://localhost:5001/api/BDController/MostrarDepartamentoControlador')
        .then(response => response.json())
        .then(data => {
            const select = document.getElementById("departamento");
            select.innerHTML = '<option value="">Seleccione un departamento</option>';
            data.forEach(item => {
                const option = document.createElement("option");
                option.value = item.id;
                option.textContent = item.nombre;
                if (item.id === empleado.idDepartamento) option.selected = true;
                select.appendChild(option);
            });
        });
}

function mostrarTiposDocumento() {
    fetch('https://localhost:5001/api/BDController/MostrarTipoDocControlador')
        .then(response => response.json())
        .then(data => {
            const select = document.getElementById("tipoDocumento");
            select.innerHTML = '<option value="">Seleccione un tipo</option>';
            data.forEach(item => {
                const option = document.createElement("option");
                option.value = item.id;
                option.textContent = item.nombre;
                if (item.id === empleado.idTipoDocumento) option.selected = true;
                select.appendChild(option);
            });
        });
}

const updateEmpleado = (id, nombre, tipoDocumento, valorDocumento, fechaNacimiento, puesto, departamento) => {
    const empleado = JSON.parse(localStorage.getItem('empleado'));
    const usuario = JSON.parse(localStorage.getItem('usuario'));

    fetch('https://localhost:5001/api/BDController/UpdateControlador', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
            id: id,
            Nombre: nombre,
            TipoDocumento: tipoDocumento,
            ValorDocumento: valorDocumento,
            FechaNacimiento: fechaNacimiento,
            Puesto: puesto,
            Departamento: departamento,
            IdUsuario: usuario.id,
            IP: "25.55.61.33"
        })
    })
        .then(response => response.json())
        .then(data => {
            insertarBitacora(8, `Empleado actualizado: ${nombre}`, usuario.id, "25.55.61.33", new Date());
            alert("Empleado actualizado exitosamente");
            window.location.href = 'VistaUsuario.html';
        })
        .catch(error => {
            console.error("Error:", error);
            insertarBitacora(7, `Error al actualizar empleado: ${nombre}`, usuario.id, "25.55.61.33", new Date());
            alert("Error al actualizar empleado");
        })
        .finally(() => {
            document.getElementById('accionInsertar').disabled = false;
            document.getElementById('regresarInsertarVista').disabled = false;
        });
};