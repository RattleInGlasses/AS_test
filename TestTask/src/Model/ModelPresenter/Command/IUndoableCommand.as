package Model.ModelPresenter.Command 
{
	public interface IUndoableCommand 
	{
		function execute(): void
		function undo(): void
	}
}