extends State


	
func enter():
	print("Entered this shit ya feel")
	Gridleton.currentGrid = parent.get_node("GridTileMap") as TileMapLayer
	print(Gridleton.currentGrid)
	#Gridleton.load()
	#transitioned.emit(self, "playing")
	
func exit():
	print(Gridleton.gridObjects)
	pass
