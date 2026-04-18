@tool
class_name CountrySelector
extends Control

var countryCodes:Array = [
	"AD", "AE", "AF", "AG", "AI", "AL", "AM", "AO", "AQ", "AR",
	"AS", "AT", "AU", "AW", "AX", "AZ", "BA", "BB", "BD", "BE",
	"BF", "BG", "BH", "BI", "BJ", "BL", "BM", "BN", "BO", "BQ",
	"BR", "BS", "BT", "BV", "BW", "BY", "BZ", "CA", "CC", "CD",
	"CF", "CG", "CH", "CI", "CK", "CL", "CM", "CN", "CO", "CR",
	"CU", "CW", "CX", "CY", "CZ", "DE", "DJ", "DK", "DM", "DO",
	"DZ", "EC", "EE", "EG", "EH", "ER", "ES", "ET", "FI", "FJ",
	"FK", "FM", "FO", "FR", "GA", "GB", "GD", "GE", "GF", "GG",
	"GH", "GI", "GL", "GM", "GN", "GP", "GQ", "GR", "GS", "GT",
	"GU", "GW", "GY", "HK", "HM", "HN", "HR", "HT", "HU", "ID",
	"IE", "IL", "IM", "IN", "IO", "IQ", "IR", "IS", "IT", "JE",
	"JM", "JO", "JP", "KE", "KG", "KH", "KI", "KM", "KN", "KP",
	"KR", "KW", "KY", "KZ", "LA", "LB", "LC", "LI", "LK", "LR",
	"LS", "LT", "LU", "LV", "LY", "MA", "MC", "MD", "ME", "MF",
	"MG", "MH", "MK", "ML", "MM", "MN", "MO", "MP", "MQ", "MR",
	"MS", "MT", "MU", "MW", "MX", "MY", "MZ", "NA", "NC", "NE",
	"NF", "NG", "NI", "NL", "NO", "NP", "NR", "NU", "NZ", "OM",
	"PA", "PE", "PF", "PG", "PH", "PK", "PL", "PM", "PN", "PR",
	"PS", "PT", "PW", "PY", "QA", "RE", "RO", "RS", "RU", "RW",
	"SA", "SB", "SC", "SD", "SE", "SG", "SH", "SI", "SJ", "SK",
	"SL", "SM", "SN", "SO", "SR", "SS", "ST", "SV", "SX", "SY",
	"SZ", "TC", "TD", "TF", "TG", "TH", "TJ", "TK", "TL", "TM",
	"TN", "TO", "TR", "TT", "TV", "TW", "TZ", "UA", "UG", "UM",
	"US", "UY", "UZ", "VA", "VC", "VE", "VG", "VI", "VN", "VU",
	"WF", "WS", "YE", "YT", "ZA", "ZM", "ZW"
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for code in countryCodes:
		var textureRect:TextureRect = TextureRect.new()
		textureRect.texture = load("res://textures/flags/%s.png" % code)
		%Grid.add_child(textureRect)
