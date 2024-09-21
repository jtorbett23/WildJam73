class_name Pancake extends RigidBody3D

var inital_pos : Vector3 = self.position
var on_pan : bool = false
var flung : bool = false
var thrown : bool = false
var pan 
var is_falling: bool = false
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
var speed = 50

func move_to_pan():
	self.global_position.x = clamp(self.global_position.x, pan.global_position.x - pan_offset,  pan.global_position.x + pan_offset)
	self.global_position.z = clamp(self.global_position.x,  pan.global_position.z - pan_offset,  pan.global_position.z + pan_offset)

func _physics_process(delta):
	# if is_falling:
	# 	print(linear_velocity)
	if self.global_position.y > 5:
		thrown = true
	#if self.linear_velocity.y < 0 and !is_falling and thrown:
		#is_falling = true	
	
	if pan != null:
		if on_pan and !pan.two_hands:
			move_to_pan()
		else:
			get_parent().position += (position - inital_pos)
			self.position = inital_pos
			if pan.two_hands and flung:
				if Input.is_action_pressed("up"):
					self.linear_velocity.z -= speed * delta
				if Input.is_action_pressed("down"):
					self.linear_velocity.z += speed * delta
				if Input.is_action_pressed("right"):
					self.linear_velocity.x += speed * delta
				if Input.is_action_pressed("left"):
					self.linear_velocity.x -= speed * delta
		
		linear_velocity.y = clamp(linear_velocity.y, -20, 100)

		
	if(self.position.y < -5 or get_parent().position.y <= -5):
		# self.position = inital_pos

		# despawn
		camera.clear_current()
		self.get_parent().queue_free()

		# reset pos
		# get_parent().position = Vector3.ZERO

func handle_body_entered(col):
	# if(col.get_script() != get_script()):
	# print("entered", col.name)
	if(col.name == "pan"):
		on_pan = true
		lock_axes(false)
	if col.name == "Plate":
		self.linear_velocity = Vector3.ZERO
		get_tree().create_timer(2).timeout.connect(func(): 
			camera.clear_current()
			)
	elif col is Pan or col is Pancake:
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
		#print("exited", col.name)
		on_pan = false
		flung = true
		
		if !pan.two_hands:
			lock_axes(true)
		else:
#			do not change camera if normal flip
			if linear_velocity.y > 0:
				camera.make_current()
