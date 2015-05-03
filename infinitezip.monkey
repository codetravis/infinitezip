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
	Field gravity:Float
	Field y_height:Float
	Field first_point:Vec2D
	Field last_point:Vec2D
	
	Method New(x:Float, y:Float, img:Image, frame_offset:Int, vx:Float, vy:Float, gravity:Float)
		Self.position = New Vec2D(x, y)
		Self.img = img
		Self.frame_offset = frame_offset
		Self.zip_box = New Box(x + 70, y + 25, 50, 30)
		Self.velocity = New Vec2D(vx, vy)
		Self.gravity = gravity
		
		animations.AddLast(New Animation("sliding", 0, 4, 5))
		animations.AddLast(New Animation("jumping", 4, 2, 5))
		SetAnimation("jumping")
	End
	
	Method Update(track_segments:List<Vec2D>)
		Self.first_point = New Vec2D(0, 320)
		Self.last_point = New Vec2D(Self.position.x + 1000, Self.position.y + 1000)
		For Local segment:Vec2D = Eachin track_segments
			If Self.position.x + 70 > segment.x And segment.x > first_point.x
				Self.first_point = segment
			Else If Self.position.x + 70 < segment.x
				Self.last_point = segment
				Exit
			End
		End
		
		' TO DO: calculate line segment height at this point
		Self.y_height = (((last_point.y - first_point.y) * (Self.zip_box.position.x - first_point.x))/(last_point.x - first_point.x)) + first_point.y

		If (last_point.x > position.x + 500 And last_point.y > position.y + 500)
			Self.velocity.y = Min(velocity.y + gravity, gravity) 
		Else If ((Self.zip_box.position.y > y_height - 5) And (Self.zip_box.position.y < y_height + 5))
			If (TouchDown(0))
				Self.velocity.y -= 40
				SetAnimation("jumping")
			Else
				' Set the Y velocity for the camera to be able to follow acurately
				Self.velocity.y = (last_point.y - first_point.y)/(last_point.x - first_point.x)
				Self.position.y = y_height - 25
				SetAnimation("sliding")
			End
		Else
			Self.velocity.y = Min(velocity.y + gravity, gravity)
		End
		
		Self.position.Set(position.x + velocity.x, position.y + velocity.y)
		Self.zip_box.Update(position.x + 70, position.y + 25)
	End
	
	Method Draw()
		Local cur_frame:Int
		
		If cur_anim <> Null
			cur_frame = cur_anim.start_frame + ((Millisecs() - cur_anim.start_time) / cur_anim.frame_time Mod cur_anim.length)
		End
		
		DrawImage(img, position.x, position.y, 0, 1.0, 1.0, frame_offset + cur_frame)
		'DrawText("line height calculated to be: " + Self.y_height + " and current y position is " + position.y, position.x - 50, position.y - 50)
		SetColor(0, 0, 0)
		Self.zip_box.Draw()
		SetColor(255, 0, 0)
		DrawCircle(first_point.x, first_point.y, 5)
		DrawCircle(last_point.x, last_point.y, 5)
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
	
	Method Update(new_pos_x:Float, new_pos_y:Float)
		Self.position.Set(new_pos_x, new_pos_y)
	End
End

Class Camera
	' Camera class alos shamelessly borrowed from Jim's Small Time Outlaws
	' Youtube channel on creating basic games with Monkey X 
	' Great stuff you should seriously check it out
	Field original_pos:Vec2D
	Field position:Vec2D
	
	Method New(x:Float=0, y:Float=0)
		Self.position = New Vec2D(x, y)
		Self.original_pos = New Vec2D(x, y)
	End
	
	Method Reset()
		Self.position.Set(original_pos.x, original_pos.y)
	End
	
	' My own take on the update method though
	' This is what we use to follow the player around
	Method Update(velocity:Vec2D)
		Self.position.x -= velocity.x
		Self.position.y -= velocity.y
	End
End