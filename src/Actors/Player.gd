class_name Player
extends Actor


const FLOOR_DETECT_DISTANCE = 20.0

export(String) var action_suffix = ""

onready var platform_detector = $PlatformDetector
onready var sprite = $Sprite
onready var animation_player = $AnimationPlayer
onready var shoot_timer = $ShootAnimation
onready var gun = $Sprite/Gun

onready var left = $UI/Left
onready var right = $UI/Right
onready var jump = $UI/Jump
onready var fire = $UI/Fire

func is_hit(button, tap_position):
	var b = tap_position
	var s = button.rect_position
	var ss = button.rect_scale * button.rect_size
	return b.x >= s.x and b.x <= s.x + ss.x and b.y >= s.y and b.y <= s.y + ss.y

func _input(event):	
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		var epos = event.position
		if epos.x < 450 + 150 \
		  or epos.x > 1667.15 - 150:
			get_tree().set_input_as_handled()
					
func old_input(event):	
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		var epos = event.position
#		if is_hit(left, epos) or is_hit(right, epos) or is_hit(jump, epos) or is_hit(fire, epos) or is_hit(jump2, epos):
		if is_hit(left, epos) or is_hit(right, epos) or is_hit(jump, epos) or is_hit(jump, epos) or false:
			get_tree().set_input_as_handled()
			if event is InputEventScreenTouch:
				if event.pressed:
					if is_hit(left, epos):
						Input.action_press("move_left")
					if is_hit(right, epos):
						Input.action_press("move_right")
					elif is_hit(fire, epos):
						Input.action_press("shoot")
					#elif is_hit(jump, epos):
					#	Input.action_press("jump")
					elif is_hit(jump, epos):
						Input.action_press("jump")
				else:
					# if jumping, we release in the future
					if is_hit(left, epos):
						Input.action_release("move_left")
					if is_hit(right, epos):
						Input.action_release("move_right")
					elif is_hit(fire, epos):
						Input.action_release("shoot")
					#elif is_hit(jump, epos):
					#	Input.action_release("jump")
					elif is_hit(jump, epos):
						Input.action_release("jump")
		elif epos.x < right.rect_position.x + right.rect_size.x * right.rect_scale.x + 150 \
		  or epos.x > jump.rect_position.x - 150:
			get_tree().set_input_as_handled()
			
func _ready():
	# Static types are necessary here to avoid warnings.
	var camera: Camera2D = $Camera
	if action_suffix == "_p1":
		camera.custom_viewport = $"../.."
	elif action_suffix == "_p2":
		var viewport: Viewport = $"../../../../ViewportContainer2/Viewport"
		viewport.world_2d = ($"../.." as Viewport).world_2d
		camera.custom_viewport = viewport


# Physics process is a built-in loop in Godot.
# If you define _physics_process on a node, Godot will call it every frame.

# We use separate functions to calculate the direction and velocity to make this one easier to read.
# At a glance, you can see that the physics process loop:
# 1. Calculates the move direction.
# 2. Calculates the move velocity.
# 3. Moves the character.
# 4. Updates the sprite direction.
# 5. Shoots bullets.
# 6. Updates the animation.

# Splitting the physics process logic into functions not only makes it
# easier to read, it help to change or improve the code later on:
# - If you need to change a calculation, you can use Go To -> Function
#   (Ctrl Alt F) to quickly jump to the corresponding function.
# - If you split the character into a state machine or more advanced pattern,
#   you can easily move individual functions.
func _physics_process(_delta):
	var direction = get_direction()

	var is_jump_interrupted = Input.is_action_just_released("jump" + action_suffix) and _velocity.y < 0.0
	_velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)

	var snap_vector = Vector2.DOWN * FLOOR_DETECT_DISTANCE if direction.y == 0.0 else Vector2.ZERO
	var is_on_platform = platform_detector.is_colliding()
	_velocity = move_and_slide_with_snap(
		_velocity, snap_vector, FLOOR_NORMAL, not is_on_platform, 4, 0.9, false
	)

	# When the character’s direction changes, we want to to scale the Sprite accordingly to flip it.
	# This will make Robi face left or right depending on the direction you move.
	if direction.x != 0:
		sprite.scale.x = 1 if direction.x > 0 else -1

	# We use the sprite's scale to store Robi’s look direction which allows us to shoot
	# bullets forward.
	# There are many situations like these where you can reuse existing properties instead of
	# creating new variables.
	var is_shooting = false
	if Input.is_action_just_pressed("shoot" + action_suffix):
		is_shooting = gun.shoot(sprite.scale.x)

	var animation = get_new_animation(is_shooting)
	if animation != animation_player.current_animation and shoot_timer.is_stopped():
		if is_shooting:
			shoot_timer.start()
		animation_player.play(animation)


func get_direction():
	return Vector2(
		Input.get_action_strength("move_right" + action_suffix) - Input.get_action_strength("move_left" + action_suffix),
		-1 if is_on_floor() and Input.is_action_just_pressed("jump" + action_suffix) else 0
	)


# This function calculates a new velocity whenever you need it.
# It allows you to interrupt jumps.
func calculate_move_velocity(
		linear_velocity,
		direction,
		speed,
		is_jump_interrupted
	):
	var velocity = linear_velocity
	velocity.x = speed.x * direction.x
	if direction.y != 0.0:
		velocity.y = speed.y * direction.y
	if is_jump_interrupted:
		pass
		#velocity.y = 0.0
	return velocity


func get_new_animation(is_shooting = false):
	var animation_new = ""
	if is_on_floor():
		animation_new = "run" if abs(_velocity.x) > 0.1 else "idle"
	else:
		animation_new = "falling" if _velocity.y > 0 else "jumping"
	if is_shooting:
		animation_new += "_weapon"
	return animation_new
