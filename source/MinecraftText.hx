package;

import flash.display.BitmapData;
import flash.geom.ColorTransform;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.graphics.FlxGraphic;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.atlas.FlxNode;
import flixel.graphics.frames.FlxFramesCollection;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.helpers.FlxRange;
import openfl.Assets;

using StringTools;
using flixel.util.FlxStringUtil;
using flixel.util.FlxUnicodeUtil;

#if flash
import openfl.geom.Rectangle;
#end
#if (openfl >= "8.0.0")
import openfl.utils.AssetType;
#end

class MinecraftText extends FlxText
{
	var swagShader:ColorSwap = null;
	
	var defaultCol:FlxColor = 0xFFFFFFFF;
	var defaultShadowCol:FlxColor = 0xFF3F3F3F;
	var useRVB:Bool = false;
	var formatRules:Array<Array<Dynamic>> = [];
	var defaultFormatRules:Array<Dynamic> = [];

	public function new(x:Float, y:Float, FieldWidth:Float = 0, ?Text:String, Size:Int = 8, alignment:FlxTextAlign = LEFT, ?defaultColor:String = 'white', ?borderStyle:String = '', ?useRVB:Bool = false)
	{
		super(x, y, FieldWidth, Text, Size);

		defaultCol = MinecraftFormat.colors.get(defaultColor.toLowerCase())[0];
		defaultShadowCol = MinecraftFormat.colors.get(defaultColor.toLowerCase())[1];
        antialiasing = false;

		this.useRVB = useRVB;

		if (borderStyle.toLowerCase() == 'shadow'){
			setFormat(Paths.font("vcr.ttf"), Size, defaultCol, alignment, FlxTextBorderStyle.SHADOW, defaultShadowCol);
			borderSize = Math.round(Size/10);
			borderQuality = 0;
		}
		else if (borderStyle.toLowerCase() == 'border'){
			setFormat(Paths.font("vcr.ttf"), Size, defaultCol, alignment, FlxTextBorderStyle.OUTLINE, defaultShadowCol);
		}
		else {
			setFormat(Paths.font("vcr.ttf"), Size, defaultCol, alignment);
		}

		if (this.useRVB){
			defaultCol = color = 0xFFFF0000;
			defaultShadowCol = borderColor = 0xFF2A0000;
			swagShader = new ColorSwap();
			shader = swagShader.shader;
		}

		defaultFormatRules = [
			[0, Text.length, Text, false, false, false, false, false]
			//[start, end, Text, obfuscated, bold, strikethrough, underline, italic]
		];
	}

	override function update(elapsed:Float) {
		if (swagShader != null)
			swagShader.hue += elapsed * 0.6;
		
		super.update(elapsed);
	}

	public function setMinecraftFormat(Text:String)
	{
		//indexOf(Text);
		applyMarkup(Text, MinecraftFormat.formats);
		//textField.replaceText();
	}
	
	/*
	public function setMCText(input:String, rules:Array<FlxTextFormatMarkerPair>):FlxText
	{
		if (rules == null || rules.length == 0)
			return this; // there's no point in running the big loop

		clearFormats(); // start with default formatting

		var rangeStarts:Array<Int> = [];
		var rangeEnds:Array<Int> = [];
		var rulesToApply:Array<FlxTextFormatMarkerPair> = [];

		var i:Int = 0;
		for (marker in MinecraftFormat.markers)
		{
			var start:Bool = false;
			var markerLength:Int = rule.uLength();

			if (!input.contains(marker))
				continue; // marker not present

			// inspect each character
			for (charIndex in 0...input.uLength())
			{
				if (!input.uSub(charIndex, markerLength).uEquals(marker))
					continue; // it's not one of the markers

				if (start)
				{
					start = false;
					rangeEnds.push(charIndex); // end a format block
				}
				else // we're outside of a format block
				{
					start = true; // start a format block
					rangeStarts.push(charIndex);
					rulesToApply.push(rule);
				}
			}

			if (start)
			{
				// we ended with an unclosed block, mark it as infinite
				rangeEnds.push(-1);
			}

			i++;
		}

		// Remove all of the markers in the string
		for (rule in rules)
			input = input.remove(rule.marker);

		// Adjust all the ranges to reflect the removed markers
		for (i in 0...rangeStarts.length)
		{
			// Consider each range start
			var delIndex:Int = rangeStarts[i];
			var markerLength:Int = rulesToApply[i].marker.uLength();

			// Any start or end index that is HIGHER than this must be subtracted by one markerLength
			for (j in 0...rangeStarts.length)
			{
				if (rangeStarts[j] > delIndex)
				{
					rangeStarts[j] -= markerLength;
				}
				if (rangeEnds[j] > delIndex)
				{
					rangeEnds[j] -= markerLength;
				}
			}

			// Consider each range end
			delIndex = rangeEnds[i];

			// Any start or end index that is HIGHER than this must be subtracted by one markerLength
			for (j in 0...rangeStarts.length)
			{
				if (rangeStarts[j] > delIndex)
				{
					rangeStarts[j] -= markerLength;
				}
				if (rangeEnds[j] > delIndex)
				{
					rangeEnds[j] -= markerLength;
				}
			}
		}

		// Apply the new text
		text = input;

		// Apply each format selectively to the given range
		for (i in 0...rangeStarts.length)
			addFormat(rulesToApply[i].format, rangeStarts[i], rangeEnds[i]);

		return this;
	}*/
}

class MinecraftFormat
{
	public static var colors:Map<String, Array<FlxColor>> = [
		'black' => [0xFF000000, 0xFF000000],
		'dark_blue' => [0xFF0000AA, 0xFF00002A],
		'dark_green' => [0xFF00AA00, 0xFF002A00],
		'dark_aqua' => [0xFF00AAAA, 0xFF002A2A],
		'dark_red' => [0xFFAA0000, 0xFF2A0000],
		'dark_purple' => [0xFFAA00AA, 0xFF2A002A],
		'gold' => [0xFFFFAA00, 0xFF402A00],
		'gray' => [0xFFAAAAAA, 0xFF2A2A2A],
		'dark_gray' => [0xFF555555, 0xFF151515],
		'blue' => [0xFF5555FF, 0xFF15153F],
		'green' => [0xFF55FF55, 0xFF153F15],
		'aqua' => [0xFF55FFFF, 0xFF153F3F],
		'red' => [0xFFFF5555, 0xFF3F1515],
		'light_purple' => [0xFFFF55FF, 0xFF3F153F],
		'yellow' => [0xFFFFFF55, 0xFF3F3F15],
		'white' => [0xFFFFFFFF, 0xFF3F3F3F],
		'minecoin_gold' => [0xFFDDD605, 0xFF373501]
	];

	public static var colorsCode:Map<String, Array<FlxColor>> = [
		'§0' => [0xFF000000, 0xFF000000],
		'§1' => [0xFF0000AA, 0xFF00002A],
		'§2' => [0xFF00AA00, 0xFF002A00],
		'§3' => [0xFF00AAAA, 0xFF002A2A],
		'§4' => [0xFFAA0000, 0xFF2A0000],
		'§5' => [0xFFAA00AA, 0xFF2A002A],
		'§6' => [0xFFFFAA00, 0xFF402A00],
		'§7' => [0xFFAAAAAA, 0xFF2A2A2A],
		'§8' => [0xFF555555, 0xFF151515],
		'§9' => [0xFF5555FF, 0xFF15153F],
		'§a' => [0xFF55FF55, 0xFF153F15],
		'§b' => [0xFF55FFFF, 0xFF153F3F],
		'§c' => [0xFFFF5555, 0xFF3F1515],
		'§d' => [0xFFFF55FF, 0xFF3F153F],
		'§e' => [0xFFFFFF55, 0xFF3F3F15],
		'§f' => [0xFFFFFFFF, 0xFF3F3F3F],
		'§g' => [0xFFDDD605, 0xFF373501]
	];

	public static var markers:Array<String> = [
		'§0',
		'§1',
		'§2',
		'§3',
		'§4',
		'§5',
		'§6',
		'§7',
		'§8',
		'§9',
		'§a',
		'§b',
		'§c',
		'§d',
		'§e',
		'§f',
		'§g',
		'§k',
		'§l',
		'§m',
		'§n',
		'§o',
		'§r'
	];

	public static var formats:Array<FlxTextFormatMarkerPair> = [
		new FlxTextFormatMarkerPair(new FlxTextFormat(0xFF000000, null, null, 0xFF000000), '§0'), //black
		new FlxTextFormatMarkerPair(new FlxTextFormat(0xFF0000AA, null, null, 0xFF00002A), '§1'), //dark_blue
		new FlxTextFormatMarkerPair(new FlxTextFormat(0xFF00AA00, null, null, 0xFF002A00), '§2'), //dark_green
		new FlxTextFormatMarkerPair(new FlxTextFormat(0xFF00AAAA, null, null, 0xFF002A2A), '§3'), //dark_aqua
		new FlxTextFormatMarkerPair(new FlxTextFormat(0xFFAA0000, null, null, 0xFF2A0000), '§4'), //dark_red
		new FlxTextFormatMarkerPair(new FlxTextFormat(0xFFAA00AA, null, null, 0xFF2A002A), '§5'), //dark_purple
		new FlxTextFormatMarkerPair(new FlxTextFormat(0xFFFFAA00, null, null, 0xFF402A00), '§6'), //gold
		new FlxTextFormatMarkerPair(new FlxTextFormat(0xFFAAAAAA, null, null, 0xFF2A2A2A), '§7'), //gray
		new FlxTextFormatMarkerPair(new FlxTextFormat(0xFF555555, null, null, 0xFF151515), '§8'), //dark_gray
		new FlxTextFormatMarkerPair(new FlxTextFormat(0xFF5555FF, null, null, 0xFF15153F), '§9'), //blue
		new FlxTextFormatMarkerPair(new FlxTextFormat(0xFF55FF55, null, null, 0xFF153F15), '§a'), //green
		new FlxTextFormatMarkerPair(new FlxTextFormat(0xFF55FFFF, null, null, 0xFF153F3F), '§b'), //aqua
		new FlxTextFormatMarkerPair(new FlxTextFormat(0xFFFF5555, null, null, 0xFF3F1515), '§c'), //red
		new FlxTextFormatMarkerPair(new FlxTextFormat(0xFFFF55FF, null, null, 0xFF3F153F), '§d'), //red
		new FlxTextFormatMarkerPair(new FlxTextFormat(0xFFFFFF55, null, null, 0xFF3F3F15), '§e'), //yellow
		new FlxTextFormatMarkerPair(new FlxTextFormat(0xFFFFFFFF, null, null, 0xFF3F3F3F), '§f'), //white
		new FlxTextFormatMarkerPair(new FlxTextFormat(0xFFDDD605, null, null, 0xFF373501), '§g'), //minecoin_gold

		new FlxTextFormatMarkerPair(new FlxTextFormat(null, null, null, null), '§k'), //obfuscated
		new FlxTextFormatMarkerPair(new FlxTextFormat(null, true, null, null), '§l'), //bold
		new FlxTextFormatMarkerPair(new FlxTextFormat(null, null, null, null), '§m'), //strikethrough
		new FlxTextFormatMarkerPair(new FlxTextFormat(null, null, null, null), '§n'), //underline
		new FlxTextFormatMarkerPair(new FlxTextFormat(null, null, true, null), '§o'), //italic
		new FlxTextFormatMarkerPair(new FlxTextFormat(0xFFFFFFFF, false, false, 0xFF3F3F3F), '§r') //reset
	];
}
