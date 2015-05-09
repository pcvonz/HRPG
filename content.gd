
extends Panel

var button
var button_number = 0
var panel
var label

#change vector size with variable.x and variable.y
var button_size_begin = Vector2()
var button_size_end = Vector2()
var panel_pos = Vector2()

var panel_size_begin = Vector2()
var panel_size_end = Vector2()

var const_margin_top = 0

func _init():
	panel_pos.y = -60
	panel_pos.x = 200
	panel_size_end.x = 300
	panel_size_end.y = 10

func _on_button_pressed():
	_create_widget()

#useful canvas item stuff. get_parent, get_size, set_size.
func _create_widget(text, id):
	panel_pos.y = panel_pos.y + 40
	
	#creating objects
	button = Button.new()
	label = Label.new()
	
	#Setting their anchor to ratio!
	#Helps with responsive design. 
	button.set_anchor(0, ANCHOR_RATIO)
	label.set_anchor(0, ANCHOR_RATIO)
	
	#Make a new post node and add it as a child of panel
	#Post is the object which holds all the task names and buttons to check off task
	var node = get_parent().get_node("post").duplicate()
	get_parent().add_child(node)
	
	#set up button
	button.set_text(text)
	button.connect("pressed", node, "post_task")
	node.task_id = id
	
	#naming nodes
	button.set_name("button" + id)
	label.set_name("label" + id)
	
	label.set_text(text)

	node.add_child(button)
	node.add_child(label)
	
	button.set_global_pos(Vector2(node.get_global_pos().x + 30, node.get_global_pos().y))
	print("button" + str(button.get_global_pos()))
	print(node.get_global_pos())
	print(label.get_global_pos())
	node.set_end(panel_size_end)
	node.set_pos(panel_pos)


func _ready():
	pass