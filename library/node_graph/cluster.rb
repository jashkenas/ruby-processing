# Set theory, cliques and subgraphs...
# by Tom de Smedt
#
# -- omygawshkenas

module NodeGraph
  module Cluster
    
    # SET THEORY
  
    def self.flatten(node, distance=1)
      # Recursively lists the node's links, out to a given distance.
      return node.nodes.map {|n| n.id} if node.respond_to?(:nodes)
      all = [node].flatten
      if distance >= 1
        node.links.each do |n|
          all << flatten(n, distance-1)
        end
      end
      return all.uniq
    end
    
    def self.intersection(a, b)
      # Returns elements that appear in both a and b.
      return a & b
    end
    
    def self.union(a, b)
      # Return all the elements from a and all from b.
      return a | b
    end
    
    def difference(a, b)
      # Return all a that don't appear in b.
      return a.reject {|el| b.include?(el) }
    end
    
    # SUBGRAPHS
    
    def subgraph(graph, id, distance=1)
      # Creates the subgraph from the node with the given id(s).
      g = graph.copy(true)
    
  end
end