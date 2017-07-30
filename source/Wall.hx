package;

import flixel.FlxSprite;
import flixel.util.FlxColor;

class Wall extends FlxSprite {
    public function new(?X:Float=0, ?Y:Float=0, ?width:Int=32, ?height:Int=32) {
        super(X, Y);
        makeGraphic(width, height, new FlxColor(0xffa0a0a0));
        immovable = true;
    }

    public function overlapsSprite(sprite:FlxSprite):Bool {
        if(sprite.x+sprite.width < x)
            return false;
        if(sprite.x > x+width)
            return false;
        if(sprite.y+sprite.height < y)
            return false;
        if(sprite.y > y+height)
            return false;
        return true;
    }
}