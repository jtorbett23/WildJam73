extends RigidBody3D

var inital_pos = self.position

func _process(delta):
	if(self.position.y < -5):
		self.position = inital_pos