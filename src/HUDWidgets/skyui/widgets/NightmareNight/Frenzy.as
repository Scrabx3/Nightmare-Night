import skyui.widgets.WidgetBase;
import skyui.components.Meter;
import skse;

class skyui.widgets.NightmareNight.Frenzy extends WidgetBase {
	// Stage
	private var meter:Meter;
	private var level:MovieClip;
	private var lvMeter:MovieClip;

	// variables
	private var __width:Number = 292.75;
	private var __height:Number = 25.25;

	private var _durTotal:Number;
	private var _durRemain:Number;
	private var _interval:Number = 50.0;

	private var transitionID:Number;
	private var desiredFrame:Number;

	private var _loopID:Number;
	private var _playfrenzy:Boolean;

	// constructor
	public function Frenzy() {
		super();

		lvMeter = level.meter;
		lvMeter.gotoAndStop(200);
		_playfrenzy = true;
		this._visible = false;

		// _loopID = setInterval(this, "test", 50);
	}

	private function test():Void {
		clearInterval(_loopID);
		setup();
		progressfrenzy(3,10);
	}

	// main loop
	private function ticking():Void {
		if (_durRemain == 0) {
			kill();
			return;
		} else if (_playfrenzy) {
			_durRemain -= _interval;
			meter.setPercent(_durRemain / _durTotal);
		}
	}

	private function kill():Void {
		clearInterval(_loopID);
		skse.SendModEvent("NightmareNightFrenzyEnd","",0,0);
		lvMeter.gotoAndStop(200);
		meter.startFlash(true);
		_loopID = setInterval(this, "fadeout", 100);
	}

	private function fadeout():Void {
		if (this._alpha < 1) {
			clearInterval(_loopID);
			this._visible = false;
			return;
		}
		this._alpha *= 0.65;
	}

	private function transitionlevel():Void {
		var forward:Boolean = lvMeter._currentframe < desiredFrame;
		if (desiredFrame == 0) {
			// can only go back to frame 1
			desiredFrame++;
		}
		transitionID = setInterval(this, "transitionlevelticks", 25);
	}
	private function transitionlevelticks():Void {
		if (lvMeter._currentframe == desiredFrame) {
			clearInterval(transitionID);
			return;
		}
		// this is only used to progress frenzy (filling the bar plays backwards)
		// resetting it back to Lv0 (<=> Frame 200) happens through gotoAndStop()
		lvMeter.prevFrame();
	}

	// papyrus
	public function startFlash(a_force:Boolean):Void {
		meter.startFlash(a_force);
	}

	public function setup():Void {
		meter.setColors(0x654E9C,0x3a109c,0xEE0000);
		// meter.setColors(0x770066,0x990066,0xEE0000);
		// meter.color = 0x990066;
		// meter.flashColor = 0xEE0000;
		meter.setFillDirection(Meter.FILL_DIRECTION_RIGHT,true);
		meter.setPercent(1,true);
	}

	public function progressfrenzy(duration:Number, lv:Number):Void {
		if (duration == 0) {
			clearInterval(_loopID);
			kill();
			return;
		}
		// assume duration in seconds 
		duration *= 1000;
		this._durTotal = duration;
		this._durRemain = duration;
		// NOTE: lvMeter has 200 Frames, Frame 1 = 100%, Frame 200 = 0%
		// every 20 frames = 10%
		desiredFrame = 200 - 20 * lv;
		transitionlevel();
		// this should be a new frenzy session if called while not visible
		// if already visible, make sure to cancel out the _interval in case were currently in the killing loop
		if (this._visible == false) {
			this._visible = true;
		} else {
			clearInterval(_loopID);
		}
		this._alpha = 100;
		meter.setPercent(1,true);
		_loopID = setInterval(this, "ticking", _interval);
	}

	public function pausefrenzy(pause:Boolean):Void {
		_playfrenzy = !pause;
	}

	public function endfrenzy():Void {
		meter.setPercent(0, true);
		kill();
	}

	// private misc
	// @Overrides WidgetBase
	private function getWidth():Number {
		return __width;
	}
	// @Overrides WidgetBase
	private function getHeight():Number {
		return __height;
	}
}