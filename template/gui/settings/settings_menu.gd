extends Popup

# Video Settings
@onready var fullscreen_option = $SettingTabs/Video/MarginContainer/VideoSettings/FullscreenOption
@onready var borderless_option = $SettingTabs/Video/MarginContainer/VideoSettings/BorderlessOption
@onready var vsync_btn = $SettingTabs/Video/MarginContainer/VideoSettings/VsyncOption

# Audio Settings
@onready var master_slider = $SettingTabs/Audio/MarginContainer2/AudioSettings/MasterSlider
@onready var music_slider = $SettingTabs/Audio/MarginContainer2/AudioSettings/MusicSlider
@onready var sfx_slider = $SettingTabs/Audio/MarginContainer2/AudioSettings/SfxSlider


func _ready():
	#fullscreen_option.button_pressed = SaveSettings.game_data.fullscreen_on
	#borderless_option.button_pressed = SaveSettings.game_data.borderless_on
	#vsync_btn.button_pressed = SaveSettings.game_data.vsync_on
	#GlobalSettings.toggle_fullscreen(SaveSettings.game_data.fullscreen_on)
	#GlobalSettings.toggle_borderless(SaveSettings.game_data.borderless_on)
	#GlobalSettings.toggle_vsync(SaveSettings.game_data.vsync_on)
	#master_slider.value = SaveSettings.game_data.master_vol
	#music_slider.value = SaveSettings.game_data.music_vol
	#sfx_slider.value = SaveSettings.game_data.sfx_vol
	pass


### DISPLAY OPTIONS
func _on_FullscreenOption_toggled(button_pressed):
	pass#GlobalSettings.toggle_fullscreen(button_pressed)

func _on_BorderlessOption_toggled(button_pressed):
	pass#GlobalSettings.toggle_borderless(button_pressed)

func _on_VsyncOption_toggled(button_pressed):
	pass#GlobalSettings.toggle_vsync(button_pressed)
	

### MUSIC OPTIONS
func _on_MasterSlider_value_changed(value):
	pass#GlobalSettings.update_master_vol(value)
	
func _on_MusicSlider_value_changed(value):
	pass#GlobalSettings.update_music_vol(value)

func _on_SfxSlider_value_changed(value):
	pass#GlobalSettings.update_sfx_vol(value)
	

func _on_close_settings_pressed():
	self.hide()



