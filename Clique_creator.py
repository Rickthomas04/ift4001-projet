# Olivianne Vaillancourt & Alexis Roberge
import itertools
import os

ensemble = []
n = 10
r = 3
s = 5
t = 0  # Si l'instance contient seulement 2 couleurs, mettre la valeur de t à 0
mode_local = False # True si l'on veut générer les cliques locales
for i in range(n):
    ensemble.append(i + 1)

clique_r = list(itertools.combinations(ensemble, r))
clique_s = list(itertools.combinations(ensemble, s))
clique_t = list(itertools.combinations(ensemble, t))
paires = list(itertools.combinations(ensemble, 2))

r_cliques_local = []
for a in paires:
    i = 1
    clique_local = []
    for c in clique_r:
        if (a[0] in c) and (a[1] in c):
            clique_local.append(i)
        i += 1
    r_cliques_local.append(clique_local)

s_cliques_local = []
for b in paires:
    i = 1
    clique_local = []
    for c in clique_s:
        if (b[0] in c) and (b[1] in c):
            clique_local.append(i)
        i += 1
    s_cliques_local.append(clique_local)

#Mettre le path du répertoire ou l'on veut avoir les fichier r_cliques
directory_r_path = ""
if mode_local : r_file_name = 'clique_r (' + str(r) + ';' + str(n) + ') local.dzn'
else : r_file_name = 'clique_r (' + str(r) + ';' + str(n) + ').dzn'
r_full_path = os.path.join(directory_r_path, r_file_name)
#Mettre le path du répertoire ou l'on veut avoir les fichier s_cliques
directory_s_path = ""
if mode_local : s_file_name = 'clique_s (' + str(s) + ';' + str(n) + ') local.dzn'
else : s_file_name = 'clique_s (' + str(s) + ';' + str(n) + ').dzn'
s_full_path = os.path.join(directory_s_path, s_file_name)
#Mettre le path du répertoire ou l'on veut avoir les fichier t_cliques
directory_t_path = ""
t_file_name = 'clique_t (' + str(t) + ';' + str(n) + ').dzn'
t_full_path = os.path.join(directory_t_path, t_file_name)

with open(r_full_path, 'w') as f:
    f.write("n = " + str(n) + ";\n")
    f.write("r = " + str(r) + ";\n")
    f.write("r_cliques = [")
    for ligne in clique_r:
        ligne_str = ', '.join(map(str, ligne))
        f.write('|' + ligne_str + '\n')
    f.write("|];" + '\n')
    if mode_local :
        f.write("r_cliques_local_index = [")
        for ligne in r_cliques_local:
            ligne_str = ', '.join(map(str, ligne))
            f.write('|' + ligne_str + '\n')
        f.write("|];" + '\n')
with open(s_full_path, 'w') as h:
    h.write("s = " + str(s) + ";\n")
    h.write("s_cliques = [")
    for ligne in clique_s:
        ligne_str = ', '.join(map(str, ligne))
        h.write('|' + ligne_str + '\n')
    h.write("|];" + '\n')
    if mode_local :
        h.write("s_cliques_local_index = [")
        for ligne in s_cliques_local:
            ligne_str = ', '.join(map(str, ligne))
            h.write('|' + ligne_str + '\n')
        h.write("|];" + '\n')
if t > 0:
    with open(t_full_path, 'w') as j:
        j.write("t = " + str(t) + ";\n")
        j.write("t_cliques = [")
        for ligne in clique_t:
            ligne_str = ', '.join(map(str, ligne))
            j.write('|' + ligne_str + '\n')
        j.write("|];" + '\n')

