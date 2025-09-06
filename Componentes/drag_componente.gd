extends Node
class_name Draggable
#El nodo objetivo siempre será el nodo padre de este componente
@onready var nodo_objetivo= get_parent()
@onready var viewport = get_viewport().get_visible_rect().size

var area2d: Area2D
var boton: Button

var mouse_in = false
var draggin = false
var offset = Vector2(0,0)
var velocidad_max = 2500 
var margen = 200  # píxeles extra fuera de pantalla


var timeout = false
var timerun = false
var T_porciento 
var check: bool = false

#region Proximas variables
#@onready var precio_progres = get_node("ProgressBar")
#@onready var l_datos : Label
#@onready var timer = get_node("Timer")
@onready var label_info: Label
#endregion

# Called when the node enters the scene tree for the first time.
func _ready():
	label_info = nodo_objetivo.get_node("info")
	area2d = nodo_objetivo.get_node("Area2D")
	boton = nodo_objetivo.get_node("boton")
	
#region Señales
	area2d.mouse_entered.connect(_mouse_entra)
	area2d.mouse_exited.connect(_mouse_sale)
	boton.button_up.connect(_on_button_up)
	boton.button_down.connect(_on_button_down)
#endregion
	 
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#region Verificar el dragg
	if draggin:
		var objetivo = nodo_objetivo.get_global_mouse_position() - offset
		var margen = 50
		var dir = objetivo - nodo_objetivo.global_position
		
		# Limitar al viewport
		objetivo.x = clamp(objetivo.x, 0, viewport.x)
		objetivo.y = clamp(objetivo.y, 0, viewport.y)
		
		# Si accidentalmente se sale demasiado de la pantalla, lo regresamos
		if objetivo.x < -margen or objetivo.x > viewport.x + margen or objetivo.y < -margen or objetivo.y > viewport.y + margen:
			objetivo = viewport / 2  # vuelve al centro
			offset = Vector2.ZERO
			
		# Limitar desplazamiento máximo para que sea suave
		if dir.length() > velocidad_max * delta:
			dir = dir.normalized() * velocidad_max * delta
		nodo_objetivo.move_and_collide(dir)
		
	else:
		# Si el nodo está muy fuera del viewport, lo corregimos
		if nodo_objetivo.global_position.x < -margen or nodo_objetivo.global_position.x > viewport.x + margen \
		or nodo_objetivo.global_position.y < -margen or nodo_objetivo.global_position.y > viewport.y + margen:
			nodo_objetivo.global_position = viewport / 2  # regresar al centro de la pantalla
		#nodo_objetivo.set_sleeping(false)
	#endregion 
	
	#region El progress bar avanza segun el tiempo que quede en el Timer
	#if timerun:
		#if timer.get_time_left() > 0:
			#T_porciento = ((1 - timer.get_time_left() / timer.get_wait_time()) * 100)
			#precio_progres.value = T_porciento
	#endregion
	
#region Detector del mouse sobre el producto
func _mouse_entra():
	label_info.show()
	mouse_in = true

func _mouse_sale():
	label_info.hide()
	mouse_in = false
#endregion

#region Drag and drop
func _on_button_down():
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		draggin = true
		offset = nodo_objetivo.get_global_mouse_position() - nodo_objetivo.global_position
	#else:
		#if !check:
			#timer.start()
			#timerun = true

func _on_button_up():
	draggin = false
	#if not Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		#timer.stop()
		#precio_progres.value=0
		#timerun = false
	pass # Replace with function body.
#endregion

#func _on_timer_timeout():
	#l_datos.show()
	#l_datos.text = precio
	#precio_progres.value=0
	#GLOBAL.emit_signal("set_price",precio)
	#check = true #Verifica si ya se hizo check al precio para no volver a escanear
	#pass # Replace with function body.
