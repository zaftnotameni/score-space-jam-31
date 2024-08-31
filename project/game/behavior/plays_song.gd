class_name PlaysSong extends AudioStreamPlayer

var songs := ['none', 'title', 'level', 'game_over']

func _enter_tree() -> void:
	add_to_group(GROUP)

func on_named_song_start_requested(named_song:String):
	if not Audio.first(): return
	match named_song:
		'none':
			Audio.first().get_node('BGM/Level').stop()
			Audio.first().get_node('BGM/GameOver').stop()
			Audio.first().get_node('BGM/Menu').stop()
		'title':
			Audio.first().get_node('BGM/Level').stop()
			Audio.first().get_node('BGM/GameOver').stop()
			Audio.play_bgm(Audio.first().get_node('BGM/Menu'))
		'level':
			Audio.first().get_node('BGM/GameOver').stop()
			Audio.first().get_node('BGM/Menu').stop()
			Audio.play_bgm(Audio.first().get_node('BGM/Level'))
		'game_over':
			Audio.first().get_node('BGM/Level').stop()
			Audio.first().get_node('BGM/Menu').stop()
			Audio.play_bgm(Audio.first().get_node('BGM/GameOver'))

func on_named_song_stop_requested(named_song:String):
	if not Audio.first(): return
	match named_song:
		'none': pass
		'title':
			Audio.first().get_node('BGM/Menu').stop()
		'level':
			Audio.first().get_node('BGM/Level').stop()
		'game_over':
			Audio.first().get_node('BGM/GameOver').stop()

func _ready() -> void:
	if Audio.first():
		Audio.first().sig_named_song_start_requested.connect(on_named_song_start_requested)
		Audio.first().sig_named_song_stop_requested.connect(on_named_song_stop_requested)

func _exit_tree() -> void:
	stop()

const GROUP := 'plays_song'

static func tree() -> SceneTree: return Engine.get_main_loop()
static func first() -> PlaysSong: return tree().get_first_node_in_group(GROUP)
static func all() -> Array: return tree().get_nodes_in_group(GROUP)
