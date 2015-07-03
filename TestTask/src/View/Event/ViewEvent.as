package View.Event 
{
	import flash.events.Event;
	import flash.geom.Rectangle;
	import Model.ModelObject;
	import Type.ObjectForm;
	import View.Object.ViewObject;
	
	public class ViewEvent extends Event
	{
		public static const CREATE_OBJECT_REQUEST: String    = "usrRqstCreateObj";
		public static const DELETE_OBJECT_REQUEST: String    = "usrRqstDeleteObj";
		public static const CHANGE_OBJECT_REQUEST: String    = "usrRqstMoveObj";
		public static const UNDO_REQUEST: String             = "usrRqstUndo";
		public static const REDO_REQUEST: String             = "usrRqstRedo";
		public static const SAVE_MODEL_STATE_REQUEST: String = "usrRqstSaveModel";
		public static const CHANGE_FOCUS_REQUEST: String     = "usrRqstFocusChange";
		
		private var _objIndex: uint;
		private var _objType: ObjectForm;
		private var _objRect: Rectangle;
		
		public function ViewEvent(type: String, objIndex: uint = 0, objType: ObjectForm = null, objRect: Rectangle = null) 
		{
			super(type);
			_objIndex = objIndex;
			_objType = objType;
			_objRect = objRect;
		}
		
		public function get objIndex(): uint 
		{
			return _objIndex;
		}
		
		public function get objType(): ObjectForm 
		{
			return _objType;
		}
		
		public function get objRect(): Rectangle 
		{
			return _objRect.clone();
		}
	}
}