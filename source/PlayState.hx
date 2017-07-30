package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;

class PlayState extends FlxState {
	private var _level:Level;
	private var _levelFile:String;

	public var player:Player;
	public var lastPlayerPos:FlxPoint;
	// public var sounds:Array<SoundObject>;
	public var soundsDone:Int;

	public var walkSound:FlxSound;
	public var wallBumpSound:FlxSound;

	public var niceSound:FlxSound;
	public var winSound:FlxSound;
	public var loseSound:FlxSound;
	public var lost:Bool;

	override public function create():Void {
		super.create();

		_levelFile = Registry.levelList[Registry.currLevel];
		_level = new Level(_levelFile, this);

		for(entityGroup in _level.entityGroups)	{
			add(entityGroup);
		}

		player = new Player(_level.spawn.x, _level.spawn.y);
		lastPlayerPos = new FlxPoint(player.x, player.y);
		add(player);
		FlxG.camera.follow(player);
		resetLevelBounds();

		soundsDone = 0;

		walkSound = FlxG.sound.load(AssetPaths.walking__wav);
		wallBumpSound = FlxG.sound.load(AssetPaths.wall_bump__wav);
		niceSound = FlxG.sound.load(AssetPaths.nice__wav);
		winSound = FlxG.sound.load(AssetPaths.you_did_it__wav);
		loseSound = FlxG.sound.load(AssetPaths.you_lose__wav);
		lost = false;
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		if (!lost) {
			handlePlayerMovement();
			FlxG.collide(player, _level.walls, processWallCollision);
			if (!playerTouchingWall()) player.isHuggingWall = false;

			var currPos:FlxPoint = new FlxPoint(player.x, player.y);
			if (!lastPlayerPos.equals(currPos)) {
				walkSound.play();
				lastPlayerPos = currPos;
			}
			for (i in 0..._level.alarms.length) {
				var alarm:Alarm = _level.alarms.members[i];
				if (alarm.off) continue;

				var playerAtAlarm:Bool = alarm.updateAndCheckVolume();
				if (playerAtAlarm) {
					if (soundsDone==alarm.pitch) {
						alarm.off = true;
						alarm.silence();
						soundsDone += 1;
						if (soundsDone==_level.alarms.length) {
							winSound.play();
						} else {
							niceSound.play();
						}
					} else {
						lost = true;
						silenceEverything();
						loseSound.play();
					}
				}
			}
		}
	}

	public function processWallCollision(player:Player, wall:Wall) {
		if (!player.isHuggingWall) {
			wallBumpSound.play();
			player.isHuggingWall = true;
		}
	}

	public function playerTouchingWall():Bool {
		for (wall in _level.walls) {
			if (wall.overlapsSprite(player))
				return true;
		}
		return false;
	}

	public function silenceEverything():Void {
		for (alarm in _level.alarms) {
			alarm.silence();
		}
	}

	public function resetLevelBounds() {
		_level.updateBounds();
		FlxG.worldBounds.set(_level.bounds.x, _level.bounds.y, _level.bounds.width, _level.bounds.height);
	}

	public function handlePlayerMovement():Void {
		// adapted from http://haxeflixel.com/documentation/groundwork/
        var _up:Bool = false;
        var _down:Bool = false;
        var _left:Bool = false;
        var _right:Bool = false;

        _up = FlxG.keys.anyPressed([UP]);
        _down = FlxG.keys.anyPressed([DOWN]);
        _left = FlxG.keys.anyPressed([LEFT]);
        _right = FlxG.keys.anyPressed([RIGHT]);

		var speed:Float;
        if (FlxG.keys.anyPressed([SHIFT]))
            speed = 50;
        else
            speed = 200;

        if (_up && _down)
            _up = _down = false;
        if (_left && _right)
            _left = _right = false;

        if (_up || _down || _left || _right) {
            var mA:Float = 0;
            if(_up){
                mA = -90;
                if (_left){
                    mA -= 45;
                }else if(_right){
                    mA += 45;
                }
            }else if(_down){
                mA = 90;
                if(_left){
                    mA += 45;
                }else if(_right){
                    mA -= 45;
                }
            }else if(_left){
                mA = 180;
            }else if(_right){
                mA = 0;
            }
            player.velocity.set(speed, 0);
            player.velocity.rotate(FlxPoint.weak(0,0), mA);
        }
        else {
            player.velocity.set(0, 0);
        }
    }
	
}
