package Model.Storage 
{
	import flash.geom.Rectangle;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import Model.ModelObject;
	
	public class ModelObjectContainer implements IExternalizable
	{
		private var _x: Number;
		private var _y: Number;
		private var _width: Number;
		private var _height: Number;
		private var _color: uint;
		private var _type: uint;		
		
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
			_type   = input.readUnsignedInt();
		}
		
		public function writeExternal(output: IDataOutput): void
		{
			output.writeDouble(_x);
			output.writeDouble(_y);
			output.writeDouble(_width);
			output.writeDouble(_height);
			output.writeUnsignedInt(_color);
			output.writeUnsignedInt(_type);
		}
	}
}