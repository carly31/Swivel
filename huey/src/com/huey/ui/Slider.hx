package com.huey.ui;

/**
 * ...
 * @author Newgrounds.com, Inc.
 */

class Slider extends Container {
	@bindable public var value(default, setValue) : Float;
	private function setValue(v : Float) : Float {
		if (step != 0) v = Math.round(v / step) * step;
		if (v < minimum) v = minimum;
		if (v > maximum) v = maximum;
		value = v;
		label.text = if(labelFunc != null) labelFunc(value) else Std.string(value);
		updateNub();
		return value;
	}
	
	public var minimum(default, setMinimum) : Float;
	private inline function setMinimum(v : Float) : Float {
		minimum = v;
		setValue( value );
		return minimum;
	}
	
	public var maximum(default, setMaximum) : Float;
	private inline function setMaximum(v : Float) : Float {
		maximum = v;
		setValue( value );
		return maximum;
	}
	
	public var step(default, setStep) : Float;
	private inline function setStep(v : Float) : Float {
		if (v < 0 || Math.isNaN(v)) v = 0;
		step = v;
		setValue( value );
		return step;
	}
	
	@forward(label) public var font : String;
	@forward(label) public var size : Float;
	@forward(label) public var color : Int;
	@forward(label) public var bold : Bool;
	
	public var nubMinimum : Float = 5.0;
	public var nubMaximum : Float = 200.0;
	
	public var nub : Component;
	
	public var label : Label;
	
	public var labelFunc(default, setLabelFunc) : Float -> String;
	private function setLabelFunc(v) {
		labelFunc = v;
		label.text = if (labelFunc != null) labelFunc(value) else Std.string(value);
		return labelFunc;
	}
	
	public function new() {
		super();
		label = new Label();
		add(label);
		
		value = minimum = 0.0;
		maximum = 1.0;
		step = 0;
		
		onMouseDown.add(mouseDownHandler);
		onMouseUp.add(mouseUpHandler);
		
		untyped _implComponent.buttonMode = true;
	}
	
	private function updateNub() : Void {
		if(nub != null) nub.x = (nubMaximum - nubMinimum) * (value - minimum) / (maximum - minimum) + nubMinimum - nub.width / 2;
	}
	
	private function mouseDownHandler(_) : Void {
		flash.Lib.current.stage.addEventListener(flash.events.MouseEvent.MOUSE_MOVE, mouseMoveHandler, false, 0, true);
		mouseMoveHandler(null);
	}
	
	private function mouseUpHandler(_) : Void {
		flash.Lib.current.stage.removeEventListener(flash.events.MouseEvent.MOUSE_MOVE, mouseMoveHandler, false);
	}
	
	private function mouseMoveHandler(e) : Void {
		value = untyped { minimum + (maximum - minimum) * (_implComponent.mouseX - nubMinimum) / (nubMaximum-nubMinimum); };
		if(e != null) e.updateAfterEvent();
	}
}