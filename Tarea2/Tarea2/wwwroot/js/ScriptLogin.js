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
                verificarUsuario(username, password, 0, "127.0.0.1", new Date().toISOString());
            });
        }
    } catch (error) {
        console.error("Error con login button:", error);
    }
});


/*Auxiliares*/
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
        .then(respuesta => {
            if (!respuesta.ok) {
                throw new Error(`Error HTTP: ${respuesta.status}`);
            }
            return respuesta.json();
        })
        .then(datos => {
            if (datos === null) {
                document.getElementById('hacerLogin').disabled = false;
                alert("Error al intentar iniciar sesión: " + error.message);
            } else {
                console.log(datos);
                localStorage.setItem('usuario', JSON.stringify(datos));
                document.getElementById('hacerLogin').disabled = false;

                alert("¡Login exitoso! Bienvenido " + datos.username);
                if (datos.tipo = 1) {
                    window.location.href = 'PrincipalAdmin.html';
                }
                else {
                    window.location.href = 'PrincipalEmplea.html';
                
                };
            }
        })
        .catch(error => {
            document.getElementById('hacerLogin').disabled = false;
            console.error("Error en login:", error);
            alert("Error al intentar iniciar sesión: " + error.message);
        });
}


