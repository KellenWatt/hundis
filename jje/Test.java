import java.lang.Math;
import java.util.Scanner;

public class Test
{
	public static void main(String[] args)
	{
		Scanner s = new Scanner(System.in);

		int n = s.nextInt();
		float radius;

		for(int i = 0; i < n; i++)
		{
		   radius = s.nextFloat();
           System.out.println(Math.PI * Math.pow(radius, 2));
		}
	}
}
