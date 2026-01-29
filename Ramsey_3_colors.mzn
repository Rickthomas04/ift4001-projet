%Olivianne Vaillancourt & Alexis Roberge
% ----- CONSTANTES -----
int: n;
int: r;
int: s;
int: t;

%Toutes les cliques
array[1..nb_r_cliques, 1..r] of int: r_cliques;
array[1..nb_s_cliques, 1..s] of int: s_cliques;
array[1..nb_t_cliques, 1..t] of int: t_cliques;

%Nombre de cliques
function int: nb_cliques(int: m) =
  product([n - i + 1 | i in 1..m]) div product([m - i + 1 | i in 1..m]);
int: nb_r_cliques = nb_cliques(r);
int: nb_s_cliques = nb_cliques(s);
int: nb_t_cliques = nb_cliques(t);
int: edges = (n*(n-1))div 2;

% ----- ENSEMBLES -----  
set of int: vertices = 1..n;

% ----- VARIABLES -----
array[vertices, vertices] of var 0..3: coloring;

% ----- CONTRAINTES -----
constraint r <= s /\ s <= t;

% Initialisation
constraint forall(i in vertices, j in 1..i)
  (coloring[i,j] = 0 /\ if i != j then coloring[j,i] != 0 endif);
    
% Aucune cliques de taille r et de couleur "1"
constraint forall(i in 1..nb_r_cliques)
  (exists(j in 1..r-1, k in j+1..r)
    (coloring[r_cliques[i,j], r_cliques[i,k]] != 1));
       
% Aucune cliques de taille s et de couleur "2"
constraint forall(i in 1..nb_s_cliques)
  (exists(j in 1..s-1, k in j+1..s)
    (coloring[s_cliques[i,j], s_cliques[i,k]] != 2));

% Aucune cliques de taille r et de couleur "3" 
constraint forall(i in 1..nb_t_cliques)
  (exists(j in 1..t-1, k in j+1..t)
    (coloring[t_cliques[i,j], t_cliques[i,k]] != 3));        

solve satisfy;

% ----------OUTPUT ----------
output join("\n", [join(" ", [show((coloring[i, j])) | j in vertices]) | i in vertices]);
               