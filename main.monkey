Import infinitezip

Const STATE_MENU:Int = 0
Const STATE_GAME:Int = 1
Const STATE_DEATH:Int = 2
Const STATE_HELP:Int = 3
Const STATE_VICTORY:Int = 4

Class InfiniteZipGame Extends App
	Field game_state:Int = STATE_MENU
	Field core_img:Image
	Field title_img:Image
	Field help_img:Image
	Field player:Player
	Field cam:Camera
	Field frame_offset:Int
	Field track_segments:List<Vec2D>
	Field track_holes:List<Int>
	Field gravity:Float
	Field speed:Float
	Field track_length:Int
	Field last_touch:Float

	Method OnCreate()
		Seed = Millisecs()
		SetUpdateRate(60)
		gravity = 4.0
		speed = 4.0
		core_img = LoadImage("edited_game_img.png", 180, 230, 8, 0.5)
		title_img = LoadImage("titlescreen.png");
		help_img = LoadImage("helpscreen.png");
		player = New Player(240, 120, core_img, 0, speed, gravity, gravity)
		track_length = 200
		track_segments = New List<Vec2D>()
		track_holes = New List<Int>()
		GenerateTrack(track_length)
		GenerateHoles(track_length)
		cam = New Camera()
		last_touch = Millisecs();
	End
	
	Method OnUpdate()
		Select game_state
			Case STATE_MENU
				If KeyHit(KEY_ENTER) Or (TouchDown(0) And (Millisecs() - last_touch >= 500))
					last_touch = Millisecs()
					game_state = STATE_HELP
				End
			Case STATE_HELP
				If KeyHit(KEY_ENTER) Or (TouchDown(0) And (Millisecs() - last_touch >= 500))
					last_touch = Millisecs()
					player = New Player(240, 120, core_img, 0, speed, gravity, gravity)
					track_length = 50
					track_segments = New List<Vec2D>()
					track_holes = New List<Int>()
					GenerateTrack(track_length)
					GenerateHoles(track_length)
					cam = New Camera()
					game_state = STATE_GAME
				End
			Case STATE_GAME
				player.Update(track_segments, track_holes)
				cam.Update(player.velocity)
				If player.position.x > track_segments.Last.x
					game_state = STATE_VICTORY
				Else If (player.position.y - track_segments.Last.y > 1000)
					game_state = STATE_DEATH
				End
			Case STATE_DEATH
				If KeyHit(KEY_ENTER) Or (TouchDown(0) And (Millisecs() - last_touch >= 500))
					last_touch = Millisecs()
					game_state = STATE_HELP
				End
			Case STATE_VICTORY
				If KeyHit(KEY_ENTER) Or (TouchDown(0) And (Millisecs() - last_touch >= 500))
					last_touch = Millisecs()
					game_state = STATE_HELP
				End
		End
	End
	
	Method OnRender()
		Cls(220, 220, 220)
		Select game_state
			Case STATE_MENU
				DrawImage(title_img, 0, 0, 0, 0.75, 0.75)
			Case STATE_HELP
				DrawImage(help_img, 0, 0, 0, 0.75, 0.75)
			Case STATE_GAME
				PushMatrix()
				Translate(cam.position.x, cam.position.y)
				player.Draw()
				
				DrawTrack()
				SetColor(255, 255, 255)
				PopMatrix()
			Case STATE_DEATH
				DrawText("You fell to your untimely demise.", 320, 200, 0.5)
			Case STATE_VICTORY
				DrawText("You survived your zip line adventure. Congratulations!", 320, 200, 0.5)
		End
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