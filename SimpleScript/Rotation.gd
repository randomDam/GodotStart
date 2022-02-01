extends MeshInstance


export var vitesse:float=0.1

#-----------------------------------------------------------
#	READY
#-----------------------------------------------------------
func _ready():
	
	pass
	
	
#-----------------------------------------------------------
#	PROCESS
#-----------------------------------------------------------
func _process(delta):
	self.rotate_y(vitesse*delta)
	self.rotate_x(vitesse*delta)
	pass
