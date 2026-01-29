%Olivianne Vaillancourt & Alexis Roberge
% ----- CONSTANTES -----
int: n;
int: r;
int: s;

int: nb_edges = n * (n - 1) div 2;

function int: nb_cliques(int: m) =
  product([n - i + 1 | i in 1..m]) div product([m - i + 1 | i in 1..m]);
int: nb_r_cliques = nb_cliques(r);
int: nb_s_cliques = nb_cliques(s);

% Toutes les cliques
array[1..nb_r_cliques, 1..r] of int: r_cliques;
array[1..nb_s_cliques, 1..s] of int: s_cliques;

function int: nb_cliques_local(int: m) =
  product([n - i | i in 2..m-1]) div product([i | i in 1..m-2]);
int: nb_r_cliques_local = nb_cliques_local(r);
int: nb_s_cliques_local = nb_cliques_local(s);

% Tableaux pointant aux cliques du tableau global
array[edges, 1..nb_r_cliques_local] of int: r_cliques_local_index;
array[edges, 1..nb_s_cliques_local] of int: s_cliques_local_index;

% Poids utilisés dans la fonction objective
int: c_r = s;
int: c_s = r;

% Génération aléatoire de l'état initial avec warm_start
function int: index_from_edge(int: i, int: j) = 
  ((i - 1) * n) - (((i - 1) * i) div 2) + (j - i);
array[edges] of bool: random_coloring_edges = [bernoulli(s / (r + s)) | i in edges];
array[vertices, vertices] of bool: random_coloring = array2d(vertices, vertices,
  [if (i == j)
    then false
   else
    (random_coloring_edges[index_from_edge(min(i, j), max(i, j))])
   endif
  | i in vertices, j in vertices]);
% ----- ENSEMBLES ----- 
set of int: vertices = 1..n;
set of int: edges = 1..nb_edges;

% ----- VARIABLES -----
array[vertices, vertices] of var bool: coloring;
array[1..nb_r_cliques] of var bool: is_r_clique;
array[1..nb_s_cliques] of var bool: is_s_clique;
array[edges] of var 0..nb_r_cliques_local: r_count;
array[edges] of var 0..nb_s_cliques_local: s_count;
var int: r_count_tot;
var int: s_count_tot;
var int: cost;

% ----- CONTRAINTES -----

constraint r <= s;

% Initialization
constraint forall(i in vertices, j in 1..i-1)
  (coloring[i,j] = coloring[j,i]);
constraint forall(i in vertices)
  (coloring[i,i] = false);

% Tableau de booléens qui dénotent les cliques monochromatiques
constraint forall(clique in 1..nb_r_cliques)
  (is_r_clique[clique] = forall(p in 1..r, q in p+1..r)
    (not coloring[r_cliques[clique, p], r_cliques[clique, q]]));
constraint forall(clique in 1..nb_s_cliques)
  (is_s_clique[clique] = forall(p in 1..s, q in p+1..s)
    (coloring[s_cliques[clique, p], s_cliques[clique, q]]));

% Compte nombre de cliques localement
constraint forall(k in edges)
  (r_count[k] =
    sum(clique in 1..nb_r_cliques_local)
      (bool2int(is_r_clique[r_cliques_local_index[k, clique]])));
constraint forall(k in edges)
  (s_count[k] =
    sum(clique in 1..nb_s_cliques_local)
      (bool2int(is_s_clique[s_cliques_local_index[k, clique]])));      

constraint r_count_tot = sum(k in edges)
  (r_count[k]);
constraint s_count_tot = sum(k in edges)  
  (s_count[k]);
constraint cost = c_r * r_count_tot + c_s * s_count_tot;

solve :: warm_start(coloring, random_coloring) minimize cost;

% ----- OUTPUT -----
output join("\n", [join(" ", [show(bool2int(coloring[i, j])) | j in vertices]) | i in vertices]);