import CoreML
import SQLite3
import AVFoundation
import PlaygroundSupport

guard let predictionModel = NextWord(modelName: "Core-CKPT-91-10", ngramSize: 6), let lookupDatabase = Lookup(databasePath: Bundle.main.path(forResource: "Tokenised", ofType: "sqlite")) else {
	PlaygroundPage.current.finishExecution()
}

var startingString = "my name is Tim Apple"
let predictionInput = predictionModel.processString(passedString: startingString).map({ lookupDatabase.lookupValue(passedValue: String($0)).index })
let predictionOutput = predictionModel.runPredictions(initialTokens: predictionInput, wordCount: 300, predictionScope: 3)

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







