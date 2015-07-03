package Model.ModelPresenter.Event 
{
	import flash.events.Event;
	import Model.ModelObject;

	public class SelectionEvent extends Event 
	{
		public static const FOCUS_CHANGED: String = "ModelFocusChanged";	
		
		public function SelectionEvent(type: String) 
		{ 
			super(type);
		} 
		
		override public function clone(): Event
		{
			return new SelectionEvent(type);
		}
	}
}