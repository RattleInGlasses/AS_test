package View 
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	
	public class Button extends SimpleButton
	{
		private var _normalStateGraphic: Sprite = null;
		private var _disabledStateGraphic: Sprite = null;
		
		public function Button(normSt: Sprite, disabledSt: Sprite, x: Number, y: Number, width: Number, height: Number) 
		{
			this.focusRect = false;
			
			this.x = x;
			this.y = y;
			_normalStateGraphic = normSt;
			_disabledStateGraphic = disabledSt;
			_normalStateGraphic.width = width;
			_normalStateGraphic.height = height;
			_disabledStateGraphic.width = width;
			_disabledStateGraphic.height = height;
			
			useHandCursor = true;
			upState = downState = hitTestState = overState = _normalStateGraphic
		}
		
		override public function set mouseEnabled(value: Boolean): void
		{
			super.mouseEnabled = value;
			upState = downState = hitTestState = overState = (value) ? _normalStateGraphic : _disabledStateGraphic;
		}
	}
}