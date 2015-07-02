package View.Graphic.ViewObject 
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	public class TriangleGraphic extends Sprite
	{
		private const DEFAULT_RECT: Rectangle = new Rectangle(0, 0, 100, 100);
		
		public function TriangleGraphic(color: uint)
		{
			graphics.beginFill(color);
			graphics.moveTo(0, DEFAULT_RECT.height);
			graphics.lineTo((DEFAULT_RECT.height / 2), 0);
			graphics.lineTo(DEFAULT_RECT.width, DEFAULT_RECT.height);
			graphics.endFill();
		}
	}
}