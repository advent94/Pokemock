extends VisualEffectsTest


func should_remove_finished_effect():
	var visual_effects = get_testable_visual_effects()
	var dummy_effect = get_dummy_effect()
	var dummy_owner = get_dummy_owner()
	
	visual_effects.add(dummy_effect, dummy_owner)
	
	EXPECT_TRUE(visual_effects._active_vfx_index[dummy_owner].has(dummy_effect))
	EXPECT_TRUE(dummy_effect.is_active())
	
	dummy_effect.finished.emit()
	
	EXPECT_FALSE(visual_effects._active_vfx_index[dummy_owner].has(dummy_effect))
	EXPECT_FALSE(dummy_effect.is_active())


func should_not_remove_finished_permanent_effect():
	var visual_effects = get_testable_visual_effects()
	var dummy_effect = get_dummy_effect(func(): pass, null, true)
	var dummy_owner = get_dummy_owner()
	
	visual_effects.add(dummy_effect, dummy_owner)
	
	EXPECT_TRUE(visual_effects._active_vfx_index[dummy_owner].has(dummy_effect))
	EXPECT_TRUE(dummy_effect.is_active())
	
	dummy_effect.finished.emit()
	
	EXPECT_TRUE(visual_effects._active_vfx_index[dummy_owner].has(dummy_effect))
	EXPECT_TRUE(dummy_effect.is_active())


func should_remove_killed_effect():
	var visual_effects = get_testable_visual_effects()
	var dummy_effect = get_dummy_effect()
	var dummy_owner = get_dummy_owner()
	
	visual_effects.add(dummy_effect, dummy_owner)
	
	EXPECT_TRUE(visual_effects._active_vfx_index[dummy_owner].has(dummy_effect))
	
	dummy_effect.killed.emit()
	
	EXPECT_FALSE(visual_effects._active_vfx_index[dummy_owner].has(dummy_effect))


func should_remove_terminating_effect():
	var visual_effects = get_testable_visual_effects()
	var dummy_effect = get_dummy_effect()
	var dummy_owner = get_dummy_owner()
	
	visual_effects.add(dummy_effect, dummy_owner)
	
	EXPECT_TRUE(visual_effects._active_vfx_index[dummy_owner].has(dummy_effect))
		
	dummy_effect.terminating.emit()
	
	EXPECT_FALSE(visual_effects._active_vfx_index[dummy_owner].has(dummy_effect))


func should_remove_owner_and_effects():
	var visual_effects = get_testable_visual_effects()
	var dummy_effect = get_dummy_effect()
	var dummy_owner = get_dummy_owner()
	
	visual_effects.add(dummy_effect, dummy_owner)
	
	EXPECT_TRUE(visual_effects._active_vfx_index.has(dummy_owner))
	EXPECT_TRUE(visual_effects._active_vfx_index[dummy_owner].has(dummy_effect))
	
	dummy_owner.queue_free()
	
	await dummy_owner.tree_exiting
	
	EXPECT_FALSE(visual_effects._active_vfx_index.has(dummy_owner))
	
