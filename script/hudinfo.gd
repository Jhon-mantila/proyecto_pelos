extends CanvasLayer

func _ready():
	hide() # aseguramos que esté oculta al inicio

func _on_return_button_pressed() -> void:
	hide()
	get_parent().show_main_buttons() # vuelve a mostrar los botones del HUD principal
