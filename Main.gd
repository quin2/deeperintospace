extends Node

export (PackedScene) var rock
export (PackedScene) var powerup
var score

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()	
	$Player.start($startPosition.position)

func _process(delta):
	pass
	

func _on_Player_hit(obj):
	if obj.is_in_group("rocks"):
		$Player.hide()
		$scoreTimer.stop()
		$powerupAddTimer.stop()
		$planetAddTimer.stop()
		#
		$GUI.show_game_over()
		#
		get_tree().call_group("rocks", "queue_free")
		get_tree().call_group("powerups", "queue_free")
		#
		$touchControls.hideControls()
		$GUI/juiceBar.hide()
		$GUI/juiceIcon.hide()
		$Player.disablePhysics()
	if obj.is_in_group("powerups"):
		$Player.changeBoostLevel(20)
		obj.hide()
		pass
		
func new_game():
	score = 0
	$Player.changeBoostLevel(100)
	
	$touchControls.showControls()
	add_child($Player)
	$Player.start($startPosition.position)
	$GUI.update_score(score)
	$GUI.show_message("are you ready?")
	$GUI/juiceBar.show()
	$GUI/juiceIcon.show()
	
	$startTimer.start()
	
func _on_startTimer_timeout():
	$scoreTimer.start()
	$planetAddTimer.start()
	$powerupAddTimer.start()

func _on_scoreTimer_timeout():
	score += 1
	if score % 30 == 0:
		$planetAddTimer.wait_time -= 0.1
	$GUI.update_score(score)

func _on_planetAddTimer_timeout():
	var planet = rock.instance()
	addRandomItemInSpawnArea(planet)

func _on_Player_updateBoost(boostLevel):
	$GUI.updateHealthBar(boostLevel / 100)

func _on_powerupAddTimer_timeout():
	var hydrogen = powerup.instance()
	addRandomItemInSpawnArea(hydrogen)
	
func addRandomItemInSpawnArea(item):
	$planetBloom/planetBloomLoc.offset = randi()
	add_child(item)
	item.position = $planetBloom/planetBloomLoc.position
	item.linear_velocity = Vector2(-200, 0)
