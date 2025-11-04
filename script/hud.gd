extends CanvasLayer

# Notifica a la scena main que se ha pulsado el boton
signal start_game


func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
	
func show_game_over():
	show_message("Game Over")
	# Wait until the MessageTimer has counted down.
	await $MessageTimer.timeout

	$Message.text = "Dodge the Creeps!"
	$Message.show()
	# Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()
	$InfoButton.show()
	
func update_score(score):
	$ScoreLabel.text = str(score)

func update_health(health):
	#$HealthLabel.text = str("❤️ ", health)
	var hearts = "❤️".repeat(health)
	$HealthLabel.text = hearts
	
func _on_start_button_pressed() -> void:
	$StartButton.hide()
	$InfoButton.hide()
	start_game.emit()

func _on_message_timer_timeout() -> void:
	$Message.hide()

func _on_player_health_changed(old_value: Variant, new_value: Variant) -> void:
	update_health(new_value)

func _on_info_button_pressed() -> void:
	$ScoreLabel.hide()
	$Message.hide()
	$StartButton.hide()
	$InfoButton.hide()
	$HUDINFO.show()
	
# 👇 Nueva función para mostrar de nuevo los botones y label
func show_main_buttons():
	$ScoreLabel.show()
	$Message.show()
	$StartButton.show()
	$InfoButton.show()
	
	
