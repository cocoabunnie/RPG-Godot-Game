extends Node2D
var touchingGreen = false
var nearCoffee = false
var spokenToGreen = false
var missionComplete = false
var stickObtained = false
var ballObtained = false
var touchingTree = false
var ballisInTree = true

func _ready():
	$sign.visible = false
	$GreenBody2/Music.play()
	$Cloud1/AnimationTree/AnimationPlayer.play("glide")
	$Cloud2/AnimationTree/AnimationPlayer.play("glide")
	$Ball.position.x = -10
	$Ball.position.y = 400
	var new_dialog = Dialogic.start('Quest1Setup')
	add_child(new_dialog)

func _process(delta):
	walkingCheck()
	getBallCheck()
	greenResolutionCheck()

	if touchingGreen == true:
		if Input.is_key_pressed(KEY_Z):
			touchingGreen = false
			if spokenToGreen == false:
				if ballObtained == false:
					var green_dialog = Dialogic.start('GreensProblem')
					add_child(green_dialog)
					spokenToGreen = true
			elif spokenToGreen == true:
				if ballObtained == false:
					var green_dialog2 = Dialogic.start('GreensProblem2')
					add_child(green_dialog2)

func walkingCheck():
	if Input.is_action_pressed("ui_right"):
		$BlueBody/Blue/AnimationTree/AnimationPlayer.set_current_animation("Walk")
	elif Input.is_action_pressed("ui_left"):
		$BlueBody/Blue/AnimationTree/AnimationPlayer.set_current_animation("Walk")
	elif Input.is_action_pressed("ui_up"):
		$BlueBody/Blue/AnimationTree/AnimationPlayer.set_current_animation("Walk")
	elif Input.is_action_pressed("ui_down"):
		$BlueBody/Blue/AnimationTree/AnimationPlayer.set_current_animation("Walk")
	else:
		$BlueBody/Blue/AnimationTree/AnimationPlayer.set_current_animation("Idle")

func _on_greenArea2_area_entered(area):
	$BlueBody/hint.visible = true
	touchingGreen = true
	$BlueBody/hint.bbcode_text = "Press Z to interact"


func _on_greenArea2_area_exited(area):
	$BlueBody/hint.visible = false
	touchingGreen = false

func _on_Stick_pressed(): #Stick obtained!
	$pickup.play()
	stickObtained = true
	$Stick.hide()
	var stickDialog = Dialogic.start('stickObtained')
	add_child(stickDialog)

func _on_treeArea_area_entered(area): #Tree interaction
	touchingTree = true
	$BlueBody/hint.visible = true
	
	if stickObtained == true:
		$BlueBody/hint.bbcode_text = "Use stick on tree"
	elif stickObtained == false:
		if spokenToGreen == true:
			$BlueBody/hint.bbcode_text = "Shake tree"

func _on_treeArea_area_exited(area):
	touchingTree = false
	$BlueBody/hint.visible = false

func getBallCheck():
	if Input.is_key_pressed(KEY_Z):
		if touchingTree == true:
			if stickObtained == true:
				if spokenToGreen == true:
					if ballisInTree == true:
						$BlueBody/hint.visible = false
						$Ball/AnimationTreePlayer/AnimationPlayer.set_current_animation("BallFall")
						ballisInTree = false
			elif stickObtained == false:
				if spokenToGreen == true:
					$treeArea/AnimationTree/AnimationPlayer.set_current_animation("shake")
					var shakeTree = Dialogic.start('ShakeTree')
					add_child(shakeTree)
					
func greenResolutionCheck():
	if Input.is_key_pressed(KEY_Z):
		if touchingGreen == true:
			if ballObtained == true:
				var greenResolution = Dialogic.start('GreenResolution')
				add_child(greenResolution)
				greenResolution.connect("dialogic_signal", self, 'openNextScene')

func openNextScene(value):
	get_node("rightBoarder/rightCollision").disabled = true
	$sign.visible = true

func _on_button_pressed():
	if ballisInTree == false:
		$pickup.play()
		$Ball.hide()
		ballObtained = true
		var ballDialog = Dialogic.start('BallObtained')
		add_child(ballDialog)

func _on_changeScene_area_entered(area):
	get_tree().change_scene("res://Quest2.tscn")
