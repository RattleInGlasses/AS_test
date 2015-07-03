package View.Event 
{
	import flash.events.Event;
	
	public class ViewControllerEvent extends Event 
	{
		public static const SELECTION_CHANGED: String = "ViewControllerSelectionChng";
		
		public function ViewControllerEvent(type: String) 
		{ 
			super(type);
		} 
	}
}