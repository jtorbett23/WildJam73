extends RigidBody3D

var inital_pos : Vector3 = self.position
var on_pan : bool = false
@onready var camera : Camera3D = $"../Camera3D"

func _ready():
	# 1 = x, 2 = y, 4 = z
	# lock_axes(true)
	self.body_entered.connect(handle_body_entered)
	self.body_exited.connect(handle_body_exited)

func lock_axes(state: bool):
	self.set_axis_lock(1, state)
	self.set_axis_lock(4,state)

var pan_offset = 0.1
var speed = 10

func _physics_process(delta):
	
	if on_pan:
		self.position.x = clamp(self.position.x, inital_pos.x - pan_offset, inital_pos.x + pan_offset)
		self.position.z = clamp(self.position.x, inital_pos.z - pan_offset, inital_pos.z + pan_offset)
	else:
		get_parent().position += (position - inital_pos)
		self.position = inital_pos
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
	on_pan = true
	lock_axes(false)
	camera.clear_current()
	pass

func handle_body_exited(col):
	if(col.get_script() != get_script()):
		print("exited")
		on_pan = false
		camera.make_current()
		# lock_axes(true)
		pass
