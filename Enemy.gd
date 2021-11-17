extends KinematicBody2D

export (int) var speed
var onTheMove = Vector2()
var screen_size
var direccion = 1
var collision

func _ready():
	show()
	screen_size = get_viewport_rect().size

func _physics_process(delta):
	onTheMove = Vector2() #Reinicia el valor
	collision = move_and_collide(onTheMove * delta)

	#if (position.y < 26): #Derecha
	#	direccion = 1
	#elif(position.y > (screen_size.y - 25)): #Izquierda
	#	direccion = direccion * (-1)
	
	onTheMove.y += direccion
	
	if onTheMove.length() > 0: #Verificar si esta en movimietno
		onTheMove = onTheMove.normalized() * speed #Normalizar
		
	
	move_and_slide(onTheMove * delta)
	
	if (get_slide_count() > 0):
		direccion = direccion * (-1)
	
	#position += onTheMove * delta #Actualizar los movimientos
	#position.x = clamp(position.x, 0, screen_size.x)
	#position.y = clamp(position.y, 25, screen_size.y)
	
	if onTheMove.y !=0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_h = direccion < 0 
