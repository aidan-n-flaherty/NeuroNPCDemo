extends Node
class_name WebsocketManager

signal command(data)

@export var websocket_url = "ws://localhost:8080"

var socket = WebSocketPeer.new()

var expBackoff = 1

func _ready():
	while true:
		var err = socket.connect_to_url(websocket_url)
		
		if err != OK:
			print("Unable to connect, waiting %d" % expBackoff)
			await get_tree().create_timer(2).timeout
			expBackoff *= 2
		else:
			print('Connected')
			break

func _process(_delta):
	socket.poll()

	# get_ready_state() tells you what state the socket is in.
	var state = socket.get_ready_state()

	if state == WebSocketPeer.STATE_OPEN:
		var data = ""
		while socket.get_available_packet_count():
			data += socket.get_packet().get_string_from_utf8()
		
		if data:
			print('Received "%s"' % data)
			
		var commands = data.split("<|action_division|>")
		for command in commands:
			if command:
				emit_signal("command", JSON.parse_string(command))
	elif state == WebSocketPeer.STATE_CLOSING:
		pass
	elif state == WebSocketPeer.STATE_CLOSED:
		var code = socket.get_close_code()
		print("WebSocket closed with code: %d. Clean: %s" % [code, code != -1])
		
		self._ready()
