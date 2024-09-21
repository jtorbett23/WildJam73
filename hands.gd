extends Node3D

const TWO_HAND_OFFSET = 0.2
@onready var right_inital_pos = $Right.position
var is_two_handed : bool = false

func toggle_two_handed():
	if !is_two_handed:
		$Right.position = $Left.position + Vector3(TWO_HAND_OFFSET,0,0)
	else:
		$Right.position = right_inital_pos
	is_two_handed = !is_two_handed
