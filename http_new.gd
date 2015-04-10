extends Node2D
var http
var headers
# HTTPClient demo
# This simple class can do HTTP requests, it will not block but it needs to be polled
# member variables here, example:
# var a=2
# var b="textvar"
var user
var user_id
var api_key

func generate_api_string(dictionary):
	var beep = ""
	for keys in dictionary.keys():
		beep = beep + keys + ": " + str(dictionary[keys]) + "\n"
	return beep
	
func _on_button_pressed():
	var beep = generate_api_string(user.profile)
	change_text(beep)

func _on_stats_pressed():
	var beep = generate_api_string(user.stats)
	change_text(beep)

func _on_tasks_pressed():
	var temp = ""
	for i in user.todos:
		if i.completed == false:
			temp = temp + str(i.text) + "\n"
			get_parent()._create_widget(temp, i.id)
			temp = ""
	change_text(temp)

func change_text(text):
	get_parent().get_node("Output").clear()
	get_parent().get_node("Output").add_text(text)

func http_request():
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
	
    # Some headers

	headers=[
		"x-api-user: " + user_id,
		"x-api-key: " + api_key
    ]

	err = http.request(HTTPClient.METHOD_GET,"/api/v2/user",headers) # Request a page from the site (this one was chunked..)
	if (err == OK ):
		var popup = get_parent().get_node("PopupDialog")
		popup.show()# Make sure all is OK
		popup.get_node("lable_err").set_text("Can't connect! Wrong key/user id?")
		
	while (http.get_status() == HTTPClient.STATUS_REQUESTING):
        # Keep polling until the request is going on
        http.poll()
        print("Requesting..")
        OS.delay_msec(500)


	assert( http.get_status() == HTTPClient.STATUS_BODY or http.get_status() == HTTPClient.STATUS_CONNECTED ) # Make sure request finished well.

	print("response? ",http.has_response()) # Site might not have a response.


	if (http.has_response()):
        #If there is a response..
		var headers = http.get_response_headers_as_dictionary() # Get response headers
		print("code: ",http.get_response_code()) # Show response code
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

		var rb = RawArray() #array that will hold the data

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
func _post():
	pass

func _ready():
	var file = File.new()
	file.open("key.txt", 1)
	user_id = "SDf"
	api_key = file.get_line()
	print(user_id)
	http_request()
	print(user.keys())
	get_parent().get_node("User").connect("pressed",self,"_on_button_pressed")
	get_parent().get_node("Stats").connect("pressed",self,"_on_stats_pressed")
	get_parent().get_node("Tasks").connect("pressed",self,"_on_tasks_pressed")