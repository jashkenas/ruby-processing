
#
# This example implements a custom VolumetricSpace using an implicit function
# to calculate each voxel. This is slower than the default array or HashMap
# based implementations, but also has much less memory requirements and so might
# be an interesting and more viable approach for very highres voxel spaces
# (e.g. >32 million voxels). This implementation here also demonstrates how to
# achieve an upper boundary on the iso value (in addition to the one given and
# acting as lower threshold when computing the iso surface)
#
# Usage:
# move mouse to rotate camera
# -/=: zoom in/out
# l: apply laplacian mesh smooth
# 
#

# 
# Copyright (c) 2010 Karsten Schmidt & ruby-processing version Martin Prout 2013
# This sketch relies on a custom ruby-processing mesh_to_vbo library
# 
# This library is free software you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation either
# version 2.1 of the License, or (at your option) any later version.
# 
# http://creativecommons.org/licenses/LGPL/2.1/
# 
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
# 
# You should have received a copy of the GNU Lesser General Public
# License along with this library if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#

load_libraries 'toxiclibscore', 'vbo', 'volumeutils'

module Toxi
  include_package 'toxi.geom'
  include_package 'toxi.geom.mesh'
  include_package 'toxi.volume'
  include_package 'toxi.processing'
end

RES = 64
ISO = 0.2
MAX_ISO = 0.66

attr_reader :mesh, :vbo, :curr_zoom, :implicit

def setup
  size(720,720, P3D)
  @vbo = MeshToVBO.new(self)
  @curr_zoom = 1
  vol = EvaluatingVolume.new(Toxi::Vec3D.new(400,400,400), RES, RES, RES, MAX_ISO)
  surface = Toxi::HashIsoSurface.new(vol)
  @mesh = Toxi::WETriangleMesh.new
  surface.compute_surface_mesh(mesh, ISO)
  @is_wire_frame = false
  no_stroke
  @implicit = vbo.meshToVBO(mesh, true)
  implicit.setFill(color(222, 222, 222))
  implicit.setAmbient(color(50, 50, 50))
  implicit.setShininess(color(10, 10, 10))
  implicit.setSpecular(color(50, 50, 50))
end

def draw
  background(0)
  lights
  define_lights
  translate(width / 2.0, height / 2.0, 0)
  rotate_x(mouse_y * -0.01)
  rotate_y(mouse_x * -0.01)
  scale(curr_zoom)
  shape(implicit)
end

def key_pressed
  case key
  when '-'
    @curr_zoom -= 0.1
  when '='
    @curr_zoom += 0.1
  when 'l', 'L'
    Toxi::LaplacianSmooth.new.filter(mesh, 1)
    @implicit = vbo.meshToVBO(mesh, true)
    # new mesh so need to set finish
    implicit.setFill(color(222, 222, 222))
    implicit.setAmbient(color(50, 50, 50))
    implicit.setShininess(color(10, 10, 10))
    implicit.setSpecular(color(50, 50, 50))
  when 's', 'S'
    save_frame("implicit.png")
  end
end

def define_lights  
  ambient_light(50, 50, 50)
  point_light(30, 30, 30, 200, -150, 0)
  directional_light(0, 30, 50, 1, 0, 0)
  spot_light(30, 30, 30, 0, 40, 200, 0, -0.5, -0.5, PI / 2, 2)
end

class EvaluatingVolume < Toxi::VolumetricSpace
  include Processing::Proxy
  java_import 'toxi.math.SinCosLUT'
  
  attr_reader :upper_bound, :lut
  FREQ = PI * 3.8
  
  def initialize(scal_vec, resX, resY, resZ, upper_limit)
    super(scal_vec, resX, resY, resZ)
    @upper_bound = upper_limit
    @lut=SinCosLUT.new
  end
  
  def clear
    # nothing to do here
  end
  
  def getVoxelAt(i)
    getVoxel(i % resX, (i % sliceRes) / resX, i / sliceRes)
  end
  
  def getVoxel(x, y, z)  # can't overload so we renamed
    val = 0
    if (x > 0 && x < resX1 && y > 0 && y < resY1 && z > 0 && z < resZ1)
      xx = x * 1.0 / resX - 0.5  # NB: careful about integer division !!!
      yy = y * 1.0 / resY - 0.5
      zz = z * 1.0 / resZ - 0.5
      #val = lut.sin(xx * FREQ) + lut.cos(yy * FREQ) + lut.sin(zz * FREQ)
      val = lut.cos(xx * FREQ) * lut.sin(yy* FREQ) + lut.cos(yy* FREQ) * lut.sin(zz* FREQ) + lut.cos(zz* FREQ)* lut.sin(xx* FREQ)
      if (val > upper_bound)
        val = 0
      end
    end
    return val
  end
end
