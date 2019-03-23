/*:
 ### Writing A WWDC Session With CoreML
 In a moment, you'll meet my friend the WWDC Present-O-Tron who'll give you a nice short WWDC style session on a topic of your choosing. You just need to tell it three things before it can start:

 1. A starting string so it knows what to talk about
 2. A word count for the number of words you want it to generate
 3. A "randomness" value (see note below)

 Once you've decided on your values, run the playground, and sit back to enjoy the wonder of a WWDC session from the comfort of your own home.

 _Disclamer: The produced session may not be quite up to the normal WWDC session standard._

 - Note:
 The predicability of this model is detirmined by the third parameter, `randomScope`. If you supply a value of 1, it will produce the same text each time for the provided starting string. The more you increase this value however, the more random the text becomes. I have found that a good value is between 2 and 5.
*/

//#-hidden-code

import CoreML
import SQLite3
import AVFoundation
import PlaygroundSupport
import UIKit

//#-end-hidden-code

let startingString: String = /*#-editable-code*/"Jony Ive is"/*#-end-editable-code*/
let wordCount: Int = /*#-editable-code*/100/*#-end-editable-code*/
let randomScope: Int = /*#-editable-code*/3/*#-end-editable-code*/

//#-hidden-code

guard let predictionModel = NextWord(modelName: "Core-CKPT-60-60", ngramSize: 6), let lookupDatabase = Lookup(databasePath: Bundle.main.path(forResource: "Tokenised", ofType: "sqlite")) else {
	PlaygroundPage.current.finishExecution()
}

let punctuationValues = [".", "!", "?", ","]
let punctuationTokens = punctuationValues.map({ lookupDatabase.lookupValue(passedValue: $0).index }) + [0]

let predictionInput = predictionModel.processString(passedString: startingString).map({ lookupDatabase.lookupValue(passedValue: String($0)).index })
let predictionOutput = predictionModel.runPredictions(initialTokens: predictionInput, wordCount: wordCount, predictionScope: randomScope, punctuationTokens: punctuationTokens).map({ lookupDatabase.lookupIndex(passedIndex: $0).value })
let startingProcessed = startingString.lowercased().split(separator: " ").map({ String($0) })

PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.liveView = Live(generatedText: startingProcessed + predictionOutput)

//#-end-hidden-code
