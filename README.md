# 🎮 MiPrimerJuego – Obby & Monetización en Roblox

Juego completo estilo **Obby (Obstacle Course)** con mecánicas de parkour, plataformas desvanecientes, láseres, sistema de monedas giratorias, tabla de clasificación (`leaderstats`), persistencia de datos segura (`DataStoreService`) y tienda integrada con **Game Pass VIP** y **Developer Products**.

---

## 📁 Estructura del Proyecto

```
MiPrimerJuego/
├── default.project.json           # Configuración para Rojo (opcional)
├── CHANGELOG.md                   # Historial de versiones y mejoras
├── README.md                      # Documentación del proyecto
│
├── Config/
│   └── Products.lua               # IDs de Game Passes y Productos de Desarrollador
│
├── Core/                          # Lógica del Servidor (ServerScriptService)
│   ├── Init.lua                   # Script principal que orquesta el juego
│   ├── ObbySetup.lua              # Generador procedural del Obby (5 etapas + lava)
│   ├── CheckpointManager.lua      # Control de niveles, respawn y checkpoints
│   ├── CoinSpawner.lua            # Generación y animación de monedas doradas
│   ├── DataStoreHandler.lua       # Guardado seguro (Coins, Nivel) + leaderstats
│   ├── MarketplaceHandler.lua     # Compras de Game Pass y ProcessReceipt
│   └── RemoteEventsSetup.lua      # Creación automática de eventos cliente-servidor
│
└── UI/                            # Lógica del Cliente (StarterGui)
    ├── HUD.client.lua             # Contador de monedas, nivel actual y botones
    ├── StoreGui.client.lua        # Ventana modal de la tienda de mejoras
    └── NotificationHandler.client.lua # Banners de aviso animados (éxito/error)
```

---

## 🚀 Cómo ponerlo a funcionar en Roblox Studio (Paso a Paso)

Dado que ya tienes **Roblox Studio abierto**, sigue estos sencillos pasos:

### 1. Elige una plantilla base
En Roblox Studio ve a **New** y selecciona **Baseplate** (el mapa plano estándar).

### 2. Configura las carpetas en el explorador (*Explorer*)
En el panel lateral derecho (*Explorer*), asegúrate de tener:
- En **ServerScriptService**:
  - Crea una carpeta llamada `Core` (o arrastra los scripts de `Core/` aquí).
- En **ReplicatedStorage**:
  - Crea una carpeta llamada `Config` y coloca dentro `Products.lua`.
- En **StarterGui**:
  - Crea una carpeta llamada `UI` (o arrastra los 3 scripts `.client.lua` de `UI/` aquí).

### 3. Asignar los tipos de Script en Roblox Studio:
- **Scripts del Servidor** (en `ServerScriptService`):
  - `Init.lua` (Script normal).
  - Todos los demás módulos (`DataStoreHandler`, `MarketplaceHandler`, `ObbySetup`, etc.) deben ser **ModuleScript** o Scripts normales invocados por `Init`.
- **Scripts del Cliente** (en `StarterGui`):
  - `HUD.client.lua`, `StoreGui.client.lua` y `NotificationHandler.client.lua` deben ser creados como **LocalScript**.

### 4. Habilitar la API de Guardado (DataStore) en Studio
Para probar el guardado de datos en local:
1. En Studio ve a **Home → Game Settings**.
2. Si te pide publicar el juego primero, dale un nombre temporal (ej. *Mi Primer Obby*).
3. Entra a **Security** y activa:
   - ✅ **Enable Studio Access to API Services** (Permitir acceso de Studio a los servicios API).
4. Haz clic en **Save**.

### 5. ¡A jugar! (Play)
1. Pulsa **Play** (F5) en Roblox Studio.
2. Verás cómo automáticamente:
   - Se construye el Obby con 5 niveles flotantes y el piso de lava roja al fondo.
   - Aparecen las monedas doradas girando en el aire.
   - En la esquina superior derecha verás la tabla de clasificación (`Nivel` y `Monedas`).
   - En la pantalla se cargará el HUD con tu saldo y nivel actual.
   - Pulsa el botón **🛒 TIENDA** para probar la interfaz de compras.
   - Pulsa **🔄 REINICIAR** o tírate a la lava para comprobar que reapareces exactamente en tu último checkpoint alcanzado.

---

## 💰 Conexión de Monetización Real

Cuando quieras habilitar compras con Robux reales:
1. En la web de Roblox (o desde Studio en *Game Settings → Monetization* / *Create*):
   - Crea un **Pass** (Pase de juego) para el VIP.
   - Crea un **Developer Product** para el paquete de 500 monedas.
2. Copia los IDs numéricos generados.
3. Abre `Config/Products.lua` y sustituye los números de ejemplo:
   ```lua
   GamePasses = {
       PremiumPass = TU_ID_DE_PASE_AQUI,
   },
   DeveloperProducts = {
       CoinPack = TU_ID_DE_PRODUCTO_AQUI,
   }
   ```

---

## 🛠️ Herramientas avanzadas (Opcional)
Si usas [Rojo](https://rojo.space/), simplemente corre `rojo serve` en esta carpeta y conecta el plugin de Rojo en Roblox Studio para sincronizar todo automáticamente en 1 segundo.
