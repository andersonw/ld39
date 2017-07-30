package;

import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.FlxSprite;

class Player extends FlxSprite {
    public var isHuggingWall:Bool;

    public function new(?X:Float = 0, ?Y:Float = 0) {
        super(X, Y);
        makeGraphic(50, 50, FlxColor.BLUE);
        // visible = false;

        isHuggingWall = false;
    }

    public function getLeftEar():FlxPoint {
        var x:Float = this.x - 50;
        var y:Float = this.y + this.height/2;
        return new FlxPoint(x, y);
    }

    public function getRightEar():FlxPoint {
        var x:Float = this.x + this.width + 50;
        var y:Float = this.y + this.height/2;
        return new FlxPoint(x, y);
    }
}