class_name Pan extends Node3D

@onready var pancake_path : String = "pancake.tscn"
@onready var label : Label3D = $'../Camera3D/Label3D'
@onready var two_hands : bool = false


func _input(event: InputEvent) -> void:
#	make the pan follow the mouse
	if event.is_action_released("ui_up"):
		self.rotation.x = lerp(self.rotation.x, self.rotation.x - deg_to_rad(45), 1)
	elif event.is_action_released("ui_down"):
		self.rotation.x = lerp(self.rotation.x, self.rotation.x + deg_to_rad(45), 1)
	elif event.is_action_released("ui_accept"):
		spawn_pancake()
	elif event.is_action_released("ui_focus_next"):
		toggle_hands()

func toggle_hands():
	if(label.text == "1"):
		label.text = "2"
		two_hands = true
	else:
		label.text = "1"
		two_hands = false

func spawn_pancake():
	get_parent().add_child(load(pancake_path).instantiate())
