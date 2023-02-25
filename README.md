# Forte; A RPG character system

The basic idea of stats are fortes.  Each forte is made up of a number of feebles (feebs).  The
value of a forte is (usually) found by summing the various feebles that make it up.  A feeble can be
a value, or it can refer to another Forte.  Reference feebles can also have a translation table to
get the value.

Each Feeb should have a short description or tag indicating where it came from.

## Forte

Each forte has a list of feebs.

Additionally there are attrs (short for attributes).  Attrs may optionally have a value (an attr
with no value is the same as an attr with the value 'true').

## D20 Examples

A player wants to get the 'Stealth' score for their character.  The stealth score is represented by
a forte 'Stealth'.  It has the following feebles:
	- Dexterity Bonus (reference)
	- Proficiency Bonus (reference)

The forte for Dexterity is based on 'Dexterity Score' with a lookup table to get the stat bonus from
the score. 

Proficiency bonus is a reference to level with a transform to get the Proficiency bonus for the 
characters current level.

Level is is forte which just contains a reference to Experience Points, with a table to lookup.

Experience points is just a list of values for each time the character was granted (50XP : Kill
troll, 8XP Rescue Dragon, 200XP, Kill Princess).

## Rolemaster Example

FIXME

## Design Notes

If you've ever played a long running campaign using a paper character sheet, you probably got to a
point and wondered why your character has a +10 bonus in snorkeling.  Or rolled for a important skill
check, only to realise 5 minutes later you didn't add your current strength bonus on.

The  idea her is that we can audit a character to understand exactly what the bonuses are, and at
the same time the system doesn't really care about the game.  A Forte for Strength is the same as
Forte for Stealth.  Many Fortes don't make sense to show on a character sheet.  Additionally
character sheets often have a lot of fields there that aren't used in gameplay, just to calculate
the numbers that are used in gameplay.   For instance a racial strength bonus is not really of
interest most of the game - you care about the total bonus, not if it it comes from a high stat and
no racial bonus, or high racial bonus and no stat bonus. 

## Notes

A feeble may not (directly or indirectly) refer to it's own forte.
