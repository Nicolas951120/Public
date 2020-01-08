import java.util.Random;
import javax.swing.*;
import java.awt.*;

public class Food implements Icon{

    public Food(String filename){
        this.food = new ImageIcon(filename);
        // randome number of x and y position
        randomPos();
    }

    public int getIconWidth(){
        return food.getIconWidth();
    }

    public int getIconHeight(){
        return food.getIconHeight();
    }

    //public void changeSpeed(Timer timer, int num){
    //    int delay = timer.getDelay();
    //    if(delay >= num){
    //        delay -= num;
    //        timer.setDelay(delay);
    //    }
    //}

    public boolean isAte(int otherX, int otherY){
        System.out.println(foodXpos[x] + " " + y + " " + otherX + " " + otherY);
        return (foodXpos[x] == otherX && foodYpos[y] == otherY);
    }

    public void randomPos(){
        //rearrange new position
        x = random.nextInt(foodXpos.length);
        y = random.nextInt(foodYpos.length);
    }

    public void paintIcon(Component c, Graphics g){
        // print food icon image
        paintIcon(c, g, foodXpos[x], foodYpos[y]);
    }

    public void paintIcon(Component c, Graphics g, int x, int y){
        // print food icon image
        food.paintIcon(c, g, x, y);
    }

    // Two arrays of default position for the pickup food
    private int [] foodXpos = {25,50,75,100,125,150,175,200,225,250,275,300,325,350,375,400,425,450,475,500,525,550,575,600,625,650,675,700,725,750,775,800,825,850};
    private int [] foodYpos = {75,100,125,150,175,200,225,250,275,300,325,350,375,400,425,450,475,500,525,550,575,600,625};
    // index of food position arrays
    private int x;
    private int y;
    // random variables for the position of pickup
    private Random random = new Random();
    // food icon
    private ImageIcon food;
}