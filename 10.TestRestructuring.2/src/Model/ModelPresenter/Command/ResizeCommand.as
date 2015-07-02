package Model.ModelPresenter.Command 
{
	import Model.Model;
	import Type.*;
	
	public class ResizeCommand implements IUndoableCommand
	{
		private var _model: Model;
		private var _objToResizeIndex: uint;
		private var _newWidth: Number;
		private var _newHeight: Number;
		private var _newX: Number;
		private var _newY: Number;
		private var _oldWidth: Number;
		private var _oldHeight: Number;
		private var _oldX: Number;
		private var _oldY: Number;
		
		public function ResizeCommand(m: Model, objIndex: uint, width: Number, height: Number, x: Number, y: Number) 
		{
			_model = m;
			_objToResizeIndex = objIndex;
			_newWidth = width;
			_newHeight = height;
			_newX = x;
			_newY = y;
		}
		
		public function execute(): void
		{
			var objSize: Size = _model.getObjectSize(_objToResizeIndex);
			_oldWidth = objSize.width;
			_oldHeight = objSize.height;
			var objPos: Position = _model.getObjectPosition(_objToResizeIndex);
			_oldX = objPos.x;
			_oldY = objPos.y;
			_model.resizeObject(_objToResizeIndex, _newWidth, _newHeight, _newX, _newY);
		}
		
		public function undo(): void
		{
			_model.resizeObject(_objToResizeIndex, _oldWidth, _oldHeight, _oldX, _oldY);
		}
	}
}