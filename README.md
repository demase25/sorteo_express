# 🎉 Sorteo Express

Una aplicación Flutter elegante y moderna para realizar sorteos de nombres y números con efectos especiales.

## ✨ Características

- 🎊 **Confetti espectacular** cuando aparece el ganador
- 📳 **Vibración táctil** en todas las interacciones
- 🌈 **Modal de compartir** con efectos visuales increíbles
- 💙 **Tema Deep Sky Blue** hermoso y moderno
- 📱 **Compartir por WhatsApp** y otras aplicaciones
- 💾 **Historial de sorteos** guardados
- 🌙 **Modo oscuro** incluido

## 🎯 Tipos de Sorteo

### Sorteo de Nombres
- Ingresa una lista de participantes
- Cada participante en una línea separada
- Sorteo aleatorio justo

### Sorteo de Números
- **Por rango**: Del número X al número Y
- **Por lista**: Números específicos separados por líneas
- Perfecto para rifas y sorteos numéricos

## 🚀 Tecnologías Utilizadas

- **Flutter** - Framework de desarrollo
- **Dart** - Lenguaje de programación
- **Shared Preferences** - Almacenamiento local
- **Confetti** - Efectos visuales
- **Share Plus** - Compartir contenido
- **URL Launcher** - Abrir aplicaciones externas

## 📱 Capturas de Pantalla

La aplicación cuenta con:
- Pantalla de inicio elegante
- Interfaz intuitiva para sorteos
- Resultados con confetti y vibración
- Historial organizado
- Modal de compartir colorido

## 🎨 Diseño

- **Color principal**: Deep Sky Blue (#00BFFF)
- **Material Design 3**
- **Tema claro y oscuro**
- **Efectos de sombra y gradientes**
- **Animaciones suaves**

## 📦 Instalación

1. Clona el repositorio:
```bash
git clone https://github.com/tu-usuario/sorteo_express.git
```

2. Navega al directorio:
```bash
cd sorteo_express
```

3. Instala las dependencias:
```bash
flutter pub get
```

4. Ejecuta la aplicación:
```bash
flutter run
```

## 🛠️ Desarrollo

### Estructura del Proyecto

```
lib/
├── main.dart                 # Punto de entrada
├── core/                    # Configuración base
│   ├── theme.dart           # Temas y colores
│   ├── routes.dart          # Navegación
│   └── constants.dart       # Constantes
├── models/                  # Modelos de datos
│   └── history_model.dart   # Modelo de historial
├── screens/                 # Pantallas principales
│   ├── home_screen.dart     # Pantalla de inicio
│   ├── sorteo_screen.dart   # Pantalla de sorteos
│   ├── result_screen.dart   # Pantalla de resultados
│   └── history_screen.dart  # Pantalla de historial
├── widgets/                 # Widgets reutilizables
│   ├── custom_button.dart   # Botón personalizado
│   ├── input_field.dart     # Campo de entrada
│   └── result_card.dart     # Tarjeta de resultado
└── services/                # Servicios y lógica
    ├── sorteo_service.dart  # Lógica de sorteos
    ├── effects_service.dart # Efectos especiales
    └── share_service.dart   # Compartir contenido
```

## 🎊 Efectos Especiales

- **Confetti**: Partículas coloridas que caen desde arriba
- **Vibración**: Feedback táctil en botones y celebraciones
- **Animaciones**: Transiciones suaves entre pantallas
- **Modal colorido**: Gradientes y efectos visuales

## 📱 Compatibilidad

- **Android**: API 21+ (Android 5.0+)
- **iOS**: iOS 11.0+
- **Flutter**: 3.0+

## 🤝 Contribuciones

Las contribuciones son bienvenidas. Por favor:

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo `LICENSE` para más detalles.

## 👨‍💻 Autor

Desarrollado con ❤️ usando Flutter

---

¡Disfruta sorteando! 🎉✨