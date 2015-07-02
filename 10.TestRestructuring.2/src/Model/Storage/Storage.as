package Model.Storage 
{
	import flash.net.SharedObject;
	import flash.utils.ByteArray;

	public class Storage 
	{
		public static const SHARED_OBJECT_NAME: String = "geometric";
		
		public function Storage() 
		{
			
		}
		
		public function SaveSerializedModel(state: ByteArray): void
		{
			try
			{
				var so: SharedObject = SharedObject.getLocal(SHARED_OBJECT_NAME);
				so.data.model = state;
				so.flush();
				so.close();
			} 
			catch (err: Error) 
			{
				if (so)
				{
					so.close();
				}
			}
		}
		
		public function loadSerializedModel(): ByteArray
		{
			try
			{
				var so: SharedObject = SharedObject.getLocal(SHARED_OBJECT_NAME);
				var result: ByteArray = so.data.model;
				so.close()
				return result;
			}
			catch (err: Error)
			{
				so.close();
			}
			return null;
		}
	}
}