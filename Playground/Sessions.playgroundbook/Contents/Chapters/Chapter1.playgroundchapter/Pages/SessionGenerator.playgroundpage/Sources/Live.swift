import UIKit
import AVFoundation

public class Live: UIViewController {
	
	let liveTitle = UILabel(frame: CGRect.zero)
	let robotView = Robot()
	public let transcriptView = Transcript()
	let speechSynthesizer = AVSpeechSynthesizer()
	let lineEnders = [".", "!", "?", ","]

	var finalTranscript: String
	
	public init(generatedText: Array<String>) {
		self.finalTranscript = cleanText(passedArray: generatedText)
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	public override func viewDidLoad() {
		super.viewDidLoad()
		
		self.view.backgroundColor = #colorLiteral(red: 0.07, green: 0.10, blue: 0.18, alpha: 1.00)
		
		liveTitle.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
		liveTitle.numberOfLines = 0
		liveTitle.textColor = #colorLiteral(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00)
		liveTitle.textAlignment = .center
		liveTitle.text = " WWDC PRESENT-O-TRON"
		
		liveTitle.translatesAutoresizingMaskIntoConstraints = false
		robotView.translatesAutoresizingMaskIntoConstraints = false
		transcriptView.translatesAutoresizingMaskIntoConstraints = false
		
		transcriptView.transcriptLabel.text = finalTranscript
		
		self.view.addSubview(liveTitle)
		self.view.addSubview(robotView)
		self.view.addSubview(transcriptView)
		
		self.view.addConstraints([
		
			// Live Title
			NSLayoutConstraint(item: robotView, attribute: .top, relatedBy: .equal, toItem: liveTitle, attribute: .bottom, multiplier: 1.0, constant: 10),
			NSLayoutConstraint(item: liveTitle, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0),
			
		
			// Robot View
			NSLayoutConstraint(item: robotView, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.4, constant: 0),
			NSLayoutConstraint(item: robotView, attribute: .width, relatedBy: .equal, toItem: robotView, attribute: .height, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: robotView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: robotView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 0.15, constant: 0),
			
			// Transcript View
			NSLayoutConstraint(item: transcriptView, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.38, constant: 0),
			NSLayoutConstraint(item: transcriptView, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0.8, constant: 0),
			NSLayoutConstraint(item: transcriptView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: transcriptView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1.0, constant: 0)
		
		])
		
		let newUtterance = AVSpeechUtterance(string: finalTranscript)
		newUtterance.rate = 0.42
		newUtterance.voice = AVSpeechSynthesisVoice(language: "en-us")
		
		speechSynthesizer.speak(newUtterance)
		
		robotView.startTalking()
		
	}

}
