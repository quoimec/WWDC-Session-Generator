import CoreML
import SQLite3
import AVFoundation
import PlaygroundSupport
import UIKit

//PlaygroundPage.current.needsIndefiniteExecution = true

//guard let predictionModel = NextWord(modelName: "Core-CKPT-91-10", ngramSize: 6), let lookupDatabase = Lookup(databasePath: Bundle.main.path(forResource: "Old_Tokenised", ofType: "sqlite")) else {
//	PlaygroundPage.current.finishExecution()
//}
//
//let lineEnders = [".", "!", "?"]
//let punctuationValues = lineEnders + [","]
//let punctuationTokens = punctuationValues.map({ lookupDatabase.lookupValue(passedValue: $0).index }) + [0]
//
//var startingString = "Open up a network connection"
//
//let predictionInput = predictionModel.processString(passedString: startingString).map({ lookupDatabase.lookupValue(passedValue: String($0)).index })
//let predictionOutput = predictionModel.runPredictions(initialTokens: predictionInput, wordCount: 300, predictionScope: 3, punctuationTokens: punctuationTokens).map({ lookupDatabase.lookupIndex(passedIndex: $0).value })
//
//var predictionSentences: Array<Array<String>> = [[]]
//
//for eachWord in predictionOutput {
//
//	predictionSentences[predictionSentences.count - 1].append(eachWord)
//
//	if lineEnders.contains(eachWord) {
//		predictionSentences.append([])
//	}
//
//}
//
//predictionSentences[0][0] = startingString + " " + predictionSentences[0][0]
//var finalSentences = predictionSentences.map({ String($0.reduce("", { $0 + $1 + " " }).dropLast()) })
//
//print(finalSentences)

struct Uppercase {

	public var lookup: String
	public var translated: String
	
	init(lookup: String, translated: String) {
	
		self.lookup = lookup
		self.translated = translated
	
	}

}

func cleanText(passedArray: Array<String>) -> String {

	var sentenceArray: Array<String> = [""]
	
	let endlineLookup = [".", "?", "!"]
	let uppercaseLookup: Array<Uppercase> = [
		Uppercase(lookup: "i", translated: "I"),
		Uppercase(lookup: "i'm", translated: "I'm"),
		Uppercase(lookup: "wwdc", translated: "WWDC"),
		Uppercase(lookup: "apple", translated: "Apple"),
		Uppercase(lookup: "ios", translated: "iOS"),
		Uppercase(lookup: "iphone", translated: "iPhone"),
		Uppercase(lookup: "mac", translated: "Mac"),
		Uppercase(lookup: "os", translated: "OS"),
		Uppercase(lookup: "sonoma", translated: "Sonoma"),
		Uppercase(lookup: "tim", translated: "Tim"),
		Uppercase(lookup: "cook", translated: "Cook")
	]
	
	for eachWord in passedArray {
	
		let lastSentence = sentenceArray.count - 1
	
		if eachWord == "," {
			sentenceArray[lastSentence] += eachWord
		} else if endlineLookup.contains(eachWord) {
			sentenceArray[lastSentence] += eachWord
			sentenceArray.append("")
		} else if let replaceIndex = uppercaseLookup.index(where: { $0.lookup == eachWord }) {
			sentenceArray[lastSentence] += " \(uppercaseLookup[replaceIndex].translated)"
		} else if sentenceArray[lastSentence].count == 0 {
			sentenceArray[lastSentence] += "\(String(eachWord.prefix(1).uppercased() + eachWord.dropFirst()))"
		} else {
			sentenceArray[lastSentence] += " \(eachWord)"
		}
	
	}
	
	return sentenceArray.reduce("", { $0 + "\($1) "})
	
}


print(cleanText(passedArray: ["my", "name", "is", "tim", "cooker", ".", "and", "i", "have", ",", "had", "the"]))






