document.addEventListener("DOMContentLoaded", function () {
    console.log("Cargando datos");
    //CargarDatos();
    console.log("Datos Cargados");

    try {
        const button = document.getElementById('hacerLogin');
        if (button) {
            button.addEventListener('click', function () {
                this.disabled = true;
                const username = document.getElementById("usuario").value.trim();
                const password = document.getElementById("contraseña").value.trim();

                // Add basic validation
                if (!username || !password) {
                    alert("Por favor ingrese usuario y contraseña");
                    this.disabled = false;
                    return;
                }

                verificarUsuario(username, password, 0, "127.0.0.1", new Date().toISOString());
            });
        }
    } catch (error) {
        console.error("Error con login button:", error);
    }
});

function verificarUsuario(username, password, idPostByUser, PostInIP, PostTime) {
    fetch('https://localhost:5001/api/BDController/VerificarUsuario', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            Username: username,
            Password: password,
            idPostByUser: idPostByUser,
            PostInIP: PostInIP,
            PostTime: PostTime || new Date().toISOString()
        })
    })
        .then(async respuesta => {
            const textoRespuesta = await respuesta.text();  // lee la respuesta como texto plano
            console.log('Respuesta texto:', textoRespuesta); // para ver qué hay en la respuesta

            if (!respuesta.ok) {
                // Si no es OK, lanza error con texto (si hay)
                throw new Error(textoRespuesta || `Error HTTP: ${respuesta.status}`);
            }

            if (!textoRespuesta) {
                throw new Error('Respuesta vacía del servidor');
            }

            // Intenta parsear el JSON solo si no está vacío
            try {
                return JSON.parse(textoRespuesta);
            } catch (e) {
                throw new Error('Respuesta no es JSON válido: ' + e.message);
            }
        })


        .then(datos => {
            if (!datos) {
                throw new Error("Respuesta vacía del servidor");
            }
            localStorage.setItem('usuario', JSON.stringify(datos));
            document.getElementById('hacerLogin').disabled = false;

            alert("¡Login exitoso! Bienvenido " + datos.username);

            // Fixed assignment (=) to comparison (===)
            if (datos.tipo === 1) {
                window.location.href = 'PrincipalAdmin.html';
            } else {
                window.location.href = 'PrincipalEmplea.html';
            }
        })
        .catch(error => {
            document.getElementById('hacerLogin').disabled = false;
            console.error("Error en login:", error);
            alert("Error al intentar iniciar sesión: " + error.message);
        });
}

