import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileReader;
import java.io.FileWriter;

public class ECE4607 {

	public static void main(String[] args) throws Exception {
		 String fileName = args[0];//"src/out.tr";
		 String fileNameOut = "outout.csv";
		 String line = "";
		 FileReader fileReader = new FileReader(fileName);
		 BufferedReader bufferedReader = new BufferedReader(fileReader);
		 
		 int totalRecieved1 = 0, totalRecieved2 = 0;
		 long totalBytesRecieved1 = 0, totalBytesRecieved2 = 0;
		 float[] instantaneousThroughput1 = new float[1000];
		 float[] instantaneousThroughput2 = new float[1000];
		 

	     while((line = bufferedReader.readLine()) != null) {
	     //	//System.out.println(line);
			 String[] splitted = line.split(" ");
			 if(splitted[0].equals("r")) {
				 if(splitted[3].equals("5")) {
					 // increment counter for flow 1
					 totalRecieved1++;
					 totalBytesRecieved1 += Integer.parseInt(splitted[5]);
					 instantaneousThroughput1[(int) Math.floor(Float.parseFloat(splitted[1]) * 10)] += Integer.parseInt(splitted[5]);
				 } else if(splitted[3].equals("6")) {
					 // increment counter for flow 2
					 totalRecieved2++;
					 totalBytesRecieved2 += Integer.parseInt(splitted[5]);
					 instantaneousThroughput2[(int) Math.floor(Float.parseFloat(splitted[1]) * 10)] += Integer.parseInt(splitted[5]);
				 }
			 }
	     }   
	     
	     System.out.println("Total segments recieved for flow 1: " + totalRecieved1);
	     System.out.println("Total segments recieved for flow 2: " + totalRecieved2);

	     //System.out.println("End-end throughput for flow 1: " + (totalBytesRecieved1 / 100) + " bytes/sec");
	     //System.out.println("End-end throughput for flow 2: " + (totalBytesRecieved2 / 100) + " bytes/sec");
	     /*
	     BufferedWriter writer1 = new BufferedWriter(new FileWriter(fileNameOut + "1.csv"));
	     BufferedWriter writer2 = new BufferedWriter(new FileWriter(fileNameOut + "2.csv"));
	     for(int i = 0; i < 1000; i++) {
		     writer1.write(Double.toString(0.1d * i) + "," + Float.toString(((float) instantaneousThroughput1[i]) / 0.1f) + "\n");
		     writer2.write(Double.toString(0.1d * i) + "," + Float.toString(((float) instantaneousThroughput2[i]) / 0.1f) + "\n");
	     }
	     writer1.close();
	     writer2.close();
		*/
	     BufferedWriter writer3 = new BufferedWriter(new FileWriter(fileNameOut));
	     writer3.append(totalRecieved1 + ", " + totalRecieved2);
	     writer3.close();

	     // Always close files.
	     bufferedReader.close(); 
	}
}
