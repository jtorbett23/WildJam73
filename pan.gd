extends Node3D

@onready var pancake_path : String = "pancake2.tscn"
@onready var camera : Camera3D = $'../Camera3D'


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
#	make the pan follow the mouse
	if event.is_action_released("ui_up"):
		self.rotation.x = lerp(self.rotation.x, self.rotation.x - deg_to_rad(45), 1)
	elif event.is_action_released("ui_down"):
		self.rotation.x = lerp(self.rotation.x, self.rotation.x + deg_to_rad(45), 1)
	elif event.is_action_released("ui_accept"):
		spawn_pancake()

func spawn_pancake():
	get_parent().add_child(load(pancake_path).instantiate())
	pass
