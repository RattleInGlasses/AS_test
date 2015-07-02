package Model 
{
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	import flash.net.SharedObject;
	import Model.Storage.*;
	
	public class Model extends EventDispatcher
	{
		public const SCENE_WIDTH: Number = 800;
		public const SCENE_HEIGHT: Number = 500;
		
		private var _objectsList: Vector.<ModelObject>;
		private var _modelSaverLoader: SaverLoader;
		
		public function Model() 
		{
			_objectsList = new Vector.<ModelObject>();
			_modelSaverLoader = new SaverLoader();
		}
		
		public function createAndAddModelObject(rect: Rectangle, objType: uint, color: uint): uint
		{
			return addObjectToModel(new ModelObject(rect, objType, color));
		}
		
		public function addObjectToModel(obj: ModelObject, modelIndex: Number = NaN): uint
		{
			modelIndex = (isNaN(modelIndex)) ? _objectsList.length : modelIndex;
			_objectsList.splice(modelIndex, 0, obj);
			
			var createEvent: ModelEvent = new ModelEvent(ModelEvent.OBJECT_ADDED, obj, modelIndex);
			dispatchEvent(createEvent);
			
			return modelIndex;
		}
			
		public function deleteObject(objIndex: uint): ModelObject
		{
			var objToDelete: ModelObject = _objectsList[objIndex];
			if (objToDelete != null)
			{
				_objectsList.splice(objIndex, 1);
				
				var deleteEvent: ModelEvent = new ModelEvent(ModelEvent.OBJECT_DELETED, null, objIndex);
				dispatchEvent(deleteEvent);
				
				return objToDelete;
			}
			else
			{
				throw new ArgumentError();
			}
		}
		
		public function setObjectRect(changedObj: ModelObject, rect: Rectangle): void
		{
			if (changedObj != null)
			{
				changedObj.rect = rect;
			}
			else
			{
				throw new ArgumentError();
			}
		}
		
		public function saveState(): void
		{			
			_modelSaverLoader.saveState(_objectsList.slice());
		}
		
		public function loadState(): void
		{
			var savedState: Vector.<ModelObject> = _modelSaverLoader.loadState();
			for each (var obj: ModelObject in savedState) 
			{
				createAndAddModelObject(obj.rect, obj.type, obj.color);
			}
		}
	}
}