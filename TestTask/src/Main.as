package
{
	import Controller.Controller;
	import flash.display.Sprite;
	import flash.events.Event;
	import Model.*;
	import Model.ModelPresenter.ModelPresenter;
	import View.View;
	
		import flash.events.MouseEvent;
		import flash.geom.Rectangle;
	
	public class Main extends Sprite 
	{
		public function Main() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e: Event = null): void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			var m: Model = new Model();
			var mp: ModelPresenter = new ModelPresenter(m);
			var v: View = new View();
			addChild(v);
			var c: Controller = new Controller(mp, v);
		}
	}
}