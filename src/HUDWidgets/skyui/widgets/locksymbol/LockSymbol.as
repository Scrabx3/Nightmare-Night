import skyui.widgets.WidgetBase;

class skyui.widgets.LockSymbol.LockSymbol extends WidgetBase{
	/* INITIALIZATION */
	public function LockSymbol()
	{
		super();
		
		_visible = false;
		countText.text = "0";
	}


  /* PUBLIC FUNCTIONS */
  
	// @overrides WidgetBase
	public function getWidth(): Number
	{
		return _width;
	}

	// @overrides WidgetBase
	public function getHeight(): Number
	{
		return _height;
	}

	// @Papyrus
	public function setVisible(a_visible: Boolean): Void
	{
		_visible = a_visible;
	}
	
	
}