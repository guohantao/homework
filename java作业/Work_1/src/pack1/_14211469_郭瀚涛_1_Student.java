package pack1;

public class _14211469_郭瀚涛_1_Student {
	 private String studentNumber = null;
	 private String studentName = null;
	 //初始值默认为-1，便于辨认该学生是0分 还是未输入；
	 private int markForMaths = -1;
	 private int markForEnglish = -1;
	 private int markForScience = -1;
	 
	 
	 public _14211469_郭瀚涛_1_Student() {}
	 public _14211469_郭瀚涛_1_Student(String number, String name)
	 {
		studentNumber = number;
		studentName = name;
	 }
	 public String getNumber() { return studentNumber; }
	 public String getName() { return studentName; }
	 
	 public void enterMarks(int markForMaths, int markForEnglish, int markForScience)
	 {
		 this.markForMaths = markForMaths;
		 this.markForEnglish = markForEnglish;
		 this.markForScience = markForScience;
	 }
	 
	 public int getMathsMark() { return markForMaths; }
	 public int getEnglishMark() { return markForEnglish; }
	 public int getScienceMark() { return markForScience; }
	 public double calculateAverage()
	 {
		 return (markForMaths + markForEnglish + markForScience)/3.0;
	 }
	 
	 public String toString() 
	 {
		return "学生姓名："+studentName+"\n"+
				"学生学号："+studentNumber+"\n"+
				"数学成绩："+this.getMathsMark()+"\n"+
				"英语成绩："+this.getEnglishMark()+"\n"+
				"科学成绩："+this.getScienceMark()+"\n"+
				"平均成绩："+this.calculateAverage();
	}
	 
	
}
