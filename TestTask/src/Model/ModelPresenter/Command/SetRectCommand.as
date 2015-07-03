package Model.ModelPresenter.Command 
{
	import flash.geom.Rectangle;
	import Model.Model;
	import Model.ModelObject;
	import Model.ModelPresenter.ISelectionController;
	import Model.ModelPresenter.ModelPresenter;
	
	public class SetRectCommand implements IUndoableCommand
	{
		private var _model: Model;
		private var _selectionController: ISelectionController;
		private var _changingObject: ModelObject;
		private var _rectBeforeExec: Rectangle;
		private var _newRect: Rectangle;
		
		public function SetRectCommand(m: Model, sc: ISelectionController, changingObject: ModelObject, rect: Rectangle) 
		{
			_model = m;
			_selectionController = sc;
			_changingObject = changingObject;
			_newRect = rect;
		}
		
		public function execute(): void
		{
			_rectBeforeExec = _changingObject.rect;
			_selectionController.selectedObject = _changingObject;
			_model.setObjectRect(_changingObject, _newRect);
		}
		
		public function undo(): void
		{
			_selectionController.selectedObject = _changingObject;
			_model.setObjectRect(_changingObject, _rectBeforeExec);
			_selectionController.selectedObject = _changingObject;
		}
	}
}