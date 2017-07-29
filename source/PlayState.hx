package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;

class PlayState extends FlxState
{
	public var player:Player;
	public var sounds:Array<SoundObject>;
	public var soundsDone:Int;

	public var niceSound:FlxSound;
	public var winSound:FlxSound;
	public var loseSound:FlxSound;
	public var lost:Bool;

	override public function create():Void {
		super.create();

		player = new Player(320, 240);
		add(player);
		var sound1:SoundObject = new SoundObject(300, 400, this, 1);
		var sound2:SoundObject = new SoundObject(600, 200, this, 0);
		var sound3:SoundObject = new SoundObject(40, 20, this, 2);
		sounds = new Array<SoundObject>();
		sounds.push(sound2);
		sounds.push(sound1);
		sounds.push(sound3);
		soundsDone = 0;

		niceSound = FlxG.sound.load(AssetPaths.nice__wav);
		winSound = FlxG.sound.load(AssetPaths.you_did_it__wav);
		loseSound = FlxG.sound.load(AssetPaths.you_lose__wav);
		lost = false;
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		if (!lost) {
			handlePlayerMovement();
			for (i in 0...sounds.length) {
				var done:Bool = sounds[i].updateAndCheckVolume();
				if (done) {
					if (soundsDone==i) {
						sounds[i].off = true;
						soundsDone += 1;
						if (soundsDone==sounds.length) {
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

	public function silenceEverything():Void {
		for (sound in sounds) {
			sound.silence();
		}
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
