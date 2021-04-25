extends CanvasLayer

signal start_game

export (int) var loadingBarLength

func show_message(text):
	$message.text = text
	$message.show()
	$messageTimer.start()
	
func show_game_over():
	show_message("ouch :(")
	yield($messageTimer, "timeout")

	$message.text = "deeper into space"
	$message.show()
	yield(get_tree().create_timer(1), "timeout")
	$start.show()
	$help.show()

func update_score(score):
	$score.text = str(score)


func _on_messageTimer_timeout():
	$message.hide()


func _on_start_pressed():
	$start.hide()
	$help.hide()
	emit_signal('start_game')


func _on_help_pressed():
	$tutorial.show()
	$tutorialOK.show()
	#
	$message.hide()
	$help.hide()
	$start.hide()
	

func _on_tutorialOK_pressed():
	$tutorial.hide()
	$tutorialOK.hide()
	#
	$message.show()
	$help.show()
	$start.show()
	
func updateHealthBar(percent):
	var poly = $juiceBar.get_polygon()
	var newX = (loadingBarLength * percent) + poly[0].x
	poly[2].x = newX
	poly[3].x = newX
	$juiceBar.set_polygon(poly)

func resetHealthBar():
	updateHealthBar(1)

func _on_soundStatus_pressed():
	if $soundStatus.text == "sound off":
		$soundStatus.text = "sound on"
		$music.stop()
	else:
		$soundStatus.text = "sound off"
		$music.play()
