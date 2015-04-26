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
End


Class Player
	Field position:Vec2D
	Field img:Image
	
	Method New(x:Float, y:Float, img:Image)
		Self.position = New Vec2D(x, y)
		Self.img = img
	End
	
	Method Update()
	
	End
	
	Method Draw()
	
	End
End