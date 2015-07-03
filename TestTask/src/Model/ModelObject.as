package Model 
{
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.net.registerClassAlias;
	import Type.ObjectForm;
	
	public class ModelObject extends EventDispatcher
	{
		public static const TRIANGLE: uint  = 1;
		public static const RECTANGLE: uint = 2;
		public static const ELLIPSE: uint   = 3;
		
		private var _rect: Rectangle;
		private var _objType: ObjectForm;
		private var _color: uint;
		
		public function ModelObject(rect: Rectangle, objType: ObjectForm, color: uint)
		{	
			_rect = rect;
			_objType = objType;
			_color = color;
		}
		
		public function get rect(): Rectangle 
		{
			return _rect.clone();
		}
		
		public function get type(): ObjectForm 
		{
			return _objType;
		}
		
		public function get color(): uint
		{
			return _color;
		}
		
		public function set rect(value: Rectangle): void
		{
			_rect = value;
			dispatchEvent(new ModelEvent(ModelEvent.OBJECT_RECT_CHANGED, this));
		}
	}
}