extends Node

var host: WebSocketClient = null
var player_number = -1

signal Update_Player(player_number, pos, draw, laser)
signal Introduce_Player(player_number, pos, draw, laser)
signal Unintroduce_Player(player_number, pos, draw, laser)
signal Welcome_Player(player_number)
signal Change_Slide(slide_number)
signal Connect_Failed
signal Room_Full
signal Remote_Click(node_path)

var room_name: String
var was_connected = false

func _ready():
	pass

func start_multiplayer(url, room_name) -> void:
	self.room_name = room_name
	print('Network start')
	was_connected = false
	get_tree().connect("connection_failed", self, "connect_failed")
	get_tree().connect("connected_to_server", self, "_connected")
	host = WebSocketClient.new();
	var error = host.connect_to_url(url, PoolStringArray(), true);
	get_tree().set_network_peer(host);

func stop_multiplayer():
	print('stop_multiplayer')
	if host != null:
		print('disconnecting...')
		if host.get_connection_status() == NetworkedMultiplayerPeer.CONNECTION_CONNECTED:
			host.disconnect_from_host()


func _connected():
	was_connected = true
	enter_room(room_name)

func connect_failed():
	_close_network()
	if not was_connected:
		emit_signal('Connect_Failed')

func _close_network():
	get_tree().set_network_peer(null)


func poll():
	if host == null:
		return
	if (host.get_connection_status() == NetworkedMultiplayerPeer.CONNECTION_CONNECTED ||
		host.get_connection_status() == NetworkedMultiplayerPeer.CONNECTION_CONNECTING):
		host.poll()

func enter_room(room_name):
	if host == null:
		return
	if host.get_connection_status() == NetworkedMultiplayerPeer.CONNECTION_CONNECTED:
		rpc_id(1, 'enter_room', room_name)


func send_update_player(pos, draw, laser):
	if host == null:
		return
	if host.get_connection_status() == NetworkedMultiplayerPeer.CONNECTION_CONNECTED:
		if player_number > -1:
			rpc_id(1, 'update_player', pos, draw, laser)

func send_change_slide(slide_number):
	if host == null:
		return
	if host.get_connection_status() == NetworkedMultiplayerPeer.CONNECTION_CONNECTED:
		if player_number > -1:
			print('Sending change slide %d' % slide_number)
			rpc_id(1, 'change_slide', slide_number)

func send_click(node_path):
	if host == null:
		return
	if host.get_connection_status() == NetworkedMultiplayerPeer.CONNECTION_CONNECTED:
		if player_number > -1:
			print('Sending click on %s' % node_path)
			rpc_id(1, 'click', node_path)

remote func clicked(node_path):
	emit_signal('Remote_Click', node_path)
	print('Received click on %s' % node_path)

remote func room_welcome(player_number):
	self.player_number = player_number
	print('RECV room_welcome %d' % player_number)
	emit_signal('Welcome_Player', player_number)

remote func room_full():
	emit_signal ('Room_Full')

remote func change_slide(slide_number):
	print('received change slide ', slide_number)
	emit_signal ('Change_Slide', slide_number)

remote func update_player(player_number, pos, draw, laser):
	emit_signal('Update_Player', player_number, pos, draw, laser)

remote func introduce_player(player_number, pos, draw, laser):
	emit_signal('Introduce_Player', player_number, pos, draw, laser)

remote func unintroduce_player(player_number, pos, draw, laser):
	emit_signal('Unintroduce_Player', player_number, pos, draw, laser)
