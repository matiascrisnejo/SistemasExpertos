% HECHOS
% Listas
% Estudiantes
estudiantes([carlos, david, esteban, julian, matias, miriam, paola]).

% Conceptos por nivel
principiantes([clases, variables, metodos, ciclos]).
intermedios([hilos, bases_datos, web_services]).
avanzados([patrones, metodologias]).

% Conceptos de programación
conceptosprogramacion(clases).
conceptosprogramacion(variables).
conceptosprogramacion(metodos).
conceptosprogramacion(ciclos).
conceptosprogramacion(hilos).
conceptosprogramacion(bases_datos).
conceptosprogramacion(patrones).
conceptosprogramacion(metodologias).
conceptosprogramacion(web_services).

% Conceptos adquiridos por los estudiantes
%david
conoce(david, clases).
conoce(david, variables).
conoce(david, metodos).
conoce(david, ciclos).
conoce(david, hilos).
conoce(david, bases_datos).
conoce(david, web_services).
conoce(david, patrones).
conoce(david, metodologias).

%miriam
conoce(miriam, clases).
conoce(miriam, variables).
conoce(miriam, metodos).
conoce(miriam, ciclos).
conoce(miriam, hilos).
conoce(miriam, bases_datos).
conoce(miriam, web_services).

%esteban
conoce(esteban, hilos).
conoce(esteban, bases_datos).
conoce(esteban, web_services).
conoce(esteban, clases). 
conoce(esteban, variables). 
conoce(esteban, metodos). 
conoce(esteban, ciclos).

%carlos
conoce(carlos, clases). 
conoce(carlos, variables). 
conoce(carlos, metodos). 
conoce(carlos, web_services).

%julian
conoce(julian, clases). 
conoce(julian, variables). 
conoce(julian, metodos). 

%matias
conoce(matias, clases). 
conoce(matias, variables). 
conoce(matias, metodos). 
conoce(matias, ciclos).

% Reglas
% Funcion auxiliar se podria cambiar por la nativa menber/2
pertenece(X, [X|_]).
pertenece(X, [_|T]) :- pertenece(X, T).

% Estudiante válido
estudiante(X) :- estudiantes(L), pertenece(X, L).

% Conocimiento válido
conoce_concepto(E, C) :- estudiante(E), conceptosprogramacion(C), conoce(E, C).

% Niveles de conocimiento
nivelprincipiante(X) :- 
    conoce_concepto(X, clases),
    conoce_concepto(X, variables),
    conoce_concepto(X, metodos),
    conoce_concepto(X, ciclos),
    \+ nivelintermedio(X),
    \+ nivelavanzado(X),!.

nivelintermedio(X) :- 
    conoce_concepto(X, hilos),
    conoce_concepto(X, bases_datos),
    conoce_concepto(X, web_services),
    \+ nivelavanzado(X),!.

nivelavanzado(X) :- 
    conoce_concepto(X, metodologias),
    conoce_concepto(X, patrones),!.

mostrar(Mensaje) :-
    writeln(Mensaje), !.

% Consultas sistema experto:
% Qué le falta para completar el nivel
faltan_de_principiante(E) :-
    principiantes(L),
    mostrar('-- Le faltan estos conceptos para el nivel principiante:  --'),
    findall(C, ( pertenece(C, L), \+ conoce(E, C) ), Faltantes),
    listar_lista(Faltantes).

faltan_de_intermedio(E) :-
    intermedios(L),
    findall(C, (pertenece(C, L), \+ conoce(E, C)), Faltantes),
    mostrar('-- Le faltan estos conceptos para el nivel intermedio:  --'),
    listar_lista(Faltantes).

faltan_de_avanzado(E) :-
    avanzados(L),
    findall(C, (pertenece(C, L), \+ conoce(E, C)), Faltantes),
    mostrar('-- Le faltan estos conceptos para el nivel avanzado:  --'),
    listar_lista(Faltantes).

% que le falta para graduarse:
faltan_para_graduarse(E) :-
    faltan_de_principiante(E),
    faltan_de_intermedio(E),
    faltan_de_avanzado(E).

% Recomendaciones de estudio:
recomendar(E) :- 
    sin_nivel(E),
    faltan_de_principiante(E),!.

recomendar(E) :-
    nivelprincipiante(E),
    faltan_de_intermedio(E),!.

recomendar(E) :-
    nivelintermedio(E),
    faltan_de_avanzado(E),!.

recomendar(E) :-
    nivelavanzado(E),
    mostrar('Se recomienda un master'),!.

% Listar estudiantes por nivel completo
listar_por_nivel :-
    mostrar('--- Sin nivel completo ---'),listar_sin_nivel,
    mostrar('--- Principiantes ---'), listar(nivelprincipiante),
    mostrar('--- Intermedios ---'), listar(nivelintermedio),
    mostrar('--- Avanzados ---'), listar(nivelavanzado).

% Listar estudiantes de un nivel especifico.
listar(Nivel) :-
    estudiantes(Es),
    forall( pertenece(E, Es), (call(Nivel, E) -> writeln(E); true)).

% Listar estudiantes sin nivel principiante completo.
listar_sin_nivel :-
    estudiantes(Es),
     forall( pertenece(E, Es),
            (sin_nivel(E) -> writeln(E); true)).

% Estudiantes sin conocimientos registrados
sin_nivel(E) :-
    estudiantes(Es),
    pertenece(E, Es), 
          (\+ call(nivelprincipiante, E), 
          \+ call(nivelintermedio, E), 
          \+ call(nivelavanzado, E)),!.

% listar conceptos por nivel
listar_conceptos_por_nivel :-
    mostrar('--- Conceptos de Nivel Principiante ---'), listar_conceptos(principiantes),
    mostrar('--- Conceptos de Nivel Intermedio ---'), listar_conceptos(intermedios),
    mostrar('--- Conceptos de Nivel Avanzado ---'), listar_conceptos(avanzados).

listar_conceptos(Nivel) :-
    call(Nivel, Conceptos),
    listar_lista(Conceptos).

listar_lista([]).
listar_lista([H|T]) :- mostrar(H), listar_lista(T).


/*
Definiciones:
call: 
    Ejecuta un predicado que se pasa como argumento como si estuvieras escribiéndolo 
    directamente. EJ: call(Predicado, Argumento).

forall: 
    Recorrer una lista (o generar soluciones) y asegurarse de que todas cumplan una 
    cierta condición o de ejecutar una acción para cada una de ellas. 
    EJ: forall(CondiciónGeneradora, Acción).

findall: 
    findall(Forma, Condición, ListaResultado).
    - Forma: Es la forma en que se estructuran los resultados.
    - Condicion: Es la consulta que se ejecuta para encontrar soluciones.
    - ListaResultado: Es la lista que contendrá todas las instancias de 
      la plantilla que cumplen la meta.
*/

/** <examples>
EJEMPLOS DE USO
Ver nivel de cada estudiante o de uno especifico.
?- nivelprincipiante(E).
?- nivelintermedio(E).
?- nivelavanzado(E).
?- nivelprincipiante(matias).
?- nivelavanzado(david).
?- nivelintermedio(miriam).

¿Qué le falta a paola del nivel principiante?
?- faltan_de_principiante(paola).

¿Qué le falta a Carlos del nivel intermedio?
?- faltan_de_intermedio(carlos).

¿Qué le falta a miriam del nivel avanzado?
?- faltan_de_avanzado(miriam).
%F = [patrones, metodologias].

Listar todos los estudiantes clasificados por los distintos niveles completos:
?- listar_por_nivel.

Listar los estudiantes clasificados por un nivel especifico:
?- listar(nivelprincipiante).

Ver si hay algún estudiante sin nivel principiante:
?- listar_sin_nivel.

Conceptos que les faltan:
?- faltan_para_graduarse(carlos).
?- faltan_de_principiante(carlos).
?- faltan_de_intermedio(paola).
?- faltan_de_avanzado(julian).

Listar todos los conceptos ordenados por nivel:
?- listar_conceptos_por_nivel.

conceptos recomendados para un estudiante:
?- recomendar(david).
?- recomendar(carlos).
?- recomendar(miriam).
*/





