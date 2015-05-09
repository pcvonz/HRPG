
extends Panel

# member variables here, example:
var children
var task_id
var url = "/api/v2/user/tasks/"

func post_task():
	url += task_id + "/up"

	##Should make this grayed out instead.
	get_parent().remove_child(self)
	
	
func _ready():
	pass



