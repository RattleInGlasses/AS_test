package Model.ModelPresenter.Command 
{
	import Model.ModelObject;
	import Model.ModelPresenter.Selection;

	public class SetFocusCommand implements IUndoableCommand
	{
		private var _selection: Selection;
		private var _selectedObjectIndex: uint;
		private var _deselectedObjectIndex: uint;
		
		public function SetFocusCommand(s: Selection, selectedObjectIndex: uint) 
		{
			_selection = s;
			_selectedObjectIndex = selectedObjectIndex;
		}
		
		/*public function execute(): void
		{
			_deselectedObjectIndex = _selection.selectedObject;
			_selection.selectedObject = _selectedObjectIndex;
		}
		
		public function undo(): void
		{
			_selection.selectedObject = _deselectedObjectIndex;
		}*/
	}
}