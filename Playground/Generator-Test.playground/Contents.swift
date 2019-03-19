import CoreML



func encodeString(passedString: String) {
	
	var mutableString = passedString.lowercased()
	var specialChars = [".", "?", "!", ","]
	for eachChar in specialChars {
		mutableString = mutableString.replacingOccurrences(of: eachChar, with: " \(eachChar) ")
	}

	let splitString = mutableString.split(separator: " ")

	print(splitString)

}

encodeString(passedString: "Hello world this is m!~e, life should be   . Fun for everyone!")





//
///// Model Prediction Input Type
//@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
//class Core_CKPT_91_10_1Input : MLFeatureProvider {
//
//    /// input1 as 1 element vector of doubles
//    var input1: MLMultiArray
//
//    /// lstm_1_h_in as optional 128 element vector of doubles
//    var lstm_1_h_in: MLMultiArray? = nil
//
//    /// lstm_1_c_in as optional 128 element vector of doubles
//    var lstm_1_c_in: MLMultiArray? = nil
//
//    var featureNames: Set<String> {
//        get {
//            return ["input1", "lstm_1_h_in", "lstm_1_c_in"]
//        }
//    }
//	
//    func featureValue(for featureName: String) -> MLFeatureValue? {
//        if (featureName == "input1") {
//            return MLFeatureValue(multiArray: input1)
//        }
//        if (featureName == "lstm_1_h_in") {
//            return lstm_1_h_in == nil ? nil : MLFeatureValue(multiArray: lstm_1_h_in!)
//        }
//        if (featureName == "lstm_1_c_in") {
//            return lstm_1_c_in == nil ? nil : MLFeatureValue(multiArray: lstm_1_c_in!)
//        }
//        return nil
//    }
//
//    init(input1: MLMultiArray, lstm_1_h_in: MLMultiArray? = nil, lstm_1_c_in: MLMultiArray? = nil) {
//        self.input1 = input1
//        self.lstm_1_h_in = lstm_1_h_in
//        self.lstm_1_c_in = lstm_1_c_in
//    }
//}
//
///// Model Prediction Output Type
//@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
//class Core_CKPT_91_10_1Output : MLFeatureProvider {
//
//    /// Source provided by CoreML
//
//    private let provider : MLFeatureProvider
//
//
//    /// output1 as 2976 element vector of doubles
//    lazy var output1: MLMultiArray = {
//        [unowned self] in return self.provider.featureValue(for: "output1")!.multiArrayValue
//    }()!
//
//    /// lstm_1_h_out as 128 element vector of doubles
//    lazy var lstm_1_h_out: MLMultiArray = {
//        [unowned self] in return self.provider.featureValue(for: "lstm_1_h_out")!.multiArrayValue
//    }()!
//
//    /// lstm_1_c_out as 128 element vector of doubles
//    lazy var lstm_1_c_out: MLMultiArray = {
//        [unowned self] in return self.provider.featureValue(for: "lstm_1_c_out")!.multiArrayValue
//    }()!
//
//    var featureNames: Set<String> {
//        return self.provider.featureNames
//    }
//
//    func featureValue(for featureName: String) -> MLFeatureValue? {
//        return self.provider.featureValue(for: featureName)
//    }
//
//    init(output1: MLMultiArray, lstm_1_h_out: MLMultiArray, lstm_1_c_out: MLMultiArray) {
//        self.provider = try! MLDictionaryFeatureProvider(dictionary: ["output1" : MLFeatureValue(multiArray: output1), "lstm_1_h_out" : MLFeatureValue(multiArray: lstm_1_h_out), "lstm_1_c_out" : MLFeatureValue(multiArray: lstm_1_c_out)])
//    }
//
//    init(features: MLFeatureProvider) {
//        self.provider = features
//    }
//}
//
//
///// Class for model loading and prediction
//@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
//class Core_CKPT_91_10_1 {
//    var model: MLModel
//
///// URL of model assuming it was installed in the same bundle as this class
//    class var urlOfModelInThisBundle : URL {
//        let bundle = Bundle(for: Core_CKPT_91_10_1.self)
//        return bundle.url(forResource: "Core-CKPT-91-10", withExtension:"mlmodelc")!
//    }
//
//    /**
//        Construct a model with explicit path to mlmodelc file
//        - parameters:
//           - url: the file url of the model
//           - throws: an NSError object that describes the problem
//    */
//    init(contentsOf url: URL) throws {
//        self.model = try MLModel(contentsOf: url)
//    }
//
//    /// Construct a model that automatically loads the model from the app's bundle
//    convenience init() {
//        try! self.init(contentsOf: type(of:self).urlOfModelInThisBundle)
//    }
//
//    /**
//        Construct a model with configuration
//        - parameters:
//           - configuration: the desired model configuration
//           - throws: an NSError object that describes the problem
//    */
//    @available(macOS 10.14, iOS 12.0, tvOS 12.0, watchOS 5.0, *)
//    convenience init(configuration: MLModelConfiguration) throws {
//        try self.init(contentsOf: type(of:self).urlOfModelInThisBundle, configuration: configuration)
//    }
//
//    /**
//        Construct a model with explicit path to mlmodelc file and configuration
//        - parameters:
//           - url: the file url of the model
//           - configuration: the desired model configuration
//           - throws: an NSError object that describes the problem
//    */
//    @available(macOS 10.14, iOS 12.0, tvOS 12.0, watchOS 5.0, *)
//    init(contentsOf url: URL, configuration: MLModelConfiguration) throws {
//        self.model = try MLModel(contentsOf: url, configuration: configuration)
//    }
//
//    /**
//        Make a prediction using the structured interface
//        - parameters:
//           - input: the input to the prediction as Core_CKPT_91_10_1Input
//        - throws: an NSError object that describes the problem
//        - returns: the result of the prediction as Core_CKPT_91_10_1Output
//    */
//    func prediction(input: Core_CKPT_91_10_1Input) throws -> Core_CKPT_91_10_1Output {
//        return try self.prediction(input: input, options: MLPredictionOptions())
//    }
//
//    /**
//        Make a prediction using the structured interface
//        - parameters:
//           - input: the input to the prediction as Core_CKPT_91_10_1Input
//           - options: prediction options
//        - throws: an NSError object that describes the problem
//        - returns: the result of the prediction as Core_CKPT_91_10_1Output
//    */
//    func prediction(input: Core_CKPT_91_10_1Input, options: MLPredictionOptions) throws -> Core_CKPT_91_10_1Output {
//        let outFeatures = try model.prediction(from: input, options:options)
//        return Core_CKPT_91_10_1Output(features: outFeatures)
//    }
//
//    /**
//        Make a prediction using the convenience interface
//        - parameters:
//            - input1 as 1 element vector of doubles
//            - lstm_1_h_in as optional 128 element vector of doubles
//            - lstm_1_c_in as optional 128 element vector of doubles
//        - throws: an NSError object that describes the problem
//        - returns: the result of the prediction as Core_CKPT_91_10_1Output
//    */
//    func prediction(input1: MLMultiArray, lstm_1_h_in: MLMultiArray?, lstm_1_c_in: MLMultiArray?) throws -> Core_CKPT_91_10_1Output {
//        let input_ = Core_CKPT_91_10_1Input(input1: input1, lstm_1_h_in: lstm_1_h_in, lstm_1_c_in: lstm_1_c_in)
//        return try self.prediction(input: input_)
//    }
//
//    /**
//        Make a batch prediction using the structured interface
//        - parameters:
//           - inputs: the inputs to the prediction as [Core_CKPT_91_10_1Input]
//           - options: prediction options
//        - throws: an NSError object that describes the problem
//        - returns: the result of the prediction as [Core_CKPT_91_10_1Output]
//    */
//    @available(macOS 10.14, iOS 12.0, tvOS 12.0, watchOS 5.0, *)
//    func predictions(inputs: [Core_CKPT_91_10_1Input], options: MLPredictionOptions = MLPredictionOptions()) throws -> [Core_CKPT_91_10_1Output] {
//        let batchIn = MLArrayBatchProvider(array: inputs)
//        let batchOut = try model.predictions(from: batchIn, options: options)
//        var results : [Core_CKPT_91_10_1Output] = []
//        results.reserveCapacity(inputs.count)
//        for i in 0..<batchOut.count {
//            let outProvider = batchOut.features(at: i)
//            let result =  Core_CKPT_91_10_1Output(features: outProvider)
//            results.append(result)
//        }
//        return results
//    }
//}

//let model = Core_CKPT_91_10_1()



//
//let ngramSize = 7
//var multi = try MLMultiArray(shape: [ngramSize, 1, 1], dataType: .double)
//
//multi[0] = 39
//multi[1] = 112
//multi[2] = 48
//multi[3] = 133
//multi[4] = 910
//multi[5] = 1243
//multi[6] = 10
//
//
//	let input = try WordLanguageModelInput(tokenizedInputSeq: multi)
//	let output = try model.prediction(input: input)
//
//	let tokenProbability = output.featureValue(for: "output1")
//
//	if let tokenOutput = tokenProbability?.multiArrayValue {
//		updateTime()
//		let thing = Array(UnsafeBufferPointer(start: tokenOutput.dataPointer.bindMemory(to: Double.self, capacity: tokenOutput.count), count: tokenOutput.count))
//
//		var final: Array<(Int, Double)> = [(0, 0), (0, 0), (0, 0)]
//
//		for (eachIndex, eachElement) in thing.enumerated() {
//
//			if eachElement > final[0].1 {
//
//				final[0] = (eachIndex, eachElement)
//				final.sort(by: { $0.1 < $1.1 })
//
//			}
//
//		}
//
//		print(final)

