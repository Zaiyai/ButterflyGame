extends Node

enum Character {
	FROG, STONE
}

enum Note {
	A, Bb, B, C, Db, D, Eb, E, F, Gb, G, Ab
}

func get_character_note(character : Character, note : Note) -> AudioStream:
	var characterName = Character.keys()[character].to_lower()
	var noteName = Note.keys()[note]
	var path : String = "res://audio/" + characterName + "/" + characterName + "_" + noteName + ".ogg"
	
	var audio = load(path)
	
	return audio
