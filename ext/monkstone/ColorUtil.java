/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package monkstone;

/**
 *
 * @author Martin Prout
 */
public class ColorUtil {

   /**
     * Returns hex long as a positive int unless greater than Integer.MAX_VALUE
     * else return the complement as a negative integer or something like that
     */
    static final int hexLong(long hexlong) {
        long SPLIT = Integer.MAX_VALUE + 1;
        if (hexlong < SPLIT) {
            return (int) hexlong;
        } else {
            return (int) (hexlong - SPLIT * 2L);
        }
    }

    static public int colorString(String hexstring) {
        return java.awt.Color.decode(hexstring).getRGB();
    }

    static public float colorLong(double hex) {
        return (float) hex;
    }
    
    static public int colorLong(long hexlong){
       return hexLong(hexlong);
    }

    static public float colorDouble(double hex){
       return (float)hex;
    }
}
