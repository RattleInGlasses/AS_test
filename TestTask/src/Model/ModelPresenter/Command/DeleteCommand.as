package Model.ModelPresenter.Command 
{
	import Model.Model;
	import Model.ModelObject;
	import Model.ModelPresenter.ISelectionController;
	
	public class DeleteCommand implements IUndoableCommand
	{
		private var _model: Model;
		private var _selectionController: ISelectionController;
		private var _objToDelIndex: uint;
		private var _deletedObj: ModelObject;
		
		public function DeleteCommand(m: Model, sc: ISelectionController, objIndex: uint) 
		{
			_model = m;
			_selectionController = sc;
			_objToDelIndex = objIndex;
		}
		
		public function execute(): void
		{
			_deletedObj = _model.deleteObject(_objToDelIndex);
		}
		
		public function undo(): void
		{
			_model.addObjectToModel(_deletedObj, _objToDelIndex);
			_selectionController.selectedObjectIndex = _objToDelIndex;
		}
	}
}