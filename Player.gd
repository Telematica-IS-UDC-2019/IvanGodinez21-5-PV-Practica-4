extends KinematicBody2D

#signal hit

export var speed = 33000  # How fast the player will move (pixels/sec).
var screen_size
var life = Resources.life  # Singleton variable
var collision
var points = 0
signal gameOver

const ground = Vector2(0,-1)
const jump_force = -10000
const gravity = 1
var on_ground = false

const Candy = preload("res://Candy.tscn")
var looking_left = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start()
	screen_size = get_viewport_rect().size
	pass

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var velocity = Vector2()  # The player's movement vector.

	if Input.is_key_pressed(KEY_SPACE):
		$Timer.start()
		$AnimationPlayer.play("Action")
		var candy = Candy.instance()
		if sign($Position2D.position.x) == 1:
			candy.set_direction(1)
		else:
			candy.set_direction(-1)
		get_parent().add_child(candy)
		candy.position = $Position2D.global_position
	if Input.is_action_pressed("ui_right") || Input.is_key_pressed(KEY_D):
		$Timer.start()
		velocity.x += 1
		looking_left = false
		if sign($Position2D.position.x) == -1:
			$Position2D.position.x *= -1
	if Input.is_action_pressed("ui_left") || Input.is_key_pressed(KEY_A):
		$Timer.start()
		velocity.x -= 1
		looking_left = true
		if sign($Position2D.position.x) == 1:
			$Position2D.position.x *= -1
#	if Input.is_action_pressed("ui_down") || Input.is_key_pressed(KEY_S):
#		$Timer.start()
#		velocity.y += 1
	if Input.is_action_pressed("ui_up") || Input.is_key_pressed(KEY_W):
		print('prees UP')
		if (on_ground):
			print('on ground')
			$Timer.start()
			velocity.y += jump_force
		
	velocity.y += gravity
		
	velocity = move_and_slide(velocity, ground)
	
	if (is_on_floor()):
		on_ground = true
	else:
		on_ground = false
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimationPlayer.play("Walk")
	
	#position += velocity * delta
	#position.x = clamp(position.x, 0, screen_size.x)
	#position.y = clamp(position.y, 0, screen_size.y)
	
	if velocity.x != 0:
		$AnimationPlayer.play("Walk")
#		$Sprite.flip_v = false
		# See the note below about boolean assignment
		$Sprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimationPlayer.play("Up")
#		$Sprite.flip_v = velocity.y > 0
	
	move_and_slide(velocity * delta)
	
	if (get_slide_count() > 0):
		for i in range(get_slide_count()):
			if "Enemy" in get_slide_collision(i).collider.name:
				touched(get_slide_collision(i).collider.name)

func touched(collision_object):
	hide()  # Player disappears after being hit.
	emit_signal("hit")
	$PainSound.volume_db = 10
	if ($PainSound.playing == false):
		$PainSound.play()
	life -= 1
	if (life > 0):
		position.x = 512
		position.y = 559
		start(position)
	else:
		$CollisionShape2D.set_deferred("disabled", true)
		emit_signal("gameOver")
	if (points > 0):
		if (life >= 0):
			get_node("../LifeCounterPlayer").text = str("Lives: ", life, " Points: ", points)
	else: 
		if (life >= 0):
			get_node("../LifeCounterPlayer").text = str("Lives: ", life)


func _on_Timer_timeout():
	$AnimationPlayer.play("Idle")
