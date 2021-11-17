extends Label

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var life = Resources.life  # Singleton variable

# Called when the node enters the scene tree for the first time.
func _ready():
	self.text = str("Lives: ", life)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
