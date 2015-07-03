package Model.ModelPresenter.Command 
{
	import flash.geom.Rectangle;
	import Model.Model;
	import Model.ModelObject;
	import Model.ModelPresenter.ISelectionController;
	import Type.ObjectForm;
	
	public class CreateCommand implements IUndoableCommand
	{
		private var _model: Model;
		private var _selectionController: ISelectionController;
		private var _rect: Rectangle;
		private var _objType: ObjectForm;
		private var _objIndex: uint;
		private var _objColor: uint;
		private var _focusBeforeExec: ModelObject;
		private var _createdObj: ModelObject;
		
		public function CreateCommand(m: Model, sc: ISelectionController, rect: Rectangle, objType: ObjectForm, color: uint)
		{
			_model = m;
			_selectionController = sc;
			_rect = rect;
			_objType = objType;
			_objColor = color;
		}
		
		public function execute(): void
		{
			_focusBeforeExec = _selectionController.selectedObject;
			if (!_createdObj)
			{
				_createdObj = _model.createModelObject(_rect, _objType, _objColor);
			}
			_objIndex = _model.addObjectToModel(_createdObj);
			_selectionController.selectedObject = _createdObj;
		}
		
		public function undo(): void
		{
			_model.deleteObject(_objIndex);
			_selectionController.selectedObject = _focusBeforeExec;
		}
	}
}