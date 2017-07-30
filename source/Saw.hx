package;

import flixel.util.FlxColor;

class Saw extends SoundObject
{
    public function new(?X:Float=0, ?Y:Float=0, ?width:Int=32, ?height:Int=32, playState:PlayState)
    {
        super(X, Y, playState);
        makeGraphic(width, height, new FlxColor(0xffa0a0a0));
        immovable = true;
    }
}