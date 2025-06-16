% HECHOS
% Lista de estudiantes
estudiantes([carlos, david, esteban, julian, matias, luciano, paola]).
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
conceptosprogramacion(basesdatos).
conceptosprogramacion(patrones).
conceptosprogramacion(metodologias).
conceptosprogramacion(webservices).

% Conceptos adquiridos por los estudiantes
%david
conoce(david, clases).
conoce(david, variables).
conoce(david, metodos).
conoce(david, ciclos).
conoce(david, hilos).
conoce(david, basesdatos).
conoce(david, webservices).
conoce(david, patrones).
conoce(david, metodologias).

conoce(luciano, clases).
conoce(luciano, variables).
conoce(luciano, metodos).
conoce(luciano, ciclos).
conoce(luciano, hilos).
conoce(luciano, basesdatos).
conoce(luciano, webservices).

%esteban
conoce(esteban, hilos).
conoce(esteban, basesdatos).
conoce(esteban, webservices).
conoce(esteban, clases). 
conoce(esteban, variables). 
conoce(esteban, metodos). 
conoce(esteban, ciclos).

%carlos
conoce(carlos, clases). 
conoce(carlos, variables). 
conoce(carlos, metodos). 
conoce(carlos, webservices).

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
    \+ nivelavanzado(X).

nivelintermedio(X) :- 
    conoce_concepto(X, hilos),
    conoce_concepto(X, basesdatos),
    conoce_concepto(X, webservices),
    \+ nivelavanzado(X).

nivelavanzado(X) :- 
    conoce_concepto(X, metodologias),
    conoce_concepto(X, patrones).

mostrar(Mensaje) :-
    writeln(Mensaje), !.

% Consultas sistema experto:
% Qué le falta para completar el nivel
faltan_para_principiante(E) :-
    principiantes(L),
    mostrar('-- Le faltan estos conceptos para el nivel principiante:  --'),
    findall(C, ( pertenece(C, L), \+ conoce(E, C) ), Faltantes),
    listar_lista(Faltantes).

faltan_para_intermedio(E) :-
    intermedios(L),
    findall(C, (pertenece(C, L), \+ conoce(E, C)), Faltantes),
    mostrar('-- Le faltan estos conceptos para el nivel intermedio:  --'),
    listar_lista(Faltantes).

faltan_para_avanzado(E) :-
    avanzados(L),
    findall(C, (pertenece(C, L), \+ conoce(E, C)), Faltantes),
    mostrar('-- Le faltan estos conceptos para el nivel avanzado:  --'),
    listar_lista(Faltantes).

% que le falta para graduarse:
faltan_para_graduarse(E) :-
    faltan_para_principiante(E),
    faltan_para_intermedio(E),
    faltan_para_avanzado(E).

% Recomendaciones de estudio - Agregar un print para que diga el nivel. REFACTORIZAR!!!
recomendar(E) :- 
    sin_nivel(E),
    faltan_para_principiante(E),!.

recomendar(E) :-
    nivelprincipiante(E),
    faltan_para_intermedio(E),!.

recomendar(E) :-
    nivelintermedio(E),
    faltan_para_avanzado(E),!.

%Agregarle que como no tiene mas materias se haga un posgrado.
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

% Listar estudiantes sin nivel principiante incompleto.
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
?- nivelprincipiante(carlos).
?- nivelavanzado(carlos).
?- nivelintermedio(paula).

¿Qué le falta a Carlos para llegar a nivel intermedio?
?- faltan_para_intermedio(carlos, F).
?- faltan_para_avanzado()
%F = [hilos, basesdatos, webservices].

¿Qué le recomendás estudiar a Luciano?
?- recomendar(luciano, R).

Listar todos los estudiantes clasificados por los distintos niveles:
?- listar_por_nivel.

Listar los estudiantes clasificados por un nivel especifico:
?- listar(nivelprincipiante).

Ver si hay algún estudiante que no tiene conocimientos:
?- sin_conocimientos(X).

Conceptos que le faltan a carlos:
?- faltan_para_graduarse(carlos).
?- faltan_para_principiante(carlos).
?- faltan_para_intermedio(carlos).
?- faltan_para_avanzado(carlos).

Estudiante sin nivel:
?- listar_sin_nivel.

Listar todos los estudiantes por niveles:
?- listar_por_nivel.

Listar todos los conceptos ordenados por nivel:
?- listar_conceptos_por_nivel.

conceptos recomendados:
?- recomendar(david).
*/







Ver si hay algún estudiante que no tiene conocimientos:
?- sin_conocimientos(X).

*/
