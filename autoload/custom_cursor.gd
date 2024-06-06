# Copyright (c) 2024 Souchet Ferdinand (@Khusheete)
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
# the Software, and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
# FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
# IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


extends Node


const SoftwareCursor: Script = preload("../src/software_cursor.gd")


var custom_cursor_enabled: bool = false:
	set(value):
		custom_cursor_enabled = value
		software_cursor.visible = true
		
		if custom_cursor_enabled:
			Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

var software_cursor: Node2D

var current_cursor: StringName = &"": set = set_current_cursor
var custom_cursors: Dictionary = {}


func _init() -> void:
	var canvas_layer := CanvasLayer.new()
	canvas_layer.layer = 2147483647 # The cursor must always be on top
	add_child(canvas_layer)
	
	software_cursor = SoftwareCursor.new()
	software_cursor.visible = false
	canvas_layer.add_child(software_cursor)


func enable_custom_cursor() -> void:
	custom_cursor_enabled = true


func disable_custom_cursor() -> void:
	custom_cursor_enabled = false


func add_custom_cursor(cursor_name: StringName, scene: Node2D) -> void:
	if cursor_name in custom_cursors:
		push_error("[CustomCursor] Cursor `%s` has already been registered" % cursor_name)
		return
	
	custom_cursors[cursor_name] = scene


func set_current_cursor(cursor_name: StringName) -> void:
	if not current_cursor.is_empty():
		# remove current cursor
		software_cursor.remove_child(custom_cursors[current_cursor])
	
	if not cursor_name in custom_cursors:
		push_error("[CustomCursors] Cursor `%s` does not exist" % cursor_name)
		return
	
	# add the cursor
	current_cursor = cursor_name
	software_cursor.add_child(custom_cursors[current_cursor])
