extends AnimatableBody3D

@onready var pancake_path : String = "model-scenes/pancake.tscn"
#@onready var label : Label3D = $'../Camera3D/Label3D'
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
	two_hands = !two_hands
	print("Two Hands is ", two_hands)
	#if(label.text == "1"):
		#label.text = "2"
		#two_hands = true
	#else:
		#label.text = "1"
		#two_hands = false

func spawn_pancake():
	var new_pancake = load(pancake_path).instantiate()	
	new_pancake.position = self.position
	get_parent().add_child(new_pancake)
