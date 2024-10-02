extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -400.0

@onready var animation_tree : AnimationTree = $AnimationTree
@onready var animation_player : AnimationPlayer = $AnimationPlayer

@onready var sprite : Sprite2D = $Sprite2D

enum State{
	Idle,
	Running,
	Falling,
	Jumping
}
var state : State = State.Idle
var attack : bool = true


func update_state():
	animation_tree["parameters/conditions/attack"] = attack

	if velocity.y > 0:
		animation_tree["parameters/movement/conditions/falling"] = true
		animation_tree["parameters/movement/conditions/jumping"] = false
		animation_tree["parameters/movement/conditions/idle"]    = false
		animation_tree["parameters/movement/conditions/running"] = false
	elif velocity.y < 0:
		animation_tree["parameters/movement/conditions/falling"] = false
		animation_tree["parameters/movement/conditions/jumping"] = true
		animation_tree["parameters/movement/conditions/idle"]    = false
		animation_tree["parameters/movement/conditions/running"] = false
	elif velocity.x != 0:
		animation_tree["parameters/movement/conditions/falling"] = false
		animation_tree["parameters/movement/conditions/jumping"] = false
		animation_tree["parameters/movement/conditions/idle"]    = false
		animation_tree["parameters/movement/conditions/running"] = true
	else:
		animation_tree["parameters/movement/conditions/falling"] = false
		animation_tree["parameters/movement/conditions/jumping"] = false
		animation_tree["parameters/movement/conditions/idle"]    = true
		animation_tree["parameters/movement/conditions/running"] = false
		
	pass

func _ready():

	
	pass

func _physics_process(delta: float) -> void:	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		sprite.flip_h = direction < 0.
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		pass

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY	
		
	attack = Input.is_physical_key_pressed(KEY_X)
	if attack and velocity.y == 0:
		velocity.x = 0

	# should not be allowed to code at 0:37
	update_state()
	move_and_slide()
