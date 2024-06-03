.include "asm/include/battle_commands.inc"

.data

_000:
    CheckIgnorableAbility CHECK_OPCODE_HAVE, BATTLER_CATEGORY_SIDE_EFFECT_MON, ABILITY_MAGMA_ARMOR, _160
    CheckIgnoreWeather _011
    CompareVarToValue OPCODE_FLAG_SET, BSCRIPT_VAR_FIELD_CONDITION, FIELD_CONDITION_SUN_ALL, _127

_011:
    CheckIgnorableAbility CHECK_OPCODE_HAVE, BATTLER_CATEGORY_SIDE_EFFECT_MON, ABILITY_FLOWER_VEIL, _023
    CheckIgnorableAbility CHECK_OPCODE_HAVE, BATTLER_RELATIVE_ALLY|BATTLER_CATEGORY_SIDE_EFFECT_MON, ABILITY_FLOWER_VEIL, _023
    GoTo _035

_023:
    CompareMonDataToValue OPCODE_EQU, BATTLER_CATEGORY_SIDE_EFFECT_MON, BMON_DATA_TYPE_1, TYPE_GRASS, _127
    CompareMonDataToValue OPCODE_EQU, BATTLER_CATEGORY_SIDE_EFFECT_MON, BMON_DATA_TYPE_2, TYPE_GRASS, _127

_035:
    GotoIfGrounded BATTLER_CATEGORY_SIDE_EFFECT_MON, _040
    GoTo _043

_040:
    GotoIfTerrainOverlayIsType MISTY_TERRAIN, _190

_043:
    CompareVarToValue OPCODE_NEQ, BSCRIPT_VAR_SIDE_EFFECT_TYPE, SIDE_EFFECT_TYPE_INDIRECT, _053
    CheckIgnorableAbility CHECK_OPCODE_HAVE, BATTLER_CATEGORY_SIDE_EFFECT_MON, ABILITY_SHIELD_DUST, _127

_053:
    CompareVarToValue OPCODE_NEQ, BSCRIPT_VAR_SIDE_EFFECT_TYPE, SIDE_EFFECT_TYPE_DIRECT, _060
    PrintAttackMessage
    Wait

_060:
    CheckSubstitute BATTLER_CATEGORY_SIDE_EFFECT_MON, _127
    CompareMonDataToValue OPCODE_FLAG_SET, BATTLER_CATEGORY_SIDE_EFFECT_MON, BMON_DATA_STATUS, STATUS_FREEZE, _138
    CompareMonDataToValue OPCODE_EQU, BATTLER_CATEGORY_SIDE_EFFECT_MON, BMON_DATA_TYPE_1, TYPE_ICE, _147
    CompareMonDataToValue OPCODE_EQU, BATTLER_CATEGORY_SIDE_EFFECT_MON, BMON_DATA_TYPE_2, TYPE_ICE, _147
    CompareMonDataToValue OPCODE_NEQ, BATTLER_CATEGORY_SIDE_EFFECT_MON, BMON_DATA_STATUS, STATUS_NONE, _127
    CompareVarToValue OPCODE_FLAG_SET, BSCRIPT_VAR_MOVE_STATUS_FLAGS, MOVE_STATUS_SEMI_INVULNERABLE|MOVE_STATUS_MISSED, _127
    CompareVarToValue OPCODE_FLAG_SET, BSCRIPT_VAR_SIDE_CONDITION_STAT_CHANGE, SIDE_CONDITION_SAFEGUARD, _171
_bypassSafeguard:
    CompareVarToValue OPCODE_NEQ, BSCRIPT_VAR_SIDE_EFFECT_TYPE, SIDE_EFFECT_TYPE_DIRECT, _105
    PlayMoveAnimation BATTLER_CATEGORY_ATTACKER
    Wait

_105:
    PlayBattleAnimation BATTLER_CATEGORY_SIDE_EFFECT_MON, BATTLE_ANIMATION_FROZEN
    Wait
    UpdateMonData OPCODE_FLAG_ON, BATTLER_CATEGORY_SIDE_EFFECT_MON, BMON_DATA_STATUS, STATUS_FREEZE
    UnlockMoveChoice BATTLER_CATEGORY_SIDE_EFFECT_MON
    // {0} was frozen solid!
    PrintMessage 101, TAG_NICKNAME, BATTLER_CATEGORY_SIDE_EFFECT_MON
    Wait
    SetHealthbarStatus BATTLER_CATEGORY_SIDE_EFFECT_MON, BATTLE_ANIMATION_FROZEN
    WaitButtonABTime 30
    End

_127:
    CompareVarToValue OPCODE_EQU, BSCRIPT_VAR_SIDE_EFFECT_TYPE, SIDE_EFFECT_TYPE_INDIRECT, _189
    WaitButtonABTime 30
    Call BATTLE_SUBSCRIPT_BUT_IT_FAILED
    GoTo _189

_138:
    CompareVarToValue OPCODE_EQU, BSCRIPT_VAR_SIDE_EFFECT_TYPE, SIDE_EFFECT_TYPE_INDIRECT, _189
    WaitButtonABTime 30
    GoTo _182

_147:
    CompareVarToValue OPCODE_EQU, BSCRIPT_VAR_SIDE_EFFECT_TYPE, SIDE_EFFECT_TYPE_INDIRECT, _189
    WaitButtonABTime 30
    // It doesn’t affect {0}...
    PrintMessage 27, TAG_NICKNAME, BATTLER_CATEGORY_SIDE_EFFECT_MON
    GoTo _182

_160:
    CompareVarToValue OPCODE_EQU, BSCRIPT_VAR_SIDE_EFFECT_TYPE, SIDE_EFFECT_TYPE_INDIRECT, _189
    PrintAttackMessage
    Wait
    WaitButtonABTime 30
    GoTo _182

_handleInfiltrator:
    // infiltrator bypasses safeguard but only on moves that are used (which allows us to check the attacker directly)
    CompareMonDataToValue OPCODE_EQU, BATTLER_CATEGORY_ATTACKER, BMON_DATA_ABILITY, ABILITY_INFILTRATOR, _bypassSafeguard
    GoTo _postInfiltratorCheck

_handleInfiltratorMoveEffect:
    // infiltrator bypasses safeguard but only on moves that are used (which allows us to check the attacker directly)
    CompareMonDataToValue OPCODE_EQU, BATTLER_CATEGORY_ATTACKER, BMON_DATA_ABILITY, ABILITY_INFILTRATOR, _bypassSafeguard
    GoTo _189

_171:
    CompareVarToValue OPCODE_EQU, BSCRIPT_VAR_SIDE_EFFECT_TYPE, SIDE_EFFECT_TYPE_DIRECT, _handleInfiltrator
    CompareVarToValue OPCODE_EQU, BSCRIPT_VAR_SIDE_EFFECT_TYPE, SIDE_EFFECT_TYPE_MOVE_EFFECT, _handleInfiltratorMoveEffect
    CompareVarToValue OPCODE_EQU, BSCRIPT_VAR_SIDE_EFFECT_TYPE, SIDE_EFFECT_TYPE_INDIRECT, _189
_postInfiltratorCheck:
    WaitButtonABTime 30
    // {0} is protected by Safeguard!
    PrintMessage 200, TAG_NICKNAME, BATTLER_CATEGORY_SIDE_EFFECT_MON

_182:
    Wait
    WaitButtonABTime 30
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_MOVE_STATUS_FLAGS, MOVE_STATUS_NO_MORE_WORK

_189:
    End

_190:
    CompareVarToValue OPCODE_EQU, BSCRIPT_VAR_SIDE_EFFECT_TYPE, SIDE_EFFECT_TYPE_INDIRECT, _189
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_MOVE_STATUS_FLAGS, MOVE_STATUS_FAILED
    End
