extends Area2D

# movement properties
@export var acceleration = 6
@export var deceleration = 1
@export var max_speed = 600

# game properties
var screen_padding = 35
var velocity = Vector2()
var screen_rect

func _ready():
	screen_rect = get_viewport().get_visible_rect()

func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
#region Player velocity and position calculation
	# Movement check
	if Input.is_anything_pressed():
		# cancel input when opposite at the same time
		if Input.is_action_pressed("up") && Input.is_action_pressed("down"):
			decelerate()
		else:
			if Input.is_action_pressed("up"):
				velocity.y -= acceleration
			if Input.is_action_pressed("down"):
				velocity.y += acceleration
		if Input.is_action_pressed("left") && Input.is_action_pressed("right"):
			decelerate()
		else:
			if Input.is_action_pressed("left"):
				velocity.x -= acceleration
			if Input.is_action_pressed("right"):
				velocity.x += acceleration
			
		# apply max speed, no speedster
		if velocity.length() > max_speed:
			velocity = velocity.normalized() * max_speed
		
	else:
		# apply deceleration when no movement key is pressed
		decelerate()
		
	# update position
	self.position += velocity * delta
#endregion

#region Player rotation
	self.look_at(get_global_mouse_position())
	rotation += deg_to_rad(90)
#endregion

#region Player position when outside the screen
	# character wrap around
	# if player is outside to the left of the screen, teleport to the right
	# adjust padding so it won't just pop up
	if position.x < screen_rect.position.x - screen_padding:
		position.x = screen_rect.position.x + screen_rect.size.x + screen_padding
	elif position.x > screen_rect.position.x + screen_rect.size.x + screen_padding:
		position.x = screen_rect.position.x - screen_padding
	
	if position.y < screen_rect.position.y - screen_padding:
		position.y = screen_rect.position.y + screen_rect.size.y + screen_padding
	elif position.y > screen_rect.position.y + screen_rect.size.y + screen_padding:
		position.y = screen_rect.position.y - screen_padding
#endregion

# decelerate the player
func  decelerate():
	if velocity.x > 0:
		velocity.x = max(velocity.x - deceleration, 0)
	if velocity.x < 0:
		velocity.x = min(velocity.x + deceleration, 0)
	if velocity.y > 0:
		velocity.y = max(velocity.y - deceleration, 0)
	if velocity.y < 0:
		velocity.y = min(velocity.y + deceleration, 0)
