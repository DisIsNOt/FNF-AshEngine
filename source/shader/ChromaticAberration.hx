package shader;

import flixel.system.FlxAssets.FlxShader;

class ChromaticAberration extends FlxShader
{
	@:glFragmentSource('
		#pragma header

		uniform float rOffset;
		uniform float gOffset;
		uniform float bOffset;

		void main()
		{
			vec4 col1 = texture2D(bitmap, openfl_TextureCoordv.st - vec2(rOffset * 0.5, 0.0));
			vec4 col2 = texture2D(bitmap, openfl_TextureCoordv.st + vec2(rOffset, 0.0));
			vec4 col3 = texture2D(bitmap, openfl_TextureCoordv.st + vec2(bOffset * 2.5, 0.0));
			vec4 toUse = texture2D(bitmap, openfl_TextureCoordv);
			toUse.r = col1.r;
			toUse.g = col2.g;
			toUse.b = col3.b;
			//float someshit = col4.r + col4.g + col4.b;

			gl_FragColor = toUse;
		}')
	public function new()
	{
		super();

		rOffset.value = [0.0];
		gOffset.value = [0.0];
		bOffset.value = [0.0];
	}
}