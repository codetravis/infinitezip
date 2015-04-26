Import infinitezip

Class InfiniteZipGame Extends App

	Field core_img:Image
	Field player:Player

	Method OnCreate()
		SetUpdateRate(60)
		core_img = LoadImage("game_img_map.png")
		player = New Player(200, 320, core_img)
	End
	
	Method OnUpdate()
		player.Update()
	End
	
	Method OnRender()
		player.Draw()
	End
End


Function Main()
	New InfiniteZipGame();
End