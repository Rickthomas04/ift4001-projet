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
var 0..nb_r_cliques: r_monochromatic;
var 0..nb_s_cliques: s_monochromatic;

% ---------- CONTRAINTES ----------
constraint r <= s;

% Initialisation
constraint forall(i in vertices, j in 1..i)
  (coloring[i,j] = false);

% Compte cliques de taille r qui sont "false" monochromatiques
constraint r_monochromatic = sum(i in 1..nb_r_cliques)
  (bool2int(forall(j in 1..r-1, k in j+1..r)
    (not coloring[r_cliques[i,j], r_cliques[i,k]])));
      
% Compte cliques de taille s qui sont "true" monochromatiques
constraint s_monochromatic = sum(i in 1..nb_s_cliques)
  (bool2int(forall(j in 1..s-1, k in j+1..s)
    (coloring[s_cliques[i,j], s_cliques[i,k]])));

solve minimize s * r_monochromatic + r * s_monochromatic;
% ---------- OUTPUT ----------
output join("\n", [join(" ", [show(bool2int(coloring[i, j])) | j in vertices]) | i in vertices]);