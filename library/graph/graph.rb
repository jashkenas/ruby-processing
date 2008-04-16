# Graph library for Ruby-Processing
# After Tom de Smedt's version for NodeBox.
# -- omygawshkenas

module Graphing
  LAYOUT_CIRCLE = :circle
  LAYOUT_SPRING = :spring
  RAD = 8
  
  class Node
    include Math

    def initialize(graph, opts={})
      @app = Processing::App.current
      defaults = {:graph => graph,
        :id => "", 
        :radius => RAD, 
        :style => Style::DEFAULT, 
        :category => "", 
        :label => nil,
        :vx => 0, :vy => 0 }.merge(opts)
        defaults.each_key {|k| instance_variable_set(k, defaults[k])}
     @label ||= @id
     @links = links()
     @force = layout.point(0, 0)
     @betweenness, @eigenvalue = nil, nil
    end
    
    def get_edges
      @links.edges.values
    end
    
    def get_betweenness
      @betweenness || @graph.betweenness_centrality
    end
    
    def get_eigenvalue
      @eigenvalue || @graph.eigenvector_centrality
    end
    
    def x
      @vx * @graph.d
    end

    def y
      @vy * @graph.d
    end

    def contains(point)
      # True if the point is in this node's absolute position
      return true if abs(@graph.x + x - point.x) < @radius * 2 && abs(@graph.y + y - point.y) < @radius * 2
      return false  
    end
  end
  
  class Links
    def initialize
      @edges = {}
      @links = []
    end

    def append(node, edge = nil)
      @edges[node.id] = edge if edge
      @links << node
    end

    def remove(node)
      @edges.delete(node.id) if @edges[node.id]
      @links.delete(node)
    end

    def edge(id)
      id = id.id if id.is_a? Node
      @edges[id]
    end
  end
  
  class Edge
    attr_accessor :node1, :node2, :weight, :label
    def initialize(node1, node2, weight=0.0, label="")
      @node1, @node2, @weight, @label = node1, node2, weight, label
    end
  end
  
  class Graph
    MULT = 2.5

    def initialize(iterations=1000, distance=1.0, layout=LAYOUT_SPRING)
      @graph = {}
      @nodes, @edges = [], []
      @root = nil
      @layout = # TODO
      @d = RAD * MULT * distance
      @styles = # Todo
      @alpha = 0
    end

    def get_distance
      @d / RAD * 2.5
    end

    def set_distance(val)
      @d = RAD * 2.5 * val
    end
    
    def copy( empty=false )
      g = Graph.new(@layout.n, @d, @layout.type)
      g.layout = @layout.copy(g)
      g.styles = @styles.copy(g)
      unless empty
        @nodes.each {|n| g.add_node(n.id, n.r, n.style, n.category, n.label, (n == @root))}
        @edges.each {|e| g.add_edge(e.node1.id, e.node2.id, e.weight, e.label)}
      end
      return g
    end

    def clear
      @graph.clear
      @nodes, @edges = [], []
      @root = nil
      @layout.i = 0
      @alpha = 0
    end
    
    def add_node(id, radius=8, style=Style::DEFAULT, category="", label=nil, root=false)
      return @graph[id] if @graph[id]
      style = style.name if style.is_a? Style
      n = Node.new(id, radius, style, category, label)
      @graph[n.id] = n
      @nodes << n
      @root = n if root
      return n
    end
    
    def add_nodes(nodes)
      nodes.each {|n| self.add_node(n) }
    end
    
    def add_edge(id1, id2, weight=0.0, label="")
      # The weight of the edge represents importance, not cost. (0.0..1.0)
      return nil if id1 == id2
      self.add_node(id1) unless @graph.has_key?(id1)
      self.add_node(id2) unless @graph.has_key?(id2)
      n1, n2 = @graph[id1], @graph[id2]
      
      # Don't duplicate a -> b, but b -> a is ok.
      return self.edge(id1, id2) if n2.links.include?(n1) && n2.links.edge(n1).node1 == n1
        
      weight = [0.0, [weight, 1.0].min ].max
      e = Edge.new(n1, n2, weight, label)
      @edges << e
      n1.links.append(n2, e)
      n2.links.append(n1, e)
      return e
    end 
    
    def remove_node(id)
      if @graph.has_key?(id)
        n = @graph[id]
        @nodes.delete(n)
        @graph.delete(id)
        
        # Then remove all edges and links.
        @edges.each do |e|
          nodes = [e.node1, e.node2]
          if nodes.include?(n)
            nodes.each {|other| other.links.remove(n) if other.links.include?(n) }
          end
          @edges.delete(e)
        end
      end
    end
    
    def remove_edge(id1, id2)
      @edges.each do |e|
        ids = [e.node1.id, e.node2.id]
        if ids.include?(id1) && ids.include?(id2)
          e.node1.links.remove(e.node2)
          e.node2.links.remove(e.node1)
          @edges.delete(e)
        end
      end
    end
    
    def node(id)
      return @graph[id]
    end
    
    def edge(id1, id2)
      links = @graph[id1].links
      links.include?(id2) ? links.edge(id2) : nil
    end
    
    def update(iterations=10)
      # Iterates the layout, updates node positions
      @alpha += 0.05
      @alpha = 1.0 if @alpha > 1.0
      
      # Each step, the bounds are recalculated.
      i = @layout.i
      if i == 0
        @layout.prepare
        @layout.i += 1
      elsif i == 1
        @layout.iterate
      elsif i < @layout.n
        n = [iterations, (i / 10 + 1)].min
        n.times { @layout.iterate }
      end
      
      # Calculate the absolute center.
      min, max = @layout.bounds
      @x = (@app.width - max.x*@d - min.x*@d) / 2
      @y = (@app.height - max.y*@d - min.y*@d) / 2
      return !(@layout.done?)
    end
    
    def solve
      @layout.solve
      @alpha = 1.0
    end
    
    def done?
      @layout.done?
    end
    
    def offset(node)
      [@x + node.x - @app.width / 2, @y + node.y - @app.height / 2]
    end
    
    def draw(opts)
      # Layout the graph in increments.
      opts = {:dx => 0, :dy => 0, 
              :weighted => false, 
              :directed => false, 
              :highlight => [], 
              :traffic => nil }.merge(opts)
      self.update
      s = @styles.default
      s.graph_background(s)
      
      # Center the graph on the page.
      @app.push_matrix
      @app.translate(@x + opts[:dx], @y + opts[:dy])
      
      # Indicate betweenness centrality ???
      traffic = opts[:traffic]
      if traffic
        traffic = 5 if traffic == true
        self.node_by_betweenness(traffic).each do |node|
          s = @styles[n.style] || @styles.default
          s.graph_traffic(s, n, @alpha) if s.graph_traffic
        end
      end
      
      # Draw the edges and edge labels.
      s = @styles.default
      s.edges(s, @edges, @alpha, opts[:weighted], opts[:directed]) if s.edges
      
      # Draw each node, with style.
      @nodes.each do |n|
        s = @styles[n.style] || @styles.default
        s.node(s, n, @alpha) if s.node
        s.node_label(s, n, @alpha) if s.node_label
      end
      
      # Highlight the shortest path.
      s = @styles.highlight || @styles.default
      s.path(s, self, highlight) if s.path
    end
    
    def prune(depth=0)
      @nodes.each {|n| self.remove_node(n.id) if n.links.size <= depth }
    end
    alias_method :trim, :prune
    
    def shortest_path(id1, id2, heuristic=nil)
      Proximity.dijkstra_shortest_path(self, id1, id2, heuristic)
    end
    
    def betweenness_centrality(normalized=true)
      # Calculates and returns node id => betweenness
      bc = Proximity.brandes_betweenness_centrality(self, normalized)
      bc.iter_items.each {|k, v| @graph[k].betweenness = v }
      return bc
    end
    
    def eigenvector_centrality( normalized=true, reversed=true, rating={},
                               start=nil, iterations=100, tolerance=0.0001) 
      ec = Proximity.eigenvector_centrality(self, normalized, reversed, rating, start, iterations, tolerance)
      ec.iter_items.each {|k, v| @graph[k].eigenvalue = v}
      return ec
    end
    
    def nodes_by_betweenness(threshold=0.0)
      # Heavily traffiked nodes come first.
      nodes = @nodes.select {|n| n.betweenness > threshold }
      nodes = nodes.sort_by {|a, b| b.betweenness <=> a.betweenness }
    end
    alias_method :nodes_by_traffic, :nodes_by_betweenness
    
    def nodes_by_eigenvalue(threshold=0.0)
      # Heavily traffiked nodes (by eigenvalue) come first.
      nodes = @nodes.select{|n| n.eigenvalue > threshold}
      nodes = nodes.sort_by {|a, b| b.eigenvalue <=> a.eigenvalue }
    end
    alias_method :nodes_by_weight, :nodes_by_eigenvalue
    
    def nodes_by_category(category)
      @nodes.select {|n| n.category == category}
    end
    
    def density
      # The number of edges in relation to the total possible edges.
      2.0 * @edges.size / (@nodes.size * (@nodes.size - 1))
    end
    
    def is_complete; self.density == 1.0; end
    def is_dense; self.density > 0.65; end
    def is_sparse; self.density < 0.35; end
    
    def sub(id, distance=1)
      Cluster.subgraph(self, id, distance)
    end
    alias_method :subgraph, :sub
  end
  
end





