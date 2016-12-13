package pack1;



import java.io.IOException;
import java.util.Scanner;

public class _14211469_郭瀚涛_1_StudentListTest {

	public static void main(String[] args) throws IOException
	{
		// TODO Auto-generated method stub
		Scanner sc = new Scanner(System.in);
		System.out.print("请输入您要建立的list数组大小：");
		int leng = sc.nextInt();
		_14211469_郭瀚涛_1_StudentList l = new _14211469_郭瀚涛_1_StudentList(leng);
		
		System.out.println("菜单如下，请输入 1~8代表您要执行的操作：\n"
				+ "1.增加1个学生 	 2. 根据学号删除学生 	3. 根据位置删除学生\n"
				+"4.判断是否为空 	 5.根据位置返回学生 	6.根据学号返回学生\n"
				+ "7.输出全部学生信息  8.退出程序");
		System.out.print("请输入您的操作：");
		
		int input;
		String name;
		String number;
		_14211469_郭瀚涛_1_Student stu;//返回的学生占存
		int no; //位置
		while((input = sc.nextInt()) != 8)
		{
			switch(input)
			{
				case 1:
					System.out.print("请输入学生学号：");//print与println的区别是 前者不会换行，后者自动换行
					number = sc.next();
					System.out.print("请输入学生姓名：");
					name = sc.next();
					_14211469_郭瀚涛_1_Student s1 = new _14211469_郭瀚涛_1_Student(number,name);
					
					System.out.print("请输入学生三门课成绩（数学，英语，科学）以逗号分开（注意全角半角）：");
					int math=-1,english=-1,science=-1;
					sc.nextLine();
					String[] s = sc.nextLine().split(",");
					math = Integer.parseInt(s[0]);
					english = Integer.parseInt(s[1]);
					science = Integer.parseInt(s[2]);
					s1.enterMarks(math, english, science);
					l.add(s1);
					break;
				case 2:
					System.out.print("请输入要删除的学号：");
					number = sc.next();
					_14211469_郭瀚涛_1_Student stu1 = new _14211469_郭瀚涛_1_Student(number,"asas");
					l.remove(stu1);
					break;
				case 3:
					System.out.print("请输入要删除的位置（从零开始，仿照数组）：");
					no = sc.nextInt();
					l.remove(no);
					break;
				case 4:
					System.out.println("判断结果是否为空：");
					l.isEmpty();
					break;
				case 5:
					System.out.print("请输入要返回的位置（从零开始，仿照数组）：");
					no = sc.nextInt();
					stu = l.getItem(no);
					if(stu != null)
						System.out.println(stu.toString());
					break;
				case 6:
					System.out.print("请输入返回学生的学号:");
					number = sc.next();
					_14211469_郭瀚涛_1_Student stu2 = new _14211469_郭瀚涛_1_Student(number,"asas");
					stu = l.getItem(stu2);

					if(stu != null)
						System.out.println(stu);
					break;
				case 7:
					System.out.println("全部信息如下所示：");
					l.printall();
					break;
				case 8:
					System.out.println("程序退出");
					break;
				default:
					System.out.println("无效输入");
			}
			System.out.print("请输入您的操作：");
		}
		System.out.println("程序退出");

	}

}
