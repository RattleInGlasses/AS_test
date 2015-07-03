package Model.ModelPresenter 
{
	
	public interface ISelectionController 
	{
		function set selectedObjectIndex(value: uint): void;
		function get selectedObjectIndex(): uint;
	}
}