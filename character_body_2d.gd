extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var sprite : AnimatedSprite2D = null

func _ready():
	sprite = $AnimatedSprite2D
	sprite.play()
	pass

var animation_code = "idle"
func _physics_process(delta: float) -> void:	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		if velocity.y > 0:
			animation_code = "fall"

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		if velocity.y == 0:
			animation_code = "run"
		sprite.flip_h = direction < 0.
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		pass

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		animation_code = "jump"
	
	# should not be allowed to code at 0:37
	if is_on_floor() and not direction and not animation_code == "jump":
		animation_code = "idle"
	print(animation_code)
	sprite.play(animation_code)
	move_and_slide()
