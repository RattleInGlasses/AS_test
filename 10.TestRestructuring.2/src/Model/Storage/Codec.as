package Model.Storage 
{
	import flash.utils.ByteArray;
	import Model.ModelObject;
	import flash.net.registerClassAlias;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	
	public class Codec 
	{
		public function Codec() 
		{
			registerClassAlias("ModelObjectContainer", ModelObjectContainer);
		}
		
		public function serializeModel(modelState: Vector.<ModelObjectContainer>): ByteArray
		{
			var byteModel: ByteArray = new ByteArray();
			byteModel.writeObject(modelState);
			return byteModel;
		}
		
		public function deserializeModel(byteModel: ByteArray): Vector.<ModelObjectContainer>
		{
			try
			{
				byteModel.position = 0;
				return byteModel.readObject() as Vector.<ModelObjectContainer>;
			}
			catch (e: Error)
			{
				
			}
			return new Vector.<ModelObjectContainer>();
		}
	}
}