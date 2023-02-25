extends Control

@onready var anims = $AnimationPlayer

signal restart_button_pressed


func _ready():
	hide()


func appear():
	anims.play("animate")


func _on_button_pressed():
	Audio.play("ButtonClick")
	anims.play("animate_out")
	await anims.animation_finished
	emit_signal("restart_button_pressed")
