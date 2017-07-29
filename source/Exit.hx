package;

import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.FlxSprite;

class Exit extends FlxSprite {
    public function new(?X:Float = 0, ?Y:Float = 0) {
        super(X, Y);
        makeGraphic(70, 70, FlxColor.RED);
    }

    public function getCenter():FlxPoint {
        return new FlxPoint(this.x+this.width/2, this.y+this.height/2);
    }
}