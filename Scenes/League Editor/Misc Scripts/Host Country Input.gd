extends LineEdit


func league_selected(t: Tournament) -> void:
	text = str(t.Host_Country_Name);

func clear_selection() -> void:
	text = "Host Country Name";
