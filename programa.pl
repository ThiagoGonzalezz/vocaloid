
canta(megurineLuka, cancion(nightFever, 4)).

canta(megurineLuka, cancion(foreverYoung,5)).

canta(hatsuneMiku,cancion(tellYourWorld,4)).

canta(gumi,cancion(forveverYoung,4)).

canta(gumi,cancion(tellYourWorld,5)).

canta(seeU,cancion(novemberRain,6)).

canta(seeU,cancion(nightFever,5)).

/*Debido al principio de Universo Cerrado, no es necesario especificar que kaito 
no sabe cantar ninguna cancion, ya que al no estar en la base de conocimientos,
todo lo desconocido se toma como falso.
*/

%1

novedoso(Cantante) :- 
    sabeAlMenosDosCanciones(Cantante),
    tiempoTotalCanciones(Cantante, Tiempo),
    Tiempo < 15.
    
    sabeAlMenosDosCanciones(Cantante) :-
        canta(Cantante, UnaCancion),
        canta(Cantante, OtraCancion),
        UnaCancion \= OtraCancion.
    
    tiempoTotalCanciones(Cantante, TiempoTotal) :-
        findall(TiempoCancion, 
    tiempoDeCancion(Cantante, TiempoCancion), Tiempos), sumlist(Tiempos,TiempoTotal).
    
    tiempoDeCancion(Cantante,TiempoCancion):-  
          canta(Cantante,Cancion),
          tiempo(Cancion,TiempoCancion).
    
    tiempo(cancion(_, Tiempo), Tiempo).
    
%2

acelerado(Cantante) :- 
    vocaloid(Cantante), 
    not((tiempoDeCancion(Cantante,Tiempo),Tiempo > 4)).
    
    vocaloid(Cantante):-
    canta(Cantante, _).
    

%Segunda Parte

%concierto(Nombre, Pais, cantFama, tipoConcierto)

%1 

%concierto(nombre, pais, fama, tipoConcierto)%
concierto(mikuExpo, eeuu, 2000, gigante(2,6)).
concierto(magicalMirai, japon, 3000, gigante(3,10)).
concierto(vocalektVisions, eeuu, 1000, mediano(9)).
concierto(mikuFest, argentina, 100, diminuto(4)).

%2

puedeParticipar(hatsuneMiku,Concierto):-
	concierto(Concierto, _, _, _).

puedeParticipar(Cantante, Concierto):-
	vocaloid(Cantante),
	Cantante \= hatsuneMiku,
	concierto(Concierto, _, _, Requisitos),
	cumpleRequisitos(Cantante, Requisitos).

cumpleRequisitos(Cantante, gigante(CantCanciones, TiempoMinimo)):-
	cantidadCanciones(Cantante, Cantidad),
	Cantidad >= CantCanciones,
	tiempoTotalCanciones(Cantante, Total),
	Total > TiempoMinimo.

cumpleRequisitos(Cantante, mediano(TiempoMaximo)):-
	tiempoTotalCanciones(Cantante, Total),
	Total < TiempoMaximo.

cumpleRequisitos(Cantante, diminuto(TiempoMinimo)):-
	canta(Cantante, Cancion),
	tiempo(Cancion, Tiempo),
	Tiempo > TiempoMinimo.

cantidadCanciones(Cantante, Cantidad) :- 
findall(Cancion, canta(Cantante, Cancion), Canciones),
length(Canciones, Cantidad).


%3

masFamoso(Cantante) :-
	nivelFamoso(Cantante, NivelMasFamoso),
	forall(nivelFamoso(_, Nivel), NivelMasFamoso >= Nivel).

nivelFamoso(Cantante, Nivel):- 
famaTotal(Cantante, FamaTotal), 	cantidadCanciones(Cantante, Cantidad), 
Nivel is FamaTotal * Cantidad.

famaTotal(Cantante, FamaTotal):- 
vocaloid(Cantante),
findall(Fama, famaConcierto(Cantante, Fama),  
CantidadesFama), 	
sumlist(CantidadesFama, FamaTotal).

famaConcierto(Cantante, Fama):-
puedeParticipar(Cantante,Concierto),
fama(Concierto, Fama).

fama(Concierto,Fama):- 
concierto(Concierto,_,Fama,_).

%4

conoce(megurineLuka, hatsuneMiku).
conoce(megurineLuka, gumi).
conoce(gumi, seeU).
conoce(seeU, kaito).


unicoParticipanteEntreConocidos(Cantante,Concierto):- 
    puedeParticipar(Cantante, Concierto),
    not((conocido(Cantante, OtroCantante), 
    OtroCantante \= Cantante,
    puedeParticipar(OtroCantante, Concierto))).    


conocido(Vocaloid1, Vocaloid2):-
conoce(Vocaloid1, Vocaloid2).

conocido(Vocaloid1, Vocaloid2):-
conoce(Vocaloid1, OtroVocaloid),
conocido(OtroVocaloid, Vocaloid2).

%5

/*
En caso de que aparezca un nuevo tipo de concierto, unicamente habrí que agregar su respectivo
cumpleRequisitos/2. Esto es posible gracias a la utilizacion de polimorfismo. Un codigo para la solucion general
y una regla chiquitita para cada uno de los distintos fuctores(tipos de concierto).
*/