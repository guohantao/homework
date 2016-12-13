package pack1;

import java.util.Arrays;


public class _14211469_郭瀚涛_1_StudentList {
	private _14211469_郭瀚涛_1_Student[] list;
	private int total=0;
	
	public _14211469_郭瀚涛_1_StudentList() {}
	public _14211469_郭瀚涛_1_StudentList(int leng)
	{
		list = new _14211469_郭瀚涛_1_Student[leng]; //A.length代表的是数组的大小，不是数字所存元素个数。
	}
	public boolean add(_14211469_郭瀚涛_1_Student stu)
	{
		
		if(total>=list.length)//人数超过数组容量，重新申请
		{
			System.out.println("数组已满，添加失败");
			return false;
		}
		else
		{
			int i;
			for(i = 0; i<total; i++)
			{
				if(list[i].getName().equals(stu.getName()))
				{
					if(list[i].getNumber().equals(stu.getNumber()))
					{
						System.out.println("输入重名且重号学生，错误！");
						return false;
					}
				}
				else
				{
					if(list[i].getNumber().equals(stu.getNumber()))
					{
						System.out.println("输入重号不重名学生，错误！");
						return false;
					}
				}
			}
			total++;
			list[total-1]=stu;
			System.out.println("添加成功 ");
			
			System.out.println("------当前有"+total+"个学生-------");
			for(i = 0; i < total; i++)
			{
				System.out.println(list[i]);
			}
			return true;
		}
	}
	public boolean remove(int no)
	{
		if(no >= total)
		{
			System.out.println("查无此项，或删除越界");
			return false;
		}
		else
		{
			int i=0;
			for(i = no + 1; i < list.length; i++)
			{
				list[i-1]=list[i];
			}
			list[i-1]=null;
			
			System.out.println("删除成功");
			System.out.println("------当前有"+ --total+"个学生-------");
			for(i = 0; i < total; i++)
			{
				System.out.println(list[i]);
			}
			return true;
		}
	}
	public boolean remove(_14211469_郭瀚涛_1_Student number)
	{
		int i;
		for(i = 0; i < total; i++)
		{
			if(list[i].getNumber().equals(number.getNumber())) //找到该学生
			{
				int j;
				for(j = i+1; j < list.length; j++)
				{
					list[j-1]=list[j];
				}
				list[j-1]=null;
				
				System.out.println("删除成功");
				System.out.println("------当前有"+ --total+"个学生-------");
				for(j = 0; j < total; j++)
				{
					System.out.println(list[j]);
				}
				return true;
			}
		}
		System.out.println("查无此学号的学生！");
		return false;
	}
	public boolean isEmpty() 
	{
		if(total == 0)
		{
			System.out.println("数组为空");
			return true;
		}
		else
		{
			System.out.println("数组不为空");
			int j;
			System.out.println("------当前有"+total+"个学生-------");
			for(j = 0; j < total; j++)
			{
				System.out.println(list[j]);
			}
			return false;
		}
	}
	public _14211469_郭瀚涛_1_Student getItem(int no)
	{
		if(no >= total)
		{
			System.out.println("查无此项");
			return null;
		}
		else
		{
			System.out.println("找到该项");
			return list[no];
		}
	}
	public _14211469_郭瀚涛_1_Student getItem(_14211469_郭瀚涛_1_Student number)
	{
		int i;
		for(i = 0; i < total; i++)
		{
			if(list[i].getNumber().equals(number.getNumber())) //找到该学生
			{
				System.out.println("找到该学生");
				return list[i];
			}
		}
		System.out.println("查无此学号的学生！");
		return null;
	}
	public  int getTotal()
	{
		return total;
	}
	public void printall()//打印所有学生信息
	{
		int i;
		System.out.println("------当前有"+total+"个学生-------");
		for(i = 0; i < total; i++)
		{
			System.out.println(list[i]);
		}
	}
}









