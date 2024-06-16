extends Node
class_name BuffFactory

var buff_list = {
	Buff.Type.NoBuff: Buff.new(),
	Buff.Type.Adrenaline: AdrenalineBuff.new(),
	Buff.Type.BigHealth: BigHealthBuff.new(),
	Buff.Type.Reflection: ReflectionBuff.new(),
	Buff.Type.Demonic: DemonicBuff.new(),
	Buff.Type.HealthSmall: HealthSmallBuff.new(),
	Buff.Type.Rainbow: RainbowBuff.new(),
	Buff.Type.Reversal: ReversalBuff.new()
}

func get_random(_min = 0, _max = buff_list.size()):
	var random = randi() % buff_list.size()
	
	return buff_list[clamp(random, _min, _max)]

func get_buff(type = 0):
	return buff_list[type]
