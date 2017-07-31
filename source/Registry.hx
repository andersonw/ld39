package;

class Registry
{
    public static var levelList:Array<String> = [AssetPaths.level_1__tmx,
                                                 AssetPaths.level_2__tmx,
                                                 AssetPaths.level_3__tmx,
                                                 AssetPaths.level_5__tmx,
                                                 AssetPaths.level_4__tmx,
                                                 AssetPaths.level_6__tmx];
    public static var narrationList:Array<String> = [AssetPaths.level_1_intro__wav,
                                                     AssetPaths.level_2_intro__wav,
                                                     AssetPaths.level_3_intro__wav,
                                                     AssetPaths.level_5_intro__wav,
                                                     AssetPaths.level_4_intro__wav,
                                                     AssetPaths.level_6_intro__wav];
    public static var currLevel:Int = 0; 
    public static var restartedLevel:Bool = false;
    public static var numSawDeaths:Int = 0;
    public static var debug:Bool = false;
}