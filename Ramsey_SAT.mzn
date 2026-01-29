%Olivianne Vaillancourt & Alexis Roberge
% ---------- CONSTANTES ----------
int: n;
int: r;
int: s;
array[1..nb_r_cliques, 1..r] of int: r_cliques;
array[1..nb_s_cliques, 1..s] of int: s_cliques;

function int: nb_cliques(int: m) =
  product([n - i + 1 | i in 1..m]) div product([m - i + 1 | i in 1..m]);
int: nb_r_cliques = nb_cliques(r);
int: nb_s_cliques = nb_cliques(s);

% ---------- ENSEMBLES ----------
set of int: vertices = 1..n;

% ---------- VARIABLES ----------
array[vertices, vertices] of var bool: coloring;
%array[vertices] of var int: true_colored_count;

% ---------- CONTRAINTES ----------

constraint r <= s;

% Initialisation de la matrice des coloriages
constraint forall(i in vertices, j in 1..i-1)
  (coloring[i,j] = coloring[j,i]);
constraint forall(i in vertices)
  (coloring[i,i] = false);

% Aucune clique de couleur "false" et taille r
constraint forall(i in 1..nb_r_cliques)
  (exists(j in 1..r-1, k in j+1..r)
    (coloring[r_cliques[i,j], r_cliques[i,k]]));
  
% Aucune clique de couleur "true" et taille s
constraint forall(i in 1..nb_s_cliques)
  (exists(j in 1..s-1, k in j+1..s)
    (not coloring[s_cliques[i,j], s_cliques[i,k]]));

% On compte le nombres de couleur "true" dans chaque rangée du coloriage
%constraint forall(i in vertices)
%  (count_eq(row(coloring, i), true, true_colored_count[i]));

% ** Contraintes de bris de symétrie **

%constraint s * count(coloring, false) <= r * (count(coloring, true) + n);

% Bris de symétrie lexicographique
% O(n) contraintes 
%constraint lex_chain_lesseq(coloring);

% Bris de symétrie lexicographique amélioré
% O(n^2) contraintes
constraint forall(i in vertices, j in i+1..n) (lex_lesseq(
  row(coloring, i)[1..i-1] ++ row(coloring, i)[i+1..j-1] ++ row(coloring, i)[j+1..n],
  row(coloring, j)[1..i-1] ++ row(coloring, j)[i+1..j-1] ++ row(coloring, j)[j+1..n])
);

solve satisfy;

% ----- OUTPUT -----
output join("\n", [join(" ", [show(bool2int(coloring[i, j])) | j in vertices]) | i in vertices]);
