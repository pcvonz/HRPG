extends Node2D

var http
var headers
var user

# Deprecated function that used to print all tasks. 
# Reference on tasks pressed to see the current way of handling this.
func generate_api_string(dictionary):
	var beep = ""
	for keys in dictionary.keys():
		beep = beep + keys + ": " + str(dictionary[keys]) + "\n"
	return beep
	
func _on_button_pressed():
	var beep = generate_api_string(user.profile)


func _on_stats_pressed():
	var beep = generate_api_string(user.stats)

# Creates a new node for each task and links it to a button
# For all tasks that aren't completed.
func _on_tasks_pressed():
	var temp = ""
	for i in user.todos:
		if i.completed == false:
			temp = temp + str(i.text) + "\n"
			get_parent().get_node("content")._create_widget(temp, i.id)
			temp = ""

# Grabs hrpg and stores it i variable http.
# Needs ssl cert, check godot settings.
func http_init():
	var err=0
	http = HTTPClient.new() # Create the Client
	var err = http.connect("https://habitrpg.com", 443, true)
	assert(err==OK)
	
	while( http.get_status()==HTTPClient.STATUS_CONNECTING or http.get_status()==HTTPClient.STATUS_RESOLVING):
                #Wait until resolved and connected
        http.poll()
        print("Connecting..")
        OS.delay_msec(500)

	assert( http.get_status() == HTTPClient.STATUS_CONNECTED ) # Could not conn
	
# Get User
# Gets the user from the habit rpg server. 
# If it doesn't succeed it requests the user to input api key and user id
## Need to figure out how to check if the it's connected or not. If it's not connected show pop up, otherwise don't show..
func http_get_user():
	var err = http.request(HTTPClient.METHOD_GET,"/api/v2/user",headers) # Request a page from the site (this one was chunked..)
	
		
	while (http.get_status() == HTTPClient.STATUS_REQUESTING):
        # Keep polling until the request is going on
        http.poll()
        print("Requesting..")
        OS.delay_msec(500)


	assert( http.get_status() == HTTPClient.STATUS_BODY or http.get_status() == HTTPClient.STATUS_CONNECTED ) # Make sure request finished well.

	print("response? ",http.has_response()) # Site might not have a response.

	print(http.get_response_code())
	
	# The 401 check makes sure that the api_key and user_id are accetpted by the server
	if (http.has_response() && (http.get_response_code() != 401)):
        #If there is a response..
		var headers = http.get_response_headers_as_dictionary() # Get response headers
		print("code: ",http.get_response_code()) # Show response code
		# Make sure all is OK
		print("**headers:\n",headers) # Show headers
		
		#Getting the HTTP Body
		if (http.is_response_chunked()):
            #Does it use chunks?
			print("Respose is Chunked!")
		else:
            #Or just plain Content-Length
			var bl = http.get_response_body_length()
			print("Response Length: ",bl)
	        #This method works for both anyway
			var rb = RawArray() #array that will hold the data\
			
			while(http.get_status()==HTTPClient.STATUS_BODY):
			#While there is body left to be read
				http.poll()
				var chunk = http.read_response_body_chunk() # Get a chunk
				if (chunk.size()==0):
	                #got nothing, wait for buffers to fill a bit
					OS.delay_usec(1000)
				else:
					rb = rb + chunk # append to read bufer
			#done!
			var text = rb.get_string_from_ascii()
			
			var task_dict = Dictionary()
			task_dict.parse_json(text)
			user = task_dict
			
			#connect all the buttons
			get_parent().get_node("User").connect("pressed",self,"_on_button_pressed")
			get_parent().get_node("Stats").connect("pressed",self,"_on_stats_pressed")
			get_parent().get_node("Tasks").connect("pressed",self,"_on_tasks_pressed")
	else:
		#if it doesn't work then show the pop-up dialog that allows api_key and user_id entry
		var popup = get_parent().get_node("PopupDialog")
		popup.show()
		popup.get_node("lable_err").set_text("Can't connect! Wrong key/user id?")
		

func http_post(task_id, url):
	print(task_id)
	http.request(HTTPClient.METHOD_POST, url, headers)

# Get headers retrieves the headers from the file keys.txt. 
# keys.txt should be stored in the root directory of the game folder.
func get_headers():
	var file = File.new()
	file.open("key.txt", 1)
	var user_id = file.get_line()
	var api_key = file.get_line()
	file.close()
	headers=[
	"x-api-user: " + user_id,
	"x-api-key: " + api_key
    ]


func _ready():
	get_headers()
	http_init()
	http_get_user()
