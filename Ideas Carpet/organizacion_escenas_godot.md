# Organización de escenas y colisiones en Godot

## 🎬 ¿Por qué usar una escena para cada objeto?

En Godot, **cada escena es un “prefab” o plantilla**.  
Te permite reutilizar y modificar fácilmente los objetos sin romper el resto del juego.

| Objeto | Tipo de escena recomendada | Nodo raíz |
|--------|-----------------------------|------------|
| 🚶‍♂️ Jugador | `CharacterBody2D` | `CharacterBody2D` |
| 🚗 Auto | `StaticBody2D` o `RigidBody2D` (según si se mueve o no) | `StaticBody2D` |
| 💎 Moneda / Power-up | `Area2D` | `Area2D` |
| 🧱 Pared / Suelo | `TileMap` o `StaticBody2D` | `StaticBody2D` |
| 🔫 Bala / proyectil | `Area2D` | `Area2D` |
| 💥 Enemigo | `CharacterBody2D` o `RigidBody2D` | `CharacterBody2D` |

---

## 🧩 Cómo hacerlo (ejemplo con el auto)

1. Crea una **nueva escena**:  
   🔹 `Archivo → Nueva Escena`  
   🔹 Nodo raíz: `StaticBody2D` (si el auto no se mueve).  
   🔹 Nómbralo `Auto`.

2. Dentro del `Auto`, agrega:
   ```
   Auto (StaticBody2D)
   ├── AnimatedSprite2D   # o Sprite2D
   └── CollisionShape2D
   ```

3. Configura el `AnimatedSprite2D` con la animación `"idle"`.
4. Ajusta el `CollisionShape2D` al tamaño del auto.
5. Guarda la escena como `auto.tscn`.

---

## 🌍 Luego, en tu escena principal (por ejemplo, “Nivel1.tscn”)

1. Abre tu escena principal.
2. Arrastra el archivo `auto.tscn` desde el panel de archivos **hacia la vista de la escena**.
3. Coloca el auto donde quieras en el mapa.

Ejemplo en código:
```gdscript
var auto = preload("res://escenas/auto.tscn").instantiate()
auto.position = Vector2(400, 300)
add_child(auto)
```

---

## 🚦 Ventajas de hacerlo así

✅ Puedes reutilizar el mismo auto en muchos niveles.  
✅ Puedes modificarlo (por ejemplo, agregarle una animación nueva) y **se actualiza en todos lados**.  
✅ Mantienes tu proyecto **organizado y limpio**.  
✅ Facilita conectar señales y scripts específicos.
