extends KinematicBody2D

const UP = Vector2 (0, -1)
const GRAVITY = 20
const MAXFALLSPEED = 400
const MAXSPEED = 80
const JUMPFORCE = -400
const ACCEL = 10

var motion = Vector2()
var facing_right = true
var jump_count = 0
var on_ground = true
var action = false
var state_machine
var attacking = false
var combo_level = 0
var can_combo = false
var comboing = false

var combo_2 =  {"damage": 170, "combo": null, "animation": "combo_2"}
var combo_1 = {"damage": 70, "combo": combo_2, "animation": "Attacc 2"}
var basic_attack = {"damage": 50, "combo": combo_1, "animation": "Attaccc"}


var current_attack

func _ready():
    state_machine = $AnimationTree.get("parameters/playback")
    current_attack = basic_attack

func _physics_process(delta):
    
    motion.y += GRAVITY
    if motion.y > MAXFALLSPEED:
        motion.y = MAXFALLSPEED
    
    if facing_right == true:
        $Sprite.scale.x = 1
    else:
        $Sprite.scale.x = -1
    
    motion.x = clamp(motion.x,-MAXSPEED,MAXSPEED)
    
    if Input.is_action_pressed("right") && attacking == false:
        motion.x += ACCEL
        facing_right = true
        if is_on_floor():
            state_machine.travel("Walking")
    elif Input. is_action_pressed("left") && attacking == false:
        motion.x += -ACCEL
        facing_right = false
        if is_on_floor():
            state_machine.travel("Walking")
    else:
        motion.x = lerp(motion.x,0,0.2)
        if is_on_floor() && (motion.x != 0 || motion.y != 0) && action == false:
            state_machine.travel("Idle")
    if Input.is_action_just_pressed("jump") && attacking == false:
        if jump_count < 1:
            jump_count = jump_count + 1 
            motion.y = JUMPFORCE
            state_machine.travel("Jump")
        print(jump_count)
    if !is_on_floor():
        on_ground = false
        if motion.y > 0:
            state_machine.travel("Falling")
    else:
        on_ground = true
        jump_count = 0
    if Input.is_action_just_pressed("attack"):
            if on_ground == true:
                if !attacking:
                    action = true
                    attacking = true                    
                    state_machine.travel(current_attack.animation)
                elif can_combo:
                    comboing = true
                    state_machine.travel(current_attack.combo.animation)
    
    motion = move_and_slide(motion, UP)
        

func start_combo_window():
    can_combo = true

func end_combo_window():
    can_combo = false

func attack_complete():
    can_combo = false
    if comboing && current_attack.combo != null:
        current_attack = current_attack.combo
    else:
        attacking = false
        action = false
        current_attack = basic_attack
    comboing = false
        
    
