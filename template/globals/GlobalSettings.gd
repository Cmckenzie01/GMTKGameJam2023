extends Node

func toggle_fullscreen(toggle):
	if toggle:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	SaveSettings.game_data.fullscreen_on = toggle
	SaveSettings.save_data()
	
func toggle_borderless(toggle):
	if toggle:
		pass
	else:
		pass
	SaveSettings.game_data.borderless_on = toggle
	SaveSettings.save_data()
	
func toggle_vsync(toggle):
	if toggle:
		pass
	else:
		pass
	SaveSettings.game_data.vsync_on = toggle
	SaveSettings.save_data()
	
func update_master_vol(vol):
	AudioServer.set_bus_volume_db(0, vol)
	SaveSettings.game_data.master_vol = vol
	SaveSettings.save_data()
	
func update_music_vol(vol):
	AudioServer.set_bus_volume_db(1, vol)
	SaveSettings.game_data.music_vol = vol
	SaveSettings.save_data()
	
func update_sfx_vol(vol):
	AudioServer.set_bus_volume_db(2, vol)
	SaveSettings.game_data.sfx_vol = vol
	SaveSettings.save_data()


