package Controller 
{
	import flash.geom.Rectangle;
	import flash.utils.*;
	import Model.*;
	import Model.ModelPresenter.ModelPresenter;
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
			
			_view.addEventListener(ViewEvent.CREATE_OBJECT_REQUEST, createModelObject);
			_view.addEventListener(ViewEvent.DELETE_OBJECT_REQUEST, deleteModelObject);
			_view.addEventListener(ViewEvent.UNDO_REQUEST, undo);
			_view.addEventListener(ViewEvent.REDO_REQUEST, redo);
			_view.addEventListener(ViewEvent.SAVE_MODEL_STATE_REQUEST, saveModelState);
		}
		
		// functions-listeners for model changes
		
		private function createViewObject(e: ModelEvent): void
		{
			var guiObj: ViewObject = _view.createGuiObject(e.objPositionIndex, e.modelObj);
			var mdlObj: ModelObject = e.modelObj;
			
			var ignoreUpdate: Boolean = false;
			guiObj.addEventListener(ViewEvent.CHANGE_OBJECT_REQUEST, function(e: ViewEvent): void {
					if (ignoreUpdate) 
					{
						return;
					}
					ignoreUpdate = true;
					_modelPresenter.setObjectRect(mdlObj, guiObj.convertedRect);
					ignoreUpdate = false;
				},
				false, 0, true);
			
			// TODO: View не должен зависеть от модели. лучше сразу вьюшку модифицировать. родительская вьюшка может слушать дочерние и обновлять selection
			mdlObj.addEventListener(ModelEvent.OBJECT_RECT_CHANGED, function(e: ModelEvent): void {
					if (ignoreUpdate) 
					{
						return;
					}
					ignoreUpdate = true;
					_view.changeGuiObjectRect(guiObj, mdlObj);
					ignoreUpdate = false;
				},
				false, 0, true);
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