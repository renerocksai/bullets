extends Node

const PORT=9000

var host: WebSocketClient = null
var player_number = -1

signal Update_Player(player_number, pos, draw, laser)
signal Introduce_Player(player_number, pos, draw, laser)
signal Welcome_Player(player_number)
signal Change_Slide(slide_number)
signal Connect_Failed
signal Room_Full

func _ready():
	pass

func start_multiplayer() -> void:
	print('Network start')
	var url = "ws://192.168.2.64:" + str(PORT)
	host = WebSocketClient.new();
	var error = host.connect_to_url(url, PoolStringArray(), true);
	get_tree().set_network_peer(host);
	get_tree().connect("connection_failed", self, "_close_network")
	get_tree().connect("connected_to_server", self, "_connected")

func stop_multiplayer():
	print('stop_multiplayer')
	if host != null:
		print('disconnecting...')
		if host.get_connection_status() == NetworkedMultiplayerPeer.CONNECTION_CONNECTED:
			host.disconnect_from_host()


func _connected():
	pass

func connect_failed():
	_close_network()
	emit_signal('Connect_Failed')

func _close_network():
	get_tree().set_network_peer(null)


func poll():
	if host == null:
		return
	if (host.get_connection_status() == NetworkedMultiplayerPeer.CONNECTION_CONNECTED ||
		host.get_connection_status() == NetworkedMultiplayerPeer.CONNECTION_CONNECTING):
		host.poll()

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

