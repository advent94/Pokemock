extends Node

## Owner to array of effects
var _active_vfx_index: Dictionary = {}

const VALID_UBER_SHADERS_INDEX: Dictionary = {
	VisualEffect.Type.COLOR_TRANSITION: [ShaderMaterialFactory.SPRITE_MATERIAL.shader],
	VisualEffect.Type.COLOR_CHANGE: [ShaderMaterialFactory.SPRITE_MATERIAL.shader],
	VisualEffect.Type.BLINKING: [ShaderMaterialFactory.SPRITE_MATERIAL.shader],
}

## TODO: One effect for many (array of clients)
## TODO: Blocking effects/unique effects (array with blocking effects for each effect)

func add(effect: VisualEffect, _owner: CanvasItem, limit: Variant = 1):
	if effect == null:
		return Log.error("Tried to add null visual effect!")
	
	if (_owner == null || _owner.is_queued_for_deletion()):
		return handle_error(effect, "Tried to add visual effect(%s) with null owner." % effect.get_type_str())
	
	if VALID_UBER_SHADERS_INDEX.keys().has(effect.get_type()) && not VALID_UBER_SHADERS_INDEX[effect.get_type()].has(_owner.material.shader):
		return handle_error(effect, "Owner's shader material is not supported by visual effects!")

	var effects_parent = effect.get_parent()
	
	if effects_parent != null:
		if effects_parent is CanvasItem && _active_vfx_index.has(effects_parent) && _active_vfx_index[effects_parent].has(effect):
			return Log.error("Effect(%s) you are trying to add already has official owner!" % effect.get_type_str())
		else:
			effect.reparent(_owner)
	else:
		_owner.add_child.call_deferred(effect)
		await effect.tree_entered
	
	effect.name = Functions.get_unique_name(_owner, Functions.enum_to_str(effect.get_type(), VisualEffect.Type).to_pascal_case())
	effect.owner = _owner
	
	if limit != null:
		effect.set_limit(limit)
	
	# CAUTION: Effect needs to have an owner to be valid so order is important!
	if not effect.is_valid():
		return handle_error(effect, "Tried to add invalid visual effect(%s)." % effect.get_type_str())
		
	if not _active_vfx_index.has(_owner):
		_active_vfx_index[_owner] = []
	
	_active_vfx_index[_owner].push_back(effect)
	
	_owner.tree_exiting.connect(func(): remove_owner(_owner))
	
	if not effect.is_permanent():
		effect.finished.connect(func(): remove_effect(effect))
		
	effect.killed.connect(func(): remove_effect_from_index(effect))
	effect.terminating.connect(func(): remove_effect_from_index(effect))
	
	effect.start()


func handle_error(effect: VisualEffect, msg: String):
	Log.error(msg)
	
	if effect != null:
		effect.die()


func remove_effect(effect: VisualEffect):
	if effect != null:
		if effect.is_active() && effect.owner != null && not effect.owner.is_queued_for_deletion():
			effect.stop()
		
		remove_effect_from_index(effect)
		effect.queue_free()


func remove_effect_from_index(effect: VisualEffect):
	if effect != null:
		if _active_vfx_index.keys().has(effect.owner):
			_active_vfx_index[effect.owner].erase(effect)


func remove_owner(_owner: CanvasItem):
	if _active_vfx_index.has(_owner):
		for effect in _active_vfx_index[_owner]:
			remove_effect(effect)
		
		_active_vfx_index.erase(_owner)
