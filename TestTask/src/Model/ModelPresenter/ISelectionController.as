package Model.ModelPresenter 
{
	import Model.ModelObject;
	
	public interface ISelectionController 
	{
		function set selectedObject(value: ModelObject): void;
		function get selectedObject(): ModelObject;
	}
}