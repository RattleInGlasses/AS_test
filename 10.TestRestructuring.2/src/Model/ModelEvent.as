package Model 
{
	import flash.events.Event;
	
	public class ModelEvent extends Event
	{
		public static const OBJECT_ADDED: String          = "mdlObjectCreated";
		public static const OBJECT_DELETED: String        = "mdlObjectDeleted";
		public static const OBJECT_RECT_CHANGED: String   = "mdlObjectRChanged";
		public static const STACK_CHANGED: String         = "mdlStackChanged";
		
		private var _changedObj: ModelObject = null;
		private var _objPositionIndex: uint = 0;
		private var _stackHasNextCommand: Boolean = false;
		private var _stackHasPrevCommand: Boolean = false;
		
		public function ModelEvent(type: String, changedObj: ModelObject = null, objPosIndex: uint = 0,
			stackHasNextCom: Boolean = false, stackHasPrevCom: Boolean = false)
		{
			super(type);
			_changedObj = changedObj;
			_objPositionIndex = objPosIndex;
			_stackHasNextCommand = stackHasNextCom;
			_stackHasPrevCommand = stackHasPrevCom;
		}
		
		override public function clone(): Event
		{
			return new ModelEvent(type, modelObj, objPositionIndex, stackHasNextCommand, stackHasPrevCommand);
		}
		
		public function get modelObj(): ModelObject
		{
			return _changedObj;
		}
			
		public function get objPositionIndex(): uint 
		{
			return _objPositionIndex;
		}
		
		public function get stackHasNextCommand(): Boolean 
		{
			return _stackHasNextCommand;
		}
		
		public function get stackHasPrevCommand(): Boolean 
		{
			return _stackHasPrevCommand;
		}
	}
}