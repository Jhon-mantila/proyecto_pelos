extends Area2D

@export var speed = 400 # Como de rapido podría moverse el jugador
var screen_size #tamaño de la ventada del juego
signal health_changed(old_value, new_value)
var health = 3

signal hit

func _ready():
	screen_size = get_viewport_rect().size
	hide() # ocultar el jugador al inicio
	

func _process(delta):
	walk_and_animate(delta)


func walk_and_animate(delta):
	
	var velocity = Vector2.ZERO # The player's movement vector.
	
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		# See the note below about the following boolean assignment.
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0
		
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
func add_health(amount):
	var old_health = health
	health += amount
	if health > 3:
		health = 3  # límite máximo opcional
	health_changed.emit(old_health, health)
	print("💚 Player health:", health)
	
func take_damage(amount):
	var old_health = health
	health -= amount
	health_changed.emit(old_health, health)
	print("💥 Player health:", health)
	if health <= 0:
		hide() # Player disappears after being hit.
		hit.emit()
		$CollisionShape2D.set_deferred("disabled", true)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("mob"):
		$HitSound.play()
		take_damage(1)
	elif body.is_in_group("potion"):
		if has_method("add_health"):
			$HealthSound.play()
			add_health(1)
			body.queue_free()
			print("🧪 Poción recogida: +1 vida")
	#hide() # Player disappears after being hit.
	#hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback.
	#$CollisionShape2D.set_deferred("disabled", true)
	
func start(pos):
	position = pos
	health = 3  # reiniciar salud
	show()
	$CollisionShape2D.disabled = false
