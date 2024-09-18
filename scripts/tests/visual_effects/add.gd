extends VisualEffectsTest

func should_fail_and_kill():
	const KILL: int = 0
	
	var visual_effects: Node = get_testable_visual_effects()
	var dummy_owner: CanvasItem = get_dummy_owner()
	var dummy_effect: VisualEffect = get_dummy_effect(invalid_callable)
	
	dummy_effect.killed.connect(CALL_STATUS_UPDATE(KILL))
	
	EXPECT_FALSE(CALLED(KILL))
	
	visual_effects.add(dummy_effect, dummy_owner)
	
	await Functions.wait(ProcessTest.TIME_FOR_CLEAN_UP)
	
	EXPECT_TRUE(CALLED(KILL))
	EXPECT_EQ(dummy_effect, null)
	
	
func should_fail_for_null_visual_effect():
	var visual_effects: Node = get_testable_visual_effects()
	var dummy_owner: CanvasItem = get_dummy_owner()
	
	visual_effects.add(null, dummy_owner)
	
	EXPECT_ERROR("Null visual effect")


func should_fail_for_null_owner():
	var visual_effects: Node = get_testable_visual_effects()
	var dummy_effect: VisualEffect = get_dummy_effect()
	
	visual_effects.add(dummy_effect, null)
	
	EXPECT_ERROR("Null owner")


func should_fail_for_invalid_shader_material():
	const VALID_SHADER_EFFECT_TYPE: VisualEffect.Type = VisualEffect.Type.BLINKING

	var visual_effects: Node = get_testable_visual_effects()
	var dummy_effect: VisualEffect = get_dummy_effect()
	var dummy_owner: CanvasItem = get_dummy_owner()
	
	dummy_owner.material = get_dummy_shader_material()
	dummy_effect._type = VALID_SHADER_EFFECT_TYPE
	visual_effects.add(dummy_effect, dummy_owner)
	
	EXPECT_ERROR("Material is not supported")


func should_fail_for_effect_already_owned():
	var visual_effects: Node = get_testable_visual_effects()
	var dummy_effect: VisualEffect = get_dummy_effect()
	var official_owner: CanvasItem = get_dummy_owner()
	var dummy_owner: CanvasItem = get_dummy_owner()
	
	visual_effects._active_vfx_index[official_owner] = [dummy_effect]
	dummy_effect.reparent(official_owner)
	visual_effects.add(dummy_effect, dummy_owner)
	
	EXPECT_ERROR("Has official owner")


func should_fail_for_invalid_effect():
	var visual_effects: Node = get_testable_visual_effects()
	var dummy_effect: VisualEffect = get_dummy_effect(invalid_callable)
	var dummy_owner: CanvasItem = get_dummy_owner()
	
	visual_effects.add(dummy_effect, dummy_owner)
	
	EXPECT_ERROR("Invalid visual effect")


func should_succeed_for_valid_effect():
	var visual_effects: Node = get_testable_visual_effects()
	var dummy_effect: VisualEffect = get_dummy_effect()
	var dummy_owner: CanvasItem = get_dummy_owner()
	
	EXPECT_FALSE(visual_effects._active_vfx_index.keys().has(dummy_owner))
	
	visual_effects.add(dummy_effect, dummy_owner)
	
	EXPECT_TRUE(visual_effects._active_vfx_index.keys().has(dummy_owner))
	EXPECT_TRUE(visual_effects._active_vfx_index[dummy_owner].has(dummy_effect))
	

func should_reparent_owned_effect():
	var visual_effects: Node = get_testable_visual_effects()
	var dummy_effect: VisualEffect = get_dummy_effect()
	var old_owner: CanvasItem = get_dummy_owner()
	var new_owner: CanvasItem = get_dummy_owner()
	
	dummy_effect.reparent(old_owner)
	
	EXPECT_EQ(dummy_effect.get_parent(), old_owner)
	
	visual_effects.add(dummy_effect, new_owner)
	
	EXPECT_EQ(dummy_effect.get_parent(), new_owner)


func should_start_valid_effect():
	const START: int = 0
	
	var visual_effects: Node = get_testable_visual_effects()
	var dummy_effect: VisualEffect = get_dummy_effect()
	var dummy_owner: CanvasItem = get_dummy_owner()
	
	dummy_effect.started.connect(CALL_STATUS_UPDATE(START))
	
	visual_effects.add(dummy_effect, dummy_owner)
	
	EXPECT_TRUE(CALLED(START))


func should_set_limiter_by_default():
	const ONE_REPETITION: int = 1
	
	var visual_effects: Node = get_testable_visual_effects()
	var dummy_effect: VisualEffect = get_dummy_effect()
	var dummy_owner: CanvasItem = get_dummy_owner()
	
	EXPECT_EQ(null, dummy_effect.limiter)
	
	visual_effects.add(dummy_effect, dummy_owner)
	
	EXPECT_EQ(dummy_effect.get_limit(), ONE_REPETITION)
