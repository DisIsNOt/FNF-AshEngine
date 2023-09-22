package shader;

import openfl.filters.ShaderFilter;
 

class ShadersHandler
{
	public static var chromaticAberration:ShaderFilter = new ShaderFilter(new ChromaticAberration());
	public static var bloom:ShaderFilter = new ShaderFilter(new Bloom());
 
 
	public static function setChrome(chromeOffset:Float):Void
	{
		chromaticAberration.shader.data.rOffset.value = [chromeOffset];
		chromaticAberration.shader.data.gOffset.value = [chromeOffset];
		chromaticAberration.shader.data.bOffset.value = [chromeOffset];
	}
 


}