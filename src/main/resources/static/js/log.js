document.addEventListener("DOMContentLoaded", async () => {
  const userDropdown = document.getElementById("userDropdown");
  const usernameDisplay = document.getElementById("usernameDisplay");

  if (!userDropdown) return;

  try {
    const response = await fetch("/api/usuario/autenticado");
    const data = await response.json();

    if (data.autenticado) {
      usernameDisplay.textContent = data.usuario;
      // Si está autenticado se activa el dropdown de perfil
      userDropdown.setAttribute("data-bs-toggle", "dropdown");
    } else {
      usernameDisplay.textContent = "Iniciar sesión";
      // Si no está autenticado se remueve el dropdown y se asigna el evento para abrir el modal de login
      userDropdown.removeAttribute("data-bs-toggle");
      userDropdown.addEventListener("click", e => {
        e.preventDefault();
        mostrarModalLogin();
      });
    }
  } catch (err) {
    usernameDisplay.textContent = "Iniciar sesión";
    userDropdown.removeAttribute("data-bs-toggle");
    userDropdown.addEventListener("click", e => {
      e.preventDefault();
      mostrarModalLogin();
    });
  }

  const urlParams = new URLSearchParams(window.location.search);
  const loginSuccess = urlParams.has("loginSuccess");
  const logoutSuccess = urlParams.has("logoutSuccess");
  const registerSuccess = urlParams.has("registerSuccess");
  const emailExists = urlParams.has("emailExists");
  const loginError = urlParams.has("loginError");

  const isPerfilPage = window.location.pathname.startsWith("/perfil");

  if (!isPerfilPage) {
    if (loginSuccess) {
      try {
        const res = await fetch("/api/usuario/autenticado");
        const data = await res.json();
        const nombre = data.usuario || "usuario";
        Swal.fire("Bienvenido", `¡Hola, ${nombre}!`, "success");
      } catch (err) {
        Swal.fire("Bienvenido", "¡Hola, usuario!", "success");
      }
    } else if (logoutSuccess) {
      Swal.fire("Sesión cerrada", "Has cerrado sesión con éxito", "info").then(async () => {
        try {
          const res = await fetch("/api/usuario/autenticado");
          const data = await res.json();
          if (!data.autenticado) {
            mostrarModalLogin();
          }
        } catch {
          mostrarModalLogin();
        }
      });
    } else if (registerSuccess) {
      Swal.fire("Registro exitoso", "Ahora inicia sesión para continuar", "success").then(() => {
        mostrarModalLogin();
      });
    } else if (emailExists) {
      Swal.fire("Error", "El correo ya está registrado", "error").then(() => {
        mostrarModalRegister();
      });
    } else if (loginError) {
      Swal.fire("Error", "Correo o contraseña incorrectos", "error").then(async () => {
        try {
          const res = await fetch("/api/usuario/autenticado");
          const data = await res.json();
          if (!data.autenticado) {
            mostrarModalLogin();
          }
        } catch {
          mostrarModalLogin();
        }
      });
    }
  }

  if (loginSuccess || logoutSuccess || registerSuccess || emailExists || loginError) {
    const cleanUrl = window.location.origin + window.location.pathname;
    window.history.replaceState({}, document.title, cleanUrl);
  }
});

function mostrarModalLogin() {
  const modalHTML = `
    <div class="modal fade" id="loginModal" tabindex="-1">
      <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content bg-dark text-white">
          <div class="modal-header">
            <h5 class="modal-title">Iniciar sesión</h5>
            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
          </div>
          <div class="modal-body">
            <form method="post" action="/login">
              <div class="mb-3">
                <label class="form-label">Correo</label>
                <input type="email" class="form-control" name="email" required />
              </div> 
              <div class="mb-3">
                <label class="form-label">Contraseña</label>
                <input type="password" class="form-control" name="password" required />
              </div>
              <button type="submit" class="btn btn-primary w-100">Ingresar</button>
            </form>
            <hr />
            <p class="text-center mt-3">¿No estás registrado?
              <a href="#" id="switchToRegister">¡Regístrate aquí!</a>
            </p>
          </div>
        </div>
      </div>
    </div>
  `;

  document.getElementById("loginModal")?.remove();
  const wrapper = document.createElement("div");
  wrapper.innerHTML = modalHTML;
  document.body.appendChild(wrapper.firstElementChild);
  const modal = new bootstrap.Modal(document.getElementById("loginModal"));
  modal.show();

  setTimeout(() => {
    document.getElementById("switchToRegister")?.addEventListener("click", e => {
      e.preventDefault();
      modal.hide();
      mostrarModalRegister();
    });
  }, 200);
}

function mostrarModalRegister() {
  const modalHTML = `
    <div class="modal fade" id="registerModal" tabindex="-1">
      <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content bg-dark text-white">
          <div class="modal-header">
            <h5 class="modal-title">Registrarse</h5>
            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
          </div>
          <div class="modal-body">
            <form id="registerForm" method="post" action="/register">
              <div class="mb-3">
                <label class="form-label">Nombre</label>
                <input type="text" class="form-control" name="nombre" required />
              </div>
              <div class="mb-3">
                <label class="form-label">Correo</label>
                <input type="email" class="form-control" name="email" required />
              </div>
              <div class="mb-3">
                <label class="form-label">Contraseña</label>
                <input type="password" class="form-control" name="password" id="password" required />
              </div>
              <div class="mb-3">
                <label class="form-label">Confirmar contraseña</label>
                <input type="password" class="form-control" name="password2" id="password2" required />
                <div id="passwordError" class="text-danger mt-1" style="display:none;">Las contraseñas no coinciden</div>
              </div>
              <button type="submit" class="btn btn-success w-100">Registrarse</button>
            </form>
            <hr />
            <p class="text-center mt-3">¿Ya estás registrado?
              <a href="#" id="switchToLogin">¡Inicia sesión aquí!</a>
            </p>
          </div>
        </div>
      </div>
    </div>
  `;

  document.getElementById("registerModal")?.remove();
  const wrapper = document.createElement("div");
  wrapper.innerHTML = modalHTML;
  document.body.appendChild(wrapper.firstElementChild);
  const modal = new bootstrap.Modal(document.getElementById("registerModal"));
  modal.show();

  setTimeout(() => {
    document.getElementById("switchToLogin")?.addEventListener("click", e => {
      e.preventDefault();
      modal.hide();
      mostrarModalLogin();
    });

    const form = document.getElementById("registerForm");
    form.addEventListener("submit", function (e) {
      const pass1 = document.getElementById("password").value;
      const pass2 = document.getElementById("password2").value;
      const errorDiv = document.getElementById("passwordError");
      let valid = true;
      let errorMsg = "";

      if (pass1.length < 6) {
        valid = false;
        errorMsg = "La contraseña debe tener al menos 6 caracteres";
      } else if (pass1 !== pass2) {
        valid = false;
        errorMsg = "Las contraseñas no coinciden";
      }

      if (!valid) {
        e.preventDefault();
        errorDiv.textContent = errorMsg;
        errorDiv.style.display = "block";
      } else {
        errorDiv.style.display = "none";
      }
    });
  }, 200);
}

function mostrarModalPerfil(nombre = "usuario") {
  const modalHTML = `
    <div class="modal fade" id="perfilModal" tabindex="-1">
      <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content bg-dark text-white">
          <div class="modal-header">
            <h5 class="modal-title">👤 Perfil</h5>
            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
          </div>
          <div class="modal-body text-center">
            <p>Hola, <strong>${nombre}</strong></p>
            <div class="d-flex justify-content-center gap-2">
              <form method="post" action="/logout">
                <button type="submit" class="btn btn-danger mt-2">Cerrar sesión</button>
              </form>
              <a href="/perfil" class="btn btn-info mt-2">Ver Perfil</a>
            </div>
          </div>
        </div>
      </div>
    </div>
  `;

  document.getElementById("perfilModal")?.remove();

  const wrapper = document.createElement("div");
  wrapper.innerHTML = modalHTML;
  document.body.appendChild(wrapper.firstElementChild);

  const modal = new bootstrap.Modal(document.getElementById("perfilModal"));
  modal.show();
}
