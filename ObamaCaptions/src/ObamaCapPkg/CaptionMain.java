package ObamaCapPkg;

import java.io.File;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Set;
import java.util.TreeMap;

import processing.core.PApplet;


import java.text.DecimalFormat;


//read in caption files, parse out into strings, with counts of occurences and file locations
public class CaptionMain extends PApplet {
	
	public TreeMap<String, ArrayList<wordCap>> captionDict;
	public TreeMap<String,fileCount> fileNameDict;
	
	public final String[] tensNames = {""," ten"," twenty"," thirty"," forty"," fifty"," sixty"," seventy"," eighty"," ninety"};
	public final String[] tensPluralNames = {"hundreds"," tens"," twenties"," thirties"," forties"," fifties"," sixties"," seventies"," eighties"," nineties"};
	public final String[] numNames = {""," one"," two"," three"," four"," five"," six"," seven"," eight"," nine"," ten"," eleven"," twelve"," thirteen"," fourteen"," fifteen"," sixteen"," seventeen"," eighteen"," nineteen"};
	public final String[] numWithTHNames = {"th"," first"," second"," third"," fourth"," fifth"," sixth"," seventh"," eighth"," ninth"," tenth"," eleventh"," twelfth"," thirteenth"," fourteenth"," fifteenth"," sixteenth"," seventeenth"," eighteenth"," nineteenth"};
	
	public final int matlabOffset = 160;		//subtract 20? to align with start?
	public TreeMap<String,Float> frameRateMap; 	//map to hold frame rates for each clip, keyed by clip name
	
	//parses a passed time string of the format  start hr:min:sec.frame --> end hr:min:sec.frame into a starting and ending frame, subtracting 160 to be in sync with matlab stuff

	public void buildFrameRateMap(){
		frameRateMap = new TreeMap<String,Float>();
		frameRateMap.put("001_xvid",25.0f);
		frameRateMap.put("002_xvid",25.0f);
		frameRateMap.put("003_xvid",25.0f);
		frameRateMap.put("004_xvid",25.0f);
		frameRateMap.put("005_xvid",25.0f);
		frameRateMap.put("006_xvid",25.0f);
		frameRateMap.put("007_xvid",25.0f);
		frameRateMap.put("008_xvid",25.0f);
		frameRateMap.put("009_xvid",25.0f);
		frameRateMap.put("010_xvid",25.0f);
		frameRateMap.put("011_xvid",25.0f);
		frameRateMap.put("012_xvid",25.0f);
		frameRateMap.put("013_xvid",25.0f);
		frameRateMap.put("014_xvid",25.0f);
		frameRateMap.put("015_xvid",25.0f);
		frameRateMap.put("016_xvid",25.0f);
		frameRateMap.put("017_xvid",25.0f);
		frameRateMap.put("018_xvid",25.0f);
		frameRateMap.put("019_xvid",25.0f);
		frameRateMap.put("020_xvid",25.0f);
		frameRateMap.put("021_xvid",25.0f);
		frameRateMap.put("022_xvid",25.0f);
		frameRateMap.put("023_xvid",25.0f);
		frameRateMap.put("024_xvid",25.0f);
		frameRateMap.put("025_xvid",25.0f);
		frameRateMap.put("026_xvid",25.0f);
		frameRateMap.put("027_xvid",25.0f);
		frameRateMap.put("028_xvid",25.0f);
		frameRateMap.put("029_xvid",25.0f);
		frameRateMap.put("030_xvid",25.0f);
		frameRateMap.put("031_xvid",25.0f);
		frameRateMap.put("032_xvid",25.0f);
		frameRateMap.put("033_xvid",25.0f);
		frameRateMap.put("034_xvid",25.0f);
		frameRateMap.put("035_xvid",25.0f);
		frameRateMap.put("036_xvid",25.0f);
		frameRateMap.put("037_xvid",25.0f);
		frameRateMap.put("038_xvid",25.0f);
		frameRateMap.put("039_xvid",25.0f);
		frameRateMap.put("040_xvid",25.0f);
		frameRateMap.put("041_xvid",25.0f);
		frameRateMap.put("042_xvid",25.0f);
		frameRateMap.put("043_xvid",25.0f);
		frameRateMap.put("044_xvid",25.0f);
		frameRateMap.put("045_xvid",25.0f);
		frameRateMap.put("046_xvid",25.0f);
		frameRateMap.put("047_xvid",25.0f);
		frameRateMap.put("048_xvid",25.0f);
		frameRateMap.put("049_xvid",25.0f);
		frameRateMap.put("050_xvid",25.0f);
		frameRateMap.put("051_xvid",25.0f);
		frameRateMap.put("052_xvid",25.0f);
		frameRateMap.put("053_xvid",25.0f);
		frameRateMap.put("054_xvid",25.0f);
		frameRateMap.put("055_xvid",25.0f);
		frameRateMap.put("056_xvid",25.0f);
		frameRateMap.put("057_xvid",25.0f);
		frameRateMap.put("058_xvid",25.0f);
		frameRateMap.put("059_xvid",25.0f);
		frameRateMap.put("060_xvid",25.0f);
		frameRateMap.put("061_xvid",25.0f);
		frameRateMap.put("062_xvid",25.0f);
		frameRateMap.put("063_xvid",25.0f);
		frameRateMap.put("064_xvid",25.0f);
		frameRateMap.put("065_xvid",25.0f);
		frameRateMap.put("066_xvid",25.0f);
		frameRateMap.put("067_xvid",25.0f);
		frameRateMap.put("068_xvid",25.0f);
		frameRateMap.put("069_xvid",25.0f);
		frameRateMap.put("070_xvid",25.0f);
		frameRateMap.put("071_xvid",25.0f);
		frameRateMap.put("072_xvid",25.0f);
		frameRateMap.put("073_xvid",25.0f);
		frameRateMap.put("074_xvid",25.0f);
		frameRateMap.put("075_xvid",25.0f);
		frameRateMap.put("076_xvid",25.0f);
		frameRateMap.put("077_xvid",25.0f);
		frameRateMap.put("078_xvid",25.0f);
		frameRateMap.put("079_xvid",25.0f);
		frameRateMap.put("080_xvid",25.0f);
		frameRateMap.put("081_xvid",25.0f);
		frameRateMap.put("082_xvid",25.0f);
		frameRateMap.put("083_xvid",25.0f);
		frameRateMap.put("084_xvid",25.0f);
		frameRateMap.put("085_xvid",25.0f);
		frameRateMap.put("086_xvid",25.0f);
		frameRateMap.put("087_xvid",25.0f);
		frameRateMap.put("088_xvid",25.0f);
		frameRateMap.put("089_xvid",25.0f);
		frameRateMap.put("090_xvid",25.0f);
		frameRateMap.put("091_xvid",25.0f);
		frameRateMap.put("092_xvid",25.0f);
		frameRateMap.put("093_xvid",25.0f);
		frameRateMap.put("094_xvid",25.0f);
		frameRateMap.put("095_xvid",25.0f);
		frameRateMap.put("096_xvid",25.0f);
		frameRateMap.put("097_xvid",25.0f);
		frameRateMap.put("098_xvid",25.0f);
		frameRateMap.put("099_xvid",25.0f);
		frameRateMap.put("100_xvid",25.0f);
		frameRateMap.put("101_xvid",25.0f);
		frameRateMap.put("102_xvid",25.0f);
		frameRateMap.put("103_xvid",25.0f);
		frameRateMap.put("104_xvid",25.0f);
		frameRateMap.put("105_xvid",25.0f);
		frameRateMap.put("106_xvid",25.0f);
		frameRateMap.put("107_xvid",25.0f);
		frameRateMap.put("108_xvid",25.0f);
		frameRateMap.put("109_xvid",25.0f);
		frameRateMap.put("110_xvid",25.0f);
		frameRateMap.put("111_xvid",25.0f);
		frameRateMap.put("112_xvid",25.0f);
		frameRateMap.put("113_xvid",25.0f);
		frameRateMap.put("114_xvid",25.0f);
		frameRateMap.put("115_xvid",25.0f);
		frameRateMap.put("116_xvid",25.0f);
		frameRateMap.put("117_xvid",25.0f);
		frameRateMap.put("118_xvid",25.0f);
		frameRateMap.put("119_xvid",25.0f);
		frameRateMap.put("120_xvid",25.0f);
		frameRateMap.put("121_xvid",25.0f);
		frameRateMap.put("122_xvid",25.0f);
		frameRateMap.put("123_xvid",25.0f);
		frameRateMap.put("124_xvid",25.0f);
		frameRateMap.put("125_xvid",25.0f);
		frameRateMap.put("126_xvid",25.0f);
		frameRateMap.put("127_xvid",25.0f);
		frameRateMap.put("128_xvid",25.0f);
		frameRateMap.put("129_xvid",25.0f);
		frameRateMap.put("130_xvid",25.0f);
		frameRateMap.put("131_xvid",25.0f);
		frameRateMap.put("132_xvid",25.0f);
		frameRateMap.put("1000_xvid",29.95924f);
		frameRateMap.put("1001_xvid",29.95924f);
		frameRateMap.put("1002_xvid",29.95924f);
		frameRateMap.put("1003_xvid",29.95924f);
		frameRateMap.put("1004_xvid",29.95924f);
		frameRateMap.put("1005_xvid",29.95924f);
		frameRateMap.put("1006_xvid",29.95924f);
		frameRateMap.put("1007_xvid",29.95924f);
		frameRateMap.put("1008_xvid",30.0f);
		frameRateMap.put("1009_xvid",29.95924f);
		frameRateMap.put("1010_xvid",30.0f);
		frameRateMap.put("1011_xvid",30.0f);
		frameRateMap.put("1012_xvid",30.0f);
		frameRateMap.put("1013_xvid",29.95924f);
		frameRateMap.put("1014_xvid",30.0f);
		frameRateMap.put("1015_xvid",30.0f);
		frameRateMap.put("1016_xvid",30.0f);
		frameRateMap.put("1017_xvid",30.0f);
		frameRateMap.put("1018_xvid",29.95924f);
		frameRateMap.put("1019_xvid",29.95924f);
		frameRateMap.put("1020_xvid",29.95924f);
		frameRateMap.put("1021_xvid",29.95924f);
		frameRateMap.put("1022_xvid",29.95924f);
		frameRateMap.put("1023_xvid",29.95924f);
		frameRateMap.put("1025_xvid",29.95924f);
		frameRateMap.put("1026_xvid",29.95924f);
		frameRateMap.put("1027_xvid",29.95924f);
		frameRateMap.put("1028_xvid",29.95924f);
		frameRateMap.put("1029_xvid",29.95924f);
		frameRateMap.put("1030_xvid",29.95924f);
		frameRateMap.put("1031_xvid",29.95924f);
		frameRateMap.put("1032_xvid",29.95924f);
		frameRateMap.put("1033_xvid",29.95924f);
		frameRateMap.put("1034_xvid",30.0f);
		frameRateMap.put("1035_xvid",29.95924f);
		frameRateMap.put("1036_xvid",29.95924f);
		frameRateMap.put("1037_xvid",29.95924f);
		frameRateMap.put("1038_xvid",29.95924f);
		frameRateMap.put("1039_xvid",29.95924f);
		frameRateMap.put("1040_xvid",29.95924f);
		frameRateMap.put("1041_xvid",29.95924f);
		frameRateMap.put("1042_xvid",29.95924f);
		frameRateMap.put("1043_xvid",29.95924f);
		frameRateMap.put("1044_xvid",29.95924f);
		frameRateMap.put("1045_xvid",29.95924f);
		frameRateMap.put("1046_xvid",29.95924f);
		frameRateMap.put("1047_xvid",29.95924f);
		frameRateMap.put("1048_xvid",29.95924f);
		frameRateMap.put("1049_xvid",29.95924f);
		frameRateMap.put("1050_xvid",29.95924f);
		frameRateMap.put("1051_xvid",29.95924f);
		frameRateMap.put("1052_xvid",29.95924f);
		frameRateMap.put("1053_xvid",29.95924f);
		frameRateMap.put("1054_xvid",29.95924f);
		frameRateMap.put("1055_xvid",29.95924f);
		frameRateMap.put("1056_xvid",29.95924f);
		frameRateMap.put("1057_xvid",29.95924f);
		frameRateMap.put("1058_xvid",29.95924f);
		frameRateMap.put("1059_xvid",29.95924f);
		frameRateMap.put("1060_xvid",30.0f);
		frameRateMap.put("1061_xvid",23.96739f);
		frameRateMap.put("1062_xvid",29.95924f);
		frameRateMap.put("1063_xvid",29.95924f);
		frameRateMap.put("1064_xvid",29.95924f);
		frameRateMap.put("1065_xvid",29.95924f);
		frameRateMap.put("1066_xvid",29.95924f);
		frameRateMap.put("1067_xvid",29.95924f);
		frameRateMap.put("1068_xvid",29.95924f);
		frameRateMap.put("1069_xvid",29.95924f);
		frameRateMap.put("1070_xvid",29.95924f);
		frameRateMap.put("1071_xvid",30.0f);
		frameRateMap.put("1072_xvid",29.95924f);
		frameRateMap.put("1073_xvid",30.0f);
		frameRateMap.put("1074_xvid",29.95924f);
		frameRateMap.put("1075_xvid",29.95924f);
		frameRateMap.put("1076_xvid",30.0f);
		frameRateMap.put("1077_xvid",29.95924f);
		frameRateMap.put("1078_xvid",30.0f);
		frameRateMap.put("1079_xvid",29.95924f);
		frameRateMap.put("1081_xvid",29.95924f);
		frameRateMap.put("1082_xvid",29.95924f);
		frameRateMap.put("1083_xvid",29.95924f);
		frameRateMap.put("1084_xvid",29.95924f);
		frameRateMap.put("1085_xvid",30.0f);
		frameRateMap.put("1086_xvid",29.95924f);
		frameRateMap.put("1087_xvid",30.0f);
		frameRateMap.put("1088_xvid",30.0f);
		frameRateMap.put("1089_xvid",30.0f);
		frameRateMap.put("1090_xvid",29.95924f);
		frameRateMap.put("1091_xvid",29.95924f);
		frameRateMap.put("1092_xvid",30.0f);
		frameRateMap.put("1093_xvid",30.0f);
		frameRateMap.put("1094_xvid",29.95924f);
		frameRateMap.put("1095_xvid",29.95924f);
		frameRateMap.put("1096_xvid",29.95924f);
		frameRateMap.put("1097_xvid",29.95924f);
		frameRateMap.put("1098_xvid",30.0f);
		frameRateMap.put("1099_xvid",29.95924f);
		frameRateMap.put("1100_xvid",29.95924f);
		frameRateMap.put("1101_xvid",29.95924f);
		frameRateMap.put("1102_xvid",29.95924f);
		frameRateMap.put("1103_xvid",29.95924f);
		frameRateMap.put("1104_xvid",29.95924f);
		frameRateMap.put("1105_xvid",29.95924f);
		frameRateMap.put("1106_xvid",29.95924f);
		frameRateMap.put("1107_xvid",30.0f);
		frameRateMap.put("1108_xvid",29.95924f);
		frameRateMap.put("1109_xvid",29.95924f);
		frameRateMap.put("1110_xvid",29.95924f);
		frameRateMap.put("1111_xvid",29.95924f);
		frameRateMap.put("1112_xvid",29.95924f);
		frameRateMap.put("1113_xvid",30.0f);
		frameRateMap.put("1114_xvid",29.95924f);
		frameRateMap.put("1115_xvid",29.95924f);
		frameRateMap.put("1116_xvid",29.95924f);
		frameRateMap.put("1117_xvid",29.95924f);
		frameRateMap.put("1118_xvid",30.0f);
		frameRateMap.put("1120_xvid",29.95924f);
		frameRateMap.put("1121_xvid",29.95924f);
		frameRateMap.put("1122_xvid",30.0f);
		frameRateMap.put("1123_xvid",29.95924f);
		frameRateMap.put("1124_xvid",30.0f);
		frameRateMap.put("1125_xvid",30.0f);
		frameRateMap.put("1126_xvid",29.95924f);
		frameRateMap.put("1127_xvid",29.95924f);
		frameRateMap.put("1128_xvid",29.95924f);
		frameRateMap.put("1129_xvid",29.95924f);
		frameRateMap.put("1130_xvid",30.0f);
		frameRateMap.put("1131_xvid",30.0f);
		frameRateMap.put("1132_xvid",29.95924f);
		frameRateMap.put("1133_xvid",29.95924f);
		frameRateMap.put("1134_xvid",29.95924f);
		frameRateMap.put("1135_xvid",30.0f);
		frameRateMap.put("1136_xvid",30.0f);
		frameRateMap.put("1137_xvid",29.95924f);
		frameRateMap.put("1138_xvid",29.95924f);
		frameRateMap.put("1139_xvid",29.95924f);
		frameRateMap.put("1140_xvid",29.95924f);
		frameRateMap.put("1141_xvid",30.0f);
		frameRateMap.put("1142_xvid",29.95924f);
		frameRateMap.put("1143_xvid",29.95924f);
		frameRateMap.put("1144_xvid",30.0f);
		frameRateMap.put("1145_xvid",29.95924f);
		frameRateMap.put("1146_xvid",29.95924f);
		frameRateMap.put("1147_xvid",29.95924f);
		frameRateMap.put("1148_xvid",30.0f);
		frameRateMap.put("1149_xvid",30.0f);
		frameRateMap.put("1150_xvid",29.95924f);
		frameRateMap.put("1151_xvid",29.95924f);
		frameRateMap.put("1152_xvid",29.95924f);
		frameRateMap.put("1153_xvid",29.95924f);
		frameRateMap.put("1154_xvid",29.95924f);
		frameRateMap.put("1155_xvid",29.95924f);
		frameRateMap.put("1156_xvid",29.95924f);
		frameRateMap.put("1157_xvid",29.95924f);
		frameRateMap.put("1158_xvid",29.95924f);
		frameRateMap.put("1159_xvid",29.95924f);
		frameRateMap.put("1160_xvid",29.95924f);
		frameRateMap.put("1161_xvid",30.0f);
		frameRateMap.put("1162_xvid",29.95924f);
		frameRateMap.put("1163_xvid",29.95924f);
		frameRateMap.put("1164_xvid",29.95924f);
		frameRateMap.put("1165_xvid",29.95924f);
		frameRateMap.put("1166_xvid",30.0f);
		frameRateMap.put("1167_xvid",29.95924f);
		frameRateMap.put("1168_xvid",29.95924f);
		frameRateMap.put("1169_xvid",30.0f);
		frameRateMap.put("1170_xvid",30.0f);
		frameRateMap.put("1171_xvid",29.95924f);
		frameRateMap.put("1172_xvid",29.95924f);
		frameRateMap.put("1173_xvid",30.0f);
		frameRateMap.put("1174_xvid",29.95924f);
		frameRateMap.put("1175_xvid",30.0f);
		frameRateMap.put("1176_xvid",30.0f);
		frameRateMap.put("1177_xvid",29.95924f);
		frameRateMap.put("1178_xvid",30.0f);
		frameRateMap.put("1179_xvid",30.0f);
		frameRateMap.put("1180_xvid",30.0f);
		frameRateMap.put("1181_xvid",29.95924f);
		frameRateMap.put("1182_xvid",29.95924f);
		frameRateMap.put("1183_xvid",29.95924f);
		frameRateMap.put("1184_xvid",29.95924f);
		frameRateMap.put("1185_xvid",29.95924f);
		frameRateMap.put("1186_xvid",29.95924f);
		frameRateMap.put("1187_xvid",30.0f);
		frameRateMap.put("1188_xvid",29.95924f);
	}
		
	private String convertLessThanOneThousand(int number, int usage) {
		String soFar;	
		String [] araToUse = (usage == 1 ? numWithTHNames : numNames);
		String [] tensAraToUse = (usage == 2 ? tensPluralNames : tensNames);
		if (number % 100 < 20){soFar = araToUse[number % 100];number /= 100;}
		else {					soFar = araToUse[number % 10]; number /= 10; soFar = tensAraToUse[number % 10] + soFar; number /= 10;}
		if (number == 0) return soFar;
		return numNames[number] + " hundred" + soFar;
	}//convertLessThanOneThousand
	
	public String convVals(int val, String valStr){
		String res;
		switch (val) {
			case 0 :{ res = ""; break;}
			case 1 :{ res = convertLessThanOneThousand(val,0) + valStr; break;}
			default :{ res = convertLessThanOneThousand(val,0) + valStr;}
		}
		return res;
	}//convVals
	
	//convert a listed numeric value to the text representation - 1 -> "one"
	//usage - 0 is normal, 1 is "th"'s , 2 is "'s" 
	public String[] convertNumToText(long number, int usage) {
		if (number == 0) { return new String[]{"zero"}; }
		String snumber = Long.toString(number);
		
		// pad with "0"
		String mask = "000000000000";
		DecimalFormat df = new DecimalFormat(mask);
		snumber = df.format(number);
		
		// XXXnnnnnnnnn
		int billions = Integer.parseInt(snumber.substring(0,3));
		// nnnXXXnnnnnn
		int millions  = Integer.parseInt(snumber.substring(3,6));
		// nnnnnnXXXnnn
		int hundredThousands = Integer.parseInt(snumber.substring(6,9));
		// nnnnnnnnnXXX
		int thousands = Integer.parseInt(snumber.substring(9,12));
		String result = convVals(billions, " billion ") + convVals(millions, " million ") + convVals(hundredThousands, " thousand ") + convertLessThanOneThousand(thousands,usage) ;
		// remove extra spaces!
		String finalRes = result.replaceAll("^\\s+", "").replaceAll("\\b\\s{2,}\\b", " "); 
		//System.out.println("numeric value as string : " + finalRes);
		return PApplet.splitTokens(finalRes);
	}//converNumToText
	
	//concatenate decimal numeric string lists
	public ArrayList<String> concatStrLists(ArrayList<String> ints, String sep, ArrayList<String> decs){
		ArrayList<String> res = ints;res.add(sep);res.addAll(decs);		
		return res;
	}
	
	//process dollars and cents values given as numeric strings, converted to text strings
	public ArrayList<String> processMoney(String tmp, String finalValStr, boolean hugeDec){
		ArrayList<String> res = new ArrayList<String>();
		String[] moneyVals = PApplet.splitTokens(tmp,"$");
		if(moneyVals.length > 1){
			//System.out.println("Big money vals ara");
			for(int i =0; i<moneyVals.length; ++i){	
				//System.out.println(moneyVals[i]);
				if (i == moneyVals.length-1){continue;}
				String[] tmpTokens = moneyVals[i].split("-");
				for(String str : tmpTokens){res.add(str);}
			}
		}
		String moneyStrNoCommas = moneyVals[moneyVals.length-1].replace(",", "");//get rid of commas
		if(moneyStrNoCommas.contains(".")){//decimal money - process dollars first, then cents, check if less than 1 digit of decimal
			String[] dlrsAndCents = moneyStrNoCommas.split("\\.");
			if(dlrsAndCents.length == 1){//period but no cents value
				int val = Integer.parseInt(dlrsAndCents[0]);				
				String[] numStr =  convertNumToText(val,0);
				for(int i = 0; i<numStr.length;++i){res.add(numStr[i]);}
				if(val != 1){finalValStr += "s";}
				if(!hugeDec) {res.add(finalValStr);}				
			} else {
				res.addAll(concatStrLists( processMoney(dlrsAndCents[0], "dollar",hugeDec),(hugeDec ? "point":"and"),processMoney(dlrsAndCents[1], "cent",hugeDec)));
			}
		} else {
			int val = Integer.parseInt(moneyStrNoCommas);				
			String[] numStr =  convertNumToText(val,0);
			for(int i = 0; i<numStr.length;++i){res.add(numStr[i]);}
			if(val != 1){finalValStr += "s";}
			res.add(finalValStr);
		}		
		return res;		
	}//processMoney
	
	public ArrayList<String> processDecimalNumbers(String decNumber){
		ArrayList<String> res = new ArrayList<String>();
		String[] pctAndDec = PApplet.splitTokens(decNumber,".");
		String[] numStr =  convertNumToText(Integer.parseInt(pctAndDec[0]),0);
		for(int i = 0; i<numStr.length;++i){res.add(numStr[i]);}
		res.add("point");
		numStr =  convertNumToText(Integer.parseInt(pctAndDec[1]),0);
		for(int i = 0; i<numStr.length;++i){res.add(numStr[i]);}
		return res;
	}
	
	//process percent values
	public ArrayList<String> processPercent(String tmp){
		ArrayList<String> res = new ArrayList<String>();		
		String[] pctVals = PApplet.splitTokens(tmp,"%");
		//System.out.println("Percent value : " + pctVals[0]);
		String pctValNoCommas = pctVals[0].replace(",", "");//get rid of commas
		if(pctValNoCommas.contains(".")){//check for point
			res.addAll(processDecimalNumbers(pctValNoCommas));
			res.add("percent");			
		} else {			 
			String[] numStr = convertNumToText(Integer.parseInt(pctVals[0]),0);
			for(int i = 0; i<numStr.length;++i){res.add(numStr[i]);}
			res.add("percent");
		}
		return res;		
	}//processPercent
	
	//build strings of "short-cut" numbers like "1911" -> "nineteen eleven" - take a value up to 4 digits
	public ArrayList<String> processYearPhoneSCut(String numStr, boolean useTrailS){
		ArrayList<String> res = new ArrayList<String>();
		int numVal = Integer.parseInt(numStr), val1 = numVal / 100, val2 = numVal % 100;
		if((val1 == 20) && (val2 < 10)){//assume year 2000 -> 2009
			res.add("two");
			res.add("thousand");
			if(val2 > 0){
				int numUsage = (useTrailS ? 2 : 0);//whether or not to use plural decades				
				String[] valAra = convertNumToText(val2,numUsage);
				for(int i = 0; i<valAra.length;++i){res.add(valAra[i]);}	
			}			
		} else {
			String[] valAra;
			if(val1 > 0){
				valAra = convertNumToText(val1,0);
				for(int i = 0; i<valAra.length;++i){res.add(valAra[i]);}
			}
			//res.add("hundred");
			int numUsage = (useTrailS ? 2 : 0);//whether or not to use plural decades				
			valAra = convertNumToText(val2,numUsage);
			for(int i = 0; i<valAra.length;++i){res.add(valAra[i]);}	
		}
		return res;
	}
	
	
	public ArrayList<String> processNumeric(String strTmp){
		ArrayList<String> res = new ArrayList<String>();
		//get rid of trailing periods
		String str = strTmp.replace("'", "");												//get rid of apost
		str = str.replace("\"","");
		if(str.charAt(str.length()-1) == '.'){str = str.substring(0, str.length()-1);} 		//get rid of last period
		String strNoCommas = str.replace(",", "").trim();//get rid of commas
		if(strNoCommas.contains(".")){			//decimal input
			res.addAll(processDecimalNumbers(strNoCommas));
		} else if((strNoCommas.contains("st")) || (strNoCommas.contains("th") && !strNoCommas.contains("month"))){				//handle fractional numeric "5th"
			String numVal = strNoCommas.replaceAll("[^0-9]", "");
			String[] numStr = convertNumToText(Integer.parseInt(numVal),1);
			for(int i = 0; i<numStr.length;++i){res.add(numStr[i]);}				
		} else if(strNoCommas.contains("-") || strNoCommas.contains("/")){				//hyphen or slash
			String[] strTokens = strNoCommas.split("-|/");
			try{
				String[] numStr = convertNumToText(Integer.parseInt(strTokens[0]),0);
				for(int i = 0; i<numStr.length;++i){res.add(numStr[i]);}	
			} catch(Exception e){		res.add(strTokens[0]);}
			for(int i = 1; i<strTokens.length;++i){//add all strings after hyphen - try to see if they are digits, otherwise add them as is
				try{res.addAll(processYearPhoneSCut(strTokens[i],false));	}
				catch(Exception e){		res.add(strTokens[i]);}
			}
			//System.out.println("res :");for(String val : res){System.out.print(val + " | ");}System.out.println("");
		} else if(( ((strNoCommas.length() == 5) || (strNoCommas.length() == 3)) && strNoCommas.contains("s")) || ((strNoCommas.length() == 4) && !strNoCommas.contains("s"))){	//numeric year - 1776, 1990s, 90s, etc - use more common notation
			if(strNoCommas.equals("2000s")){res.add("two");res.add("thousands");} 
			else {res.addAll(processYearPhoneSCut(strNoCommas.replaceAll("[^0-9]", "").trim(),(strNoCommas.length() == 5) || (strNoCommas.length() == 3)));}			
		} else {
			String[] numStr = convertNumToText(Integer.parseInt(strNoCommas),0);
			for(int i = 0; i<numStr.length;++i){res.add(numStr[i]);}	
		}	
		
		return res;		
	}//processNumeric
	
	public void debugOutput(String type, String tmp, ArrayList<String> res) {System.out.println(type + " input : " + tmp + "  " + type + " res : ");for(String val : res){System.out.println(val);}}
	
	//check if the next string value in the string list is million, billion, or trillion, to properly build string list data
	public boolean checkHugeMoneyNextVal(String nextVal){return (nextVal.contains("illion"));}
	//all processing to be done on a particular token (string) - remove unwanted punctuation, etc - may separate into multiple words
	public ArrayList<String> parseStrToken(String inStr, String nextVal){
		ArrayList<String> res = new ArrayList<String>();		
		String tmp = inStr
				.replace("...", "")
				.replace(";","")
				.replace("?","")
				.replace("!","")
				.trim(), 				
				tmp2 = nextVal.trim();	
		if(tmp.contains("$")){//process money value - check if next value in token stream is billion, million, trillion, etc.
			res = processMoney(tmp, "dollar", nextVal.contains("illion"));	
			//debugOutput("Money String",tmp, res);
		} else if(tmp.contains("%")){//process percent value
			res = processPercent(tmp);
			//debugOutput("Percent String",tmp, res);
		} else if (tmp.contains("401(k)")){//process specific string
			res.add("four");res.add("oh");res.add("one");res.add("kay");		
			//debugOutput("401k",tmp, res);
		} else if (tmp.contains("g20")){//handle error in caption file
			res.add("gee");res.add("twenty");	
			//debugOutput("g20",tmp, res);
		} else if (tmp.contains("aaa")){//handle specific string
			res.add("triple");res.add("ay");	
			//debugOutput("aaa",tmp, res);
		} else if (tmp.contains("afl") && tmp.length() == 3){//handle specific string
			res.add("ay");res.add("eff");res.add("ell");	
			//debugOutput("afl",tmp, res);
		} else if (tmp.contains("acceptedif")){//handle error in caption file
			res.add("accepted");res.add("if");	
			//debugOutput("acceptedif",tmp, res);
		} else if ((tmp.contains("www.")) || (tmp.contains(".gov"))){			//web page
			int stIDX = 0;
			if (tmp.contains("www.")){
				res.add("double");res.add("you");res.add("double");res.add("you");res.add("double");res.add("you");
				res.add("dot");
				stIDX = 1;
			}
			String[] urlTokens = tmp.split("\\.");
			for(int i = stIDX; i<urlTokens.length-1;++i){
				res.add(urlTokens[i]);
				res.add("dot");
			}
			//last substring - ".gov/<qstring stuff..."
			String[] qstrTokens =urlTokens[urlTokens.length-1].split("/"); 
			for(int i = 0; i<qstrTokens.length-1;++i){
				res.add(qstrTokens[i]);
				res.add("forward");
				res.add("slash");
			}		
			res.add(qstrTokens[qstrTokens.length-1]);
			//debugOutput("Web address",tmp, res);
		} else if (tmp.matches(".*\\d+.*")) {//contains any number not already covered
			//System.out.println("numeric tmp : " + tmp);
			res = processNumeric(tmp);
			//debugOutput("Numeric",tmp, res);
		} else {
			tmp = tmp
					.replace("\"", "")
					.replace("'", "")
					.replace("’", "")
					.replace("[", "")
					.replace("]", "")
					.replace(",", "")
					.replace(".", "")
					.replace(":", "")
					;
			if(tmp.contains("-")){	res.addAll(handleHyphens("-",tmp));} 
			else if(tmp.contains("—")){	res.addAll(handleHyphens("—",tmp));	} 
			else if(tmp.contains("–")){	res.addAll(handleHyphens("–",tmp));	} 
			else {				res.add(tmp);			}
			//debugOutput("\tAlpha :",tmp, res);
		}		
		return res;
	}
	//handle the multitude of hyphens found in the caption files
	public ArrayList<String> handleHyphens(String hyphen, String tmp){
		ArrayList<String> res = new ArrayList<String>();	
		String[] hyphenToks = tmp.split(hyphen);
		for(int i = 0;i<hyphenToks.length; ++i){res.add(hyphenToks[i]);} 
		return res;
	}
	
	//time string partitions a block in the caption file. - this is one sentence
	//starts with time string of format st time '-->' end time
	//then contains 1, 2 or potentially 3 lines of text, then a blank line, before another time string starts
	//idx is index of time string within passed strAra
	//wordMap is start-frame-estimated location of each word in sentence
	public int readSentence(String fileName, String[] strAra, int idx, TreeMap<Integer, wordCap> wordMap, hrMinSecToFrame timeConv){
		int curLine = idx, sentenceLen = 0, frameSpan;
		String curTimeString = new String(strAra[curLine].trim()), readString = "";//readString is string line
		int[] curTimeVals = timeConv.parseTimeStrings(curTimeString);
		frameSpan = curTimeVals[1]-curTimeVals[0] -1;
		++curLine;
		ArrayList<String> raw_sentence = new ArrayList<String>(),sentence = new ArrayList<String>();		//the sentence being spoken during this time span
		while(strAra[curLine].length() != 0){		
			if((curLine == 5) && (strAra[curLine].toLowerCase().contains("president:"))){	String[] tmpAra = PApplet.splitTokens(strAra[curLine], ":");	if(tmpAra.length > 1) {readString = tmpAra[1].toLowerCase();	} else {++curLine;continue;}} 
			else {	readString = strAra[curLine].toLowerCase();	}						
			String[] token = PApplet.splitTokens(readString, " "); // Get a line and parse tokens.
			for(int j=0;j<token.length; ++j){
				raw_sentence.add(token[j]);
			}
			++curLine;		
		}	
		//build sentences from multiple caption lines - a sentence spans the time span given in the preceding time stamp
		for(int j=0;j<raw_sentence.size(); ++j){
			ArrayList<String> tmpStringAra = parseStrToken(raw_sentence.get(j),(j == raw_sentence.size()-1)? "" : raw_sentence.get(j+1));//word
			for(int i =0; i<tmpStringAra.size();++i){
				String val = tmpStringAra.get(i);
				sentence.add(val);		
				sentenceLen += val.length();					
			}
		}
		
		//put words in map
		wordCap tmpWordCap;
		//String _fileName, String _word, String _timeFrameStr, int _frameStart, int _frameEnd
		int stLoc = curTimeVals[0], endLoc = 0;
		//set each words location based on time span of caption, and length based on fraction of caption time span that word takes up
		int sntWrdIDX = 0;
		for(int j=0; j<sentence.size();++j){
			String word = sentence.get(j);
			
			float ratio = word.length()/(1.0f * sentenceLen);
			int frameLen = Math.round(frameSpan * ratio);
			endLoc = stLoc + frameLen;			
			//tmpWordCap = new wordCap(fileName, word, curTimeString, stLoc, endLoc,j,(curTimeVals[0] > 1 ? curTimeVals[0] : 1),curTimeVals[1]);
			if(stLoc > 0){//if beginning of sentence is clippsed
				tmpWordCap = new wordCap(fileName, word, curTimeString, stLoc, endLoc,sntWrdIDX++,(curTimeVals[0] > 1 ? curTimeVals[0] : 1),curTimeVals[1]);
				wordMap.put(stLoc, tmpWordCap);
				stLoc = endLoc;
			} else {
			//System.out.println("Start : " +stLoc + " | End : " +endLoc  + " | "+ sentence.get(j));
				stLoc = 1;
			}
		}
		//System.out.println("wordMap length : " + wordMap.size());		
		return curLine;
	}//readTimeString
	
	//read a single file of captions and process the file's captions into a word map 
	public void readFile(String dirLoc,String outDirLoc, String fileName, String ext){
		String capFileName = "../data/"+dirLoc +"/"+fileName+ext;
		String wordScriptFileName = outDirLoc + "/snd/" +fileName+"/wordScript_"+ fileName+".csv";
		String bestWordBndsFileName = outDirLoc + "/capLocs/" + fileName+".csv";
		String audioBoundsFileName = "D:/LipReaderProject/listeningeye/MatlabCode/FaceDetectCrop/" +outDirLoc + "/snd/" +fileName+"/audioBounds_"+ fileName+".csv";
		
		TreeMap<Integer, wordCap> wordMap = new TreeMap<Integer,wordCap>();			//holds captions keyed by start frame location in this file
		String[] strAra = null;
		try{
			strAra = loadStrings(capFileName);
			//System.out.println("File name : " + fileName + " Size : " + strAra.length);
		} catch (Exception e) {	System.out.println("Caption File Read Error : " + capFileName + " not found."); return;		}
		hrMinSecToFrame timeConv = null;
		try{
			timeConv = new hrMinSecToFrame(frameRateMap.get(fileName),matlabOffset);
		} catch (Exception e) {	System.out.println("File doesn't exist in frame rate map : File name : " + fileName + " not found."); return;		}
		//if (str == null) {System.out.println("Error! Failed to read the file.");}
		for (int i=4; i<strAra.length; ++i) { //skip 1st 4 lines
			//System.out.println("Line " + (i+1) + " : " + strAra[i]);
			if(strAra[i].trim().equals("")){continue;}
			//time string is start of functional block
			if(strAra[i].trim().contains("-->")){i = readSentence(fileName,strAra,i,wordMap,timeConv);}//read lines between time strings, set values in wordMap, advance i		
		}
		String[] audioBndsStrAra = null;
		try{
			audioBndsStrAra = loadStrings(audioBoundsFileName);			
		} catch (Exception e) {	System.out.println("Audio Bounds File Read Error : Unable to find audio bounds csv : " + audioBoundsFileName ); return;		}
		findBestWordBounds(wordMap,audioBndsStrAra);
		//by here we have entire word layout of video plus estimates of frame locations - read in audio suggestions for word locations
		writePerVidFile("D:/from dropbox/eclipse workspace/ObamaCaptions/data/out_"+dirLoc +"/wordScript_"+ fileName+".csv", wordMap, true);		
		writePerVidFile("D:/LipReaderProject/listeningeye/MatlabCode/FaceDetectCrop/" + wordScriptFileName, wordMap, false);	
		//improve word bounds locations, resave results updated
		writePerVidFile("D:/LipReaderProject/listeningeye/MatlabCode/FaceDetectCrop/" + bestWordBndsFileName, wordMap, false);	
	}//readFile

	//avoid negs
	public int keepPos (int val){return max(1,val);}
	//this function will try to find the best boundary in the audio data for each word, based on suggestions from caption file's caption display text and suggestions from audio file's volume limits
	public void findBestWordBounds(TreeMap<Integer, wordCap> wordMap,String[] audioBndsStrAra){
		int[][] bndsVals = new int[audioBndsStrAra.length-1][2];
		TreeMap<Integer, Integer> bndsValsByStartTree = new TreeMap<Integer, Integer> (), bndsValsByEnd = new TreeMap<Integer, Integer> ();//start to idx in bndsVals, end to idx in bnds vals
		Integer[] tmpIntAra = new Integer[]{0,0};
		for(int i = 1; i<audioBndsStrAra.length;++i){
			String[] tokens = audioBndsStrAra[i].split(",");
			bndsVals[i-1][0] = Integer.parseInt(tokens[0]);
			bndsVals[i-1][1] = Integer.parseInt(tokens[1]);
			tmpIntAra = new Integer[]{bndsVals[i-1][0],bndsVals[i-1][1]};
			bndsValsByStartTree.put(bndsVals[i-1][0], i-1);
			bndsValsByEnd.put(bndsVals[i-1][1], i-1);
		}	
		int wordIDX = 0;
		//now find best estimate of word bounds, based on word location in caption file (and cap file "sentence", suggestions of caption file text display timing, and volume bounds from audio data
		//move through bndsVals ara to find closest reasonable boundaries for a particular word suggested by a caption file
		for(Integer key : wordMap.keySet()){		//for every word
			wordCap wordData = wordMap.get(key);
			int curWordStartEst = wordData.frameStEst;		//estimate based on caption display string and partition in sentence length
			int curWordEndEst = wordData.frameEndEst;		//estimate based on caption display string and partition in sentence length
			//get idx in start audio suggestions that is highest before start value and idx in end audio suggestions that is lowest while being past end estimate
			Integer floorKey = bndsValsByStartTree.floorKey(curWordStartEst+1), ceilKey =  bndsValsByEnd.ceilingKey(curWordEndEst-1);
			int audioIDXSt = (floorKey == null ? 1 : floorKey);
		    int audioIDXEnd = (ceilKey == null ? bndsValsByEnd.lastKey() : ceilKey);
		    //these values will include other text
		    wordData.audSugStEst = audioIDXSt;
		    wordData.audSugEndEst = audioIDXEnd;
			//System.out.println("Audio-suggested frame bounds : st : " + audioIDXSt + " | end : " + audioIDXEnd + " || derived from caption :  "+ curWordStartEst + " | " + curWordEndEst);
			}//for every word
	}//findBestWordBounds
	
	
	//write a file per video listing out, in order, the words spoken, along with their frame bound estimates and the caption time string from the vtt file
	public void writePerVidFile(String fileName, TreeMap<Integer, wordCap> wordMap, boolean addWordCap){
		String[] stringVals = new String[wordMap.size()+1];
		int idx = 0;
		stringVals[idx++] = "FrameStartEst,FrameEndEst,Word,SentenceLocation,NearestAudioFrameStart,NearestAudioFrameEnd,CapTimeFrameStart,CapTimeFrameEnd,SourceFileName,timeFrameString";
		for(Integer key : wordMap.keySet()){
			//System.out.println("Key : " + key + " val : " + wordMap.get(key));
			wordCap wordData = wordMap.get(key);
			stringVals[idx++] = wordData.toString();
			if(addWordCap){//build complete dictionaries
				addWordCapToDict(captionDict,wordData);
				addToFileNameToWordMap(fileName, wordData);
			}
		}		
		saveStrings(fileName, stringVals);	
	}//writePerVidFile
	
	//add wordData field to global dictionary of words
	public void addWordCapToDict(TreeMap<String,ArrayList<wordCap>> map, wordCap wordData){
		ArrayList<wordCap> tmpList = map.get(wordData.word);
		if(null == tmpList){tmpList = new ArrayList<wordCap>();}
		tmpList.add(wordData);
		map.put(wordData.word, tmpList);
	}//addWordToCapDict
	
	public int showCaptionDict(){
		Set<String> keys = captionDict.keySet();
		int numWords = keys.size();
		int idx = 0;
		int numTotOccurences = 0;
		
		for(String key : keys){
			ArrayList<wordCap> wordAra = captionDict.get(key);
			numTotOccurences += wordAra.size();
			System.out.println(idx++ + "th word : " + key + "	\t# of occurences : " + wordAra.size());			
		}	
		System.out.println("Total of "+numWords+" unique words, " + numTotOccurences + " total words, found in the parsed vtt files.");
		System.out.println("");
		return numTotOccurences;
	}//showCaptionDict
	
	//save a csv which has 1st col == word, and then all files and locations where the word can be found, 1 row per (so multiple rows per word)
	public void saveCaptionDictCSV(int numTotOccurences, TreeMap<String,Integer> chosenWords){
		Set<String> keys = captionDict.keySet(), chosenWordKeys = chosenWords.keySet();
		//save to csv
		TreeMap<String,Integer> chsnWordsToIDX = new TreeMap<String,Integer>();
		int cwidx = 0;
		for(String key : chosenWordKeys){chsnWordsToIDX.put(key,cwidx++);}
		String[] outStrings = new String[numTotOccurences+1];
		String[] outOverviewStrings = new String[keys.size()];
		
		ArrayList<String> outTrainingDataStrings = new ArrayList<String>();			//data with only numeric values
		ArrayList<String> outChosenStrings = new ArrayList<String>();
		TreeMap<String, String> outChosenTrainVids = new TreeMap<String,String>();	//using treemap to make unique - could be set
		//TreeMap<String, String> outChosenTrainWords = new TreeMap<String,String>();	//using treemap to make unique - each word
		int idx = 0, w_idx = 0;
		outStrings[idx++]="word,FrameStEstimate,FrameEndEstimate,SentenceLocation,audioAugFrameStEstimate,audioAugFrameEndEstimate,CaptionsStartTime,CaptionsEndTime,FileName,TimeCaption";
		outChosenStrings.add("word,FrameStEstimate,FrameEndEstimate,SentenceLocation,audioAugFrameStEstimate,audioAugFrameEndEstimate,CaptionsStartTime,CaptionsEndTime,FileName,TimeCaption,WordClassIDX");
		for(String key : keys){//for every word
			ArrayList<wordCap> wordAra = captionDict.get(key);
			outOverviewStrings[w_idx++] = key + ","+wordAra.size(); 		//word and # of occurences
			for(int i =0; i<wordAra.size();++i){							//individual row with word, start frame, end frame, file name and time string
				wordCap wordC = wordAra.get(i);
				String resStr = ""+wordC.word + ","+ wordC.frameStEst + "," + wordC.frameEndEst + "," + wordC.sentenceLoc + "," 
						+ wordC.audSugStEst + "," + wordC.audSugEndEst + "," + wordC.capFrameSt + "," + wordC.capFrameEnd + "," + wordC.fileName + "," + wordC.timeFrameStr;
				outStrings[idx++]=resStr;
				if(chosenWords.keySet().contains(key)){		
					//outChosenTrainWords.put(wordC.word, wordC.word);
					outChosenTrainVids.put(wordC.fileName, wordC.fileName);
					outChosenStrings.add(resStr+"," + chsnWordsToIDX.get(key));
					outTrainingDataStrings.add(wordC.frameStEst+","+wordC.frameEndEst+","+wordC.sentenceLoc+","+wordC.audSugStEst+","
							+ wordC.audSugEndEst + "," + wordC.capFrameSt + "," + wordC.capFrameEnd + "," + wordC.fileNum + ","+chsnWordsToIDX.get(key));
				}
			}
		}
		String[] trainingStrings = outChosenStrings.toArray(new String[0]);
		String[] trainVids = outChosenTrainVids.keySet().toArray(new String[0]);
		String[] trainingDataStrings = outTrainingDataStrings.toArray(new String[0]);
		//String[] trainWords = outChosenTrainWords.keySet().toArray(new String[0]); //			.keySet().toArray(new String[0]);
		
		//D:/LipReaderProject/listeningeye/MatlabCode/FaceDetectCrop/trainingData/
		//saveStrings("D:/LipReaderProject/listeningeye/MatlabCode/FaceDetectCrop/trainingData/training_ChosenWords.csv", trainWords);
		saveStrings("D:/LipReaderProject/listeningeye/MatlabCode/FaceDetectCrop/trainingData/training_NecessaryVids.csv", trainVids);
		saveStrings("D:/LipReaderProject/listeningeye/MatlabCode/FaceDetectCrop/trainingData/training_WordDict.csv", trainingStrings);	
		saveStrings("D:/LipReaderProject/listeningeye/MatlabCode/FaceDetectCrop/trainingData/training_DataNumericDict.csv", trainingDataStrings);
		//saveStrings("training_ChosenWords.csv", trainWords);
		saveStrings("training_DataNumericDict.csv", trainingDataStrings);
		saveStrings("training_NecessaryVids.csv", trainVids);
		saveStrings("training_WordDict.csv", trainingStrings);	
		saveStrings("totalWordDict.csv", outStrings);	
		saveStrings("totalWordCountDict.csv", outOverviewStrings);	
	}//saveCaptionDictCSV
	//
	
	//build structure that has a word map for each filename - this will hopefully reveal which files have the most unique words
	public void addToFileNameToWordMap(String fileName,wordCap wordData){
		fileCount fCntObj = fileNameDict.get(fileName);
		if(null==fCntObj){fCntObj = new fileCount(fileName);}
		fCntObj.addUniqueWord(wordData);		
		fileNameDict.put(fileName, fCntObj);		
	}//addToFileNameToWordMap
	
	public void showCapsPerFileDict(){
		//to build structure to determine minimum files to cover all words, (Knapsack): 
		//first need list to put fileCount objs into		
		ArrayList<fileCount> allFileCounts = new ArrayList<fileCount>();
			
		Set<String> fileKeys = fileNameDict.keySet();		
		int maxNumWordsInFile = -1; String maxWordsFileName="";
		for(String fkey : fileKeys){
			fileCount fileCountObj = fileNameDict.get(fkey);
			allFileCounts.add(fileCountObj);
			System.out.println("Filename : " + fkey + "	\t# of unique words : " + fileCountObj.uWordCount);
			if(maxNumWordsInFile <fileCountObj.uWordCount ){
				maxWordsFileName = fkey;
				maxNumWordsInFile = fileCountObj.uWordCount;
			}		
		}		
		System.out.println("Most unique words per file : "+maxNumWordsInFile+" unique words found in file " + maxWordsFileName );
		//(knapsack con't) then need to sort by # of unique words
		Collections.sort(allFileCounts);
		//then add to word->fileCount map, in order, so that files with most words are favored - word is added only if it doesn't exist already
		TreeMap<String, fileCount> wordToFCountMap = new TreeMap<String, fileCount>();
		ArrayList<fileCount> uniqueWordFileNames = new ArrayList<fileCount>(), extraWordFileNames = new ArrayList<fileCount>();
		int numUniqueFiles = 0;
		for(int i = allFileCounts.size()-1; i >=0;--i){
			boolean addedThisFile = false;
			fileCount fCnt = allFileCounts.get(i);
			for(String fWord : fCnt.uniqueWords.keySet()){		
				fileCount tmpFCnt = wordToFCountMap.get(fWord);
				if(tmpFCnt == null){ 
					fCnt.addWordUsedFor(fWord);
					wordToFCountMap.put(fWord, fCnt);
					addedThisFile = true;
				}				
			}		
			if(addedThisFile){uniqueWordFileNames.add(fCnt);++numUniqueFiles;} else {	extraWordFileNames.add(fCnt);	}
		}//
//		Set<String> wordKeys = wordToFCountMap.keySet();
//		for(String word : wordKeys){
//			System.out.println("Word : " + word + " | Filename : " + wordToFCountMap.get(word).fileName);
//		}
		System.out.println("");
		System.out.println("# of unique files added : " + numUniqueFiles + " # of unique words covered:  " + wordToFCountMap.size() );
		
		Collections.sort(uniqueWordFileNames);
		String[] outStrings = new String[uniqueWordFileNames.size()+1];
		outStrings[0]="File Name,# of Unique Words,# of words this file used for,Unique words List";
		for(int i = uniqueWordFileNames.size()-1; i >=0;--i){
			outStrings[i+1] = uniqueWordFileNames.get(i).toString();
			System.out.println(i+"\t:"+uniqueWordFileNames.get(i).fileName);			
		}
		saveStrings("FilesForAllWords.csv", outStrings);	

		System.out.println("Files without any unique words - unnecessary for training");
		for(int i = 0; i<extraWordFileNames.size();++i){
			System.out.println(i+"\t:"+extraWordFileNames.get(i).fileName);			
		}
	}//showCapsPerFileDict

	//print out all words in caption dictionary and file name to word map data
	public void saveAllMetrics(TreeMap<String,Integer> chosenWords){
		saveCaptionDictCSV( showCaptionDict(), chosenWords);
		showCapsPerFileDict();
	}//showCapDict
	

	//process VTT files
	public void procVTTFiles(){
		captionDict = new TreeMap<String,ArrayList<wordCap>>();
		fileNameDict = new TreeMap<String,fileCount>();
		buildFrameRateMap();
		String[] dirs = {"batch_1", "batch_2"};
		String[] projDirs = {"output", "output_2"};//dirs used in project data - to write per-vid csvs directly to t directories
		for(int d =0; d<dirs.length;++d){
			File folder = new File("D:/from dropbox/eclipse workspace/ObamaCaptions/data/"+dirs[d]);
			File[] listOfFiles = folder.listFiles();
			String tmpName;
		    for (int i = 0; i < listOfFiles.length; i++) {
		    	if (listOfFiles[i].isFile()) {
		    		tmpName = listOfFiles[i].getName();
		    		String[] tokens = PApplet.splitTokens(tmpName, ".");
		    		System.out.println("Processing File " + tokens[0] + "| ext : " + tokens[1]);
		    		readFile(dirs[d],projDirs[d],tokens[0], "."+tokens[1]);
		    	} else if (listOfFiles[i].isDirectory()) {System.out.println("Directory " + listOfFiles[i].getName());}
		    }//for each file
		}//for each dir
		System.out.println("Done");
		System.out.println("");
		//TODO load desired training data
		String trainingDataFileName = "DesiredTrainingWords.csv";
		saveAllMetrics(loadDesiredTrainingData(trainingDataFileName));
	}//procVTTFiles	
	
	public TreeMap<String,Integer> loadDesiredTrainingData(String fileName){		
		TreeMap<String,Integer> chosenWords = new TreeMap<String,Integer>();
		//desired training data csv should have word and # of occurences
		String[] wordStrings = loadStrings(fileName);
		for(int i =0;i<wordStrings.length;++i){
			String[] toks = wordStrings[i].split(",");
			chosenWords.put(toks[0].toLowerCase(),Integer.parseInt(toks[1]));
		}	
		return chosenWords;
	}//loadDesiredTrainingData
	
	public void setup(){procVTTFiles();}//setup

	public static void main(String[] args) {
		//for every file
		PApplet.main(new String[] {  "ObamaCapPkg.CaptionMain" });
	}//main
}//captionMain class


//used to convert text hr/min/sec to frame value - set conversion rate, and perform calc here
class hrMinSecToFrame {
	public final float frameRt;
	public float hrToFrame , minToFrame, secToFrame;
	public int matlabOffset;							//offset for building file in matlab to skip intro
	public hrMinSecToFrame(float _frameRt, int _matlabOffset){
		frameRt = _frameRt;
		matlabOffset = _matlabOffset;
		hrToFrame = frameRt * 3600;
		minToFrame = frameRt * 60;
		secToFrame = frameRt;
	}
	//convert a time string from the vtt file to a time value
	public int convToFrameRate(String tmpTimeStr){
		String[] tokens =  PApplet.splitTokens(tmpTimeStr,":.");
		int res = Math.round(Integer.parseInt(tokens[0]) * hrToFrame + 
				Integer.parseInt(tokens[1]) * minToFrame + 
				Integer.parseInt(tokens[2]) * secToFrame + 
				frameRt * .001f * Float.parseFloat(tokens[3]));
		res -=matlabOffset;
		return res;
		
	}
	public int[] parseTimeStrings(String timeString){
		int[] res = new int[]{0,0};
		String[] timeVals = PApplet.splitTokens(timeString,"-->");
		for(int i =0; i<timeVals.length;++i){
			//System.out.println("timevals str["+i+"]-> "+timeVals[i].trim());
			res[i]=convToFrameRate(timeVals[i].trim());
			//System.out.println("res["+i+"] : " + res[i]);	
		}	
		return res;
	}//parseTimeString

	
}//hrMinSecToFrame

