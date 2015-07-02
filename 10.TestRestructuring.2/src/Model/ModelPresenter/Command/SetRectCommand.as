package Model.ModelPresenter.Command 
{
	import flash.geom.Rectangle;
	import Model.Model;
	import Model.ModelObject;
	
	public class SetRectCommand implements IUndoableCommand
	{
		private var _model: Model;
		private var _changingObj: ModelObject;
		private var _rectBeforeExec: Rectangle;
		private var _newRect: Rectangle;
		
		public function SetRectCommand(m: Model, changingObj: ModelObject, rect: Rectangle) 
		{
			_model = m;
			_changingObj = changingObj;
			_newRect = rect;
		}
		
		public function execute(): void
		{
			_rectBeforeExec = _changingObj.rect;
			_model.setObjectRect(_changingObj, _newRect);
		}
		
		public function undo(): void
		{
			_model.setObjectRect(_changingObj, _rectBeforeExec);
		}
	}
}