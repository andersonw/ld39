package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.system.FlxSound;

class DoneState extends FlxState {
    var doneNarration:FlxSound;
    var totalTimeElapsed:Float;

    override public function create():Void {
        doneNarration = FlxG.sound.load(AssetPaths.you_beat_the_game__wav);
        doneNarration.play();
        totalTimeElapsed = 0;
    }

    override public function update(elapsed:Float):Void {
        totalTimeElapsed += elapsed;
    }
}