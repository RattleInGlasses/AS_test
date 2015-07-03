package View 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import View.Event.*;
	import View.Graphic.Button.*;
	import View.Graphic.ViewObject.*;
	import View.Object.*;
	import Type.ObjectForm;

	public class View extends Sprite
	{
		private var _modelScene: Rectangle = new Rectangle();
		private var _workAreaBounds: Rectangle = new Rectangle();
		private var _workArea: Sprite = new Sprite();
		
		private var _btnAddTriangle: Button;
		private var _btnAddEllipse: Button;
		private var _btnAddRectangle: Button;
		private var _btnDel: Button;
		private var _btnUndo: Button;
		private var _btnRedo: Button;
		
		private var _controller: ViewController;
		private var _selectionFrame: SelectionFrame;
		
		public function View() 
		{	
			addButtons();
			addViewEventListeners();
		}
		
		// functions for controlling view
		
		public function set selectedObjectIndex(value: uint): void
		{
			if (value != uint.MAX_VALUE)
			{
				_controller.selectedObject = _workArea.getChildAt(value) as ViewObject;
			}
			else
			{
				_controller.selectedObject = null;
			}
		}
		
		public function get selectedObjectIndex(): uint
		{
			if (_controller.selectedObject)
			{
				return _workArea.getChildIndex(_controller.selectedObject);
			}
			else
			{
				return uint.MAX_VALUE
			}
		}
		
		public function createGuiObject(objIndex: uint, objType: ObjectForm, objColor: uint, objRect: Rectangle): ViewObject
		{
			var image: Sprite;
			switch (objType)
			{				
				case ObjectForm.TRIANGLE:
					image = new TriangleGraphic(objColor);
				break;
				case ObjectForm.RECTANGLE:
					image = new RectangleGraphic(objColor);
				break;
				case ObjectForm.ELLIPSE:
					image = new EllipseGraphic(objColor);
				break;
			}
			var workArea: Rectangle = new Rectangle(0, 0, _workAreaBounds.width, _workAreaBounds.height);
			var newObj: ViewObject = new ViewObject(image, objRect, workArea, _modelScene);
			_workArea.addChildAt(newObj, objIndex);
			
			newObj.addEventListener(MouseEvent.MOUSE_DOWN, function (e: MouseEvent): void {
				_controller.selectedObject = newObj;
			},
			false, 0, true);
			
			return newObj;
		}
		
		public function deleteGuiObject(objIndex: uint): void
		{
			var objToDel: ViewObject = _workArea.getChildAt(objIndex) as ViewObject;
			_workArea.removeChild(objToDel);
			selectedObjectIndex = uint.MAX_VALUE;
		}
		
		public function changeGuiObjectRect(guiObject: ViewObject, modelObjRect: Rectangle): void
		{
			// after recreating an object, listeners of controller for old view object are still exist
			if (_workArea.contains(guiObject))
			{
				guiObject.setRectByModelData(modelObjRect);
				_controller.selectedObject = guiObject;
			}
		}

		public function setUndoRedoState(undoState: Boolean, redoState: Boolean): void
		{
			_btnRedo.mouseEnabled = redoState;
			_btnUndo.mouseEnabled = undoState;
		}
		
		public function setModelStageSize(mdlWidth: Number, mdlHeight: Number): void
		{
			_modelScene.height = mdlHeight;
			_modelScene.width = mdlWidth;
			
			setViewBounds();
			drawStageBounds();
			addSelectionFrame();
			addSelectionFrameEventListeners();
			addController();
		}
		
		// init section
		
		private function addButtons(): void
		{
			var btnAddTriangleSprite: Sprite = new addTriangleButtonGraphic(); 
			var btnAddEllipseSprite: Sprite = new addElipseButtonGraphic();
			var btnAddRectangleSprite: Sprite = new addRectangleButtonGraphic();
			var btnDelNormalSprite: Sprite = new BasketGraphic();
			var btnDelDisabledSprite: Sprite = new BasketDisabledGraphic();
			var btnUndoNormalSprite: Sprite = new UndoGraphic();
			var btnUndoDisabledSprite: Sprite = new UndoDisabledGraphic();
			var btnRedoNormalSprite: Sprite = new RedoGraphic();
			var btnRedoDisabledSprite: Sprite = new RedoDisabledGraphic();
			
			_btnAddTriangle = new Button(btnAddTriangleSprite, btnAddTriangleSprite, Const.GUI_BUTTON_ADD_TRIANGLE_X, Const.GUI_BUTTON_ADD_TRIANGLE_Y, Const.GUI_BUTTON_ADD_TRIANGLE_WIDTH, Const.GUI_BUTTON_ADD_TRIANGLE_HEIGHT);
			_btnAddEllipse = new Button(btnAddEllipseSprite, btnAddEllipseSprite, Const.GUI_BUTTON_ADD_ELLIPSE_X, Const.GUI_BUTTON_ADD_ELLIPSE_Y, Const.GUI_BUTTON_ADD_ELLIPSE_WIDTH, Const.GUI_BUTTON_ADD_ELLIPSE_HEIGHT);
			_btnAddRectangle = new Button(btnAddRectangleSprite, btnAddRectangleSprite, Const.GUI_BUTTON_ADD_RECTANGLE_X, Const.GUI_BUTTON_ADD_RECTANGLE_Y, Const.GUI_BUTTON_ADD_RECTANGLE_WIDTH, Const.GUI_BUTTON_ADD_RECTANGLE_HEIGHT);
			_btnDel = new Button(btnDelNormalSprite, btnDelDisabledSprite, Const.GUI_BUTTON_DELETE_X, Const.GUI_BUTTON_DELETE_Y, Const.GUI_BUTTON_DELETE_WIDTH, Const.GUI_BUTTON_DELETE_HEIGHT);
			_btnUndo = new Button(btnUndoNormalSprite, btnUndoDisabledSprite, Const.GUI_BUTTON_UNDO_X, Const.GUI_BUTTON_UNDO_Y, Const.GUI_BUTTON_UNDO_WIDTH, Const.GUI_BUTTON_UNDO_HEIGHT);
			_btnRedo = new Button(btnRedoNormalSprite, btnRedoDisabledSprite, Const.GUI_BUTTON_REDO_X, Const.GUI_BUTTON_REDO_Y , Const.GUI_BUTTON_REDO_WIDTH, Const.GUI_BUTTON_REDO_HEIGHT);
			
			_btnDel.mouseEnabled = false;
			_btnUndo.mouseEnabled = false;
			_btnRedo.mouseEnabled = false;
			
			addChild(_btnAddTriangle);
			addChild(_btnAddEllipse);
			addChild(_btnAddRectangle);
			addChild(_btnDel);
			addChild(_btnUndo);
			addChild(_btnRedo);
		}
		
		private function addViewEventListeners(): void
		{
			_btnAddTriangle.addEventListener(MouseEvent.CLICK, createTriangleRequest);
			_btnAddEllipse.addEventListener(MouseEvent.CLICK, createEllipseRequest);
			_btnAddRectangle.addEventListener(MouseEvent.CLICK, createRectangleRequest);
			_btnUndo.addEventListener(MouseEvent.CLICK, undoRequest);
			_btnRedo.addEventListener(MouseEvent.CLICK, redoRequest);
			_btnDel.addEventListener(MouseEvent.CLICK, deleteObjectRequest);
			
			addEventListener(Event.DEACTIVATE, saveModelStateRequest);
			
			if (stage)
			{
				stage.addEventListener(MouseEvent.MOUSE_DOWN, setNullSelection);
			}
			else
			{
				addEventListener(Event.ADDED, addStageListener);
			}
		}	
		
		private function addStageListener(e: Event): void
		{
			removeEventListener(Event.ADDED, addStageListener);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, setNullSelection);
		}
		
		private function addSelectionFrame(): void
		{
			var selectionFrameLayer: Sprite = createSelectionFrameLayer();
			_selectionFrame = new SelectionFrame(new Rectangle(0, 0, _workAreaBounds.width, _workAreaBounds.height));
			
			selectionFrameLayer.addChild(_selectionFrame);
			addChild(selectionFrameLayer);
		}
		
		private function createSelectionFrameLayer(): Sprite
		{
			var selectionFrameLayer: Sprite = new Sprite();
			selectionFrameLayer.graphics.lineStyle(2, 0xFF0000, 0);
			selectionFrameLayer.graphics.moveTo(0, 0);
			selectionFrameLayer.graphics.lineTo(0, _workAreaBounds.height);
			selectionFrameLayer.graphics.lineTo(_workAreaBounds.width, _workAreaBounds.height);
			selectionFrameLayer.graphics.lineTo(_workAreaBounds.width, 0);
			selectionFrameLayer.graphics.lineTo(0, 0);
			
			selectionFrameLayer.x = _workArea.x;
			selectionFrameLayer.y = _workArea.y;
			
			return selectionFrameLayer;
		}
		
		private function addSelectionFrameEventListeners(): void
		{
			_selectionFrame.addEventListener(SelectionFrameEvent.BOUND, activateBtnDel);
			_selectionFrame.addEventListener(SelectionFrameEvent.UNBOUND, deactivateBtnDel);
		}
		
		private function addController(): void
		{
			_controller = new ViewController(_selectionFrame);
			_controller.addEventListener(ViewControllerEvent.SELECTION_CHANGED, changeSelectionRequest);
		}
		
		// listener-functions for User Events
		
		private function changeSelectionRequest(e: ViewControllerEvent): void
		{
			dispatchEvent(new ViewEvent(ViewEvent.CHANGE_FOCUS_REQUEST));
		}
		
		private function createTriangleRequest(e: MouseEvent): void
		{
			dispatchEvent(new ViewEvent(ViewEvent.CREATE_OBJECT_REQUEST, 0, ObjectForm.TRIANGLE));
		}
		
		private function createEllipseRequest(e: MouseEvent): void
		{
			dispatchEvent(new ViewEvent(ViewEvent.CREATE_OBJECT_REQUEST, 0, ObjectForm.ELLIPSE));
		}
		
		private function createRectangleRequest(e: MouseEvent): void
		{
			dispatchEvent(new ViewEvent(ViewEvent.CREATE_OBJECT_REQUEST, 0, ObjectForm.RECTANGLE));
		}
		
		private function deleteObjectRequest(e: MouseEvent): void
		{
			dispatchEvent(new ViewEvent(ViewEvent.DELETE_OBJECT_REQUEST, _workArea.getChildIndex(_controller.selectedObject)))
		}
		
		private function undoRequest(e: MouseEvent): void
		{
			var undoRequest: ViewEvent = new ViewEvent(ViewEvent.UNDO_REQUEST);
			dispatchEvent(undoRequest);
		}
		
		private function redoRequest(e: MouseEvent): void
		{
			var redoRequest: ViewEvent = new ViewEvent(ViewEvent.REDO_REQUEST);
			dispatchEvent(redoRequest);
		}
		
		private function saveModelStateRequest(e: Event): void
		{
			var saveModelRequest: ViewEvent = new ViewEvent(ViewEvent.SAVE_MODEL_STATE_REQUEST);
			dispatchEvent(saveModelRequest);
		}
		
		private function setNullSelection(e: MouseEvent): void
		{
			if ((e.target == _workArea) || (e.target == stage))
			{
				selectedObjectIndex = uint.MAX_VALUE;
			}
		}
		
		// listener-functions for Object Events
		
		private function activateBtnDel(e: SelectionFrameEvent): void
		{
			_btnDel.mouseEnabled = true;
		}
		
		private function deactivateBtnDel(e: SelectionFrameEvent): void
		{
			_btnDel.mouseEnabled = false;
		}
		
		// functions for managing relations between model and view stages
		
		private function setViewBounds(): void
		{
			var stageAspectRatio: Number = Const.GUI_WORK_AREA_WIDTH / Const.GUI_WORK_AREA_HEIGHT;
			var modelAspectRatio: Number = _modelScene.width / _modelScene.height;
			if (stageAspectRatio < modelAspectRatio)
			{
				_workAreaBounds.width = Const.GUI_WORK_AREA_WIDTH;
				_workAreaBounds.height = Const.GUI_WORK_AREA_WIDTH / modelAspectRatio;
			}
			else
			{
				_workAreaBounds.height = Const.GUI_WORK_AREA_HEIGHT;
				_workAreaBounds.width = Const.GUI_WORK_AREA_HEIGHT * modelAspectRatio;
			}
			_workAreaBounds.x = (Const.GUI_WORK_AREA_WIDTH - _workAreaBounds.width) / 2;
			_workAreaBounds.y = Const.GUI_MENU_HEIGHT + ((Const.GUI_WORK_AREA_HEIGHT - _workAreaBounds.height) / 2);
		}
		
		private function drawStageBounds(): void
		{
			_workArea.graphics.beginFill(0xFFFFFF);
			_workArea.graphics.lineStyle(1, 0x000000);
			_workArea.graphics.drawRect(0, 0, _workAreaBounds.width, _workAreaBounds.height);
			_workArea.graphics.endFill();
			_workArea.x = _workAreaBounds.x;
			_workArea.y = _workAreaBounds.y;
			addChildAt(_workArea, 0);
		}
	}
}