
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
	dline 2, "I know I didn't"
	dline 3, "tell you before"
	dline 4, "coming\, but..."
	dline 5, "Can I spend some"
	dline 6, "time with you?"
	
	dline 7, "Really? Oh\, ",2,"\,"
	dline 8, "you're the best!"
	; 14
	; 15
	dline 19, "I really missed"
	dline 20, "seeing you\, ",2,"."
	
	dline 9, "..."
	dline 10, "Look\, ",2,"\, I know"
	dline 11, "that was rude\, but"
	dline 12, "would you really"
	dline 13, "turn me away?"
	dline 14, "It's been almost a"
	dline 15, "year\, now."
	dline 16, "It's alright\,"
	dline 17, "then?"
	dline 18, "Thank you."
	
	dline 21, 1," joined you!"
	
	
OkayNoChoice::
	dstr "Okay"
	dstr "No"
