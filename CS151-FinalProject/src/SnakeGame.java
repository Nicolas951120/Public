import javax.swing.JFrame;
import java.awt.Color;

public class SnakeGame {
    public static void main(String[] args){
        // Write JFrame and make a new object
        JFrame frame = new JFrame();
        SnakePlay snakePlay = new SnakePlay();

        frame.setBounds(10,10,905,700);
        frame.setBackground(Color.DARK_GRAY);
        frame.getContentPane().add(new SnakePlay());
        frame.setResizable(false);
        frame.setVisible(true);
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.add(snakePlay);
    }
}
