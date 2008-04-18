// A RubyLauncher for Launchin' that Ruby code.
// -- omygawshkenas

import java.util.Arrays;
import java.io.*;
import java.lang.reflect.InvocationTargetException;

import org.jruby.Ruby;
import org.jruby.RubyInstanceConfig;
import org.jruby.javasupport.JavaUtil;
import org.jruby.runtime.builtin.IRubyObject;

public class RubyLauncher {
  private Ruby runtime;
  private IRubyObject rubyObject;
  private IRubyObject mainClass;
  
  public RubyLauncher(String args[]) {
    final RubyInstanceConfig config = new RubyInstanceConfig() {{
      setObjectSpaceEnabled(false);
    }};
    runtime = Ruby.newInstance(config);
    rubyObject = JavaUtil.convertJavaToUsableRubyObject(runtime, this);
    rubyObject.dataWrapStruct(this);
    runtime.defineGlobalConstant("JRUBY_APPLICATION", rubyObject);
    mainClass = JavaUtil.convertJavaToUsableRubyObject(runtime, args[0]);
    runtime.defineGlobalConstant("JRUBY_MAIN_CLASS", mainClass);
    
    try {
      BufferedInputStream code = new BufferedInputStream(new FileInputStream(args[0]));
      runtime.runFromMain(code, args[0]);
    } catch (IOException e) {
      System.err.println("Error: " + e.getCause());
    }
    
  }
  static public void main(String args[]) {  
    RubyLauncher launcher = new RubyLauncher(args);   
  }
}