package Model.ModelPresenter 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	import Model.*;
	import Model.ModelPresenter.Command.*;
	import Model.ModelPresenter.Event.*;
	import Type.ObjectForm;
	
	public class ModelPresenter extends EventDispatcher implements ISelectionController
	{
		private var _model: Model;
		private var _commandStack: CommandStack;
		private var _selection: ModelObject;
		
		public function ModelPresenter(m: Model) 
		{
			_model = m;
			_commandStack = new CommandStack();
			
			_model.addEventListener(ModelEvent.OBJECT_ADDED, notifyControllerAboutEvent);
			_model.addEventListener(ModelEvent.OBJECT_DELETED, notifyControllerAboutEvent);
			_model.addEventListener(ModelEvent.OBJECT_RECT_CHANGED, notifyControllerAboutEvent);
			_commandStack.addEventListener(CommandStackEvent.STACK_CHANGED, notifyControllerAboutStackState);
		}
		
		// model-interface functions
		
		public function get selectedObject(): ModelObject
		{
			return _selection;
		}
		
		public function set selectedObject(value: ModelObject): void
		{
			if (_selection != value)
			{
				_selection = value;
				dispatchEvent(new ModelEvent(ModelEvent.FOCUS_CHANGED));
			}
		}
		
		public function createObject(objType: ObjectForm, rect: Rectangle, color: uint): void
		{
			var createCommand: IUndoableCommand = new CreateCommand(_model, this, rect, objType, color);
			createCommand.execute();
			_commandStack.addCommand(createCommand);
		}
		
		public function deleteObject(objIndex: uint): void
		{
			var deleteCommand: IUndoableCommand = new DeleteCommand(_model, this, objIndex);
			deleteCommand.execute();
			_commandStack.addCommand(deleteCommand);
		}
		
		public function setObjectRect(objToChange: ModelObject, rect: Rectangle): void
		{
			var setRectCommand: IUndoableCommand = new SetRectCommand(_model, this, objToChange, rect);
			setRectCommand.execute();
			_commandStack.addCommand(setRectCommand);
		}
		
		public function undo(): void
		{
			var undoCommand: IUndoableCommand = _commandStack.getPrevCommand();
			if (undoCommand != null)
			{
				undoCommand.undo();
			}
		}
		
		public function redo(): void
		{
			var redoCommand: IUndoableCommand = _commandStack.getNextCommand();
			if (redoCommand != null)
			{
				redoCommand.execute();
			}
		}
		
		public function saveModelState(): void
		{
			_model.saveState();
		}
		
		public function loadModelState(): void
		{
			_model.loadState();
		}
		
		// functions-listeners for model changes
		
		private function notifyControllerAboutEvent(e: Event): void
		{
			dispatchEvent(e);
		}
		
		private function notifyControllerAboutStackState(e: CommandStackEvent): void
		{
			var stackEvent: ModelEvent = new ModelEvent(ModelEvent.STACK_CHANGED, null, 0, _commandStack.hasNextCommand(), _commandStack.hasPrevCommand());
			dispatchEvent(stackEvent);
		}
		
		// other
		
		public function get SCENE_WIDTH(): Number
		{
			return _model.SCENE_WIDTH;
		}
		
		public function get SCENE_HEIGHT(): Number
		{
			return _model.SCENE_HEIGHT;
		}
	}
}