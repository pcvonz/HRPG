
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
	panel_size_end.y = 60

func _on_button_pressed():
	print("HELLO")
	_create_widget()

#useful canvas item stuff. get_parent, get_size, set_size.
func _create_widget(text, id):
	button_size_begin.x = 200
	button_size_begin.y = 0
	button_size_end.x = 200
	button_size_end.y = 0
	panel_pos.y = panel_pos.y + 40
	
	#creating widget objects
	button = Button.new()
	panel = Panel.new()
	label = Label.new()
	#Make a new post node and add it as a child of panel
	var node = get_node("post").duplicate()
	add_child(node)
	
	#set up button
	button.set_text(text)
	button.connect("pressed", node, "post_task")
	
	node.task_id = id
	
	#naming nodes
	button.set_name("button" + id)
	panel.set_name(id)
	label.set_name("label" + id)
	
	
	label.set_text(text)
	node.add_child(panel)
	panel.add_child(button)
	panel.add_child(label)
	
	button.set_begin(button_size_begin)
	button.set_end(button_size_end)
	panel.set_end(panel_size_end)
	panel.set_pos(panel_pos)


func _ready():
	print("HELLO O O O ")