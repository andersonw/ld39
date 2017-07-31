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
	public var lastNumWallsTouched:Int;
	// public var sounds:Array<SoundObject>;
	public var soundsDone:Int;

	public var narrationSound:FlxSound;
	public var walkSound:FlxSound;
	public var wallBumpSound:FlxSound;

	public var niceSound:FlxSound;
	public var winSound:FlxSound;
	public var loseSound:FlxSound; // losing by picking up in the wrong order
	public var buzzSound:FlxSound;
	public var sawDeathSound:FlxSound;
	public var sawWhirSound:FlxSound;
	public var lost:Bool;
	public var waitingToWin:Bool;
	public var winTimer:Float;

	override public function create():Void {
		super.create();
		narrationSound = FlxG.sound.load(Registry.narrationList[Registry.currLevel]);
		if (!Registry.restartedLevel) {
			narrationSound.play();
		}
		_levelFile = Registry.levelList[Registry.currLevel];
		_level = new Level(_levelFile, this);

		for(entityGroup in _level.entityGroups)	{
			add(entityGroup);
		}

		player = new Player(_level.spawn.x, _level.spawn.y);
		lastPlayerPos = new FlxPoint(player.x, player.y);
		lastNumWallsTouched = 0;
		add(player);
		FlxG.camera.follow(player);
		resetLevelBounds();

		soundsDone = 0;

		walkSound = FlxG.sound.load(AssetPaths.walking__wav);
		wallBumpSound = FlxG.sound.load(AssetPaths.wall_bump__wav);
		niceSound = FlxG.sound.load(AssetPaths.nice__wav);
		winSound = FlxG.sound.load(AssetPaths.great_job__wav);
		loseSound = FlxG.sound.load(AssetPaths.wrong_order__wav);
		buzzSound = FlxG.sound.load(AssetPaths.buzz__wav);
		sawDeathSound = FlxG.sound.load(AssetPaths.saw_death__wav);
		sawWhirSound = FlxG.sound.load(AssetPaths.saw_whir__wav, .6);
		lost = false;
		waitingToWin = false;
		winTimer = 0;
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		if (lost) {
			player.velocity.set(0,0);
		}
		if (FlxG.keys.pressed.R && !waitingToWin) {
			Registry.restartedLevel = true;
			FlxG.switchState(new PlayState());
		}
		for (saw in _level.saws) {
			saw.updatePosition(elapsed);
			if (saw.updateAndCheckVolume() && !lost) {
				lost = true;
				if (Registry.numSawDeaths < 2) {
					sawDeathSound.play();
				}
				sawWhirSound.play();
				Registry.numSawDeaths += 1;
			}
		}
		if (waitingToWin) {
			winTimer += elapsed;
			if (winTimer*1000 > winSound.length + 500) {
				Registry.currLevel += 1;
				if (Registry.currLevel != Registry.levelList.length) {
					FlxG.switchState(new PlayState());
				} else {
					FlxG.switchState(new DoneState());
				}
			}
		} else if (!lost) {
			handlePlayerMovement();
			FlxG.collide(player, _level.walls, processWallCollision);
			var currentTouchingWallCount:Int = playerTouchingWallCount();
			if (currentTouchingWallCount > lastNumWallsTouched) {
				wallBumpSound.play();
			}
			lastNumWallsTouched = currentTouchingWallCount;
			// trace(lastNumWallsTouched);

			var currPos:FlxPoint = new FlxPoint(player.x, player.y);
			if (!lastPlayerPos.equals(currPos)) {
				walkSound.play();
				lastPlayerPos = currPos;
			} else {
				walkSound.stop();
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
							narrationSound.stop();
							if (Registry.currLevel < Registry.levelList.length - 1) {
								winSound.play();
							}
							Registry.restartedLevel = false;
							waitingToWin = true;
						} else {
							niceSound.play();
						}
					} else {
						alarm.silence();
						lost = true;
						loseSound.play();
						buzzSound.play();
					}
				}
			}
		}
	}

	public function processWallCollision(player:Player, wall:Wall) {

	}

	public function playerTouchingWallCount():Int {
		var count:Int = 0;
		for (wall in _level.walls) {
			if (wall.overlapsSprite(player))
				count += 1;
		}
		return count;
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

        _up = FlxG.keys.anyPressed([UP, W]);
        _down = FlxG.keys.anyPressed([DOWN, S]);
        _left = FlxG.keys.anyPressed([LEFT, A]);
        _right = FlxG.keys.anyPressed([RIGHT, D]);

		var speed:Float;
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
