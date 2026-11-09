# CHANGELOG

## [1.1.0] - 2026-11-09 (Actualización de Retención y Cosméticos)

### 🔁 Sistema de Renacimientos (Rebirths)
- **RebirthManager.lua**:
  - Requisito de completar el Nivel 5 (Isla de Victoria).
  - Multiplicador de monedas permanente (+50% por cada renacimiento).
  - Efecto acumulativo con el Game Pass VIP (+100% adicional).
  - Bonificación inmediata de +100 monedas al renacer.
  - Sincronización oficial en la tabla de clasificación (`leaderstats.Renacer`).

### ✨ Sistema de Estelas Cosméticas (Trails)
- **TrailManager.lua**:
  - Catálogo de 4 estelas con físicas de iluminación y degradados cromáticos:
    - *Arcoíris Cósmico* (100 🪙)
    - *Fuego Volcánico* (250 🪙)
    - *Ciber Neón* (450 🪙)
    - *Oro Divino* (800 🪙)
  - Acoplamiento dinámico a `HumanoidRootPart` con `Attachment` superior e inferior.
  - Persistencia de inventario (`OwnedTrails`) y estela activa (`EquippedTrail`) en DataStore.
  - Re-equipamiento automático al reaparecer tras caer o morir.

### 🏃 Nuevas Mecánicas de Parkour
- **ObbySetup.lua**:
  - **Trampolines (Jump Pads):** Plataformas verdes de neón que impulsan al jugador hacia arriba y adelante para superar abismos.
  - **Aceleradores (Speed Boosters):** Bandas naranjas de neón que otorgan velocidad x2 (WalkSpeed 32) durante 3 segundos.
  - **Portal de Renacimiento Físico:** En la Isla de Victoria, con letrero interactivo y detección al pisarlo.
  - Emisores de partículas de victoria (confetti multicolor).

### 🛒 Tienda Multi-Pestaña y HUD Renovado
- **StoreGui.client.lua**:
  - Nueva navegación por pestañas: **💎 ROBUX & PASES** y **✨ ESTELAS COSMÉTICAS**.
  - Botones con estado en tiempo real: *Comprar*, *Equipar*, *✅ Equipado (Quitar)*.
- **HUD.client.lua**:
  - Indicador de multiplicador en vivo (`⚡ 1.5x`).
  - Marcador de estela actualmente activa.
  - Botón dinámico de renacer que se ilumina en dorado al llegar a la meta.

---

## [1.0.0] - 2026-11-06 (Versión Completa y Funcional)
- Implementación de los 5 niveles del Obby con lava letal.
- Checkpoints con teletransporte y reaparición segura.
- Monedas doradas giratorias con respawn.
- Persistencia con DataStore y tabla de clasificación (`leaderstats`).
- Integración de Marketplace (`ProcessReceipt` y Game Passes).
