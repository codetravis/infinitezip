Import infinitezip

Class InfiniteZipGame Extends App

	Field core_img:Image
	Field player:Player
	Field cam:Camera
	Field frame_offset:Int
	Field track_segments:List<Vec2D>
	Field track_holes:List<Int>
	Field gravity:Float
	Field speed:Float
	Field track_length:Int

	Method OnCreate()
		SetUpdateRate(60)
		gravity = 4.0
		speed = 4.0
		core_img = LoadImage("edited_game_img.png", 180, 230, 8, 0.5)
		player = New Player(240, 120, core_img, 0, speed, gravity, gravity)
		track_length = 100
		track_segments = New List<Vec2D>()
		track_holes = New List<Int>()
		GenerateTrack(track_length)
		GenerateHoles(track_length)
		cam = New Camera()
	End
	
	Method OnUpdate()
		player.Update(track_segments, track_holes)
		cam.Update(player.velocity)
	End
	
	Method OnRender()
		Cls(220, 220, 220)
		PushMatrix()
		Translate(cam.position.x, cam.position.y)
		player.Draw()
		
		DrawTrack()
		SetColor(255, 255, 255)
		PopMatrix()
	End
	
	Method GenerateTrack(length:Int)
		Local lastx:Int = 0
		For Local i:Int = 0 Until length
			Local randx:Int = Rnd(110, 210) + lastx
			Local randy:Int = Rnd(200, 300)
			track_segments.AddLast(New Vec2D(randx, randy))
			lastx = randx
		End
	End
	
	Method GenerateHoles(length:Int)
		Local which_segment = 0
		While which_segment < length
			Local hole:Int = Rnd(3, 7) + which_segment
			track_holes.AddLast(hole)
			which_segment = hole
		End
	End
	
	Method DrawTrack()
		SetColor(0,0,0)
		Local count = 0
		Local first_point:Vec2D = track_segments.First()
		For Local segment:Vec2D = Eachin track_segments
			If Not segment.SamePoint(first_point) And Not track_holes.Contains(count)
				DrawLine(first_point.x, first_point.y, segment.x, segment.y)
				first_point = segment
			Else
				first_point = segment
			End
			count += 1
		End
		SetColor(255, 255, 255)
	End
End


Function Main()
	New InfiniteZipGame();
End