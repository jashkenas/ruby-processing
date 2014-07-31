// Daniel Shiffman
// The Nature of Code, Fall 2006
// Neural Network

// Class to describe the entire network
// Arrays for input_array neurons, hidden_array neurons, and output neuron

// Need to update this so that it would work with an array out outputs
// Rather silly that I didn't do this initially

// Also need to build in a "Layer" class so that there can easily
// be more than one hidden_array layer

package nn;

import java.util.ArrayList;

public class Network {

    // Layers
    InputNeuron[] input_array;
    HiddenNeuron[] hidden_array;
    OutputNeuron output;
    
    public static final double LEARNING_CONSTANT = 0.5;

    // Only One output now to start!!! (i can do better, really. . .)
    // Constructor makes the entire network based on number of inputs & number of neurons in hidden_array layer
    // Only One hidden_array layer!!!  (fix this dood)

    public Network(int inputs, int hidden_arraytotal) {

        input_array = new InputNeuron[inputs+1];  // Got to add a bias input_array
        hidden_array = new HiddenNeuron[hidden_arraytotal+1];

        // Make input_array neurons
        for (int i = 0; i < input_array.length-1; i++) {
            input_array[i] = new InputNeuron();
        }
        
        // Make hidden_array neurons
        for (int i = 0; i < hidden_array.length-1; i++) {
            hidden_array[i] = new HiddenNeuron();
        }

        // Make bias neurons
        input_array[input_array.length-1] = new InputNeuron(1);
        hidden_array[hidden_array.length-1] = new HiddenNeuron(1);

        // Make output neuron
        output = new OutputNeuron();
        for (InputNeuron input : input_array) {
            for (int j = 0; j < hidden_array.length-1; j++) {
                // Create the connection object and put it in both neurons
                Connection c = new Connection(input, hidden_array[j]);
                input.addConnection(c);
                hidden_array[j].addConnection(c);
            }
        }
        for (HiddenNeuron hidden : hidden_array) {
            Connection c = new Connection(hidden, output);
            hidden.addConnection(c);
            output.addConnection(c);
        }

    }


    public double feedForward(double[] inputVals) {
        
        // Feed the input_array with an array of inputs
        for (int i = 0; i < inputVals.length; i++) {
            input_array[i].input(inputVals[i]);  
        }
        
        // Have the hidden_array layer calculate its output
        for (int i = 0; i < hidden_array.length-1; i++) {
            hidden_array[i].calcOutput();
        }

        // Calculate the output of the output neuron
        output.calcOutput();
        
        // Return output
        return output.getOutput();
    }

    public double train(double[] inputs, double answer) {
        double result = feedForward(inputs);
        
        
        // This is where the error correction all starts
        // Derivative of sigmoid output function * diff between known and guess
        double deltaOutput = result * (1 - result) * (answer - result);

        
        // BACKPROPOGATION
        // This is easier b/c we just have one output
        // Apply Delta to connections between hidden_array and output
        ArrayList<Connection> connections = output.getConnections();
        for (int i = 0; i < connections.size(); i++) {
            Connection c = connections.get(i);
            Neuron neuron = c.getFrom();
            double temp_output = neuron.getOutput();
            double deltaWeight = temp_output * deltaOutput;
            c.adjustWeight(LEARNING_CONSTANT * deltaWeight);
        }
        for (HiddenNeuron hidden : hidden_array) {
            connections = hidden.getConnections();
            double sum  = 0;
            // Sum output delta * hidden_array layer connections (just one output)
            for (int j = 0; j < connections.size(); j++) {
                Connection c = connections.get(j);
                // Is this a connection from hidden_array layer to next layer (output)?
                if (c.getFrom() == hidden) {
                    sum += c.getWeight() * deltaOutput;
                }
            }    
            // Then adjust the weights coming in based:
            // Above sum * derivative of sigmoid output function for hidden_array neurons
            for (int j = 0; j < connections.size(); j++) {
                Connection c = connections.get(j);
                // Is this a connection from previous layer (input_array) to hidden_array layer?
                if (c.getTo() == hidden) {
                    double temp_output = hidden.getOutput();
                    double deltaHidden = temp_output * (1 - temp_output);  // Derivative of sigmoid(x)
                    deltaHidden *= sum;   // Would sum for all outputs if more than one output
                    Neuron neuron = c.getFrom();
                    double deltaWeight = neuron.getOutput() * deltaHidden;
                    c.adjustWeight(LEARNING_CONSTANT * deltaWeight);
                }
            } 
        }
        return result;
    }
}
