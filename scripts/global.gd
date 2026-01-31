extends Node

static var player = null
static var camera = null
static var game_manager

enum Level { SAFE, CEMETERY, WOODS }
static var current_level := Level.SAFE

var game_over = false
