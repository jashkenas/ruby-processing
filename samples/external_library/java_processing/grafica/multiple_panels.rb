load_library :grafica
include_package 'grafica'

N_POINTS = 21

def setup
  size(500, 500)
  background(255)

  first_plot_pos = [0, 0]
  panel_dim = [200, 200]
  margins = [60, 70, 40, 30]

  # Create four plots to represent the 4 panels
  plot1 = GPlot.new(self)
  plot1.set_pos(first_plot_pos.to_java(Java::float))
  plot1.set_mar([0, margins[1], margins[2], 0])
  plot1.set_dim(panel_dim.to_java(Java::float))
  plot1.set_axes_offset(0)
  plot1.set_ticks_length(-4)
  plot1.getXAxis.set_draw_tick_labels(false)
  
  plot2 = GPlot.new(self)
  plot2.set_pos(first_plot_pos[0] + margins[1] + panel_dim[0], first_plot_pos[1])
  plot2.set_mar([0, 0, margins[2], margins[3]])
  plot2.set_dim(panel_dim.to_java(Java::float))
  plot2.set_axes_offset(0)
  plot2.set_ticks_length(-4)
  plot2.getXAxis.set_draw_tick_labels(false)
  plot2.getYAxis.set_draw_tick_labels(false)
  plot3 = GPlot.new(self)
  plot3.set_pos(first_plot_pos[0], first_plot_pos[1] + margins[2] + panel_dim[1])
  plot3.set_mar([margins[0], margins[1], 0, 0])
  plot3.set_dim(panel_dim.to_java(Java::float))
  plot3.set_axes_offset(0)
  plot3.set_ticks_length(-4)
  plot4 = GPlot.new(self)
  plot4.set_pos(first_plot_pos[0] + margins[1] + panel_dim[0], first_plot_pos[1] + margins[2] + panel_dim[1])
  plot4.set_mar([margins[0], 0, 0, margins[3]])
  plot4.set_dim(panel_dim.to_java(Java::float))
  plot4.set_axes_offset(0)
  plot4.set_ticks_length(-4)
  plot4.getYAxis.set_draw_tick_labels(false)

  # Prepare the points for the four plots
  points1 = GPointsArray.new(N_POINTS)
  points2 = GPointsArray.new(N_POINTS)
  points3 = GPointsArray.new(N_POINTS)
  points4 = GPointsArray.new(N_POINTS)
  
 N_POINTS.times do |i|
    points1.add(sin(TAU*i/(N_POINTS-1)), cos(TAU*i/(N_POINTS-1)))
    points2.add(i, cos(TAU*i/(N_POINTS-1)))
    points3.add(sin(TAU*i/(N_POINTS-1)), i)
    points4.add(i, i)
 end
  
  # Set the points, the title and the axis labels
  plot1.set_points(points1)
  plot1.getYAxis.set_axis_label_text("cos(i)")
  plot1.set_title_text("Plot with multiple panels")
  plot1.get_title.set_relative_pos(1)
  plot1.get_title.set_text_alignment(CENTER)

  plot2.set_points(points2)

  plot3.set_points(points3)
  plot3.getXAxis.set_axis_label_text("sin(i)")
  plot3.getYAxis.set_axis_label_text("i")
  plot3.setInvertedYScale(true)

  plot4.set_points(points4)
  plot4.getXAxis.set_axis_label_text("i")
  plot4.setInvertedYScale(true)
  
  # Draw the plots
  plot1.begin_draw
  plot1.draw_box
  plot1.drawXAxis
  plot1.drawYAxis
  plot1.draw_top_axis
  plot1.draw_right_axis
  plot1.draw_title
  plot1.draw_points
  plot1.draw_lines
  plot1.end_draw

  plot2.begin_draw
  plot2.draw_box
  plot2.drawXAxis
  plot2.drawYAxis
  plot2.draw_top_axis
  plot2.draw_right_axis
  plot2.draw_points
  plot2.draw_lines
  plot2.end_draw
  
  plot3.begin_draw
  plot3.draw_box
  plot3.drawXAxis
  plot3.drawYAxis
  plot3.draw_top_axis
  plot3.draw_right_axis
  plot3.draw_points
  plot3.draw_lines
  plot3.end_draw

  plot4.begin_draw
  plot4.draw_box
  plot4.drawXAxis
  plot4.drawYAxis
  plot4.draw_top_axis
  plot4.draw_right_axis
  plot4.draw_points
  plot4.draw_lines
  plot4.end_draw
end
