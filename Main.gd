extends Node2D

@onready var game = $Game
@onready var ui_layer: UILayer = $UILayer
@onready var ready_screen = $UILayer/Screens/ReadyScreen
@onready var music := $Music

var players := {}

var players_ready := {}
var players_score := {}

var match_started := false

func _ready() -> void:
	OnlineMatch.connect("error", Callable(self, "_on_OnlineMatch_error"))
	OnlineMatch.connect("disconnected", Callable(self, "_on_OnlineMatch_disconnected"))
	OnlineMatch.connect("player_joined", Callable(self, "_on_OnlineMatch_player_joined"))
	OnlineMatch.connect("player_left", Callable(self, "_on_OnlineMatch_player_left"))

	randomize()
	music.play_random()

#####
# UI callbacks
#####

func _on_TitleScreen_play_local() -> void:
	GameState.online_play = false

	ui_layer.hide_screen()
	ui_layer.show_back_button()

	start_game()

func _on_TitleScreen_play_online() -> void:
	GameState.online_play = true

	# Show the game map in the background because we have nothing better.
	game.reload_map()

	ui_layer.show_screen("ConnectionScreen")

func _on_UILayer_change_screen(name: String, _screen) -> void:
	if name == 'TitleScreen':
		ui_layer.hide_back_button()
	else:
		ui_layer.show_back_button()

	if name != 'ReadyScreen':
		if match_started:
			match_started = false
			music.play_random()

func _on_UILayer_back_button() -> void:
	ui_layer.hide_message()

	stop_game()

	if GameState.online_play:
		OnlineMatch.leave()

	if ui_layer.current_screen_name in ['ConnectionScreen', 'MatchScreen', 'CreditsScreen']:
		ui_layer.show_screen("TitleScreen")
	elif not GameState.online_play:
		ui_layer.show_screen("TitleScreen")
	else:
		ui_layer.show_screen("MatchScreen")

func _on_ReadyScreen_ready_pressed() -> void:
	rpc("player_ready", get_tree().get_unique_id())

#####
# OnlineMatch callbacks
#####

func _on_OnlineMatch_error(message: String):
	if message != '':
		ui_layer.show_message(message)
	ui_layer.show_screen("MatchScreen")

func _on_OnlineMatch_disconnected():
	#_on_OnlineMatch_error("Disconnected from host")
	_on_OnlineMatch_error('')

func _on_OnlineMatch_player_left(player) -> void:
	game.kill_player(player.peer_id)

	players.erase(player.peer_id)
	players_ready.erase(player.peer_id)

	if players.size() < 2:
		OnlineMatch.leave()
		_on_OnlineMatch_error(player.username + " has left - not enough players!")
	else:
		ui_layer.show_message(player.username + " has left")

func _on_OnlineMatch_player_joined(player) -> void:
	if get_tree().is_server():
		# Tell this new player about all the other players that are already ready.
		for player in players_ready.values():
			rpc_id(player.peer_id, "player_ready", player.peer_id)

#####
# Gameplay methods and callbacks
#####

@rpc("any_peer", "call_local") func player_ready(peer_id: int) -> void:
	ready_screen.set_status(peer_id, "READY!")

	if get_tree().is_server() and not players_ready.has(peer_id):
		players_ready[peer_id] = true
		if players_ready.size() == OnlineMatch.players.size():
			if OnlineMatch.match_state != OnlineMatch.MatchState.PLAYING:
				OnlineMatch.start_playing()
			start_game()

func start_game() -> void:
	if GameState.online_play:
		players = OnlineMatch.get_player_names_by_peer_id()
	else:
		players = {
			1: "Player1",
			2: "Player2",
		}

	game.game_start(players)

func stop_game() -> void:
	OnlineMatch.leave()

	players.clear()
	players_ready.clear()
	players_score.clear()

	game.game_stop()

func restart_game() -> void:
	stop_game()
	start_game()

func _on_Game_game_started() -> void:
	ui_layer.hide_screen()
	ui_layer.hide_all()
	ui_layer.show_back_button()

	if not match_started:
		match_started = true
		music.play_random()

func _on_Game_player_dead(peer_id: int) -> void:
	if GameState.online_play:
		var my_id = get_tree().get_unique_id()
		if peer_id == my_id:
			ui_layer.show_message("You lose!")

func _on_Game_game_over(peer_id: int) -> void:
	players_ready.clear()

	if not GameState.online_play:
		show_winner(players[peer_id])
	elif get_tree().is_server():
		if not players_score.has(peer_id):
			players_score[peer_id] = 1
		else:
			players_score[peer_id] += 1

		var is_match: bool = players_score[peer_id] >= 5

		rpc("show_winner", players[peer_id], peer_id, players_score[peer_id], is_match)

func update_wins_leaderboard() -> void:
	if not Online.nakama_session or Online.nakama_session.is_expired():
		# If our session has expired, then wait until a new session is setup.
		await Online.session_connected

	Online.nakama_client.write_leaderboard_record_async(Online.nakama_session, 'fish_game_wins', 1)

@rpc("any_peer", "call_local") func show_winner(name: String, peer_id: int = 0, score: int = 0, is_match: bool = false) -> void:
	if is_match:
		ui_layer.show_message(name + " WINS THE WHOLE MATCH!")
	else:
		ui_layer.show_message(name + " wins this round!")

	await get_tree().create_timer(2.0).timeout
	if not game.game_started:
		return

	if GameState.online_play:
		if is_match:
			stop_game()
			if peer_id != 0 and peer_id == get_tree().get_unique_id():
				update_wins_leaderboard()
			ui_layer.show_screen("MatchScreen")
		else:
			ready_screen.hide_match_id()
			ready_screen.reset_status("Waiting...")
			ready_screen.set_score(peer_id, score)
			ui_layer.show_screen("ReadyScreen")
	else:
		restart_game()

func _on_Music_song_finished(song) -> void:
	if not music.current_song.playing:
		music.play_random()
