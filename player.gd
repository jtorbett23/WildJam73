extends CharacterBody3D


const SPEED = 5.0
const ROTATION_FACTOR = 0.01
const RAY_LENGTH = 1000

@onready var ignored_collision_shapes : Array = $"../Truck".collison_shapes + [self]
@onready var neck : Node3D = $Neck
@onready var camera : Camera3D = $Neck/Camera3D
@onready var hands : Node3D = $Hands
@onready var left_hand: MeshInstance3D = $Hands/Left
@onready var right_hand: MeshInstance3D = $Hands/Right


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	#if event is InputEventMouse:
		#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if event.is_action_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			neck.rotate_y(-event.relative.x * ROTATION_FACTOR)
			hands.rotate_y(-event.relative.x * ROTATION_FACTOR)
			camera.rotate_x(-event.relative.y * ROTATION_FACTOR)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-30), deg_to_rad(60))
	
	if event is InputEventMouseButton:
		if event.button_mask == MOUSE_BUTTON_LEFT:
			var collider = get_click_collisions()
			if collider != null:
				print(collider)
				if collider.has_node("GrabPoint"):
					collider.get_parent().remove_child(collider)
					collider.position = Vector3.ZERO - collider.get_node("GrabPoint").position
					collider.rotation = Vector3.ZERO 
					left_hand.add_child(collider)
#					IF SCAN TO PHYSICS ON PAN, MOVE THIS CODE??? did not work cri
		#elif event.button_mask == MOUSE_BUTTON_RIGHT:
			#var collider = get_click_collisions()
			#if collider:
				#if collider.has_node("GrabPoint"):
					#collider.get_parent().remove_child(collider)
					#collider.position = Vector3.ZERO - collider.get_node("GrabPoint").position
					#collider.rotation = Vector3.ZERO 
					#right_hand.add_child(collider)
			

func get_click_collisions():
		var space_state = get_world_3d().direct_space_state
		var mousepos = get_viewport().get_mouse_position()

		var origin = camera.project_ray_origin(mousepos)
		var end = origin + camera.project_ray_normal(mousepos) * RAY_LENGTH
		var query = PhysicsRayQueryParameters3D.create(origin, end,4294967295, ignored_collision_shapes)
		query.collide_with_areas = true

		var result = space_state.intersect_ray(query)
		if result and result["collider"]:
			var collider = result["collider"]
			return collider	
		return null


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (neck.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
