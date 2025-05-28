extends CharacterBody3D

const SPEED = 2.0
const JUMP_VELOCITY = 4.5
const acceleration = 25.0

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var use_ui := false

@export var camera: Camera3D
@export var animation_player: AnimationPlayer

func _ready():
	G.set_player(self)

func _physics_process(delta):
	if use_ui:
		return

	# Гравитация
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Прыжок
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Движение от взгляда игрока
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := Vector3(input_dir.x, 0, input_dir.y).normalized()

	direction = direction.rotated(Vector3.UP, camera.global_rotation.y)

	if direction:
		direction *= SPEED
		velocity.x = move_toward(velocity.x, direction.x, delta * acceleration)
		velocity.z = move_toward(velocity.z, direction.z, delta * acceleration)

		if is_on_floor() and velocity.y <= 0:
			if velocity.length_squared() >= 0.1:
				# var look_position := global_position + Vector3(-velocity.x, 0, -velocity.z)
				# $Person.look_at(look_position, Vector3.UP, true)
				var target_dir = Vector3(velocity.x, 0, velocity.z).normalized()
				var current_forward = -$Person.global_transform.basis.z.normalized()

				var lerped_dir = current_forward.lerp(target_dir, delta * 5.0).normalized()

				var new_basis = Basis()
				new_basis.z = -lerped_dir
				new_basis.x = lerped_dir.cross(Vector3.UP).normalized()
				new_basis.y = new_basis.z.cross(new_basis.x).normalized()

				var new_transform = $Person.global_transform
				new_transform.basis = new_basis
				$Person.global_transform = new_transform
	else:
		velocity.x = move_toward(velocity.x, 0, delta * acceleration)
		velocity.z = move_toward(velocity.z, 0, delta * acceleration)

	animation_player_play(direction)

	move_and_slide()

func animation_player_play(direction: Vector3):
	if direction.length() > 0.1:
		animation_player.speed_scale = 0.7
		animation_player.play("walk")
	else:
		animation_player.speed_scale = 1.0
		animation_player.play("idle")

func play_animation(name_animation: String):
	if animation_player.is_playing():
		animation_player.stop()
	
	animation_player.speed_scale = 1.5
	animation_player.play(name_animation)

