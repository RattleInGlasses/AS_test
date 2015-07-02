package View.Event 
{
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	public class ViewObjectEvent extends Event 
	{
		static public const CHANGE: String       = "ViewObjectChange";
		static public const STOP_CHANGE: String  = "ViewObjectStopChange";
		
		public function ViewObjectEvent(type: String)
		{ 
			super(type);
		} 
	}
}