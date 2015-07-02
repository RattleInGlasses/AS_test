package View.Object 
{
	import flash.display.Sprite;
	
	public class SelectionFrameCorner extends Sprite
	{
		public static const CORNER_RADIUS: int = 10;
		private const CORNER_COLOR: uint = 0x0000FF;
		
		public function SelectionFrameCorner() 
		{
			graphics.beginFill(CORNER_COLOR);
			graphics.drawCircle(0, 0, CORNER_RADIUS);
			graphics.endFill();
		}
		
		public function setPosition(x: Number, y: Number): void
		{
			this.x = x;
			this.y = y;
		}
	}
}