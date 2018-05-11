
INCLUDE "macros.asm"
INCLUDE "constants.asm"

INCLUDE "sound/DevSoundEntryPoints.asm"

; DevSound isn't really intended to be included as a submodule...
; I got DevEd to allow some "interfacing", but it's not as clean as I'd like it to be.
; At least it works in a reasonable way !

; Tell DevSound not to use its DS_* hooks ; Aevilia defines its own
UseCustomHooks = 1
; Tell DevSound not to include its default song data
DontIncludeSongData = 1
; Disable Zombie mode, since it causes issues with SFX (and eats a lot of CPU)
DisableZombieMode = 1
; DevSound defines its own `dbw` macro - which is exactly the same as Aevilia's, but we need to avoid conflicts, lel
PURGE dbw
INCLUDE "sound/DevSound/DevSound.asm"

INCLUDE "sound/SongData.asm" ; Make sure this follows DevSound.asm !

INCLUDE "sound/song_names.asm"

INCLUDE	"sound/FXHammer.asm"
