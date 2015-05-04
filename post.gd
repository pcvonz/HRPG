
extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"
var task_id
var url = "/api/v2/user/tasks/"

func post_task():
	url += task_id + "/up"
#	get_parent().get_node("http").http_post(task_id, url)
	print(get_parent())
	get_parent().const_margin_top -= 37.5
	get_parent().set_margin(MARGIN_TOP, get_parent().const_margin_top)
	##Should make this grayed out instead.
	get_parent().remove_child(self)
	
	
func _process(delta):
	get_parent().set_size(OS.get_window_size())
	
func _ready():
	set_process(true)


