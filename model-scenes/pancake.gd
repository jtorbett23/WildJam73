class_name Pancake extends RigidBody3D

var inital_pos : Vector3 = self.position
var on_pan : bool = false
var flung : bool = false
var pan 
@onready var ube : StandardMaterial3D = load("res://model-scenes/ube.tres")
@onready var camera : Camera3D = $"../Camera3D"

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

var pan_offset = 0.1
var speed = 10

func _physics_process(delta):
	
	if pan != null:
		if on_pan:
			# get_parent().position = Vector3.ZERO
			self.global_position.x = clamp(self.global_position.x, pan.global_position.x - pan_offset,  pan.global_position.x + pan_offset)
			self.global_position.z = clamp(self.global_position.x,  pan.global_position.z - pan_offset,  pan.global_position.z + pan_offset)
		else:
			get_parent().position += (position - inital_pos)
			self.position = inital_pos
			if pan.two_hands and flung:
				if Input.is_action_pressed("ui_up"):
					self.position.z -= speed * delta
				elif Input.is_action_pressed("ui_down"):
					self.position.z += speed * delta
				elif Input.is_action_pressed("ui_right"):
					self.position.x += speed * delta
				elif Input.is_action_pressed("ui_left"):
					self.position.x -= speed * delta


		
	if(self.position.y < -5 or get_parent().position.y <= -5):
		# self.position = inital_pos

		# despawn
		camera.clear_current()
		queue_free()

		# reset pos
		# get_parent().position = Vector3.ZERO

func handle_body_entered(col):
	# if(col.get_script() != get_script()):
	print("entered")
	if(col.name == "pan"):
		on_pan = true
		lock_axes(false)
	camera.clear_current()
	flung = false

func handle_body_exited(col):
	if(col.get_script() != get_script() and col.name == "pan"):
		print("exited")
		on_pan = false
		flung = true
	
		
		if !pan.two_hands:
			lock_axes(true)
		else:
#			do not change camera if normal flip
			camera.make_current()
