shader_type canvas_item;

//colorsito me permite elegir el color en la paleta
uniform vec4 colorsito : hint_color;

void fragment(){
	COLOR.rgb = colorsito.rgb;
	//toma el alpha de la textura (sea jugador o target)
	COLOR.a = texture(TEXTURE,UV).a;
}