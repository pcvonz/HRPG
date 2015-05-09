
extends Panel
var children
# This handles responsive screen size for interface buttons.
# 
func _process(delta):
	var screen_size = OS.get_window_size()
	var x = screen_size.x / 5
	var size = Vector2(x, 2)
	children = get_children()[0].get_children()
	for child in children:
		#set all nodes that don't contain method "set_size" to not visible
		if child.is_visible():
			child.set_size(size)
	set_size(OS.get_window_size())
	

func _ready():
	set_process(true)

