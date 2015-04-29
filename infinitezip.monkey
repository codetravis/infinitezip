Import Mojo


' class to handle points and velocity in 2d space
Class Vec2D
	Field x:Float
	Field y:Float
	
	Method New(x:Float=0, y:Float=0)
		Set(x,y)
	End
	
	Method Set(x:Float, y:Float)
		Self.x = x
		Self.y = y
	End
	
	Method SamePoint:Bool(point:Vec2D)
		If Self.x = point.x And Self.y = point.y
			Return True
		Else
			Return False
		End
	End
End


Class Player
	Field position:Vec2D
	Field img:Image
	Field animations:List<Animation> = New List<Animation>()
	Field cur_anim:Animation
	Field frame_offset:Int
	Field zip_box:Box
	Field velocity:Vec2D
	
	Method New(x:Float, y:Float, img:Image, frame_offset:Int, vx:Float, vy:Float)
		Self.position = New Vec2D(x, y)
		Self.img = img
		Self.frame_offset = frame_offset
		Self.zip_box = New Box(x + 70, y + 25, 50, 30)
		Self.velocity = New Vec2D(vx, vy)
		
		animations.AddLast(New Animation("sliding", 0, 4, 5))
		animations.AddLast(New Animation("jumping", 4, 2, 5))
		SetAnimation("sliding")
	End
	
	Method Update(track_segments:List<Vec2D>)
		Local first_point:Vec2D = New Vec2D(0, 320)
		Local last_point:Vec2D = New Vec2D(480, 320)
		For Local segment:Vec2D = Eachin track_segments
			If Self.position.x > segment.x
				first_point = segment
			Else If Self.position.x < segment.x
				last_point = segment
				Exit
			End
		End
		
		' TO DO: calculate line segment height at this point
		If Self.position.y > first_point.y - 10
			Self.velocity.y = 0
		Else If position.y < first_point.y + 30
			Self.velocity.y = 4.0
		End
		
		Self.position.Set(position.x + velocity.x, position.y + velocity.y)
		Self.zip_box.Update(velocity.x, velocity.y)
	End
	
	Method Draw()
		Local cur_frame:Int
		
		If cur_anim <> Null
			cur_frame = cur_anim.start_frame + ((Millisecs() - cur_anim.start_time) / cur_anim.frame_time Mod cur_anim.length)
		End
		
		DrawImage(img, position.x, position.y, 0, 1.0, 1.0, frame_offset + cur_frame)
		SetColor(0, 0, 0)
		Self.zip_box.Draw()
		SetColor(255, 255, 255)
	End
	
	Method SetAnimation(name:String)
		If cur_anim = Null Or name <> cur_anim.name
			cur_anim = GetAnimationByName(name)
			cur_anim.start_time = Millisecs()
		End
	End
	
	Method GetAnimationByName:Animation(name:String)
		For Local anim:Animation = Eachin animations
			If anim.name = name
				Return anim
			End
		End
		
		Return Null
	End
End

Class Animation
	Field name:String
	Field start_frame:Int
	Field length:Int
	Field fps:Int
	
	Field start_time:Int
	Field frame_time:Int
	
	Method New(name:String, start_frame:Int, length:Int, fps:Int)
		Self.name = name
		Self.start_frame = start_frame
		Self.length = length
		Self.fps = fps
		
		frame_time = 1000/fps
	End

End

Class Box
	Field position:Vec2D
	Field width:Int
	Field height:Int
	
	Method New(x:Int, y:Int, width:Int, height:Int)
		Self.position = New Vec2D(x, y)
		Self.width = width
		Self.height = height
	End
	
	Method Draw()
		DrawRect(position.x, position.y, width, height)
	End
	
	Method Update(velocity_x:Float, velocity_y:Float)
		Self.position.Set(position.x + velocity_x, position.y + velocity_y)
	End
End