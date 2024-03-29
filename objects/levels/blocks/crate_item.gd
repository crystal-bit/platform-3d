extends StaticBody3D
class_name Crate

enum CRATE_TYPE {
	BASE,
	COIN
}


@export var crate_type: CRATE_TYPE = CRATE_TYPE.BASE
@onready var coin: Node3D = $coinGold


func _ready():
	if crate_type == CRATE_TYPE.COIN:
		GameState.add_coin_to_count(2)
		set_meta('coins', 2)
	else:
		$coinGold.queue_free()


func hit():
	$crateItem/AnimationPlayer.stop()
	$crateItem/AnimationPlayer.play("hit")
	match crate_type:
		CRATE_TYPE.BASE:
			pass
		CRATE_TYPE.COIN:
			$coinGold/AnimationPlayer.stop()
			$coinGold/AnimationPlayer.play("appear")
			GameState.player_got_coin()

			if get_meta('coins') > 1:
				set_meta('coins', get_meta('coins') - 1)
			else:
				$crateItem.hide()
				$CollisionShape3D.queue_free()
				await $coinGold/AnimationPlayer.animation_finished
				queue_free()
		_:
			pass
