package Controller 
{
	import flash.events.EventDispatcher;
	import flash.events.FocusEvent;
	import flash.geom.Rectangle;
	import flash.utils.*;
	import Model.*;
	import Model.ModelPresenter.ModelPresenter;
	import Type.ObjectForm;
	import View.View;
	import View.Object.*;
	import View.View;
	import View.Event.*;
	import flash.events.Event;
	
	public class Controller
	{
		private const MAX_COLOR_BRIGHTNESS: uint = 240;
		
		private var _defaultObjectRect: Rectangle = new Rectangle();
		private var _modelPresenter: ModelPresenter;
		private var _view: View;
		
		private var ignoreFocusUpdate: Boolean = false;
		
		public function Controller(mp: ModelPresenter, v: View)
		{
			_modelPresenter = mp;
			_view = v;
			
			setDefaultObjectRect();
			addListeners();
			
			_view.setModelStageSize(_modelPresenter.SCENE_WIDTH, _modelPresenter.SCENE_HEIGHT);
			_modelPresenter.loadModelState();
		}
		
		private function setDefaultObjectRect(): void
		{
			_defaultObjectRect.width  = _defaultObjectRect.height = Math.min((_modelPresenter.SCENE_WIDTH / 2), (_modelPresenter.SCENE_HEIGHT / 2));
			_defaultObjectRect.x = (_modelPresenter.SCENE_WIDTH - _defaultObjectRect.width) / 2;
			_defaultObjectRect.y = (_modelPresenter.SCENE_HEIGHT - _defaultObjectRect.height) / 2;
		}
		
		private function addListeners(): void
		{
			_modelPresenter.addEventListener(ModelEvent.OBJECT_ADDED, createViewObject);
			_modelPresenter.addEventListener(ModelEvent.OBJECT_DELETED, deleteViewObject);
			_modelPresenter.addEventListener(ModelEvent.STACK_CHANGED, setUndoRedoViewState);
			_modelPresenter.addEventListener(ModelEvent.FOCUS_CHANGED, setViewFocus);
			
			_view.addEventListener(ViewEvent.CREATE_OBJECT_REQUEST, createModelObject);
			_view.addEventListener(ViewEvent.DELETE_OBJECT_REQUEST, deleteModelObject);
			_view.addEventListener(ViewEvent.UNDO_REQUEST, undo);
			_view.addEventListener(ViewEvent.REDO_REQUEST, redo);
			_view.addEventListener(ViewEvent.SAVE_MODEL_STATE_REQUEST, saveModelState);
			_view.addEventListener(ViewEvent.CHANGE_FOCUS_REQUEST, setModelFocus);
		}
		
		// functions-listeners for model changes
		
		private function setViewFocus(e: ModelEvent): void
		{
			if (_modelPresenter.selectedObject == null)
			{
				ignoreFocusUpdate = true;
				_view.selectedObject = null;
				ignoreFocusUpdate = false;
			}
		}
		
		private function createViewObject(e: ModelEvent): void
		{
			var mdlObj: ModelObject = e.modelObj;
			var guiObj: ViewObject = _view.createGuiObject(e.objPositionIndex, mdlObj.type, mdlObj.color, mdlObj.rect);			
			
			guiObj.addEventListener(ViewEvent.CHANGE_OBJECT_REQUEST, function(e: ViewEvent): void {
				_modelPresenter.setObjectRect(mdlObj, guiObj.convertedRect);
			},
			false, 0, true);
			
			mdlObj.addEventListener(ModelEvent.OBJECT_RECT_CHANGED, function(e: ModelEvent): void {
				_view.changeGuiObjectRect(guiObj, mdlObj.rect);
			},
			false, 0, true);
			
			var ignoreUpdate: Boolean = false;
			_view.addEventListener(ViewEvent.CHANGE_FOCUS_REQUEST, function(e: ViewEvent): void {
				if (_view.selectedObject == guiObj)
				{
					if (ignoreUpdate)
					{
						return
					}
					_modelPresenter.selectedObject = mdlObj;
				}
			});
			
			_modelPresenter.addEventListener(ModelEvent.FOCUS_CHANGED, function(e: ModelEvent): void {
				if (_modelPresenter.selectedObject == mdlObj)
				{
					ignoreUpdate = true;
					_view.selectedObject = guiObj;
					ignoreUpdate = false;
				}
			});
		}
		
		private function deleteViewObject(e: ModelEvent): void
		{
			_view.deleteGuiObject(e.objPositionIndex);
		}
		
		private function setUndoRedoViewState(e: ModelEvent): void
		{
			_view.setUndoRedoState(e.stackHasPrevCommand, e.stackHasNextCommand);
		}
		
		// functions-listeners for view requests	
		
		private function setModelFocus(e: ViewEvent): void
		{
			if (_view.selectedObject == null)
			{
				if (ignoreFocusUpdate) 
				{
					return;
				}
				_modelPresenter.selectedObject = null;
			}
		}
		
		private function createModelObject(e: ViewEvent): void
		{
			var color: uint = getRandomColor();
			_modelPresenter.createObject(e.objType, _defaultObjectRect, color);
		}
		
		private function deleteModelObject(e: ViewEvent): void
		{
			_modelPresenter.deleteObject(e.objIndex);
		}
		
		private function undo(e: ViewEvent): void
		{
			_modelPresenter.undo();
		}
		
		private function redo(e: ViewEvent): void
		{
			_modelPresenter.redo();
		}
		
		private function saveModelState(e: ViewEvent): void
		{
			_modelPresenter.saveModelState();
		}
		
		// other
		
		private function getRandomColor(): uint
		{
			var r: uint = Math.random() * (MAX_COLOR_BRIGHTNESS + 1);
			var g: uint = Math.random() * (MAX_COLOR_BRIGHTNESS + 1);
			var b: uint = Math.random() * (MAX_COLOR_BRIGHTNESS + 1);
			
			return r * 256 * 256 + g * 256 + b;
		}
	}
}