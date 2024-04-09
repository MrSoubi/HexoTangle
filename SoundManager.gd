extends Node

@export_group("Audio Stream Players")
@export var musicPlayer: AudioStreamPlayer;
@export var sfxPlayer_1: AudioStreamPlayer;
@export var sfxPlayer_2: AudioStreamPlayer;

@export_group("Audio Streams")
@export var sfx_oneLine: AudioStream
@export var sfx_twoLines: AudioStream
@export var sfx_threeLines: AudioStream
@export var sfx_fourLines: AudioStream
@export var sfx_hardDrop: AudioStream
@export var sfx_softDrop: AudioStream
@export var sfx_rotation: AudioStream
@export var sfx_movement: AudioStream
@export var sfx_hold: AudioStream
@export var sfx_unhold: AudioStream
@export var sfx_error: AudioStream

func _on_h_slider_music_value_changed(value):
	musicPlayer.volume_db = (value / 100) * 80 - 80;

func _on_h_slider_vfx_value_changed(value):
	sfxPlayer_1.volume_db = (value / 100) * 80 - 80;
	sfxPlayer_2.volume_db = (value / 100) * 80 - 80;

func playSFX(sfx: GlobalData.SFX):
	var audioStream: AudioStream
	match (sfx):
		GlobalData.SFX.ONE_LINE:
			audioStream = sfx_oneLine
		GlobalData.SFX.TWO_LINES:
			audioStream = sfx_twoLines
		GlobalData.SFX.THREE_LINES:
			audioStream = sfx_threeLines
		GlobalData.SFX.FOUR_LINES:
			audioStream = sfx_fourLines
	
	if (!sfxPlayer_1.playing):
		sfxPlayer_1.stream = audioStream
		sfxPlayer_1.play()
	elif (!sfxPlayer_2.playing):
		sfxPlayer_2.stream = audioStream
		sfxPlayer_2.play()
