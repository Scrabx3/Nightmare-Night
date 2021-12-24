import skyui.widgets.WidgetBase;
import skyui.util.Tween;
import mx.utils.Delegate;

class skyui.widgets.locksymbol.locksymbolWidget extends WidgetBase
{

	/* INITIALIZATION */
	var adjustment:Number;

	public function locksymbolWidget()
	{
		super();
		_visible = false;
	}


	/* PUBLIC FUNCTIONS */

	// @overrides WidgetBase
	public function getWidth():Number
	{
		return _width;
	}

	// @overrides WidgetBase
	public function getHeight():Number
	{
		return _height;
	}

	// @Papyrus
	public function setVisible(a_visible:Boolean):Void
	{
		_visible = a_visible;
	}

	public function FlashVisibility(fade_time:Number):Void
	{
		setVisible(true);
		_alpha = 100;
		var onCompleteFlash: Function = Delegate.create(this, function(){if(_alpha == 0){_visible = false;_alpha = 100;}});
		Tween.LinearTween(this,"_alpha",100,0,fade_time,onCompleteFlash);
	}
}