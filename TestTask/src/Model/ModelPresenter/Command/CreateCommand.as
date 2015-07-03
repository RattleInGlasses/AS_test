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
		private var _focusBeforeExec: uint;
		
		private var _redoObj: ModelObject;
		
		public function CreateCommand(m: Model, sc: ISelectionController, rect: Rectangle, objType: ObjectForm, color: uint)
		{
			_model = m;
			_selectionController = sc;
			_rect = rect;
			_objType = objType;
			_objColor = color;
			_redoObj = null;
		}
		
		public function execute(): void
		{
			_focusBeforeExec = _selectionController.selectedObjectIndex;
			if (!_redoObj)
			{
				_objIndex = _model.createAndAddModelObject(_rect, _objType, _objColor);
			}
			else
			{
				_objIndex = _model.addObjectToModel(_redoObj);
			}
			_selectionController.selectedObjectIndex = _objIndex;
		}
		
		public function undo(): void
		{
			_redoObj = _model.deleteObject(_objIndex);
			_selectionController.selectedObjectIndex = _focusBeforeExec;
		}
	}
}