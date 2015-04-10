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

func _init():
	panel_pos.y = -60
	panel_pos.x = 200
	panel_size_end.x = 300
	panel_size_end.y = 60

func _on_button_pressed():
	print("HELLO")
	_create_widget()

func task_button_pressed(text):
	pass
#useful canvas item stuff. get_parent, get_size, set_size.
func _create_widget(text, id):
	button_size_begin.x = 200
	button_size_begin.y = 0
	button_size_end.x = 200
	button_size_end.y = 0
	panel_pos.y = panel_pos.y + 40
	
	button = Button.new()
	panel = Panel.new()
	label = Label.new()
	var node = get_node("post").duplicate()
	node.set_name(text)
	button.set_text(text)
	button.connect("pressed", node, "post_it")
	node.task_id = id
	
	panel.set_name("panel" + str(button_number))
	button_number = button_number + 1
	label.set_text(text)
	get_node("Panel").add_child(panel)
	panel.add_child(button)
	panel.add_child(label)
	
	button.set_begin(button_size_begin)
	button.set_end(button_size_end)
	panel.set_end(panel_size_end)
	panel.set_pos(panel_pos)


func _ready():
	print("HELLO O O O ")
	get_node("Button").connect("pressed", self, "_on_button_pressed")