package Model.ModelPresenter 
{
	import flash.events.Event;
	
	public class CommandStackEvent extends Event
	{
		static public const STACK_CHANGED: String = "commandStackChanged";
		
		public function CommandStackEvent(type: String) 
		{
			super(type);
		}
	}
}