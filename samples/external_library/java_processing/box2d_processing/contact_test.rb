load_library 'jbox2d'
require 'jruby/core_ext'
class JContactListener
  include org.jbox2d.callbacks.ContactListener

  def initialize()
  end
  java_signature "void beginContact(org.jbox2d.dynamics.contacts.Contact c)"
  def begin_contact(c)
  end
  java_signature "void endContact(org.jbox2d.dynamics.contacts.Contact c)"
  def end_contact(c)
  end
  java_signature "void beginContact(org.jbox2d.dynamics.contacts.Contact,org.jbox2d.callbacks.ContactImpulse )"
  def pre_solve(c, ci)
  end
  java_signature "void beginContact(org.jbox2d.dynamics.contacts.Contact,org.jbox2d.callbacks.ContactImpulse )"
  def post_solve(c, ci)
  end 
end



