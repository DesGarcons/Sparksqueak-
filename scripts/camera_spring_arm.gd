extends Node3D

@export var MOUSE_SENSITIVITY: float = 0.005
@export_range(-90.0, 0.0, 0.1, "radians_as_degress") var min_vertical_angle: float = -PI/2
@export_range(0.0, 90.0, 0.1, "radians_as_degress") var max_vertical_angle: float = PI/4

@onready var spring_arm := $SpringArm3D 

func _ready():
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _unhandled_input(event: InputEvent) -> void:
    if G.player.use_ui:
        return
    if event is InputEventMouseMotion:
        rotation.y -= event.relative.x * MOUSE_SENSITIVITY
        rotation.y = wrapf(rotation.y, 0.0, TAU)

        rotation.x -= event.relative.y * MOUSE_SENSITIVITY
        rotation.x = clamp(rotation.x, min_vertical_angle, max_vertical_angle)
    
    if event.is_action_pressed("wheel_up"):
        if spring_arm.spring_length > 0.5:
            spring_arm.spring_length -= 0.5
    if event.is_action_pressed("wheel_down"):
        if spring_arm.spring_length < 5.0: 
            spring_arm.spring_length += 0.5