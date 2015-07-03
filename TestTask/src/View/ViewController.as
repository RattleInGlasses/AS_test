package View 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import View.Event.*;
	import View.Object.*;

	public class ViewController extends EventDispatcher
	{
		private var _selectionFrame: SelectionFrame;
		private var _boundObject: ViewObject;
		private var _lastSentRect: Rectangle;
		private var _lastSentSelection: ViewObject;
		
		public function ViewController(selectionFrame: SelectionFrame) 
		{
			_selectionFrame = selectionFrame;
			addSelectionFrameListeners();
		}
		
		// used by View
		
		public function get selectedObject(): ViewObject
		{
			return _boundObject;
		}
		
		public function set selectedObject(object: ViewObject): void
		{			
			_boundObject = object;
			removeOldListeners();
			if (object)
			{
				addNewListeners(object);
				_lastSentRect = object.rect.clone();
				_selectionFrame.rect = object.rect.clone();
				_selectionFrame.show();
				_selectionFrame.dispatchEvent(new SelectionFrameEvent(SelectionFrameEvent.BOUND));
			}
			else // object == null
			{
				_selectionFrame.hide();
			}
			
			if (_lastSentSelection != object)
			{
				_lastSentSelection = object;
				dispatchEvent(new ViewControllerEvent(ViewControllerEvent.SELECTION_CHANGED));
			}
		}
		
		// listeners
		
		private function addSelectionFrameListeners(): void
		{
			_selectionFrame.addEventListener(SelectionFrameEvent.CHANGE, changeViewObject);
			_selectionFrame.addEventListener(SelectionFrameEvent.STOP_CHANGE, sendChangeObjectRequestToModel);
		}
		
		private function addNewListeners(object: ViewObject): void
		{
			object.addEventListener(ViewObjectEvent.CHANGE, changeSelectionFrame);
			object.addEventListener(ViewObjectEvent.STOP_CHANGE, sendChangeObjectRequestToModel);
			object.addEventListener(Event.REMOVED, unbindFrame);
		}
		
		private function removeOldListeners(): void
		{
			if (_boundObject)
			{
				_boundObject.removeEventListener(ViewObjectEvent.CHANGE, changeSelectionFrame);
				_boundObject.removeEventListener(ViewObjectEvent.STOP_CHANGE, sendChangeObjectRequestToModel);
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
			_selectionFrame.dispatchEvent(new SelectionFrameEvent(SelectionFrameEvent.UNBOUND));
		}
		
		// listen for frame
		
		private function changeViewObject(e: SelectionFrameEvent): void
		{
			_boundObject.rect = _selectionFrame.rect;
		}
		
		// common listen 
		
		private function sendChangeObjectRequestToModel(e: Event): void
		{
			_selectionFrame.rect = _boundObject.rect;
			if (!_lastSentRect.equals(_boundObject.rect))
			{
				_boundObject.sendChangeObjectRequest();
				_lastSentRect = _boundObject.rect;
			}
		}
	}
}