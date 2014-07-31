// Daniel Shiffman
// The Nature of Code, Fall 2006
// Neural Network

// Class to describe a connection between two neurons

package nn;

public class Connection {

    private final Neuron from;     // Connection goes from. . .
    private final Neuron to;       // To. . .
    private double weight;   // Weight of the connection. . .

    // Constructor  builds a connection with a random weight
    public Connection(Neuron a_, Neuron b_) {
        from = a_;
        to = b_;
        weight = Math.random()*2-1;
    }
    
    // In case I want to set the weights manually, using this for testing
    public Connection(Neuron a_, Neuron b_, double w) {
        from = a_;
        to = b_;
        weight = w;
    }

    public Neuron getFrom() {
        return from;
    }
    
    public Neuron getTo() {
        return to;
    }  
    
    public double getWeight() {
        return weight;
    }

    // Changing the weight of the connection
    public void adjustWeight(double deltaWeight) {
        weight += deltaWeight;
    }


}
