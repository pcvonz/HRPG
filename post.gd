
extends Control

# member variables here, example:
# var a=2
# var b="textvar"
var task_id
var url = "/api/v2/user/tasks/" 

func post_it():
	print(task_id)
	var err=0
	var http = HTTPClient.new() # Create the Client
	var err = http.connect("https://habitrpg.com", 443, true)
	assert(err==OK)
	
	
	while( http.get_status()==HTTPClient.STATUS_CONNECTING or http.get_status()==HTTPClient.STATUS_RESOLVING):
                #Wait until resolved and connected
        http.poll()
        print("Connecting..")
        OS.delay_msec(500)

	assert( http.get_status() == HTTPClient.STATUS_CONNECTED ) 
	
	
	print("HELLO")
	var headers=[
		"x-api-user: " + "b16e0c46-c20b-4aea-9f1f-6e9dd80ad61b",
		"x-api-key: " + "3f1607f9-4c83-44d9-9971-1ffb0929957c"
    ]
	url = url + task_id + "/up/"
	http.request(HTTPClient.METHOD_POST,"/api/v2/user/tasks/5d591607-e3f6-4b83-bdd6-07239461a096/up",headers)
	
	
func _ready():
	# Initialization here
	pass


