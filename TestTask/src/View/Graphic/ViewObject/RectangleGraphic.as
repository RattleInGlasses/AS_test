package View.Graphic.ViewObject 
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	public class RectangleGraphic extends Sprite
	{
		private const DEFAULT_RECT: Rectangle = new Rectangle(0, 0, 100, 100);
		
		public function RectangleGraphic(color: uint)
		{
			graphics.beginFill(color);
			graphics.drawRect(DEFAULT_RECT.x, DEFAULT_RECT.y, DEFAULT_RECT.width, DEFAULT_RECT.height);
			graphics.endFill();
		}
	}
}