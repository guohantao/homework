package pack1;

import java.io.IOException;
import java.util.Scanner;



public class _14211469_郭瀚涛_1_StudentTest {

	public static void main(String[] args) throws IOException
	{
		// TODO Auto-generated method stub
		Scanner sc = new Scanner(System.in);
		String name = null;
		String number = null;
		int math=-1,english=-1,science=-1;

		int flag = 0;
		while(flag != 1)
		{
			try
			{
				System.out.print("请输入学生学号：");//print与println的区别是 前者不会换行，后者自动换行
				number = sc.nextLine();
				//System.out.println(number.charAt(0)+"...."+number.charAt(1)+"....."+number.length());
				System.out.print("请输入学生姓名：");
				name = sc.nextLine();
				System.out.print("请输入学生三门课成绩（数学，英语，科学）以逗号分开（注意全角半角）：");
				String[] s = sc.nextLine().split(",");
				math = Integer.parseInt(s[0]);
				english = Integer.parseInt(s[1]);
				science = Integer.parseInt(s[2]);

				Testexception t = new Testexception(number,math,english,science);
				t.test();
			}
			catch(_14211469_郭瀚涛_2_StudentNumberException e)
			{
				System.out.println(e);
				continue;
			}
			catch(_14211469_郭瀚涛_2_SoreException e)
			{
				System.out.println(e);
				continue;
			}
			flag = 1;
		}
		_14211469_郭瀚涛_1_Student s1 = new _14211469_郭瀚涛_1_Student(number,name);
		s1.enterMarks(math, english, science);
		
		System.out.println(s1);
		
		
		

	}

}

class Testexception
{
	private  int math, english, science;
	private  String num;
	public Testexception(){};
	public Testexception(String num, int math, int english, int science)
	{
		this.num = num;
		this.math = math;
		this.english = english;
		this.science = science;
	}
	public void test() throws _14211469_郭瀚涛_2_SoreException, _14211469_郭瀚涛_2_StudentNumberException
	{
		if((math < 0 || math > 100)||(english < 0 || english > 100)||(science <0 || science > 100))
		{
			throw new _14211469_郭瀚涛_2_SoreException("输入成绩有误，请重新输入。");
		}
		if((num.charAt(0) !=  '2') || (num.charAt(1) != '0')) //注意是字符不是数字
		{
			throw new _14211469_郭瀚涛_2_StudentNumberException("学号格式（第一位和第二位）不正确，请重新输入。");
		}
		else
		{
			if(num.length() != 10)
			{
				throw new  _14211469_郭瀚涛_2_StudentNumberException("学号格式(长度）不正确，请重新输入。");
			}
		}

	}

}