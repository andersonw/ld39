package;

import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxSound;

class SoundObject extends FlxSprite {
    private var _playState:PlayState;

    private var _leftSound:FlxSound;
    private var _rightSound:FlxSound;

    public var off:Bool;

    public function new(x:Float, y:Float, playState:PlayState) {
        super(x, y);
        _playState = playState;

        makeGraphic(2, 2, FlxColor.RED);
        // visible = false;
    }

    public function updateAndCheckVolume():Bool {
        if (off) {
            _leftSound.volume = 0;
            _rightSound.volume = 0;
            trace("setting volume to 0");
            return false;
        } else {
            var player:Player = _playState.player;
            var leftEarDistance:Float = player.getLeftEar().distanceTo(new FlxPoint(this.x, this.y));
            var rightEarDistance:Float = player.getRightEar().distanceTo(new FlxPoint(this.x, this.y));
            var leftVolume:Float = Math.min(1, 1200/Math.pow(leftEarDistance,1.5));
            var rightVolume:Float = Math.min(1, 1200/Math.pow(rightEarDistance,1.5));
            // trace(leftEarDistance + " " + rightEarDistance);
            // trace(leftVolume + " " + rightVolume);
            _leftSound.volume = leftVolume;
            _rightSound.volume = rightVolume;
        
            if (leftVolume==1 && rightVolume==1) {
                return true;
            } else {
                return false;
            }
        }
    }

    public function silence():Void {
        _leftSound.stop();
        _rightSound.stop();
    }
}