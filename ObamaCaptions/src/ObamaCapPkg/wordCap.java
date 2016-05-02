package ObamaCapPkg;

import java.util.ArrayList;
import java.util.TreeMap;

//class to hold a single word found in a caption file. retain parent file name, time span string, and estimate of frame number where word starts
public class wordCap implements Comparable<wordCap>{
	public String word, fileName;						//parent video file
	public String timeFrameStr;				//location string within the caption file -> format is start hr:min:sec.frame --> end hr:min:sec.frame
	public int frameStEst, frameEndEst, sentenceLoc;		//estimate of frame location within the file where the word starts, word ends - based solely off location string; location in owning "sentence" (sequence of words described by a single time string span in caption file
	public int capFrameSt, capFrameEnd;						//begin and end bounds of time string caption for sentence this word belongs to
	public int audSugStEst, audSugEndEst, fileNum;					//begin and end bounds of time string caption for sentence this word belongs to; file Number
	public wordCap(String _fileName, String _word, String _timeFrameStr, int _frameStart, int _frameEnd, int _sentLoc,int _capStart, int _capEnd) {
		fileName = _fileName;
		String[] toks = fileName.split("_");
		fileNum = Integer.parseInt(toks[0]);
		word = _word;
		timeFrameStr = _timeFrameStr;
		sentenceLoc = _sentLoc;
		frameStEst = _frameStart;	frameEndEst = _frameEnd;
		audSugStEst = _frameStart;	audSugEndEst = _frameEnd;		//overridden once calculated
		capFrameSt = _capStart; capFrameEnd = _capEnd;
	}
	@Override
	public int compareTo(wordCap arg0) {return (this.frameStEst < arg0.frameStEst ? -1 : (this.frameStEst > arg0.frameStEst ? 1 : 0));}
	@Override
	public String toString(){return frameStEst + "," + frameEndEst + "," + word.trim() + "," +sentenceLoc + "," + audSugStEst + "," + audSugEndEst+ "," + capFrameSt + "," + capFrameEnd + "," + fileName + "," + timeFrameStr;}
	
}//wordCap

class fileCount implements Comparable<fileCount>{
	public String fileName;
	public int uWordCount = 0, usedForWordCount = 0;
	public TreeMap<String,wordCap> uniqueWords, usedForWords;		//unique word/wordcap mappings
	
	public fileCount(String _fname){		fileName = _fname;uniqueWords = new TreeMap<String,wordCap>();usedForWords = new TreeMap<String,wordCap>();}
	
	public void addUniqueWord(wordCap newWord){	//put only 1 occurence of each word in this fileCount map
		wordCap res = uniqueWords.get(newWord.word);
		if((res == null) || (res.frameStEst > newWord.frameStEst)){uniqueWords.put(newWord.word, newWord); uWordCount = uniqueWords.size(); }		//if doesn't exist, or if earlier in file (hopefully helps to coalesce collections of unique words into sections)
	}
	//add word that this file is used for
	public void addWordUsedFor(String newWord){
		wordCap res = usedForWords.get(newWord);
		if(res == null) {usedForWords.put(newWord, uniqueWords.get(newWord)); usedForWordCount = usedForWords.size(); }		//if doesn't exist, or if earlier in file (hopefully helps to coalesce collections of unique words into sections)
	}
	
	public String getAllUniqueWords(){
		String res = "";
		for(wordCap word : usedForWords.values()){res += word.frameStEst + " - " + word.frameEndEst + "," + word.word.trim() + "," ;}

		return res;
	}
	
	@Override
	public int compareTo(fileCount arg0) {return (this.uWordCount < arg0.uWordCount ? -1 : (this.uWordCount > arg0.uWordCount ? 1 : 0));}
	@Override
	public String toString(){
		String res = fileName + "," + uWordCount + "," + usedForWordCount + ",";
		//for(wordCap word : uniqueWords.values()){res += word.frameStEst + " - " + word.frameEndEst + "," + word.word.trim() + "," ;}
		for(wordCap word : usedForWords.values()){res += word.frameStEst + " - " + word.frameEndEst + "," + word.word.trim() + "," ;}
		return res;
	}
}//fileCount