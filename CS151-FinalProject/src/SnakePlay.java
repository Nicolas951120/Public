
import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;

public class SnakePlay extends JPanel implements KeyListener, ActionListener {

    // define two arrays X and Y for exposition position
    private int[] snakeXlength = new int[750];
    private int[] snakeYlength = new int[750];
    private int lengthOfsanke = 3;          //default the length of snake body


    // four variables for detecting on which side of snake is moving by using boolean varaibles
    private boolean left = false;
    private boolean right = false;
    private boolean up = false;
    private boolean down = false;

    private boolean gg = false;

    // four variables for the snake face
    private ImageIcon headRight;
    private ImageIcon headLeft;
    private ImageIcon headUp;
    private ImageIcon headDown;

    // create variables for manage the speed of the snake inside a panel
    private Timer timer;
    private int delay = 100;

    // define the variable of the first time to move
    private int moves = 0;

    // initial the variable of the score
    private int score = 0;

    // create variable for the futher snake body
    private ImageIcon snakeBody;

    // create variable for the futher snake body
    private Food food;

    // Make constructors
    public SnakePlay(){
        addKeyListener(this);
        setFocusable(true);
        setFocusTraversalKeysEnabled(false);
        // draw the food image icon
        food = new Food("food.png");
        timer = new Timer(delay, this);
        timer.start();
    }

    public void paint(Graphics g){
        Graphics2D g2 = (Graphics2D) g;

        if (moves == 0) {
            // if the game has started, then set the default position for the snake
            snakeXlength[2] = 50;
            snakeXlength[1] = 75;
            snakeXlength[0] = 100;

            snakeYlength[2] = 100;
            snakeYlength[1] = 100;
            snakeYlength[0] = 100;
        }
        // draw title image border
        g.setColor(Color.white);
        g.drawRect(24,10,851,55);

        // draw the title image
        Image title = Toolkit.getDefaultToolkit().getImage("title.jpg");
        g2.drawImage(title,25,11,this);


        // draw the scores
        g.setColor(Color.white);
        g.setFont(new Font("arial", Font.PLAIN,14));
        g.drawString("Scores:" + score, 780,30);

        // draw the length of snake
        g.setColor(Color.white);
        g.setFont(new Font("arial", Font.PLAIN,14));
        g.drawString("Length:" + lengthOfsanke, 780,50);

        // draw border for gameplay area
        g.setColor(Color.WHITE);
        g.drawRect(24,74,851,577);

        // draw background for the gameplay
        g.setColor(Color.LIGHT_GRAY);
        g.fillRect(25,75,850,575);

        // draw the icon
       headRight = new ImageIcon("headRight.png");
       headRight.paintIcon(this,g,snakeXlength[0],snakeYlength[0]);

        if(!gg){
        for(int i = 0; i < lengthOfsanke; i++) {
            // dectect the direction of the snake, right, left, up, and down
            if (i == 0 && right) {  // draw icon
                headRight = new ImageIcon("headRight.png");
                headRight.paintIcon(this, g, snakeXlength[i], snakeYlength[i]);
            }
            if (i == 0 && left) {   // draw icon
                headLeft = new ImageIcon("headLeft.png");
                headLeft.paintIcon(this, g, snakeXlength[i], snakeYlength[i]);
            }
            if (i == 0 && up) {     // draw icon
                headUp = new ImageIcon("headUp.png");
                headUp.paintIcon(this, g, snakeXlength[i], snakeYlength[i]);
            }
            if (i == 0 && down) {   // draw icon
                headDown = new ImageIcon("headDown.png");
                headDown.paintIcon(this, g, snakeXlength[i], snakeYlength[i]);
                //   g.dispose();
            }
            if(i != 0){     // draw the boyd of snake image
                snakeBody = new ImageIcon("body.png");
                snakeBody.paintIcon(this, g, snakeXlength[i], snakeYlength[i]);
            }
          }
        }

        // check if the food is collided with the head of snake
        if(food.isAte(snakeXlength[0], snakeYlength[0])){
        //if((foodXpos[xpos] == snakeXlength[0]) && foodYpos[ypos] == snakeYlength[0]){
            // score will increment after pickup food
            score++;
            // if the snake picks up the food icon, then the length of snake will increse
            lengthOfsanke++;

			// if the snake picks up the food icon, then the speed of snake will increse
			if(delay >= 5){
            	delay -= 3;
            	timer.setDelay(delay);
			}


            //rearrange new position
            food.randomPos();
        }
        food.paintIcon(this,g);   // print food icon image

        // game over check
        for(int m = 4; m < lengthOfsanke; m++){
            if(snakeXlength[m] == snakeXlength[0] && snakeYlength[m] == snakeYlength[0]){
                right = false;
                left = false;
                up = false;
                down = false;

                delay = 100;
                timer.setDelay(delay);
                gg = true;

                g.setColor(Color.RED);
                g.setFont(new Font("arial", Font.BOLD, 50));
                g.drawString("Game Over",300,300);

                g.setFont(new Font("arial", Font.BOLD, 20));
                g.drawString("Space to RESTART",350,340);

            }
        }
    }

    @Override
    public void actionPerformed(ActionEvent e) {
        timer.start();
        // check the position
        if(right){  // check the right variable is true
            for(int j = lengthOfsanke - 1; j >= 0; j--){
                snakeYlength[j + 1] = snakeYlength[j];
            }
            for (int j = lengthOfsanke; j >=0; j--){
                if(j == 0){
                    snakeXlength[j] = snakeXlength[j] + 25;
                }else{
                    snakeXlength[j] = snakeXlength[j - 1];
                }
                if(snakeXlength[j] > 850){
                    snakeXlength[j] = 25;
                }
            }
            repaint();
        }
         // check the position
        if(left){   // check the left variable is true
            for(int j = lengthOfsanke - 1; j >= 0; j--){
                snakeYlength[j + 1] = snakeYlength[j];
            }
            for (int j = lengthOfsanke; j >=0; j--){
                if(j == 0){
                    snakeXlength[j] = snakeXlength[j] - 25;
                }else{
                    snakeXlength[j] = snakeXlength[j - 1];
                }
                if(snakeXlength[j] < 25){
                    snakeXlength[j] = 850;
                }
            }
            repaint();
        }
         // check the position
        if(up){     // check the up variable is true
            for(int j = lengthOfsanke - 1; j >= 0; j--){
                snakeXlength[j + 1] = snakeXlength[j];
            }
            for (int j = lengthOfsanke; j >=0; j--){
                if(j == 0){
                    snakeYlength[j] = snakeYlength[j] - 25;
                }else{
                    snakeYlength[j] = snakeYlength[j - 1];
                }
                if(snakeYlength[j] < 75){
                    snakeYlength[j] = 625;
                }
            }
            repaint();
        }
         // check the position
        if(down){   // check the down variable is true
            for(int j = lengthOfsanke - 1; j >= 0; j--){
                snakeXlength[j + 1] = snakeXlength[j];
            }
            for (int j = lengthOfsanke; j >=0; j--){
                if(j == 0){
                    snakeYlength[j] = snakeYlength[j] + 25;
                }else{
                    snakeYlength[j] = snakeYlength[j - 1];
                }
                if(snakeYlength[j] > 625){
                    snakeYlength[j] = 75;
                }
            }
            repaint();
        }
    }

    @Override
    public void keyTyped(KeyEvent e) {

    }

    // To move the snake towards direction
    @Override
    public void keyPressed(KeyEvent e) {
        if(e.getKeyCode() == KeyEvent.VK_SPACE && gg){
            moves = 0;
            score = 0;
            delay = 100;
            timer.setDelay(delay);
			gg = false;
            lengthOfsanke = 3;
            repaint();
        }
        if(e.getKeyCode() == KeyEvent.VK_RIGHT && !gg){
            moves++;
            right = true;
            // check if the left is not true, then keep the snake moving towrads the right direction.
            // if the left is true and the right key is pressed, then don't move towards the left direction
            if(!left){
                right = true;
            }else{
                right = false;
                left = true;
            }
            up = false;
            down = false;
        }
        if(e.getKeyCode() == KeyEvent.VK_LEFT && !gg){
            moves++;
            left = true;
            // check if the right is not true, then keep the snake moving towrads the left direction.
            // if the right is true and the left key is pressed, then don't move towards the right direction
            if(!right){
                left = true;
            }else{
                left = false;
                right = true;
            }
            up = false;
            down = false;
        }
        if(e.getKeyCode() == KeyEvent.VK_UP && !gg){
            moves++;
            up = true;
            // check if the down is not true, then keep the snake moving towrads the up direction.
            // if the down is true and the up key is pressed, then don't move towards the down direction
            if(!down){
                up = true;
            }else{
                up = false;
                down = true;
            }
            left = false;
            right = false;
        }
        if(e.getKeyCode() == KeyEvent.VK_DOWN && !gg){
            moves++;
            down = true;
            // check if the up is not true, then keep the snake moving towrads the down direction.
            // if the up is true and the down key is pressed, then don't move towards the up direction
            if(!up){
                down = true;
            }else{
                down = false;
                up = true;
            }
            left = false;
            right = false;
        }
    }

    @Override
    public void keyReleased(KeyEvent e) {

    }
}
