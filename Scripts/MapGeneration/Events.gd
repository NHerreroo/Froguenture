extends Node

signal map_exited(room:Room)

signal level_done

signal camera_low_shake
signal camera_mid_shake
signal camera_big_shake

signal room_exited

signal cardSelect
func notifycardSelect():
	emit_signal("cardSelect")



signal cardHover
func notifycardHover():
	emit_signal("cardHover")
