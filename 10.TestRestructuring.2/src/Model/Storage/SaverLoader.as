package Model.Storage 
{
	import flash.net.SharedObject;
	import flash.utils.ByteArray;
	import Model.ModelObject;
	
	public class SaverLoader 
	{
		private var _codec: Codec;
		private var _storage: Storage;
		
		public function SaverLoader() 
		{
			_codec = new Codec();
			_storage = new Storage();
		}
		
		public function saveState(modelState: Vector.<ModelObject>): void
		{
			var modelPackage: Vector.<ModelObjectContainer> = packState(modelState);
			_storage.SaveSerializedModel(_codec.serializeModel(modelPackage));
		}
		
		public function loadState(): Vector.<ModelObject>
		{
			var modelPackage: Vector.<ModelObjectContainer> = _codec.deserializeModel(_storage.loadSerializedModel());
			var modelState: Vector.<ModelObject> = unpackState(modelPackage);
			return modelState;
		}
		
		private function packState(modelState: Vector.<ModelObject>): Vector.<ModelObjectContainer>
		{
			var modelContainer: Vector.<ModelObjectContainer> = new Vector.<ModelObjectContainer>();
			for each (var stateObject: ModelObject in modelState)
			{
				modelContainer.push(new ModelObjectContainer(stateObject));
			}
			return modelContainer;
		}
		
		private function unpackState(modelPackage: Vector.<ModelObjectContainer>): Vector.<ModelObject>
		{
			var modelState: Vector.<ModelObject> = new Vector.<ModelObject>();
			for each (var objectContainer: ModelObjectContainer in modelPackage)
			{
				modelState.push(objectContainer.modelObject);
			}
			return modelState;
		}
	}
}