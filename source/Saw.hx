package;

import flixel.FlxG;
import flixel.util.FlxColor;

class Saw extends SoundObject {
    private var LEFT_SOUNDS = [AssetPaths.saw_left__wav, AssetPaths.saw2_left__wav];
    private var RIGHT_SOUNDS = [AssetPaths.saw_right__wav, AssetPaths.saw2_right__wav];
    private var _totalTimeElapsed:Float;

    private var _shape:String;
    private var _originalX:Float;
    private var _originalY:Float;
    private var _pathWidth:Float;
    private var _pathHeight:Float;

    public function new(?X:Float=0, ?Y:Float=0, ?width:Int=32, ?height:Int=32, ?pitch:Int=0, ?shape:String, playState:PlayState) {
        super(X, Y, playState);
        makeGraphic(20, 20, new FlxColor(0xffa0a0a0));
        if (!Registry.debug) visible = false;
        _leftSound = FlxG.sound.load(LEFT_SOUNDS[pitch], 1, true);
        _rightSound = FlxG.sound.load(RIGHT_SOUNDS[pitch], 1, true);
        _leftSound.play();
        _rightSound.play();

        _originalX = X;
        _originalY = Y;
        _pathWidth = width;
        _pathHeight = height;
        _shape = shape;
        _totalTimeElapsed = 0;
    }

    public function updatePosition(elapsed:Float) {
        _totalTimeElapsed += elapsed;
        var SAW_SPEED:Float = 400;
        if (_shape=="horizontal") {
            var distance_traveled:Float = (SAW_SPEED*_totalTimeElapsed) % (2 * _pathWidth);
            if (distance_traveled < _pathWidth) {
                this.x = _originalX + distance_traveled;
            } else {
                this.x = _originalX + 2 * _pathWidth - distance_traveled;
            }
        } else if (_shape=="vertical") {
            var distance_traveled:Float = (SAW_SPEED*_totalTimeElapsed) % (2 * _pathHeight);
            if (distance_traveled < _pathHeight) {
                this.y = _originalY + distance_traveled;
            } else {
                this.y = _originalY + 2 * _pathHeight - distance_traveled;
            }
        }
    }
}