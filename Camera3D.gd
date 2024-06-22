extends Camera3D

var sensitivity: float = 0.01
var mouse_motion_accumulator: Vector2 = Vector2.ZERO

func _input(event):
    if event is InputEventMouseMotion:
        var mouse_motion = event.relative * sensitivity
        mouse_motion_accumulator += mouse_motion

func _process(delta: float):
    rotate_object_local(Vector3(0, 1, 0), -mouse_motion_accumulator.x)
    rotate_object_local(Vector3(1, 0, 0), -mouse_motion_accumulator.y)
    mouse_motion_accumulator = Vector2.ZERO
