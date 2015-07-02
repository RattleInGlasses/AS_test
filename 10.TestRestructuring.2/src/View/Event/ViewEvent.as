package View.Event 
{
	import flash.events.Event;
	import flash.geom.Rectangle;
	import Model.ModelObject;
	
	public class ViewEvent extends Event
	{
		public static const CREATE_OBJECT_REQUEST: String    = "usrRqstCreateObj";
		public static const DELETE_OBJECT_REQUEST: String    = "usrRqstDeleteObj";
		public static const CHANGE_OBJECT_REQUEST: String    = "usrRqstMoveObj";
		public static const UNDO_REQUEST: String             = "usrRqstUndo";
		public static const REDO_REQUEST: String             = "usrRqstRedo";
		public static const SAVE_MODEL_STATE_REQUEST: String = "usrRqstSaveModel";
		
		private var _objIndex: uint;
		private var _objType: uint;
		private var _objRect: Rectangle;
		private var _modelObj: ModelObject;
		
		public function ViewEvent(type: String, objIndex: uint = 0, objType: uint = 0, objRect: Rectangle = null, modelObj: ModelObject = null) 
		{
			super(type);
			_objIndex = objIndex;
			_objType = objType;
			_objRect = objRect;
			_modelObj = modelObj;
		}
		
		public function get objIndex(): uint 
		{
			return _objIndex;
		}
		
		public function get objType(): uint 
		{
			return _objType;
		}
		
		public function get objRect(): Rectangle 
		{
			return _objRect.clone();
		}
		
		public function get modelObj(): ModelObject
		{
			return _modelObj;
		}
	}
}