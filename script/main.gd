extends Node

@export var mob_scene: PackedScene
@export var potion_scene: PackedScene

var score

func _ready():
	pass
	#new_game()

func game_over() -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()
	$PotionTimer.stop()
	$Music.stop()
	$DeathSound.play()
	$HUD.show_game_over()
															
func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$Music.play() #Activamos la musica de fondo del juego
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	get_tree().call_group("mob", "queue_free")
	# Mostramos la salud inicial
	$HUD.update_health($Player.health)

func _on_mob_timer_timeout() -> void:
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()

	# Choose a random location on Path2D.
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	# Set the mob's position to the random location.
	mob.position = mob_spawn_location.position

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)

func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)

func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$PotionTimer.start()
	$ScoreTimer.start()

func _on_potion_timer_timeout() -> void:
	# Crer nueva instancia de la escena de la pocioo
	var potion = potion_scene.instantiate()
	
	# Cambiar una pocición aleatoria en el Path2D
	var potion_spawn_location = $MobPath/PotionSpawnLocation
	potion_spawn_location.progress_ratio = randf()
	
	# Estableces la dirección de la poción en la ruta perpendicular
	var direction = potion_spawn_location.rotation + PI / 2
	
	# Agregar algo de aleatorio a la dirección
	direction += randf_range(-PI / 4,PI / 4)
	potion.rotation = direction
	
	# Cambiar la velocidad de las pociones
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	potion.linear_velocity = velocity.rotated(direction)
	
	#Genera la poción añadiendolo en la escena principal
	add_child(potion)
	
	
	
	
	
	
