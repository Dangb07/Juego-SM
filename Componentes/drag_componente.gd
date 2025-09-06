extends Node
class_name Draggable

var dragging := false
var drag_offset := Vector2.ZERO
var nodo_objetivo: Node2D

func _ready() -> void:
	# El "nodo_objetivo" será el padre de este componente
	nodo_objetivo = get_parent() as Node2D
	if not nodo_objetivo:
		push_warning("Draggable necesita estar en una escena 2D (Node2D, Sprite2D, etc.)")

func _unhandled_input(event: InputEvent) -> void:
	if not nodo_objetivo:
		return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if _is_mouse_over(event.position):
				dragging = true
				drag_offset = nodo_objetivo.global_position - event.position
		else:
			dragging = false

func _process(delta: float) -> void:
	if dragging and nodo_objetivo:
		nodo_objetivo.global_position = get_viewport().get_mouse_position() + drag_offset

# --- Detección básica ---
func _is_mouse_over(mouse_pos: Vector2) -> bool:
	# Si el padre tiene un Area2D lo usamos:
	var area := nodo_objetivo.get_node_or_null("Area2D")
	if area:
		return area.get_overlapping_point(mouse_pos)

	# Si el padre tiene un Sprite2D lo usamos como bounding box:
	var sprite := nodo_objetivo.get_node_or_null("Sprite2D")
	if sprite and sprite.texture:
		var tex_size = sprite.texture.get_size() * sprite.scale
		var rect = Rect2(nodo_objetivo.global_position - tex_size / 2, tex_size)
		return rect.has_point(mouse_pos)

	# Si no hay nada, no podemos detectar clic
	return false
