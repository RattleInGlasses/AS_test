package View.Object 
{
	import flash.events.Event;
	import flash.geom.Rectangle;
	import View.Event.*;

	public class ViewController 
	{
		private var _selectionFrame: SelectionFrame;
		private var _boundObject: ViewObject;
		private var _lastSentRect: Rectangle;
		
		public function ViewController(selectionFrame: SelectionFrame) 
		{
			_selectionFrame = selectionFrame;
			addSelectionFrameListeners();
		}
		
		// used by View
		
		public function bindObjectToFrame(object: ViewObject): void
		{
			removeOldListeners();
			addNewListeners(object);
			_lastSentRect = object.rect.clone();
			_selectionFrame.rect = object.rect.clone();
			_boundObject = object;
			_selectionFrame.show();
			_selectionFrame.dispatchEvent(new SelectionFrameEvent(SelectionFrameEvent.BOUND));
		}	
		
		public function get boundObject(): ViewObject
		{
			return _boundObject;
		}
		
		// listeners
		
		private function addSelectionFrameListeners(): void
		{
			_selectionFrame.addEventListener(SelectionFrameEvent.CHANGE, changeViewObject);
			_selectionFrame.addEventListener(SelectionFrameEvent.STOP_CHANGE, sendChangeEventToModel);
		}
		
		private function addNewListeners(object: ViewObject): void
		{
			object.addEventListener(ViewObjectEvent.CHANGE, changeSelectionFrame);
			object.addEventListener(ViewObjectEvent.STOP_CHANGE, sendChangeEventToModel);
			object.addEventListener(Event.REMOVED, unbindFrame);
		}
		
		private function removeOldListeners(): void
		{
			if (_boundObject)
			{
				_boundObject.removeEventListener(ViewObjectEvent.CHANGE, changeSelectionFrame);
				_boundObject.removeEventListener(ViewObjectEvent.STOP_CHANGE, sendChangeEventToModel);
				_boundObject.removeEventListener(Event.REMOVED, unbindFrame);
			}
		}
		
		// listen for object
		
		private function changeSelectionFrame(e: ViewObjectEvent): void
		{
			_selectionFrame.rect = _boundObject.rect;
		}
		
		private function unbindFrame(e: Event): void
		{
			removeOldListeners();
			_selectionFrame.hide();
			_selectionFrame.dispatchEvent(new SelectionFrameEvent(SelectionFrameEvent.UNBOUND));
		}
		
		// listen for frame
		
		private function changeViewObject(e: SelectionFrameEvent): void
		{
			_boundObject.rect = _selectionFrame.rect;
		}
		
		// common listen 
		
		private function sendChangeEventToModel(e: Event): void
		{
			_selectionFrame.rect = _boundObject.rect;
			if (!_lastSentRect.equals(_boundObject.rect))
			{
				_boundObject.dispatchEvent(new ViewEvent(ViewEvent.CHANGE_OBJECT_REQUEST));
				_lastSentRect = _boundObject.rect;
			}
		}
	}
}