
SECTION "Player house text strings", ROMX
	
	set_text_prefix PlayerHouseTV
	dname
	dstr 1
	dline 0, "Wanna watch TV for"
	dline 1, "for a bit?"
	
	dline 2, "Yeah\, let's not."
	
	dline 3, "Hey!"
	dline 4, "I'm watching the"
	dline 5, "TV\, there!"
	dline 6, "You're not"
	dline 7, "transparent\, you"
	dline 8, "know\, ",2,"!"
	
	
	set_text_prefix PlayerHouseSiblingTVScript
	dname 1
	dline 0, "I know I'm"
	dline 1, "bothering you\,"
	dline 2, "but I'd like to"
	dline 3, "stay a bit before"
	dline 4, "leaving."
	dline 5, "I'm sorry."
	
	
	set_text_prefix PlayerHouseDontLeaveScript
	dname 1
	dline 0, "Wait!"
	dline 1, "Um\, ",2,"..."
	dline 2, "I know I was"
	dline 3, "rude not to tell"
	dline 4, "you before coming\,"
	dline 5, "but..."
	dline 6, "Can I spend some"
	dline 7, "time with you?"
	
	dline 8, "Really? Oh\, ",2,"\,"
	dline 9, "you're the best!"
	; 14
	; 15
	dline 20, "I really missed"
	dline 21, "seeing you\, ",2,"."
	
	dline 10, "..."
	dline 11, "Look\, ",2,"\, I know"
	dline 12, "that was rude\, but"
	dline 13, "would you really"
	dline 14, "turn me away?"
	dline 15, "It's been almost a"
	dline 16, "year\, now."
	dline 17, "It's alright\,"
	dline 18, "then?"
	dline 19, "Thank you."
	
	dline 22, 1," joined you!"
	
	
OkayNoChoice::
	dstr "Okay"
	dstr "No"
