
% Lista de estudiantes
estudiantes([carlos, david, esteban, julian, matias, miriam, paola]).% esto no se puede hacer en prolog, las listas se pasan por parametros en el interprete

% Conceptos de programacion
conceptosprogramacion(clases).
conceptosprogramacion(variables).
conceptosprogramacion(metodos).
conceptosprogramacion(ciclos).
conceptosprogramacion(hilos).
conceptosprogramacion(basesdatos).
conceptosprogramacion(patrones).
conceptosprogramacion(metodologias).
conceptosprogramacion(webservices).

% Conceptos adquiridos por los estudiantes (Revisar que todos los estudiantes tengas conoce!)
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

conoce(carlos,clases). 
conoce(carlos,variables). 
conoce(carlos,metodos). 
conoce(carlos,ciclos).

conoce(julian,clases). 
conoce(julian,variables). 
conoce(julian,metodos). 
conoce(julian,ciclos).

conoce(matias,clases). 
conoce(matias,variables). 
conoce(matias,metodos). 
conoce(matias,ciclos).

% Reglas

pertenece(X, [X|_]) :- !.
pertenece(X, [_|L]) :- pertenece(X, L).

estudiante(X) :- estudiantes(L), pertenece(X, L).

conoce_concepto(E, C) :- estudiante(E), conceptosprogramacion(C), conoce(E, C).

nivelprincipiante(X) :- conoce_concepto(X,clases), conoce_concepto(X,variables), conoce_concepto(X,metodos), conoce_concepto(X,ciclos), not(nivelavanzado(X)), not(nivelintermedio(X)).
nivelintermedio(X) :- conoce_concepto(X,hilos), conoce_concepto(X,basesdatos), conoce_concepto(X,webservices), not(nivelavanzado(X)). 
nivelAvanzado(X) :- conoce_concepto(X,metodologias), conoce_concepto(X,patrones).


%porcentajeDeCarreraAprovado(X) :- conoce_concepto(X) > N .