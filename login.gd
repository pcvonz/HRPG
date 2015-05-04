
extends PopupDialog

func _login():
	var user_id = get_node("user").get_text()
	var api_key = get_node("api").get_text()
	var file = File.new()
	file.open("key.txt", 2)
	file.store_string(user_id + "\n" + api_key)
	file.close()
	self.hide()
	get_parent().get_node("http")._ready()
	
	

func _ready():
	# Initialization here
	get_node("login_button").connect("pressed", self, "_login")


