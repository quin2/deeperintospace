extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	hideControls()
	
func hideControls():
	$left.hide()
	$right.hide()
	$boost.hide()

func showControls():
	$left.show()
	$right.show()
	$boost.show()

