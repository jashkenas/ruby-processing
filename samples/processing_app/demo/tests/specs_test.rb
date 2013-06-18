def setup
  size(100, 100, P3D)
  puts(Java::Processing::opengl::PGraphicsOpenGL.OPENGL_VENDOR)
  puts(Java::Processing::opengl::PGraphicsOpenGL.OPENGL_RENDERER)
  puts(Java::Processing::opengl::PGraphicsOpenGL.OPENGL_VERSION)
  puts(Java::Processing::opengl::PGraphicsOpenGL.GLSL_VERSION)
  puts(Java::Processing::opengl::PGraphicsOpenGL.OPENGL_EXTENSIONS)
end



