class_name ShaderMaterialFactory

const SPRITE_MATERIAL: ShaderMaterial = preload(FilePaths.SPRITE_SHADER_MATERIAL)

const SHADER_MATERIAL_INDEX: Dictionary = {
	"sprite": SPRITE_MATERIAL,
}

static func create(name: String) -> ShaderMaterial:
	if SHADER_MATERIAL_INDEX.keys().has(name):
		return SHADER_MATERIAL_INDEX[name].duplicate()
	return ShaderMaterial.new()
