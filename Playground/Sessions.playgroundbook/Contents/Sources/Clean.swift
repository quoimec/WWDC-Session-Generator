import Foundation

public struct Uppercase {

	public var lookup: String
	public var translated: String
	
	init(lookup: String, translated: String) {
	
		self.lookup = lookup
		self.translated = translated
	
	}

}

public func cleanText(passedArray: Array<String>) -> String {

	var sentenceArray: Array<String> = [""]
	
	let endlineLookup = [".", "?", "!"]
	let uppercaseLookup: Array<Uppercase> = [
		Uppercase(lookup: "i", translated: "I"),
		Uppercase(lookup: "i'm", translated: "I'm"),
		Uppercase(lookup: "wwdc", translated: "WWDC"),
		Uppercase(lookup: "api's", translated: "API's"),
		Uppercase(lookup: "api", translated: "API"),
		Uppercase(lookup: "apple", translated: "Apple"),
		Uppercase(lookup: "ios", translated: "iOS"),
		Uppercase(lookup: "iphone", translated: "iPhone"),
		Uppercase(lookup: "mac", translated: "Mac"),
		Uppercase(lookup: "os", translated: "OS"),
		Uppercase(lookup: "watch", translated: "Watch"),
		Uppercase(lookup: "id", translated: "ID"),
		Uppercase(lookup: "xcode", translated: "XCode"),
		Uppercase(lookup: "sonoma", translated: "Sonoma"),
		Uppercase(lookup: "siri", translated: "Siri"),
		Uppercase(lookup: "tim", translated: "Tim"),
		Uppercase(lookup: "cook", translated: "Cook"),
		Uppercase(lookup: "jony", translated: "Jony"),
		Uppercase(lookup: "ive", translated: "Ive"),
		Uppercase(lookup: "craig", translated: "Craig"),
		Uppercase(lookup: "federighi", translated: "Federighi"),
		Uppercase(lookup: "coreml", translated: "CoreML"),
		Uppercase(lookup: "arkit", translated: "ARKit"),
		Uppercase(lookup: "ar", translated: "AR"),
		Uppercase(lookup: "av", translated: "AV"),
		Uppercase(lookup: "vr", translated: "VR"),
		Uppercase(lookup: "ml", translated: "ML"),
		Uppercase(lookup: "uiview", translated: "UIView"),
		Uppercase(lookup: "uiviewcontroller", translated: "UIViewController"),
		Uppercase(lookup: "shortcuts", translated: "Shortcuts"),
		Uppercase(lookup: "cpu", translated: "CPU")
	]
	
	for eachWord in passedArray {
	
		let lastSentence = sentenceArray.count - 1
	
		if eachWord == "," {
			sentenceArray[lastSentence] += eachWord
		} else if endlineLookup.contains(eachWord) {
			sentenceArray[lastSentence] += eachWord
			sentenceArray.append("")
		} else if let replaceIndex = uppercaseLookup.index(where: { $0.lookup == eachWord }) {
		
			if sentenceArray[lastSentence].count == 0 {
				sentenceArray[lastSentence] += "\(uppercaseLookup[replaceIndex].translated)"
			} else {
				sentenceArray[lastSentence] += " \(uppercaseLookup[replaceIndex].translated)"
			}
		
		} else if sentenceArray[lastSentence].count == 0 {
			sentenceArray[lastSentence] += "\(String(eachWord.prefix(1).uppercased() + eachWord.dropFirst()))"
		} else {
			sentenceArray[lastSentence] += " \(eachWord)"
		}
	
	}
	
	switch sentenceArray[sentenceArray.count - 1].last {
	
		case ",":
		sentenceArray[sentenceArray.count - 1] = String(sentenceArray[sentenceArray.count - 1].dropLast() + ".")
		
		case ".", "!", "?":
		break
		
		default:
		sentenceArray[sentenceArray.count - 1] += "."
		
	}
	
	return sentenceArray.reduce("", { $0 + "\($1) "})
	
}
