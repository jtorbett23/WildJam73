extends Node3D

static var colour_list : Array = [Color.YELLOW, Color.AQUAMARINE, Color.MEDIUM_PURPLE, Color.PALE_GREEN, Color.HOT_PINK]
static var material_list : Array = [preload("res://model-scenes/customer1.tres"),preload("res://model-scenes/customer2.tres"),
preload("res://model-scenes/customer3.tres"), preload("res://model-scenes/customer4.tres"), preload("res://model-scenes/customer5.tres")]
@onready var customer : MeshInstance3D = $Customer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	customer.material_override = material_list.pop_back()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
