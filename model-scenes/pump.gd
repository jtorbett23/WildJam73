class_name Pump extends StaticBody3D

@onready var pancake_path : String = "model-scenes/pancake.tscn"
@onready var spawn_point : Node3D = $SpawnPoint

# mesh.
#const cake_albedo = Color(0.906, 0.777, 0)
#const ube_albedo = Color(0.839, 0, 0.907)
#const syrup_albedo = Color(0.907, 0.637, 0.024)
# Called when the node enters the scene tree for the first time.

func interact(holding):
	spawn_pancake(holding)


func spawn_pancake(holding):
	var new_pancake = load(pancake_path).instantiate()
	
	new_pancake.position = spawn_point.global_position
	get_parent().add_child(new_pancake)
	if holding != null:	
		new_pancake.get_node("pancake").pan = holding
