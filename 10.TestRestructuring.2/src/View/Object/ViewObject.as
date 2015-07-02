package View.Object 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import View.Event.ViewObjectEvent;
	
	public class ViewObject extends Sprite
	{
		private var _workingArea: Rectangle; 
		private var _modelScene: Rectangle;		
		
		public function ViewObject(image: Sprite, modelObjRect: Rectangle, workingArea: Rectangle, modelSceneRect: Rectangle) 
		{
			_workingArea = workingArea
			_modelScene = modelSceneRect.clone();
			
			addChild(image);
			setRectByModelData(modelObjRect);
			focusRect = false;
			
			addListeners();
		}
		
		// program interface functions
		
		public function set rect(value: Rectangle): void
		{
			x = value.x;
			y = value.y;
			width = value.width;
			height = value.height;
		}
		
		public function get rect(): Rectangle
		{
			return new Rectangle(x, y, width, height);
		}
		
			// functions used by Controller
			
		public function get convertedRect(): Rectangle
		{
			return convertViewRectToModelRect(rect);
		}
		
		public function setRectByModelData(value: Rectangle): void
		{
			rect = convertModelRectToViewRect(value);
		}
		
		// listeners init
		
		private function addListeners(): void
		{
			addEventListener(MouseEvent.MOUSE_DOWN, beginDrag, false, 0, true);
		}
		
		// (listeners) user interface functions
		
		private function beginDrag(e: MouseEvent): void
		{			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, moveObject);
			stage.addEventListener(MouseEvent.MOUSE_UP, endDrag);
			
			var bounds: Rectangle = new Rectangle(_workingArea.x, _workingArea.y, _workingArea.width - width, _workingArea.height - height);
			startDrag(false, bounds);
		}
		
		private function endDrag(e: MouseEvent): void
		{
			stopDrag();
			
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, moveObject);
			stage.removeEventListener(MouseEvent.MOUSE_UP, endDrag);
			
			dispatchEvent(new ViewObjectEvent(ViewObjectEvent.STOP_CHANGE));
		}
		
		private function moveObject(e: MouseEvent): void
		{	
			e.updateAfterEvent();
			dispatchEvent(new ViewObjectEvent(ViewObjectEvent.CHANGE));
		}
		
		// functions for managing relations between model and view stages
		
		private function convertModelRectToViewRect(mRect: Rectangle): Rectangle
		{
			var vRect: Rectangle = new Rectangle();
			var view_ModelAspect: Number = _workingArea.height / _modelScene.height;
			vRect.x = mRect.x * view_ModelAspect;
			vRect.y = mRect.y * view_ModelAspect;
			vRect.width = mRect.width * view_ModelAspect;
			vRect.height = mRect.height * view_ModelAspect;
			
			return vRect;
		}
		
		private function convertViewRectToModelRect(vRect: Rectangle): Rectangle
		{
			var mRect: Rectangle = new Rectangle();
			var model_ViewAspect: Number = _modelScene.height / _workingArea.height;
			mRect.x = vRect.x * model_ViewAspect;
			mRect.y = vRect.y * model_ViewAspect;
			mRect.width = vRect.width * model_ViewAspect;
			mRect.height = vRect.height * model_ViewAspect;
			
			return mRect;
		}
	}
}