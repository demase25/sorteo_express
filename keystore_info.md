# 🔐 Información del Keystore de Producción - Sorteo Express

## 📋 Datos del Keystore

**Nombre del archivo:** `sorteo-express-keystore.jks`  
**Ubicación:** `android/app/sorteo-express-keystore.jks`  
**Tamaño:** 2,678 bytes  
**Fecha de creación:** 12/10/2025  

---

## 🔑 Credenciales del Keystore

### **Información de Acceso:**
- **Store Password:** `SorteoExpress2024!`
- **Key Alias:** `sorteoexpress`
- **Key Password:** `SorteoExpress2024!`

### **Información del Certificado:**
- **CN (Common Name):** Sorteo Express
- **O (Organization):** Sorteo Express
- **C (Country):** ES
- **Algoritmo:** RSA
- **Tamaño de clave:** 2048 bits
- **Validez:** 10,000 días (~27 años)

---

## 📱 Configuración de Build

### **Application ID:**
```
com.sorteoexpress.app
```

### **Versión:**
```
1.0.1+2
```

### **Archivo de Build Generado:**
```
build/app/outputs/bundle/release/app-release.aab
Tamaño: 43.6 MB
```

---

## ⚠️ IMPORTANTE - Seguridad

### **🔒 CRÍTICO - Guardar en Lugar Seguro:**
1. **Hacer múltiples copias** del archivo `sorteo-express-keystore.jks`
2. **Guardar las contraseñas** en lugar seguro
3. **Nunca subir** al repositorio Git
4. **Backup en la nube** (encriptado)

### **📋 Lista de Verificación:**
- [ ] Copia del keystore en USB
- [ ] Copia en la nube (encriptada)
- [ ] Contraseñas guardadas en lugar seguro
- [ ] Documentación completa guardada

---

## 🚨 Si Pierdes el Keystore:

### **Consecuencias:**
- ❌ **No podrás actualizar** la aplicación
- ❌ **Tendrás que crear** una nueva app
- ❌ **Perderás** todas las descargas
- ❌ **Perderás** todas las reseñas
- ❌ **Tendrás que empezar** desde cero

### **Prevención:**
- ✅ **Múltiples copias** en lugares diferentes
- ✅ **Documentar contraseñas** en lugar seguro
- ✅ **Probar el keystore** antes de publicar
- ✅ **Verificar que funciona** para futuras actualizaciones

---

## 🛠️ Comandos Útiles

### **Verificar el Keystore:**
```bash
keytool -list -v -keystore android/app/sorteo-express-keystore.jks -alias sorteoexpress
```

### **Cambiar Contraseña (si es necesario):**
```bash
keytool -keypasswd -keystore android/app/sorteo-express-keystore.jks -alias sorteoexpress
```

### **Recompilar la App:**
```bash
flutter clean
flutter build appbundle --release
```

---

## 📦 Estado del Proyecto

### **✅ Completado:**
- [x] Keystore de producción generado
- [x] Configuración en build.gradle.kts
- [x] Android App Bundle compilado
- [x] Archivo .gitignore actualizado
- [x] Documentación creada

### **🎯 Listo para:**
- [x] Subir a Google Play Store
- [x] Procesar en Play Console
- [x] Publicar la aplicación

---

## 📞 Contacto de Emergencia

**En caso de perder el keystore:**
- Contactar soporte de Google Play Console
- Documentar el problema detalladamente
- Preparar nueva aplicación como último recurso

---

*Keystore generado exitosamente el 12/10/2025 - Listo para producción*
