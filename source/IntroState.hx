package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.system.FlxSound;

class IntroState extends FlxState {
    var introNarration:FlxSound;
    var totalTimeElapsed:Float;

    override public function create():Void {
        FlxG.mouse.visible = false;
        introNarration = FlxG.sound.load(AssetPaths.intro_narration__wav);
        introNarration.play();
        totalTimeElapsed = 0;
        // trace("length: " + introNarration.length);
    }

    override public function update(elapsed:Float):Void {
        totalTimeElapsed += elapsed;
        // trace(totalTimeElapsed);
        if (totalTimeElapsed*1000 > introNarration.length || FlxG.keys.pressed.SPACE) {
            introNarration.stop();
            FlxG.switchState(new PlayState());
        }
    }
}