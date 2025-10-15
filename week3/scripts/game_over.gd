extends Control

@onready var restart_button = $VBoxContainer/Restart
@onready var menu_button = $VBoxContainer/Menu
@onready var final_score = $VBoxContainer/Score
@onready var best_score = $VBoxContainer/BestScore
@onready var new_record = $VBoxContainer/Newrecord
var should_blink = false
var blink_time = 0.5
var blink_timer = 0.0
func _ready():
	set_process(true)
	restart_button.pressed.connect(_on_restart_pressed)
	menu_button.pressed.connect(_on_menu_pressed)
	final_score.text = "You survived for %d seconds" %GlobalTimer.elapsed_time
	best_score.text = " Previous record: %d seconds" %GlobalTimer.best_time
	var is_new_record = GlobalTimer.elapsed_time > GlobalTimer.best_time
	
	if is_new_record:
		GlobalTimer.best_time = GlobalTimer.elapsed_time  # ← Aggiorna QUI
		new_record.visible = true
		should_blink = true
	else:
		new_record.visible = false
		
func _on_restart_pressed():
	# Ricarica il gioco
	get_tree().paused = false  # Toglie la pausa
	get_tree().change_scene_to_file("res://scenes/node_2d.tscn")

func _on_menu_pressed():
	# Torna al menu principale
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/start.tscn")

func _process(delta):
	if should_blink:
		blink_timer += delta
		if blink_timer >= blink_time:
			# Alterna tra opaco e trasparente
			if new_record.modulate.a == 1.0:
				new_record.modulate.a = 0.0  # Trasparente
			else:
				new_record.modulate.a = 1.0  # Opaco
			
			blink_timer = 0.0
