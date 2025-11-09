from itertools import combinations
from sage.graphs.graph_generators import graphs
from sage.all import graphics_array

#Preveri če je S liho-neodvisna množica v G.
#Pogoji:
#    (i) S je neodvisna množica;
#    (ii) vsak v, ki ne pripada S, nima nobenega soseda v S ali ima liho število sosedov v S

def is_odd_independent(G, S):
    S = list(S)

    # (i)
    for u, v in combinations(S, 2):
        if G.has_edge(u, v):
            return False

    # (ii)
    V = set(G.vertices())
    Sset = set(S)
    for v in V - Sset:
        st = 0
        for u in S:
            if G.has_edge(u, v):
                st += 1
        if st != 0 and (st % 2 == 0):
            return False

    return True


#Preveri, če alpha_od(G) = 1 (ne obstaja liho-neodvisna množica S z |S| >= 2).

def alpha_od_is_one(G):
    V = list(G.vertices())
    n = len(V)
    if n < 2:
        return True

    for k in range(2, n + 1):
        for S in combinations(V, k):
            if is_odd_independent(G, S):
                return False  # našli smo večjo množico

    return True


#Za vsak n = 1, ..., 9 prešteje grfe z alpha_od(G) = 1 in jih nariše.

def count_and_draw_alpha_od_1(n_max=9, only_connected=False, draw_threshold=6, max_cols=5):
    results = {}
    counts = {} 

    for n in range(1, n_max + 1):
        st = 0
        grafi = []

        for G in graphs(n):
            if only_connected and not G.is_connected():
                continue
            if alpha_od_is_one(G):
                st += 1
                if n <= draw_threshold:
                    grafi.append(G)

        counts[n] = st

        print(f"n = {n}: število grafov z alpha_od(G) = 1 -> {st}")

        # risanje grafov
        if n <= draw_threshold and grafi:
            results[n] = [G.graph6_string() for G in grafi]
            plots = [g.plot() for g in grafi]
            ncols = min(max_cols, len(plots))
            nrows = (len(plots) + ncols - 1) // ncols
            GA = graphics_array(plots, nrows, ncols)
            show(GA, figsize=(3*ncols, 3*nrows))
        elif n <= draw_threshold:
            print("  (ni grafov z alpha_od(G) = 1 za to n)")

        print("-" * 40)

    return counts, results
