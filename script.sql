-- Crear base de datos
CREATE DATABASE rest_api_db 
  DEFAULT CHARACTER SET utf8mb4 
  COLLATE utf8mb4_unicode_ci;

-- Usar la base de datos
USE rest_api_db;

-- Tabla: Usuario (solo rol de estudiante)
CREATE TABLE usuario (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(50) NOT NULL DEFAULT 'ROLE_ESTUDIANTE',
    INDEX idx_usuario_email (email)
) ENGINE=InnoDB;

-- Tabla: Categoria
CREATE TABLE categoria (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    INDEX idx_categoria_nombre (nombre)
) ENGINE=InnoDB;

-- Tabla: Curso (con datos del profesor como texto y JSON para temario/aprendizajes/publico)
CREATE TABLE curso (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(255) NOT NULL,
    descripcion TEXT,
    fecha DATE, -- Puedes dejar como DATE o VARCHAR si prefieres fechas en formato "FEB 2025"
    duracion VARCHAR(50),
    nivel VARCHAR(50),
    precio DECIMAL(10,2),
    imagen VARCHAR(255),
    categoria_id BIGINT,
    profesor_nombre VARCHAR(100) NOT NULL, -- 🔹 Nombre del profesor directamente en el curso
    -- Campos JSON para datos dinámicos
    temario JSON,        -- JSON con temario y contenido
    aprendizajes JSON,  -- JSON array de aprendizajes
    publico JSON,       -- JSON array de público objetivo
    INDEX idx_curso_categoria (categoria_id),
    FOREIGN KEY (categoria_id) REFERENCES categoria(id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- Tabla: Compra (nueva para registrar cursos comprados)
CREATE TABLE compra (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    usuario_id BIGINT,
    curso_id BIGINT,
    fecha_compra DATE,
    estado VARCHAR(50) DEFAULT 'completado',
    INDEX idx_compra_usuario (usuario_id),
    INDEX idx_compra_curso (curso_id),
    FOREIGN KEY (usuario_id) REFERENCES usuario(id) ON DELETE CASCADE,
    FOREIGN KEY (curso_id) REFERENCES curso(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Insertar categorías
INSERT INTO categoria (nombre) VALUES 
('Backend'), 
('Programación'), 
('Frontend'), 
('Diseño Web'), 
('Herramientas de Desarrollo');

-- Curso 1: Curso de Java
INSERT INTO curso (
    id, nombre, descripcion, fecha, duracion, nivel, precio, imagen, 
    categoria_id, profesor_nombre, 
    temario, aprendizajes, publico
) VALUES (
    1,
    'Curso de Java',
    'Aprende programación orientada a objetos y desarrollo backend con Java.',
    '2025-02-01',
    '10 horas',
    'Intermedio',
    30.00,
    '/img/curso-java.jpg',
    1, -- categoria_id = Backend
    'Andres Sacco 🇦🇷',
    '[{"titulo": "1. Introducción a Java", "descripcion": "Comienza tu camino en el mundo de Java: conceptos básicos y configuración del entorno.", "contenido": [{"titulo": "1.1 - Instalación de JDK", "duracion": "08:00"}, {"titulo": "1.2 - Primera aplicación en Java", "duracion": "10:00"}, {"titulo": "1.3 - Variables y tipos de datos", "duracion": "12:00"}]}, {"titulo": "2. Programación Orientada a Objetos", "descripcion": "Aprende los fundamentos de la POO en Java.", "contenido": [{"titulo": "2.1 - Clases y objetos", "duracion": "15:00"}, {"titulo": "2.2 - Herencia y polimorfismo", "duracion": "20:00"}, {"titulo": "2.3 - Interfaces y abstracción", "duracion": "18:00"}]}]',
    '["Dominarás la sintaxis básica de Java y sus estructuras de control.", "Crearás aplicaciones backend robustas utilizando frameworks como Spring Boot.", "Implementarás pruebas unitarias con JUnit y Mockito."]',
    '["Desarrolladores backend o estudiantes interesados en aprender Java desde cero."]'
);

-- Curso 2: Curso de Python
INSERT INTO curso (
    id, nombre, descripcion, fecha, duracion, nivel, precio, imagen, 
    categoria_id, profesor_nombre, 
    temario, aprendizajes, publico
) VALUES (
    2,
    'Curso de Python',
    'Introducción a la programación con Python: desde lo básico hasta proyectos prácticos.',
    '2025-03-01',
    '5 horas',
    'Básico',
    15.00,
    '/img/python-curso-gratis.jpg',
    2, -- categoria_id = Programación
    'Laura Gómez 🇨🇴',
    '[{"titulo": "1. Introducción al curso", "descripcion": "Probando el manejo de reservas de una compañía aérea", "contenido": [{"titulo": "1.1 - Instalación de Python", "duracion": "09:01"}, {"titulo": "1.2 - Probando el manejo de reservas de una compañía aérea", "duracion": "10:36"}, {"titulo": "1.3 - ¿Qué es una prueba unitaria?", "duracion": "12:02"}]}]',
    '["Dominarás sintaxis básica, estructuras de control y manejo de datos.", "Crearás scripts y pequeñas aplicaciones funcionales.", "Introducirás conceptos de programación orientada a objetos."]',
    '["Desarrolladores backend o estudiantes interesados en aprender Python desde cero."]'
);

-- Curso 3: Curso de JavaScript
INSERT INTO curso (
    id, nombre, descripcion, fecha, duracion, nivel, precio, imagen, 
    categoria_id, profesor_nombre, 
    temario, aprendizajes, publico
) VALUES (
    3,
    'Curso de JavaScript',
    'Domina el lenguaje de programación más utilizado en el desarrollo web.',
    '2025-04-01',
    '8 horas',
    'Intermedio',
    25.00,
    '/img/curso-js.jpg',
    3, -- categoria_id = Frontend
    'Carlos Rivas 🇲🇽',
    '[{"titulo": "1. Fundamentos de JavaScript", "descripcion": "Conceptos básicos del lenguaje y su integración con HTML/CSS.", "contenido": [{"titulo": "1.1 - Variables y tipos de datos", "duracion": "10:00"}, {"titulo": "1.2 - Funciones y eventos", "duracion": "12:00"}, {"titulo": "1.3 - Manipulación del DOM", "duracion": "15:00"}]}, {"titulo": "2. JavaScript Avanzado", "descripcion": "Conceptos avanzados para desarrollar aplicaciones modernas.", "contenido": [{"titulo": "2.1 - Closures y scope", "duracion": "18:00"}, {"titulo": "2.2 - Promesas y async/await", "duracion": "20:00"}, {"titulo": "2.3 - Trabajando con APIs", "duracion": "22:00"}]}]',
    '["Comprenderás los fundamentos de JavaScript y su uso en el navegador.", "Aprenderás a manipular el DOM y crear interacciones dinámicas.", "Explorarás conceptos avanzados como closures y promesas."]',
    '["Desarrolladores frontend o estudiantes interesados en aprender JavaScript desde cero."]'
);

-- Curso 4: Curso de CSS
INSERT INTO curso (
    id, nombre, descripcion, fecha, duracion, nivel, precio, imagen, 
    categoria_id, profesor_nombre, 
    temario, aprendizajes, publico
) VALUES (
    4,
    'Curso de CSS',
    'Aprende a diseñar interfaces modernas y responsivas con CSS.',
    '2025-06-01',
    '6 horas',
    'Básico',
    20.00,
    '/img/curso-css.jpg',
    4, -- categoria_id = Diseño Web
    'Ana Torres 🇪🇸',
    '[{"titulo": "1. Fundamentos de CSS", "descripcion": "Selectores, propiedades y diseño responsive.", "contenido": [{"titulo": "1.1 - Selectores y propiedades", "duracion": "10:00"}, {"titulo": "1.2 - Diseño responsive", "duracion": "15:00"}, {"titulo": "1.3 - Flexbox y Grid", "duracion": "20:00"}]}, {"titulo": "2. Animaciones y transiciones", "descripcion": "Mejora la experiencia de usuario con animaciones.", "contenido": [{"titulo": "2.1 - Transiciones simples", "duracion": "12:00"}, {"titulo": "2.2 - Animaciones complejas", "duracion": "18:00"}, {"titulo": "2.3 - Frameworks CSS", "duracion": "22:00"}]}]',
    '["Dominarás selectores, propiedades y diseño responsive.", "Crearás animaciones y transiciones para mejorar la experiencia de usuario.", "Implementarás frameworks CSS como Bootstrap para agilizar el desarrollo."]',
    '["Desarrolladores frontend o estudiantes interesados en aprender CSS desde cero."]'
);

-- Curso 5: Curso de HTML
INSERT INTO curso (
    id, nombre, descripcion, fecha, duracion, nivel, precio, imagen, 
    categoria_id, profesor_nombre, 
    temario, aprendizajes, publico
) VALUES (
    5,
    'Curso de HTML',
    'Aprende los fundamentos del lenguaje de marcado HTML para crear sitios web.',
    '2025-08-01',
    '4 horas',
    'Básico',
    10.00,
    '/img/curso-html.jpg',
    4, -- categoria_id = Diseño Web
    'Mario López 🇵🇪',
    '[{"titulo": "1. Fundamentos de HTML", "descripcion": "Etiquetas básicas y estructura de documentos HTML.", "contenido": [{"titulo": "1.1 - Etiquetas básicas", "duracion": "08:00"}, {"titulo": "1.2 - Formularios y tablas", "duracion": "10:00"}, {"titulo": "1.3 - Semántica HTML", "duracion": "12:00"}]}]',
    '["Dominarás etiquetas básicas y estructura de documentos HTML.", "Crearás formularios y tablas para recopilar datos.", "Implementarás semántica HTML para mejorar la accesibilidad."]',
    '["Desarrolladores frontend o estudiantes interesados en aprender HTML desde cero."]'
);

-- Curso 6: Curso de React JS
INSERT INTO curso (
    id, nombre, descripcion, fecha, duracion, nivel, precio, imagen, 
    categoria_id, profesor_nombre, 
    temario, aprendizajes, publico
) VALUES (
    6,
    'Curso de React JS',
    'Aprende a construir interfaces dinámicas y reutilizables con React JS.',
    '2025-09-01',
    '8 horas',
    'Intermedio',
    25.00,
    '/img/curso-react.jpg',
    3, -- categoria_id = Frontend
    'Laura Gómez 🇨🇴',
    '[{"titulo": "1. Fundamentos de React", "descripcion": "Introducción a React y su ecosistema.", "contenido": [{"titulo": "1.1 - Instalación y configuración", "duracion": "10:00"}, {"titulo": "1.2 - Componentes y JSX", "duracion": "12:00"}, {"titulo": "1.3 - Props y State", "duracion": "15:00"}]}, {"titulo": "2. Hooks en React", "descripcion": "Conceptos avanzados para desarrollar aplicaciones modernas.", "contenido": [{"titulo": "2.1 - useState y useEffect", "duracion": "18:00"}, {"titulo": "2.2 - useContext y useReducer", "duracion": "20:00"}, {"titulo": "2.3 - Custom Hooks", "duracion": "22:00"}]}]',
    '["Comprenderás los fundamentos de React y JSX.", "Aprenderás a manejar estados y props para crear componentes funcionales.", "Implementarás custom hooks para encapsular lógica reutilizable."]',
    '["Desarrolladores frontend o estudiantes interesados en aprender React desde cero."]'
);

-- Curso 7: Curso de TypeScript
INSERT INTO curso (
    id, nombre, descripcion, fecha, duracion, nivel, precio, imagen, 
    categoria_id, profesor_nombre, 
    temario, aprendizajes, publico
) VALUES (
    7,
    'Curso de TypeScript',
    'Domina TypeScript para escribir código JavaScript más seguro y escalable.',
    '2025-10-01',
    '6 horas',
    'Intermedio',
    20.00,
    '/img/curso-typescript.png',
    3, -- categoria_id = Frontend
    'Carlos Rivas 🇲🇽',
    '[{"titulo": "1. Fundamentos de TypeScript", "descripcion": "Tipos básicos, interfaces y clases.", "contenido": [{"titulo": "1.1 - Tipos básicos", "duracion": "10:00"}, {"titulo": "1.2 - Interfaces y tipos", "duracion": "12:00"}, {"titulo": "1.3 - Funciones y clases", "duracion": "15:00"}]}, {"titulo": "2. TypeScript Avanzado", "descripcion": "Tipos genéricos, módulos y namespaces.", "contenido": [{"titulo": "2.1 - Tipos genéricos", "duracion": "18:00"}, {"titulo": "2.2 - Módulos y namespaces", "duracion": "20:00"}, {"titulo": "2.3 - Integración con React", "duracion": "22:00"}]}]',
    '["Dominarás tipos básicos y avanzados de TypeScript.", "Crearás interfaces y tipos personalizados para mejorar la legibilidad del código.", "Implementarás TypeScript en proyectos React y Node.js."]',
    '["Desarrolladores frontend o estudiantes interesados en aprender TypeScript desde cero."]'
);

-- Curso 8: Curso de Git y GitHub
INSERT INTO curso (
    id, nombre, descripcion, fecha, duracion, nivel, precio, imagen, 
    categoria_id, profesor_nombre, 
    temario, aprendizajes, publico
) VALUES (
    8,
    'Curso de Git y GitHub',
    'Aprende a usar Git y GitHub para el control de versiones y colaboración en proyectos.',
    '2025-11-01',
    '4 horas',
    'Básico',
    10.00,
    '/img/curso-git-github.jpg',
    5, -- categoria_id = Herramientas de Desarrollo
    'Ana Torres 🇪🇸',
    '[{"titulo": "1. Fundamentos de Git", "descripcion": "Comandos básicos y trabajo con ramas.", "contenido": [{"titulo": "1.1 - Instalación y configuración", "duracion": "08:00"}, {"titulo": "1.2 - Comandos básicos", "duracion": "10:00"}, {"titulo": "1.3 - Trabajo con ramas", "duracion": "12:00"}]}, {"titulo": "2. Colaboración con GitHub", "descripcion": "Uso de GitHub para colaborar en proyectos en equipo.", "contenido": [{"titulo": "2.1 - Creación de repositorios remotos", "duracion": "15:00"}, {"titulo": "2.2 - Pull requests y code reviews", "duracion": "18:00"}, {"titulo": "2.3 - Resolución de conflictos", "duracion": "20:00"}]}]',
    '["Dominarás comandos básicos de Git para gestionar repositorios locales.", "Aprenderás a trabajar con ramas y resolver conflictos de fusión.", "Implementarás flujos de trabajo colaborativos con GitHub."]',
    '["Desarrolladores de cualquier nivel que quieran aprender Git y GitHub."]'
);

-- Curso 9: Curso de Angular
INSERT INTO curso (
    id, nombre, descripcion, fecha, duracion, nivel, precio, imagen, 
    categoria_id, profesor_nombre, 
    temario, aprendizajes, publico
) VALUES (
    9,
    'Curso de Angular',
    'Domina Angular Framework para construir aplicaciones web robustas y escalables.',
    '2025-12-01',
    '10 horas',
    'Intermedio',
    30.00,
    '/img/curso-angular.jpeg',
    3, -- categoria_id = Frontend
    'Laura Gómez 🇨🇴',
    '[{"titulo": "1. Fundamentos de Angular", "descripcion": "Introducción a Angular y su ecosistema.", "contenido": [{"titulo": "1.1 - Configuración del entorno", "duracion": "10:00"}, {"titulo": "1.2 - Componentes y templates", "duracion": "12:00"}, {"titulo": "1.3 - Data binding", "duracion": "15:00"}]}, {"titulo": "2. Angular Avanzado", "descripcion": "Conceptos avanzados para proyectos complejos.", "contenido": [{"titulo": "2.1 - Routing y navegación", "duracion": "18:00"}, {"titulo": "2.2 - Formularios reactivos", "duracion": "20:00"}, {"titulo": "2.3 - Servicios y HTTP", "duracion": "22:00"}]}]',
    '["Comprenderás los fundamentos de Angular y su arquitectura.", "Aprenderás a crear componentes, servicios y módulos.", "Implementarás routing y formularios reactivos."]',
    '["Desarrolladores frontend o estudiantes interesados en aprender Angular desde cero."]'
);

-- Curso 10: Curso de Spring Boot
INSERT INTO curso (
    id, nombre, descripcion, fecha, duracion, nivel, precio, imagen, 
    categoria_id, profesor_nombre, 
    temario, aprendizajes, publico
) VALUES (
    10,
    'Curso de Spring Boot',
    'Aprende a construir aplicaciones backend robustas con Spring Boot.',
    '2026-01-01',
    '12 horas',
    'Intermedio',
    35.00,
    '/img/curso-springboot.webp',
    1, -- categoria_id = Backend
    'Andres Sacco 🇦🇷',
    '[{"titulo": "1. Fundamentos de Spring Boot", "descripcion": "Introducción a Spring Boot y su configuración.", "contenido": [{"titulo": "1.1 - Instalación y configuración", "duracion": "10:00"}, {"titulo": "1.2 - Creación de APIs RESTful", "duracion": "12:00"}, {"titulo": "1.3 - Manejo de excepciones", "duracion": "15:00"}]}, {"titulo": "2. Spring Boot Avanzado", "descripcion": "Conceptos avanzados para proyectos complejos.", "contenido": [{"titulo": "2.1 - Integración con bases de datos", "duracion": "18:00"}, {"titulo": "2.2 - Seguridad con Spring Security", "duracion": "20:00"}, {"titulo": "2.3 - Testing de aplicaciones", "duracion": "22:00"}]}]',
    '["Dominarás los conceptos básicos de Spring Boot y su ecosistema.", "Crearás APIs RESTful utilizando Spring MVC.", "Implementarás bases de datos relacionales con JPA y Hibernate."]',
    '["Desarrolladores backend o estudiantes interesados en aprender Spring Boot desde cero."]'
);

-- Curso 11: Curso de PHP
INSERT INTO curso (
    id, nombre, descripcion, fecha, duracion, nivel, precio, imagen, 
    categoria_id, profesor_nombre, 
    temario, aprendizajes, publico
) VALUES (
    11,
    'Curso de PHP',
    'Aprende a desarrollar aplicaciones web dinámicas con PHP.',
    '2026-02-01',
    '8 horas',
    'Básico',
    20.00,
    '/img/curso-php.png',
    1, -- categoria_id = Backend
    'Carlos Rivas 🇲🇽',
    '[{"titulo": "1. Fundamentos de PHP", "descripcion": "Variables, estructuras de control y funciones.", "contenido": [{"titulo": "1.1 - Variables y tipos de datos", "duracion": "08:00"}, {"titulo": "1.2 - Estructuras de control", "duracion": "10:00"}, {"titulo": "1.3 - Funciones y arrays", "duracion": "12:00"}]}, {"titulo": "2. PHP Avanzado", "descripcion": "Conexión con MySQL, sesiones y APIs RESTful.", "contenido": [{"titulo": "2.1 - Conexión con MySQL", "duracion": "15:00"}, {"titulo": "2.2 - Sesiones y autenticación", "duracion": "18:00"}, {"titulo": "2.3 - APIs RESTful con PHP", "duracion": "20:00"}]}]',
    '["Dominarás la sintaxis básica de PHP y sus estructuras de control.", "Crearás aplicaciones web dinámicas con MySQL.", "Implementarás sesiones y autenticación para mejorar la seguridad."]',
    '["Desarrolladores backend o estudiantes interesados en aprender PHP desde cero."]'
);

select*from curso;
select*from categoria;
select*from compra;
select*from usuario