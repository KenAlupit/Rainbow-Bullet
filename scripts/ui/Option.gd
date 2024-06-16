extends Panel

export(String) var text = ""
export(String) var busIndex = ""
export(Array) var ticks = [0, 5]
export(int) var tickIndex = 0

var bus

onready var nameLabel = $Name
onready var value = $Value

onready var valueText = $Value/Value
onready var back = $Value/Back
onready var next = $Value/Next

func update_volume():
	valueText.text = String(SettingsData.data[tickIndex])
	AudioServer.set_bus_volume_db(bus, linear2db(float(float(SettingsData.data[tickIndex])/float(ticks[1]))))

func _ready():
	nameLabel.text = text
	bus = AudioServer.get_bus_index(busIndex)
	
	update_volume()

func _on_Back_pressed():
	SettingsData.data[tickIndex] = clamp(SettingsData.data[tickIndex] - 1, ticks[0], ticks[1])
	update_volume()


func _on_Next_pressed():
	SettingsData.data[tickIndex] = clamp(SettingsData.data[tickIndex] + 1, ticks[0], ticks[1])
	update_volume()
