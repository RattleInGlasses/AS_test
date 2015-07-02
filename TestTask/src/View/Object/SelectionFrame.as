package View.Object 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import View.Event.SelectionFrameEvent;
	
	public class SelectionFrame extends Sprite
	{
		private const MIN_SIZE: int = 2 * SelectionFrameCorner.CORNER_RADIUS;
		
		private var _topLeftCorner: SelectionFrameCorner = new SelectionFrameCorner();
		private var _topRightCorner: SelectionFrameCorner = new SelectionFrameCorner();
		private var _bottomLeftCorner: SelectionFrameCorner = new SelectionFrameCorner();
		private var _bottomRightCorner: SelectionFrameCorner = new SelectionFrameCorner();
		
		private var _lastCornerPoint: Point;
		private var _pullingPoint: Point;
		private var _pullingCorner: SelectionFrameCorner;
		
		private var _rect: Rectangle = new Rectangle();
		private var _workingArea: Rectangle;
		
		public function SelectionFrame(workingArea: Rectangle) 
		{
			_workingArea = workingArea.clone();
			
			addCorners();
			hide();
			focusRect = false;
			
			addListeners();
		}
		
		public function set rect(value: Rectangle): void
		{
			_rect = value.clone();
			repaint();
		}
		
		public function get rect(): Rectangle
		{
			return _rect.clone();
		}
		
		public function show(): void
		{
			visible = true;
		}
		
		public function hide(): void
		{
			visible = false;
		}
		
		// init methods
		
		private function addCorners(): void
		{
			addCorner(_topLeftCorner);
			addCorner(_topRightCorner);
			addCorner(_bottomLeftCorner);
			addCorner(_bottomRightCorner);
		}
		
		private function addCorner(corner: SelectionFrameCorner): void
		{
			addChild(corner);
		}
		
		private function addListeners(): void
		{
			_topLeftCorner.addEventListener(MouseEvent.MOUSE_DOWN, startResize);
			_topRightCorner.addEventListener(MouseEvent.MOUSE_DOWN, startResize);
			_bottomLeftCorner.addEventListener(MouseEvent.MOUSE_DOWN, startResize);
			_bottomRightCorner.addEventListener(MouseEvent.MOUSE_DOWN, startResize);
		}
		
		// listeners-methods
		
		/*private function startResize(e: MouseEvent): void
		{
			_lastPoint = new Point(stage.mouseX, stage.mouseY);
			var targetCorner: ResizableFrameCorner = e.target as ResizableFrameCorner;
			switch (targetCorner) 
			{
				case _topLeftCorner:
					_topCornerDrag = true;
					_leftCornerDrag = true;
				break;
				case _topRightCorner:
					_topCornerDrag = true;
					_leftCornerDrag = false;
				break;
				case _bottomLeftCorner:
					_topCornerDrag = false;
					_leftCornerDrag = true;
				break;
				case _bottomRightCorner:
					_topCornerDrag = false;
					_leftCornerDrag = false;
				break;
			}
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, resize);
			stage.addEventListener(MouseEvent.MOUSE_UP, endResize);
		}
		
		private function resize(e: MouseEvent): void
		{			
			var curPoint: Point = new Point(stage.mouseX, stage.mouseY);
			var dx: Number;
			var dy: Number;
			if (_leftCornerDrag)
			{
				dx = curPoint.x - _lastPoint.x;
				//dx = (curX < _workingArea.left) ? (_workingArea.left - _lastX) : dx; // check bound
				//dx = ((_rect.width - dx) < MIN_SIZE) ? (_rect.width - MIN_SIZE) : dx; // check min_size
				_rect.width -= dx;				
				_rect.x += dx;
				//_lastPoint.x += dx;
			}
			else // right corner drag
			{
				dx = curPoint.x - _lastPoint.x;
				//dx = (curX > _workingArea.right) ? (_workingArea.right - _lastX - _rect.width) : dx;
				//dx = (_rect.width + dx < MIN_SIZE) ? (MIN_SIZE - _rect.width) : dx;
				_rect.width += dx;
			}
			if (_topCornerDrag)
			{
				dy = curPoint.y - _lastPoint.y;
				//dy = (curY < _workingArea.top) ? (_workingArea.top - _lastY) : dy;
				//dy = (_rect.height - dy < MIN_SIZE) ? (_rect.height - MIN_SIZE) : dy;
				_rect.height -= dy;
				_rect.y += dy;
			}
			else //bottom corner drag
			{
				dy = curPoint.y - _lastPoint.y;
				//dy = (curY > _workingArea.bottom) ? (_workingArea.bottom - _lastY - _rect.height) : dy;
				//dy = (_rect.height + dy < MIN_SIZE) ? (MIN_SIZE - _rect.height) : dy;
				_rect.height += dy;
			}
			repaint();
			_lastPoint = curPoint;
			
			e.updateAfterEvent();	
			dispatchEvent(new NewSelectionFrameEvent(NewSelectionFrameEvent.CHANGE));		
		}*/
		
		private function startResize(e: MouseEvent): void
		{
			_pullingCorner = e.target as SelectionFrameCorner;
			_pullingPoint = new Point(_pullingCorner.mouseX, _pullingCorner.mouseY);
			_lastCornerPoint = new Point(parent.mouseX - _pullingPoint.x, parent.mouseY - _pullingPoint.y);
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, resize);
			stage.addEventListener(MouseEvent.MOUSE_UP, endResize);
		}
		
		private function resize(e: MouseEvent): void
		{		
			switch (_pullingCorner) 
			{
				case _topLeftCorner:
					moveTopSide();
					moveLeftSide();
				break;
				case _topRightCorner:
					moveTopSide();
					moveRightSide();
				break;
				case _bottomLeftCorner:
					moveBottomSide();
					moveLeftSide();
				break;
				case _bottomRightCorner:
					moveBottomSide();
					moveRightSide();
				break;
			}
			repaint();
			
			e.updateAfterEvent();
			dispatchEvent(new SelectionFrameEvent(SelectionFrameEvent.CHANGE));		
		}
		
		private function moveTopSide(): void
		{			
			var curCornerY: Number = parent.mouseY - _pullingPoint.y;
			if (curCornerY < _workingArea.top)
			{
				_rect.height += _rect.y - _workingArea.top;
				_rect.y = _workingArea.top;
			}
			else
			{
				var dy: Number = curCornerY - _lastCornerPoint.y;
				_rect.height -= dy;
				_rect.y += dy;
			}
			
			keepRectMinSizeFromTop();
			_lastCornerPoint.y = _rect.y;
		}
		
		private function moveBottomSide(): void
		{
			var curCornerY: Number = parent.mouseY - _pullingPoint.y;
			if (curCornerY > _workingArea.bottom)
			{
				_rect.height = _workingArea.bottom - rect.y;
			}
			else
			{
				_rect.height += curCornerY - _lastCornerPoint.y;
			}
			
			keepRectMinSizeFromBottom();
			_lastCornerPoint.y = _rect.y + _rect.height;
		}
		
		private function moveLeftSide(): void
		{
			var curCornerX: Number = parent.mouseX - _pullingPoint.x;
			if (curCornerX < _workingArea.left)
			{
				_rect.width += _rect.x - _workingArea.left;
				_rect.x = _workingArea.left;
			}
			else
			{
				var dx: Number = curCornerX - _lastCornerPoint.x;
				_rect.width -= dx;	
				_rect.x += dx;
			}
			
			keepRectMinSizeFromLeft();
			_lastCornerPoint.x = _rect.x;
		}
		
		private function moveRightSide(): void
		{
			var curCornerX: Number = parent.mouseX - _pullingPoint.x;
			if (curCornerX > _workingArea.right)
			{
				_rect.width = _workingArea.right - rect.x;
			}
			else
			{
				_rect.width += curCornerX - _lastCornerPoint.x;
			}
			
			keepRectMinSizeFromRight();
			_lastCornerPoint.x = _rect.x + _rect.width;
		}
		
		private function keepRectMinSizeFromTop(): void
		{
			if (_rect.height < MIN_SIZE)
			{
				var dHeight: Number = MIN_SIZE - _rect.height;
				_rect.height = MIN_SIZE;
				_rect.y -= dHeight;
			}
		}
		
		private function keepRectMinSizeFromBottom(): void
		{
			if (_rect.height < MIN_SIZE)
			{
				_rect.height = MIN_SIZE;
			}
		}
		
		private function keepRectMinSizeFromLeft(): void
		{
			if (_rect.width < MIN_SIZE)
			{
				var dWidth: Number = MIN_SIZE - _rect.width;
				_rect.width = MIN_SIZE;
				_rect.x -= dWidth;
			}
		}
		
		private function keepRectMinSizeFromRight(): void
		{
			if (_rect.width < MIN_SIZE)
			{
				_rect.width = MIN_SIZE;
			}
		}
		
		private function endResize(e: MouseEvent = null): void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, resize);
			stage.removeEventListener(MouseEvent.MOUSE_UP, endResize);
			
			dispatchEvent(new SelectionFrameEvent(SelectionFrameEvent.STOP_CHANGE));
		}
		
		// other
		
		private function repaint(): void
		{
			x = _rect.x;
			y = _rect.y;
			drawLines();
			setCornersPosition();
		}
		
		private function drawLines(): void
		{
			graphics.clear();
			graphics.lineStyle(2, 0x0000FF);
			graphics.moveTo(0, 0);
			graphics.lineTo(0, _rect.height);
			graphics.lineTo(_rect.width, _rect.height);
			graphics.lineTo(_rect.width, 0);
			graphics.lineTo(0, 0);
		}
		
		private function setCornersPosition(): void
		{
			_topLeftCorner.setPosition(0, 0);
			_bottomLeftCorner.setPosition(0, _rect.height);
			_topRightCorner.setPosition(_rect.width, 0);
			_bottomRightCorner.setPosition(_rect.width, _rect.height);
		}
	}
}