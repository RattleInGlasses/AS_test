package Model.Storage 
{
	import flash.geom.Rectangle;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import Model.ModelObject;
	import Type.ObjectForm;
	
	public class ModelObjectContainer implements IExternalizable
	{
		private const INT_TRIANGLE: int  = 1;
		private const INT_RECTANGLE: int = 2;
		private const INT_ELLIPSE: int   = 3;
		
		private var _x: Number;
		private var _y: Number;
		private var _width: Number;
		private var _height: Number;
		private var _color: uint;
		private var _type: ObjectForm;		
		
		public function ModelObjectContainer(mdlObj: ModelObject = null)
		{
			if (mdlObj)
			{
				_x = mdlObj.rect.x;
				_y = mdlObj.rect.y;
				_width = mdlObj.rect.width;
				_height = mdlObj.rect.height;
				_color = mdlObj.color;
				_type = mdlObj.type;
			}
		}
		
		public function get modelObject(): ModelObject 
		{
			return new ModelObject(new Rectangle(_x, _y, _width, _height), _type, _color);
		}
		
		public function readExternal(input: IDataInput): void
		{
			_x      = input.readDouble();
			_y      = input.readDouble();
			_width  = input.readDouble();
			_height = input.readDouble();
			_color  = input.readUnsignedInt();
			_type   = IntToObjectForm(input.readUnsignedInt());
		}
		
		public function writeExternal(output: IDataOutput): void
		{
			output.writeDouble(_x);
			output.writeDouble(_y);
			output.writeDouble(_width);
			output.writeDouble(_height);
			output.writeUnsignedInt(_color);
			output.writeUnsignedInt(ObjectFormToInt(_type));
		}
		
		private function ObjectFormToInt(value: ObjectForm): int
		{
			var result: int;
			switch (value)
			{
				case ObjectForm.ELLIPSE:
					result = INT_ELLIPSE;
				break;
				case ObjectForm.RECTANGLE:
					result = INT_RECTANGLE;
				break;
				case ObjectForm.TRIANGLE:
					result = INT_TRIANGLE;
				break;
			}
			return result;
		}
		
		private function IntToObjectForm(value: int): ObjectForm
		{
			var result: ObjectForm;
			switch (value)
			{
				case INT_ELLIPSE:
					result = ObjectForm.ELLIPSE;
				break;
				case INT_RECTANGLE:
					result = ObjectForm.RECTANGLE;
				break;
				case INT_TRIANGLE:
					result = ObjectForm.TRIANGLE;
				break;
			}
			return result;
		}
	}
}