package Model.ModelPresenter 
{
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	import Model.*;
	import Model.ModelPresenter.Command.*;
	
	public class ModelPresenter extends EventDispatcher
	{
		private var _model: Model;
		private var _commandStack: CommandStack;
		
		public function ModelPresenter(m: Model) 
		{
			_model = m;
			_commandStack = new CommandStack();
			
			_model.addEventListener(ModelEvent.OBJECT_ADDED, notifyControllerAboutChangedObject);
			_model.addEventListener(ModelEvent.OBJECT_DELETED, notifyControllerAboutChangedObject);
			_model.addEventListener(ModelEvent.OBJECT_RECT_CHANGED, notifyControllerAboutChangedObject);
			_commandStack.addEventListener(CommandStackEvent.STACK_CHANGED, notifyControllerAboutStackState);
		}
		
		// model-interface functions
		
		public function createObject(objType: uint, rect: Rectangle, color: uint): void
		{
			var createCommand: IUndoableCommand = new CreateCommand(_model, rect, objType, color);
			createCommand.execute();
			_commandStack.addCommand(createCommand);
		}
		
		public function deleteObject(objIndex: uint): void
		{
			var deleteCommand: IUndoableCommand = new DeleteCommand(_model, objIndex);
			deleteCommand.execute();
			_commandStack.addCommand(deleteCommand);
		}
		
		public function setObjectRect(objToChange: ModelObject, rect: Rectangle): void
		{
			var setRectCommand: IUndoableCommand = new SetRectCommand(_model, objToChange, rect);
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
		
		private function notifyControllerAboutChangedObject(e: ModelEvent): void
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