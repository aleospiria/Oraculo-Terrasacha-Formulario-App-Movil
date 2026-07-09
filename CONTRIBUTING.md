# Contribuyendo a Terrasacha Captura de Datos

## Flujo de trabajo

1. Crear un issue describiendo el cambio (bug, feature, mejora)
2. Crear una rama desde `dev` con nombre `tipo/descripcion-corta`:
   ```
   feat/creacion-screen-parcelas
   fix/visualizarpredios
   docs/correccion-CONTRIBUTING
   ```
3. Hacer cambios y commits atómicos
4. Si la rama dev ha avanzado considerablemente después de que nació la rama, es mejor hacer un `git rebase dev` antes del PR para evitar posibles conflictos. adicional, aplicar un `git push --force-with-lease` en la rama creada, para mantener asi el historial limpio
5. Abrir PR y esperar la aprobación 

### Convención de commits

Los mensajes de los commits van en **español**. Usamos [Conventional Commits](https://www.conventionalcommits.org/):

```
feat: cambios que afecten la funcionalidad
fix: corrección de errores 
docs: cambios en la documuentación (generalmente en /docs)
refactor: cambios que NO afecten la funcionalidad
test: cambios o nuevos de test
chore: actaulización de dependencias o versiones
style: correciones de escritura, ortográficas, indentación, etc
perf: optimizaciones
``` 

## 💻 Convenciones de código

- **Archivos:** `UpperCamelCase.dart` para screens/widgets, `snake_case.dart` para utilidades
- **Clases:** `UpperCamelCase`
- **Variables/funciones:** `lowerCamelCase`
- **Constantes:** `lowerCamelCase` 
- **Sin comentarios en código** o usar comentarios especiales como TODO, o FIX

---

## Pull Requests

- Título descriptivo: `feat: lo que hace` o `fix: lo que arregla`
- Descripción clara del cambio
- Referencia issues si aplica (Con **#** y el numero del Issue)
- Asegura que `flutter analyze` pase sin errores
- Prueba manualmente en dispositivo/emulador

---


## AWS Amplify

### Servicios usados

| Servicio | Propósito |
|---|---|
| **Amplify Auth (Cognito)** | Autenticación de usuarios |
| **Amplify API (AppSync)** | GraphQL para datos |
| **Amplify DataStore** | Persistencia offline (en migración) |

### Comandos útiles

```bash
# Pull del backend actual
amplify pull --appId dly7zagn36ddlu --envName dev --profile alejo_terrasacha

# Ver estado
amplify status
```

---

## Notas importantes

- **No editar** archivos en `lib/models/` — son generados por Amplify
- **No editar** `amplifyconfiguration.dart` — es generado

