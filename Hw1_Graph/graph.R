is_valid = function(g){
  # Check each of 6 criteria to determine if g is a graph #
  # If a test fails at any step, function stops and returns FALSE #
  
  # Check if input is a list and not an empty list#
  if(is.list(g) == FALSE | length(g) == 0) {
    return(FALSE)
  }

  # if gr is a list, get number of verticies #
  numVert = length(g)
  # Check if g is a list of lists and that nested lists not empty. #
  for(i in 1:numVert){
    if(is.list(g[[i]]) == FALSE | length(g[[i]]) == 0) {
      return(FALSE)
    }
  }
  
  # Check if each secondary list contains edges and weights vectors #
  for(i in 1:numVert){
    if(length(g[[i]]) == 0) {
      return(FALSE)
    }
    if(!(all(c("edges", "weights") %in% names(g[[i]])))){
      return(FALSE)
    }
  }
  
  namesGraph = names(g)
  # Check if there are names for the primary list that they are all unique #
  if(length(namesGraph) == 0){
    return(FALSE)
  }
  #Vector of unique names should have same length as vector of all vertex names#
  if(length(unique(namesGraph))!=length(namesGraph)){
    return(FALSE)
  }
  for(j in 1:numVert){
    # Check that each secondary list contains only edges and weights #
    # vectors that are of the appropriate type. #
    # First elements in list for each vertex are the edges, #
    # should be integers or NULL #
    if(typeof(g[[namesGraph[j]]][["edges"]]) !="integer" &
       typeof(g[[namesGraph[j]]][["edges"]]) !="NULL"){
      return(FALSE)
    }
    # Second elements in list for each vertex are the weights, #
    # should be doubles or NULL #
    if(typeof(g[[namesGraph[j]]][["weights"]]) !="double" &
       typeof(g[[namesGraph[j]]][["weights"]]) !="NULL"){
      return(FALSE)
    }
    # Check that all edges have weights #
    if(length(g[[namesGraph[j]]][["edges"]]) !=
       length(g[[namesGraph[j]]][["weights"]])){
      return(FALSE)
    }
    # Check that there is no duplicated edges #
    if(length(g[[namesGraph[j]]][["edges"]]) !=
       length(unique(g[[namesGraph[j]]][["edges"]]))){
      return(FALSE)
    }
    # Check that all weights are not less than or equal to 0 #
      if(length(g[[namesGraph[j]]][["edges"]]) != 0 &
         length(g[[namesGraph[j]]][["weights"]]) != 0){
        if(g[[j]][["weights"]] <= 0 || is.na(g[[j]][["weights"]]) ||
           is.na(g[[j]][["edges"]])){
          return(FALSE)
        }
        # Check that there are not any edges to non-existent vertices. #
        # Assume vertices labeled as integers in numerical order. #
        if(any(g[[j]][["edges"]] > numVert)){
          return(FALSE)
        }
      }
  
  }
  return(TRUE)
}



# function to tell if a graph is undirected #
# input g is a graph #
# returns TRUE if function undirected #
# returns FALSE otherwise #
is_undirected = function(g) {
  # checks that graph is valid #
  if (is_valid(g) == FALSE) {
    stop("The input is not a valid graph")
  }
  
  # create adjacency matrix from helper function #
  ajmatrix = adjacency_matrix(g)
  # takes transpose of adjacency matrix #
  ajmatrix.tran = t(ajmatrix)
  
  # checks to see if matrix and tranpose are identical #
  if(identical(ajmatrix, ajmatrix.tran) && length(g) >= 1) {
    return(TRUE)
  } else {
    return(FALSE)
  }
}



is_isomorphic = function(g1, g2){
  if (is_valid(g1) == FALSE || is_valid(g2) == FALSE) {
    stop("The input is not a valid graph")
  }
  # Check if both graphs are of equal length, return FALSE if not #
  if (length(g1) != length(g2)){
    return(FALSE)
  }
  # Check if both graphs have the sames labels, return FALSE if not #
  if (identical(sort(names(g1)), sort(names(g2))) == FALSE){
    return(FALSE)
  }
  for(count1 in 1:length(g1)){
    #Get label of ith vertice in graph1 #
    label.track =  names(g1[count1])
    # Get indexes of edges of ith vertice in graph1 (could be vector) #
    edge.trackg1 =  g1[[label.track]]$edges
    # Get weight of associated with each edge(could also be a vector) #
    weight.trackg1 = g1[[label.track]]$weights
    # define a list that will hold labels of each edge and and its associated weight of graph1 for ith vertice #
    g1comp_list = list()
    # loop through the edges, and determine the associated label in graph1 and store it in a vector #
    if(length(edge.trackg1)>0){
      for (count2 in 1:length(edge.trackg1)){
        g1comp_list[[count2]]  = list(names(g1[edge.trackg1[count2]]), weight.trackg1[count2])
      }
    }
    # Find label of ith vertice in graph1 in graph2, and determine associated indexes and weights #
    edge.trackg2 =  g2[[label.track]]$edges
    weight.trackg2 = g2[[label.track]]$weights
    # define a list that will hold labels of each edge and #
    # its associated weight for graph2 for vertice associated with label.track #
    g2comp_list = list()
    # loop through the edges, and determine the associated label in graph2 and store it in a vector #
    if(length(edge.trackg2)>0){
      for (count3 in 1:length(edge.trackg2)){
        g2comp_list[[count3]]  = list(names(g2[edge.trackg2[count3]]), weight.trackg2[count3])
      }
    }
    # Find intersection of g1comp_list and g2comp_list and see it is equal to g1comp_list #
    # If it is equal, the result implies that equated labels in both graphs have the same structure #
    # If not flag is updated to 1 #
    if (!identical(g1comp_list, g1comp_list[g1comp_list %in% g2comp_list]) | !identical(g2comp_list, g2comp_list[g2comp_list %in% g1comp_list])){
      return(FALSE)
    }
  }
  return(TRUE)
}



# helper function to create adjacency matrix #
# input is a graph g #
# output is an N by N matrix#
adjacency_matrix = function(g){
  # set size of adjacency matrix #
  N <- length(names(g))
  # initiate the adjacency matrix #
  ajmatrix <- matrix(0, nrow = N, ncol = N)
  # assign values to the adjacency matrix #
  for(i in 1:N){
    ajmatrix[i, g[[i]][["edges"]]] <- g[[i]][["weights"]]
  }
  return(ajmatrix)
}



is_connected = function(g, v1, v2){
  # store the vertex label #
  names.graph <- names(g)
  # check validity of the graph #
  if(is_valid(g) == FALSE){
    stop("The input is not a valid graph")
  }
  # check if v1 and v2 are in g #
  if(!(v1 %in% names.graph & v2 %in% names.graph)){
    stop("invalid vertex label")
  }
  # create adjacency matrix from helper function #
  ajmatrix <- adjacency_matrix(g)
  # set loop to size of matrix #
  N <- nrow(ajmatrix)
  # assign values to the adjacency matrix to several powers #
  for(i in 1:N){
    if(i == 1){
      ajmatrix.N <- ajmatrix
    } else {
      ajmatrix.N <- ajmatrix %*% ajmatrix.N
      # check if there is a path from v1 to v2 #
    }
    if(ajmatrix.N[which(names.graph == v1), which(names.graph == v2)] > 0){
      return(TRUE)
    }
  }
  return(FALSE)
}



# Influenced by Dijkstra's Algorithm with C code provided from: #
# http://www.codewithc.com/dijkstras-algorithm-in-c/ #
# Also referenced Wikipedia article on Dijkstra's Algorithm #

# Returns shortest path between two verticies in a graph #
# Input is a graph, g, a source vertex v1 and a target vertex v2 #
shortest_path = function(g, v1, v2){
  
  
  
  # Function can't run if input not a graph #
  if(is_valid(g)==FALSE){
    stop("Input is not a valid graph")
  }
  # Return empty vector if v1 and v2 are not connected #
  if(is_connected(g, v1, v2) == FALSE){
    return(c())
  }
  #Sum_weight finds the sum of all weights in a graph, g#
  sum_weight = function(g){
    sum.edge = 0
    for(i in 1:length(g)){
      sum.edge = sum.edge + sum(g[[i]]$weights)
    }
    return(sum.edge)
  }
  
  # Define infinity as 10 more than the sum of all weights in g #
  Infinity = sum_weight(g)+10
  N = length(g)
  # Convert vertex labels to integers based on their position #
  int.v1 = which(names(g) == v1)
  int.v2 = which(names(g) == v2)
  
  # create adjacency matrix of connected weights #
  # if elements not connected, weight between them is INF, initialize matrix to INF #
  cost = matrix(Infinity, nrow = N, ncol = N)
  for (i in 1:N) {
    for (j in 1:N) {
      if(length(g[[i]]$edges) == 0){
        if (i == j) { #elements on diagonal are 0
          cost[i, j] = Infinity
        }
      }
      else{
        for(k in 1:length(g[[i]]$edges)){
          if (g[[i]]$edges[[k]] == j) {
            # Find which edge k for vertex i is connected to vertex j #
            # Set cost[i, j] = the weight for this edge #
            cost[i, j] = g[[i]]$weights[[which(g[[i]]$edges == j)]]
          }
        }
      }
    }
  }
  #Algortithm does not revist already visited verticies#
  #Special case when v1 = v2#
  if(v1 == v2){
    currentMin = which.min(cost[int.v1, ])
    #If shortest path from v1 to v1 is just through itself, return "v1" "v1"#
    if(currentMin == int.v1){
      return(c(v1, v2))
    }
    else if(cost[int.v1, int.v1] == min(cost[int.v1,])){
      return(c(v1, v2))
    }
    
    #Otherwise, might have to visit another vertex first for shortest path#
    else if(which.min(cost[currentMin,]) == int.v1){
      return(names(g)[c(int.v1, currentMin, int.v1)])
    }
  }

  
  # Initialize various vectors to 0 #
  # Initialize distances between vertices to infinity to begin #
  distance = rep(Infinity,N)
  # Initialize previous vertex to -1 so it is undefined to begin #
  prev = rep(-1,N)
  # Vector of verteces selected for comparison, initalize to 0 since none selected #
  selected = rep(0,N)
  # Vector of final shortest path #
  path = rep(0,N)
  
  
  
  # Path starts at v1, start then denotes the current vertex that we are considering #
  # as the source (from which distances to other verticies are measured) #
  start = int.v1
  # We select the vertix at start #
  selected[start] = 1
  # Initial distance to start is 0 #
  distance[start] = 0
  
  # Find shortest path while the target v2 is unselected #
  while(selected[int.v2] == 0) {
    min = Infinity
    m = 0
    for(k in 1:N){
      # For each current vertex, calculate new distance between this vertex and all #
      # other unvisited verticies #
      d = distance[start] + cost[start, k]
      # If this new distance between the current vertex and vertex k #
      # is less than the previous distance[k] and if vertex k is unvisited, set #
      # distance[k] to this new smaller distance d #
      # and note that we have now visited this vertex, prev[k] = start #
      if((d < distance[k]) & (selected[k] == 0)){
        distance[k] = d
        prev[k] = start
      }
      # If the distance between the two considered verticies is less than min #
      # which is initialized to INF and we have not yet selected or visited the #
      # vertex k, we set min to distance[k] and index m as k #
      # m updates what our current vertex considered as the source is #
      if((min > distance[k]) & (selected[k] == 0)){
        min = distance[k]
        m = k
      }
    }
    # Current vertex considered (which equals start) is set to m #
    start = m
    # Note that we have now visited vertex start and do not visit it again #
    selected[start] = 1
  }
  # After looping through all verticies as the start vertix, we set start to be #
  # vertex v2 #
  start = int.v2
  l = 0
  # We then select the verticies visited on our shortest path #
  # If a vertex is not in shortest path, start = -1, so start != -1 is the condition #
  # for the while loop to select all verticies in the path #
  while (start != -1) {
    l = l+1
    path[l] = start
    start = prev[start]
  }
  # Need to reverse order of elements in path to go from v1 to v2 #
  out.path = rev(path)
  out.verts = names(g)[out.path]
  return(out.verts)
}
