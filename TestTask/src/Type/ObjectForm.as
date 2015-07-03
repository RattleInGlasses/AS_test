package Type 
{
	public class ObjectForm 
	{
		public static const RECTANGLE: ObjectForm = new ObjectForm();
		public static const ELLIPSE: ObjectForm   = new ObjectForm();
		public static const TRIANGLE: ObjectForm  = new ObjectForm();
		
		private static var _enumCreated: Boolean = false;
		{
			_enumCreated = true;
		}
		
		public function ObjectForm()
		{
			if (_enumCreated)
			{
				throw new Error("The enum is already created.");
			}
		}
	}
}