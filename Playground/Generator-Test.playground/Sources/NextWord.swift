import Foundation
import CoreML

public class NextWord {
	
    public var model: MLModel
    var ngramSize: Int

	public init?(modelName: String, ngramSize: Int) {
	
		guard let modelURL = Bundle.main.url(forResource: modelName, withExtension: "mlmodelc") else {
			print("Error: Failed to locate MLModelC file")
			return nil
		}
		
		do {
			self.model = try MLModel(contentsOf: modelURL)
			self.ngramSize = ngramSize
		} catch {
			print("Error: Failed to open stored model")
			return nil
		}
	
	}
	
	public func processString(passedString: String) -> Array<String.SubSequence> {

		var mutableString = passedString.lowercased()
		let specialChars = [".", "?", "!", ","]
		let ignoreChars = ["'"]

		var punctuationChars = CharacterSet.punctuationCharacters
		punctuationChars.remove(charactersIn: specialChars.reduce("", { $0 + $1 }) + ignoreChars.reduce("", { $0 + $1 }))

		while mutableString.rangeOfCharacter(from: punctuationChars) != nil {
			mutableString.replaceSubrange(mutableString.rangeOfCharacter(from: punctuationChars)!, with: " ")
		}

		for eachChar in specialChars {
			mutableString = mutableString.replacingOccurrences(of: eachChar, with: " \(eachChar) ")
		}

		return mutableString.split(separator: " ")

	}
	
	public func runPredictions(initialTokens: Array<Int>, wordCount: Int, predictionScope: Int) -> Array<Int> {
		
		var buildingTokens = Array<Int>()
		var safeTokens = initialTokens.count == self.ngramSize ? initialTokens : spliceArray(passedArray: initialTokens)
		let safeScope = predictionScope < 1 ? 1 : predictionScope > 10 ? 10 : predictionScope
		let safeCount = wordCount < 1 ? 0 : wordCount > 300 ? 300 : wordCount
	
		for _ in 0 ..< safeCount {
		
			guard let newPrediction = makePrediction(safeTokens: safeTokens, safeScope: safeScope) else {
				continue
			}
			
			buildingTokens.append(safeTokens[0])
			safeTokens.removeFirst()
			safeTokens.append(newPrediction)
		
		}
		
		buildingTokens.removeFirst(self.ngramSize)
		return buildingTokens
	
	}
	
	func makePrediction(safeTokens: Array<Int>, safeScope: Int) -> Int? {
	
		guard let inputArray = try? MLMultiArray(shape: [NSNumber(value: self.ngramSize), 1, 1], dataType: .int32) else {
			print("Error: Failed to initialise input MLArray... Somehow? Don't ask me.")
			return nil
		}
			
		for (eachIndex, eachToken) in safeTokens.enumerated() {
			inputArray[eachIndex] = NSNumber(value: eachToken)
		}
		
		let nextInput = NextWord_Input(input1: inputArray)
		
		guard let nextOutput = try? model.prediction(from: nextInput) else {
			print("Error: Model rejected prediction input")
			return nil
		}
		
		guard let tokenOutput = nextOutput.featureValue(for: "output1")?.multiArrayValue else {
			print("Error: Model did not return an MLArray feature for output1")
			return nil
		}
		
		let tokenArray = Array(UnsafeBufferPointer(start: tokenOutput.dataPointer.bindMemory(to: Double.self, capacity: tokenOutput.count), count: tokenOutput.count))
		var topPredictions = Array<(Int, Double)>.init(repeating: (0, 0.0), count: safeScope)
		
		for (eachIndex, eachElement) in tokenArray.enumerated() {
		
			if eachElement > topPredictions[0].1 {
				topPredictions[0] = (eachIndex, eachElement)
				topPredictions.sort(by: { $0.1 < $1.1 })
			}
		
		}
		
		return selectRandom(passedPrediction: topPredictions.shuffled())
		
	}
	
	func selectRandom(passedPrediction: Array<(Int, Double)>) -> Int {
	
		let sumPredictions = passedPrediction.reduce(0, { $0 + $1.1 })
		let randomPrediction = Double.random(in: 0.0 ... sumPredictions)
		var runningSum = 0.0
		
		for eachPrediction in passedPrediction {
		
			if runningSum + eachPrediction.1 >= randomPrediction {
				return eachPrediction.0
			} else {
				runningSum += eachPrediction.1
			}
		
		}
		
		return passedPrediction[passedPrediction.count - 1].0
	
	}
	
	func spliceArray(passedArray: Array<Int>) -> Array<Int> {

		//	let endlineChars = [".", "!", "?"]
		var outputArray = passedArray

		if outputArray.count > self.ngramSize {
			outputArray = Array(outputArray[outputArray.count - self.ngramSize ..< outputArray.count])
		}

		//  Note: This section splits up input strings if there it contains an endline charachter,
		//	It was removed because it reduced the quality of predictions
		//
		//	for eachEndline in endlineChars {
		//		if outputArray.contains(eachEndline), let lastIndex = outputArray.lastIndex(of: eachEndline) {
		//			outputArray = Array(outputArray[lastIndex ..< outputArray.count])
		//		}
		//	}

		if outputArray.count < self.ngramSize {
			outputArray = Array<Int>(repeating: 0, count: self.ngramSize - outputArray.count) + outputArray
		}

		return outputArray

	}

}

public class NextWord_Input: MLFeatureProvider {

    public var input1: MLMultiArray
    public var lstm_1_h_in: MLMultiArray? = nil
    public var lstm_1_c_in: MLMultiArray? = nil

    public var featureNames: Set<String> {
        get {
            return ["input1", "lstm_1_h_in", "lstm_1_c_in"]
        }
    }

    public func featureValue(for featureName: String) -> MLFeatureValue? {
        if (featureName == "input1") {
            return MLFeatureValue(multiArray: input1)
        }
        if (featureName == "lstm_1_h_in") {
            return lstm_1_h_in == nil ? nil : MLFeatureValue(multiArray: lstm_1_h_in!)
        }
        if (featureName == "lstm_1_c_in") {
            return lstm_1_c_in == nil ? nil : MLFeatureValue(multiArray: lstm_1_c_in!)
        }
        return nil
    }

    public init(input1: MLMultiArray, lstm_1_h_in: MLMultiArray? = nil, lstm_1_c_in: MLMultiArray? = nil) {
        self.input1 = input1
        self.lstm_1_h_in = lstm_1_h_in
        self.lstm_1_c_in = lstm_1_c_in
    }
}

public class NextWord_Output: MLFeatureProvider {

    private let provider : MLFeatureProvider

    public lazy var output1: MLMultiArray = {
        [unowned self] in return self.provider.featureValue(for: "output1")!.multiArrayValue
    }()!

    public lazy var lstm_1_h_out: MLMultiArray = {
        [unowned self] in return self.provider.featureValue(for: "lstm_1_h_out")!.multiArrayValue
    }()!

    public lazy var lstm_1_c_out: MLMultiArray = {
        [unowned self] in return self.provider.featureValue(for: "lstm_1_c_out")!.multiArrayValue
    }()!

    public var featureNames: Set<String> {
        return self.provider.featureNames
    }

    public func featureValue(for featureName: String) -> MLFeatureValue? {
        return self.provider.featureValue(for: featureName)
    }

   	public init(output1: MLMultiArray, lstm_1_h_out: MLMultiArray, lstm_1_c_out: MLMultiArray) {
        self.provider = try! MLDictionaryFeatureProvider(dictionary: ["output1" : MLFeatureValue(multiArray: output1), "lstm_1_h_out" : MLFeatureValue(multiArray: lstm_1_h_out), "lstm_1_c_out" : MLFeatureValue(multiArray: lstm_1_c_out)])
    }

    public init(features: MLFeatureProvider) {
        self.provider = features
    }
	
}
