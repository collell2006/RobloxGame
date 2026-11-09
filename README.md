# 🎮 MiPrimerJuego – Obby, Renacimientos & Estelas en Roblox

Juego completo estilo **Obby (Obstacle Course)** con mecánicas avanzadas de parkour, trampolines de impulso, cintas aceleradoras, plataformas desvanecientes, rayos láser, sistema de **Renacimientos (Rebirths)** con multiplicadores de monedas, **Tienda de Estelas Cosméticas (Trails)** para gastar monedas del juego, persistencia segura con `DataStoreService` y monetización con Robux reales vía **Game Pass VIP** y **Developer Products**.

---

## 📁 Estructura del Proyecto

```
MiPrimerJuego/
├── default.project.json           # Configuración para sincronización con Rojo
├── CHANGELOG.md                   # Historial de versiones y mejoras (v1.1.0)
├── README.md                      # Documentación del proyecto
│
├── Config/
│   └── Products.lua               # IDs de Game Passes y Productos de Desarrollador
│
├── Core/                          # Lógica del Servidor (ServerScriptService)
│   ├── Init.lua                   # Orquestador principal del servidor
│   ├── ObbySetup.lua              # Generador del Obby (5 etapas, trampolines, boosters y lava)
│   ├── CheckpointManager.lua      # Control de niveles, respawn y checkpoints
│   ├── CoinSpawner.lua            # Monedas doradas giratorias con partículas y multiplicador
│   ├── RebirthManager.lua         # Sistema de Renacimientos y multiplicadores de prestigio
│   ├── TrailManager.lua           # Sistema de estelas cosméticas en el personaje
│   ├── DataStoreHandler.lua       # Guardado seguro (Monedas, Nivel, Renacer, Inventario)
│   ├── MarketplaceHandler.lua     # Compras de Game Pass y ProcessReceipt
│   └── RemoteEventsSetup.lua      # Inicialización automática de eventos de red
│
└── UI/                            # Lógica del Cliente (StarterGui)
    ├── HUD.client.lua             # Estadísticas (Monedas, Nivel, Renacer, Multiplicador, Estela)
    ├── StoreGui.client.lua        # Tienda interactiva con 2 pestañas (Robux y Estelas)
    └── NotificationHandler.client.lua # Banners de aviso animados (éxito/error)
```

---

## 🌟 Novedades de la Versión 1.1.0

1. **Economía de Monedas con Utilidad Real (Estelas Cosméticas):**
   - Los jugadores ahora tienen un motivo para coleccionar monedas: comprar estelas que dejan un rastro de partículas al correr y saltar.
   - 4 estelas disponibles: *Arcoíris Cósmico*, *Fuego Volcánico*, *Ciber Neón* y *Oro Divino*.
   - El inventario y la estela equipada se guardan en la nube para que nunca se pierdan.

2. **Bucle de Retención Infinito: Renacimientos (Rebirths):**
   - Al llegar al Nivel 5 (Isla de Victoria), los jugadores pueden renacer en el portal místico o mediante el botón en pantalla.
   - Cada renacimiento otorga un **+50% de monedas permanente** acumulativo, incentivando a pasarse el juego varias veces.

3. **Mecánicas de Parkour Divertidas:**
   - **Trampolines (Jump Pads):** Impulsan al jugador a gran altura y velocidad para sortear abismos gigantescos.
   - **Cintas Aceleradoras (Speed Boosters):** Duplican la velocidad del personaje temporalmente.

4. **Tienda Multi-Pestaña:**
   - Pestaña 1: **💎 ROBUX & PASES** (Monetización del creador).
   - Pestaña 2: **✨ ESTELAS COSMÉTICAS** (Tienda dentro del juego que consume monedas recolectadas).

---

## 🚀 Cómo probarlo en Roblox Studio

1. **Abre Roblox Studio** con un mapa nuevo (**Baseplate**).
2. **Copia los archivos a sus carpetas:**
   - En **ServerScriptService**: Coloca los scripts de `Core/` (con `Init.lua` como Script ejecutable).
   - En **ReplicatedStorage**: Coloca la carpeta `Config/` con `Products.lua`.
   - En **StarterGui**: Coloca los scripts de `UI/` como `LocalScript`.
3. **Activa el guardado de datos en Studio:**
   - **Game Settings** → **Security** → activa **Enable Studio Access to API Services**.
4. **Pulsa Play (F5):**
   - Recoge monedas en el camino y pisa los trampolines verdes para volar.
   - Abre la tienda con el botón **🛒 TIENDA**, cambia a la pestaña de **✨ ESTELAS** y equípate tu primera estela cuando ahorres monedas.
   - Llega a la meta (Nivel 5) y entra en el portal morado para activar tu primer **Renacimiento**.
