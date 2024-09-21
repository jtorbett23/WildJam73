class_name Pancake extends RigidBody3D

var inital_pos : Vector3 = self.position
var on_pan : bool = false
var flung : bool = false
var thrown : bool = false
var pan 
@onready var ube : StandardMaterial3D = load("res://model-scenes/ube.tres")
@onready var camera : Camera3D = $"../Camera3D"

const END_COLLISONS = ["WindowCol", "FloorCol", "GroundCol"]

func _ready():
	# 1 = x, 2 = y, 4 = z
	# lock_axes(true)
	self.body_entered.connect(handle_body_entered)
	self.body_exited.connect(handle_body_exited)

func setup(type: Pump.type):
	if type == Pump.type.CLASSIC:
		var mesh: MeshInstance3D = $Cylinder
		mesh.set_surface_override_material(0, null)

func lock_axes(state: bool):
	self.set_axis_lock(1, state)
	self.set_axis_lock(4,state)

var pan_offset = 0.2
var speed = 10

func move_to_pan():
	self.global_position.x = clamp(self.global_position.x, pan.global_position.x - pan_offset,  pan.global_position.x + pan_offset)
	self.global_position.z = clamp(self.global_position.x,  pan.global_position.z - pan_offset,  pan.global_position.z + pan_offset)

func _physics_process(delta):
	if self.global_position.y > 5:
		thrown = true
	if pan != null:
		if on_pan and !pan.two_hands:
			# get_parent().position = Vector3.ZERO
			pass
			move_to_pan()
		else:
			get_parent().position += (position - inital_pos)
			self.position = inital_pos
			if pan.two_hands and flung:
				if Input.is_action_pressed("up"):
					self.position.z -= speed * delta
				elif Input.is_action_pressed("down"):
					self.position.z += speed * delta
				elif Input.is_action_pressed("right"):
					self.position.x += speed * delta
				elif Input.is_action_pressed("left"):
					self.position.x -= speed * delta


		
	if(self.position.y < -5 or get_parent().position.y <= -5):
		# self.position = inital_pos

		# despawn
		camera.clear_current()
		self.get_parent().queue_free()

		# reset pos
		# get_parent().position = Vector3.ZERO

func handle_body_entered(col):
	# if(col.get_script() != get_script()):
	print("entered", col.name)
	if(col.name == "pan"):
		on_pan = true
		lock_axes(false)
	if col is Pan or col is Pancake:
		camera.clear_current()
	elif col.name in END_COLLISONS:
		get_tree().create_timer(2).timeout.connect(func(): 
			camera.clear_current()
			get_parent().queue_free()
			)
	elif col.name == "UnitsCol" and thrown:
		get_tree().create_timer(2).timeout.connect(func(): 
			camera.clear_current()
			get_parent().queue_free()
			)
		
	flung = false

func handle_body_exited(col):
	if(col is Pan):
		print("exited", col.name)
		on_pan = false
		flung = true
		
		if !pan.two_hands:
			lock_axes(true)
		else:
#			do not change camera if normal flip
			if linear_velocity.y > 0:
				camera.make_current()
