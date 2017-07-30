package;

import flixel.addons.editors.tiled.TiledLayer;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.util.FlxColor;

// adapted from https://github.com/HaxeFlixel/flixel-demos/blob/master/Editors/TiledEditor/source/TiledLevel.hx
class Level extends TiledMap
{
    private var _playState:PlayState;

    public var walls:FlxTypedGroup<Wall>;
    public var alarms:FlxTypedGroup<Alarm>;
    public var saws:FlxTypedGroup<Saw>;

    public var bounds:FlxRect;

    public var entityGroups:Array<FlxTypedGroup<Dynamic>>;

    public var spawn:FlxPoint;

    public function new(levelPath:String, playState:PlayState)
    {
        super(levelPath);
        _playState = playState;

        walls = new FlxTypedGroup<Wall>();
        alarms = new FlxTypedGroup<Alarm>();
        saws = new FlxTypedGroup<Saw>();

        entityGroups = [walls, alarms, saws];

        for (layer in layers)
        {
            if (layer.type != TiledLayerType.OBJECT) continue;

            var objectLayer:TiledObjectLayer = cast layer;
            for (obj in objectLayer.objects)
            {
                // waste of an object, but if we don't put this compiler complains about levelObj.scaleFactor
                switch(objectLayer.name)
                {
                    case "Walls":
                        var levelObj:Wall = new Wall(obj.x, obj.y, obj.width, obj.height);
                        walls.add(levelObj);
                    case "Alarms":
                        var pitch:Int = Std.parseInt(obj.properties.get("pitch"));
                        var levelObj:Alarm = new Alarm(obj.x, obj.y, _playState, pitch);
                        alarms.add(levelObj);
                    case "Saws":
                        var levelObj:Saw = new Saw(obj.x, obj.y, obj.width, obj.height, _playState);
                        saws.add(levelObj);
                    case "Locations":
                        if(obj.name == "start")
                            spawn = new FlxPoint(obj.x, obj.y);
                }
            }
        }

        // set level bounds (used for collision)
        updateBounds();
    }

    public function updateBounds()
    {
        // update bounds
        var minX:Float=0.;
        var maxX:Float=0.;
        var minY:Float=0.;
        var maxY:Float=0.;
        
        for(entityGroup in entityGroups)
        {
            for(obj in entityGroup)
            {
                minX = Math.min(minX, obj.x);
                maxX = Math.max(maxX, obj.x+obj.width);
                minY = Math.min(minY, obj.y);
                maxY = Math.max(maxY, obj.y+obj.height);
            }
        }
        /*
        trace("minX, maxX, minY, maxY");
        trace(minX);
        trace(maxX);
        trace(minY);
        trace(maxY); */

        bounds = new FlxRect(minX-100, minY-100, maxX-minX+200, maxY-minY+200);
    }
}