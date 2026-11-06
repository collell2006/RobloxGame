# CHANGELOG

## [1.0.0] - 2026-11-06 (Versión Completa y Funcional)

### Servidor (Backend & Gameplay)
- **Init.lua**: Orquestación limpia y centralizada de todos los servicios.
- **ObbySetup.lua**: Generador completo de 5 etapas temáticas:
  - Etapa 1: Plataformas de salto básicas.
  - Etapa 2: Cilindros de madera con alturas variables.
  - Etapa 3: Plataformas desvanecientes que caen al pisarlas.
  - Etapa 4: Puentes con rayos láser que causan daño letal.
  - Etapa 5: Isla de victoria con trofeo dorado.
  - Piso letal (Kill Floor): Lava de neón roja que reinicia la vida al caer.
- **CheckpointManager.lua**:
  - Detección de avance de checkpoints numerados con letreros flotantes.
  - Teletransporte seguro de reaparición (`CharacterAdded`) hacia el nivel guardado.
  - Recompensa por checkpoint (+15 monedas) y evento voluntario de reinicio.
- **CoinSpawner.lua**: Monedas doradas giratorias con PointLight y tiempo de respawn de 12 segundos. Soporte para bonificación VIP (x2).
- **DataStoreHandler.lua**:
  - Sistema de guardado y carga seguro con reintentos (`MAX_RETRIES = 3`).
  - Integración nativa con `leaderstats` oficial de Roblox (`Nivel` y `Monedas`).
  - Auto-guardado periódico cada 3 minutos.
  - Manejo crítico de cierre de servidor (`game:BindToClose`) para evitar pérdida de datos.
- **MarketplaceHandler.lua**:
  - Implementación oficial de `MarketplaceService.ProcessReceipt` para Developer Products.
  - Verificación de posesión de Game Pass al entrar (`UserOwnsGamePassAsync`).
  - Detección de compra de Game Pass en tiempo real y asignación de atributos.
- **RemoteEventsSetup.lua**: Inicialización garantizada de eventos `BuyGamePass`, `BuyProduct`, `Notify` y `ResetToCheckpoint`.

### Cliente (UI & UX)
- **HUD.client.lua**:
  - Interfaz moderna con contador de monedas y nivel actual.
  - Botón de acceso rápido a la **Tienda** (`🛒 TIENDA`).
  - Botón de reinicio al checkpoint actual (`🔄 REINICIAR`).
  - Detección reactiva de atributos sin bucles pesados.
- **StoreGui.client.lua**:
  - Ventana modal estilizada con dos tarjetas de producto:
    - Pase VIP (x2 monedas, +1000 monedas de bienvenida y tag VIP).
    - Pack de 500 Monedas (compra repetible).
  - Botones de compra conectados directamente con el servidor.
- **NotificationHandler.client.lua**:
  - Banners emergentes animados con `TweenService` para compras, recompensas y checkpoints.

### Configuración e Infraestructura
- **default.project.json**: Estructura compatible con Rojo para sincronización automática con Studio.
- **README.md**: Guía completa de uso e instrucciones detalladas para Roblox Studio.
