import CoreML
import SQLite3
import AVFoundation
import PlaygroundSupport

guard let predictionModel = NextWord(modelName: "Core-CKPT-60-60", ngramSize: 6), let lookupDatabase = Lookup(databasePath: Bundle.main.path(forResource: "Tokenised", ofType: "sqlite")) else {
	PlaygroundPage.current.finishExecution()
}

let punctuationTokens = [".", ",", "!", "?"].map({ lookupDatabase.lookupValue(passedValue: $0).index }) + [0]

print(punctuationTokens)

var startingString = "Tim/Apple"
let predictionInput = predictionModel.processString(passedString: startingString).map({ lookupDatabase.lookupValue(passedValue: String($0)).index })
let predictionOutput = predictionModel.runPredictions(initialTokens: predictionInput, wordCount: 300, predictionScope: 3, punctuationTokens: punctuationTokens)

print(startingString)

for eachIndex in predictionOutput {

	print(lookupDatabase.lookupIndex(passedIndex: eachIndex).value)

}

func cleanString(passedStrings: Array<String>) -> String {

	

	return ""

}



//let startString = "What we're introducing today"
//print(startString)

//let synthesizer = AVSpeechSynthesizer()
//let utterance = AVSpeechUtterance(string: "Say Hello")
//utterance.rate = 0.5
//synthesizer.speak(utterance)







