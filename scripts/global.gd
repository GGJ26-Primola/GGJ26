extends Node

static var player = null
static var camera = null
static var game_manager

enum Level { SAFE, CEMETERY, WOODS, BOSS }
static var current_level := Level.SAFE

var game_over = false
var boss_agro = false
var mist_damage = false
