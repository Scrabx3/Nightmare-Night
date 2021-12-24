import gfx.core.UIComponent;
import gfx.utils.Constraints;
import gfx.controls.ScrollBar;

import skyui.util.MarkupParser;
import skyui.components.MaskedTextArea;

import TextField.StyleSheet;

class testStage extends UIComponent
{
  /* PRIVATE VARIABLES */
	private var _constraints: Constraints;
	private var _markup: Object;

  /* STAGE ELEMENTS */
	public var titleText: TextField;
	public var maskedTextArea: MaskedTextArea;
	public var scrollBar: ScrollBar;

  /* INITIALIZATION */
	function TextLoader()
	{
		super();
	}

	public function configUI(): Void
	{
		super.configUI();

		MarkupParser.registerParseCallback(this, "onDataParsed");

		_constraints = new Constraints(this, false);
		_constraints.addElement(maskedTextArea, Constraints.ALL);
		_constraints.addElement(scrollBar, Constraints.TOP | Constraints.BOTTOM | Constraints.RIGHT);

		maskedTextArea.scrollBar = scrollBar;
		maskedTextArea.scrollBarAutoHide = false;
		maskedTextArea.styleSheet = MarkupParser.styleSheet;
		testTextField.styleSheet = MarkupParser.styleSheet;
		//imageTest.htmlText = "<img src=\"giphy.gif\"/>"

		maskedTextArea.addEventListener("changeSection", this, "onChangeSection")
	}

  /* PRIVATE FUNCTIONS */
	private function draw(): Void
	{
		load("demoText.txt");
	}

	private function onDataParsed(a_event: Object): Void
	{
		_markup = a_event.markup;
		testTextField.htmlText = _markup["main"].htmlText;
		trace(_markup["main"].htmlText);
	}

	private function onChangeSection(a_event: Object): Void
	{
		var newSection: Object = _markup[a_event.args[0].toLowerCase()];
		if (newSection != undefined)
			maskedTextArea.htmlText = newSection.htmlText;
	}

	/* PUBLIC FUNCTIONS */

	public function load(a_path): Boolean
	{
		return MarkupParser.load(a_path);
	}
}


