package View.Event 
{
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	public class SelectionFrameEvent extends Event 
	{
		public static const CHANGE: String      = "SelectionFrameStartChange";
		public static const STOP_CHANGE: String = "SelectionFrameStopChange";
		public static const BOUND: String       = "SelectionFrameBound";
		public static const UNBOUND: String     = "SelectionFrameUnbound";
		
		public function SelectionFrameEvent(type: String, rect: Rectangle = null) 
		{ 
			super(type);
		} 
	}
}