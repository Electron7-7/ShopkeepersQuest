class_name GameRoot extends Node

@export var levelOne: PackedScene = preload('res://Levels/Testing.tscn')
@export var mouseCursor: CompressedTexture2D = preload('res://Mats-Tex-Sprts/mouse-cursor.png')

func _ready() -> void:
	var offset = mouseCursor.get_width() / 2
	add_child.call_deferred(levelOne.instantiate())
	DisplayServer.cursor_set_custom_image(mouseCursor, 0, Vector2(offset, offset))


func printdb(data):
	get_node('%Debug').text = str(data)
