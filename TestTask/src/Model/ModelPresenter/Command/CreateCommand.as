package Model.ModelPresenter.Command 
{
	import flash.geom.Rectangle;
	import Model.Model;
	import Model.ModelObject;
	
	public class CreateCommand implements IUndoableCommand
	{
		private var _model: Model;
		private var _rect: Rectangle;
		private var _objType: uint;
		private var _objIndex: uint;
		private var _objColor: uint;
		
		private var _redoObj: ModelObject;
		
		public function CreateCommand(m: Model, rect: Rectangle, objType: uint, color: uint)
		{
			_model = m;
			_rect = rect;
			_objType = objType;
			_objColor = color;
			_redoObj = null;
		}
		
		public function execute(): void
		{
			if (!_redoObj)
			{
				_objIndex = _model.createAndAddModelObject(_rect, _objType, _objColor);
			}
			else
			{
				_objIndex = _model.addObjectToModel(_redoObj);
			}
		}
		
		public function undo(): void
		{
			_redoObj = _model.deleteObject(_objIndex);
		}
	}
}