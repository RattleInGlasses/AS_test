package Model.ModelPresenter 
{
	import flash.events.EventDispatcher;
	import Model.ModelObject;
	import Model.ModelPresenter.Event.SelectionEvent;
	
	public class Selection extends EventDispatcher
	{
		private var _focusedObject: uint;
		
		public function Selection() 
		{
			_focusedObject = uint.MAX_VALUE;
		}	
		
		/*public function get selectedObject(): uint
		{
			return _focusedObject;
		}
		
		public function set selectedObject(value: uint): void
		{
			if (_focusedObject != value)
			{
				_focusedObject = value;
				dispatchEvent(new SelectionEvent(SelectionEvent.FOCUS_CHANGED));
			}
		}*/
	}
}