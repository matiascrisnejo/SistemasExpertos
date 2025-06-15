% HECHOS
% Lista de estudiantes
estudiantes([carlos, david, esteban, julian, matias, miriam, paola]).
% Conceptos por nivel
principiantes([clases, variables, metodos, ciclos]).
intermedios([hilos, basesdatos, webservices]).
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
conoce(david, clases).
conoce(david, variables).
conoce(david, metodos).
conoce(david, ciclos).
conoce(david, hilos).
conoce(david, basesdatos).
conoce(david, webservices).
conoce(david, patrones).
conoce(david, metodologias).

conoce(miriam, clases).
conoce(miriam, variables).
conoce(miriam, metodos).
conoce(miriam, ciclos).
conoce(miriam, hilos).
conoce(miriam, basesdatos).
conoce(miriam, webservices).

conoce(esteban, hilos).
conoce(esteban, basesdatos).
conoce(esteban, webservices).
conoce(esteban, clases). 
conoce(esteban, variables). 
conoce(esteban, metodos). 
conoce(esteban, ciclos).

conoce(carlos, clases). 
conoce(carlos, variables). 
conoce(carlos, metodos). 
conoce(carlos, ciclos).

conoce(julian, clases). 
conoce(julian, variables). 
conoce(julian, metodos). 
conoce(julian, ciclos).

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

% Qué le falta para alcanzar el siguiente nivel
% findall(Elemento, Condición, ListaResultado).
faltan_para_principiante(E, Faltantes) :-
    principiantes(L),
    findall(C, (pertenece(C, L), \+ conoce(E, C)), Faltantes).

faltan_para_intermedio(E, Faltantes) :-
    intermedios(L),
    findall(C, (pertenece(C, L), \+ conoce(E, C)), Faltantes).

faltan_para_avanzado(E, Faltantes) :-
    avanzados(L),
    findall(C, (pertenece(C, L), \+ conoce(E, C)), Faltantes).


% Recomendaciones de estudio
recomendar(E, Recomendacion) :-
    nivelprincipiante(E),
    intermedios(Recomendacion).

recomendar(E, Recomendacion) :-
    nivelintermedio(E),
    avanzados(Recomendacion).

recomendar(E, []) :-
    nivelavanzado(E).

% Listar estudiantes por nivel
listar_por_nivel :-
    writeln('--- Principiantes ---'), listar(nivelprincipiante),
    writeln('--- Intermedios ---'), listar(nivelintermedio),
    writeln('--- Avanzados ---'), listar(nivelavanzado).
/*
call: Ejecuta un predicado que se pasa como argumento como si estuvieras escribiéndolo 
directamente. EJ: call(Predicado, Argumento).

forall: Recorrer una lista (o generar soluciones) y asegurarse de que todas cumplan una 
cierta condición o de ejecutar una acción para cada una de ellas. 
EJ: forall(CondiciónGeneradora, Acción).
*/
% Listar estudiantes de un nivel especifico.
listar(Nivel) :-
    estudiantes(Es),
    forall(pertenece(E, Es), (call(Nivel, E) -> writeln(E); true)).

% Estudiantes sin conocimientos registrados
sin_conocimientos(E) :-
    estudiante(E),
    \+ conoce(E, _).
/*
✅ EJEMPLOS DE USO
Ver nivel de cada estudiante o de uno especifico.
?- nivelprincipiante(E).
?- nivelintermedio(E).
?- nivelavanzado(E).
?- nivelprincipiante(carlos).
?- nivelavanzado(carlos).
?- nivelintermedio(paula).

¿Qué le falta a Carlos para llegar a nivel intermedio?
?- faltan_para_intermedio(carlos, F).
faltan_para_avanzado()
F = [hilos, basesdatos, webservices].

¿Qué le recomendás estudiar a Miriam?
?- recomendar(miriam, R).

Listar todos los estudiantes clasificados por los distintos niveles:
?- listar_por_nivel.

Listar los estudiantes clasificados por un nivel especifico:
?- listar(nivelprincipiante)

Ver si hay algún estudiante que no tiene conocimientos:
?- sin_conocimientos(X).

*/
