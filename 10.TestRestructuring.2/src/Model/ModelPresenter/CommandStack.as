package Model.ModelPresenter 
{
	import flash.events.EventDispatcher;
	import Model.ModelPresenter.Command.IUndoableCommand;
	
	public class CommandStack extends EventDispatcher
	{
		private var _commands: Array = new Array();
		private var _curCommand: int = -1; //point to the last added (executed) command
		
		public function CommandStack() 
		{
			super();
		}
		
		public function get count(): uint
		{
			return _curCommand + 1;
		}
		
		public function addCommand(command: IUndoableCommand): void
		{
			trimEndCommands();
			_commands.push(command);
			_curCommand = _commands.length - 1;

			dispatchEvent(new CommandStackEvent(CommandStackEvent.STACK_CHANGED));
		}
		
		public function getPrevCommand(): IUndoableCommand
		{
			var result: IUndoableCommand = null;
			if (_curCommand >= 0)
			{
				result = _commands[_curCommand--];
			}

			dispatchEvent(new CommandStackEvent(CommandStackEvent.STACK_CHANGED));
			
			return result;
		}
		
		public function getNextCommand(): IUndoableCommand
		{
			var result: IUndoableCommand = null;
			if (_curCommand < _commands.length - 1)
			{
				result = _commands[++_curCommand];
			}

			dispatchEvent(new CommandStackEvent(CommandStackEvent.STACK_CHANGED));
			
			return result;
		}
		
		public function hasNextCommand(): Boolean
		{
			return ((_curCommand + 1) < _commands.length);
		}
		
		public function hasPrevCommand(): Boolean
		{
			return (_curCommand >= 0)
		}
		
		private function trimEndCommands(): void
		{
			_commands.splice(_curCommand + 1);
		}
	}
}