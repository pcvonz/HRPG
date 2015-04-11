
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
	get_parent().remove_and_delete_child(self)
	
func _ready():
	# Initialization here
	pass


