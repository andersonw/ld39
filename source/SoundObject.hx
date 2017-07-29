package;

import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxSound;

class SoundObject {
    private var _playState:PlayState;
    private var LEFT_SOUNDS = [AssetPaths.a_left__wav, AssetPaths.b_left__wav, AssetPaths.c_left__wav];
    private var RIGHT_SOUNDS = [AssetPaths.a_right__wav, AssetPaths.b_right__wav, AssetPaths.c_right__wav];

    private var pitch:Int;
    private var _leftSound:FlxSound;
    private var _rightSound:FlxSound;

    public var x:Float;
    public var y:Float;
    public var off:Bool;

    public function new(x:Float, y:Float, playState:PlayState, ?pitch:Int = 0) {
        this.x = x;
        this.y = y;
        _playState = playState;
        this.pitch = pitch;

        var debugPixel:FlxSprite = new FlxSprite(x, y);
        debugPixel.makeGraphic(2, 2, FlxColor.RED);
        _playState.add(debugPixel);
        debugPixel.visible = false;

        _leftSound = FlxG.sound.load(LEFT_SOUNDS[pitch], 1, true);
        _rightSound = FlxG.sound.load(RIGHT_SOUNDS[pitch], 1, true);
        _leftSound.play();
        _rightSound.play();
    }

    public function updateAndCheckVolume():Bool {
        if (off) {
            _leftSound.volume = 0;
            _rightSound.volume = 0;
            return false;
        } else {
            var player:Player = _playState.player;
            var leftEarDistance:Float = player.getLeftEar().distanceTo(new FlxPoint(this.x, this.y));
            var rightEarDistance:Float = player.getRightEar().distanceTo(new FlxPoint(this.x, this.y));
            var leftVolume:Float = Math.min(1, 1200/Math.pow(leftEarDistance,1.5));
            var rightVolume:Float = Math.min(1, 1200/Math.pow(rightEarDistance,1.5));
            // trace(pitch + " " + leftEarDistance + " " + rightEarDistance);
            // trace(pitch + " " + leftVolume + " " + rightVolume);
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