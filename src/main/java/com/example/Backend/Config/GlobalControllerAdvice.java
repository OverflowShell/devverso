package com.example.Backend.Config;

import com.example.Backend.Entidad.Usuario;
import com.example.Backend.Servicio.UsuarioService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

@ControllerAdvice
public class GlobalControllerAdvice {

    @Autowired
    private UsuarioService userService;

    @ModelAttribute("usuario")
    public Usuario getUsuarioActual(HttpSession session) {
        String email = (String) session.getAttribute("usuarioActual");
        if(email != null){
            return userService.getByEmail(email).orElse(null);
        }
        return null;
    }
}
