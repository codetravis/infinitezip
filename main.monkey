Import infinitezip

Class InfiniteZipGame Extends App

	Field core_img:Image
	Field player:Player
	Field cam:Camera
	Field frame_offset:Int
	Field track_segments:List<Vec2D>
	Field gravity:Float
	Field speed:Float

	Method OnCreate()
		SetUpdateRate(60)
		gravity = 4.0
		speed = 1.0
		core_img = LoadImage("edited_game_img.png", 180, 230, 4, 0.5)
		player = New Player(240, 120, core_img, 0, speed, gravity)
		track_segments = New List<Vec2D>()
		GenerateTrack()
		cam = New Camera()
	End
	
	Method OnUpdate()
		player.Update(track_segments)
		cam.Update(player.velocity)
	End
	
	Method OnRender()
		Cls(220, 220, 220)
		PushMatrix()
		Translate(cam.position.x, cam.position.y)
		player.Draw()
		'DrawText("x:" + player.zip_box.position.x + " -- y: " + player.zip_box.position.y, 50, 50)
		'DrawText("width:" + player.zip_box.width + " -- height: " + player.zip_box.height, 50, 70) 
		
		DrawTrack()
		SetColor(255, 255, 255)
		PopMatrix()
	End
	
	Method GenerateTrack()
		Local lastx:Int = 0
		If track_segments.Count() > 0
			lastx = track_segments.Last().x
		End
		
		If track_segments.Count() < 5
			For Local i:Int = 0 Until 5
				Local randx:Int = Rnd(110, 210) + lastx
				Local randy:Int = Rnd(200, 400)
				track_segments.AddLast(New Vec2D(randx, randy))
				lastx = randx
			End
		End
	End
	
	Method DrawTrack()
		SetColor(0,0,0)
		Local first_point:Vec2D = track_segments.First()
		For Local segment:Vec2D = Eachin track_segments
			If Not segment.SamePoint(first_point)
				DrawLine(first_point.x, first_point.y, segment.x, segment.y)
				first_point = segment
			End
		End
		SetColor(255, 255, 255)
	End
End


Function Main()
	New InfiniteZipGame();
End