package;

import flixel.FlxG;

class Alarm extends SoundObject {
    public var pitch:Int;
    private var LEFT_SOUNDS = [AssetPaths.a_left__wav, AssetPaths.b_left__wav, AssetPaths.c_left__wav];
    private var RIGHT_SOUNDS = [AssetPaths.a_right__wav, AssetPaths.b_right__wav, AssetPaths.c_right__wav];

    public function new(?X:Float=0, ?Y:Float=0, playState:PlayState, ?pitch:Int=0) {
        super(X, Y, playState);
        this.pitch = pitch;

        _leftSound = FlxG.sound.load(LEFT_SOUNDS[pitch], 1, true);
        _rightSound = FlxG.sound.load(RIGHT_SOUNDS[pitch], 1, true);
        _leftSound.play();
        _rightSound.play();
    }
}