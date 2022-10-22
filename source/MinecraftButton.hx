package;

import flixel.FlxObject;
import animateatlas.AtlasFrameMaker;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.effects.FlxTrail;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.tweens.FlxTween;
import flixel.util.FlxSort;
import Section.SwagSection;
import MinecraftText;
#if MODS_ALLOWED
import sys.io.File;
import sys.FileSystem;
#end
import openfl.utils.AssetType;
import openfl.utils.Assets;
import haxe.Json;
import haxe.format.JsonParser;

using StringTools;

class MinecraftButton extends FlxSprite
{
	public var type:String;
	public var name:String;
	var image:String;

	public function new(x:Float, y:Float, ?type:String = 'custom', ?name:String = 'button')
	{
		super(x, y);
		
		this.type = type;
		this.name = name;

		switch (type){
			case 'small':
				image = 'MCbuttons/button_small';
			case 'medium' | 'slideBG':
				image = 'MCbuttons/button_medium';
			case 'large':
				image = 'MCbuttons/button_large';
			case 'slide':
				image = 'MCbuttons/slide';
			case 'custom':
				image = 'MCbuttons/button_' + name.toLowerCase();
		}

		loadGraphic(Paths.image(image));
		height = height / 3;
		antialiasing = false;
		loadGraphic(Paths.image(image), true, Math.floor(width), Math.floor(height));

		setGraphicSize(Std.int(width * 3));
		updateHitbox();
		if (type == 'slideBG')
		{
			animation.add('locked', [0]);
			animation.add('idle', [0]);
			animation.add('selected', [0]);
		}
		else
		{
			animation.add('locked', [0]);
			animation.add('idle', [1]);
			animation.add('selected', [2]);
		}
	}
}
