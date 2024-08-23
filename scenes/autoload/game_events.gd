extends Node

signal clam_collected(number: float)


func emit_clam_collected(number: float):
	clam_collected.emit(number)
