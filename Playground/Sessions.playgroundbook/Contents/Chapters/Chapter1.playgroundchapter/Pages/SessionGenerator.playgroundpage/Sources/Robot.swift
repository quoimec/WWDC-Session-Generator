import UIKit

public class Robot: UIView {

	let robotHead = UIImageView()
	let mouthTop = UIImageView()
	let mouthBot = UIImageView()
	
	var mouthTopConstraint = NSLayoutConstraint()
	var mouthBotConstraint = NSLayoutConstraint()
	
	var shouldTalk = false

	public init() {
		super.init(frame: CGRect.zero)

		robotHead.image = UIImage(named: "Robot_Main")
		mouthTop.image = UIImage(named: "Robot_Mouth_Bot")
		mouthBot.image = UIImage(named: "Robot_Mouth_Top")
		
		robotHead.translatesAutoresizingMaskIntoConstraints = false
		mouthTop.translatesAutoresizingMaskIntoConstraints = false
		mouthBot.translatesAutoresizingMaskIntoConstraints = false
	
		self.addSubview(robotHead)
		self.addSubview(mouthTop)
		self.addSubview(mouthBot)
		
		mouthTopConstraint = NSLayoutConstraint(item: mouthTop, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0)
		mouthBotConstraint = NSLayoutConstraint(item: mouthBot, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0)
		
		self.addConstraints([
			
			// Robot Head
			NSLayoutConstraint(item: robotHead, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: robotHead, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: robotHead, attribute: .trailing, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: robotHead, attribute: .bottom, multiplier: 1.0, constant: 0),
			
			// Mouth Top
			NSLayoutConstraint(item: mouthTop, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0),
			mouthTopConstraint,
			NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: mouthTop, attribute: .trailing, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: mouthTop, attribute: .bottom, multiplier: 1.0, constant: 0),
			
			// Mouth Bottom
			NSLayoutConstraint(item: mouthBot, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0),
			mouthBotConstraint,
			NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: mouthBot, attribute: .trailing, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: mouthBot, attribute: .bottom, multiplier: 1.0, constant: 0)
		
		])
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	public func startTalking() {
		shouldTalk = true
		animateTalking()
	}
	
	public func stopTalking() {
		shouldTalk = false
	}
	
	func animateTalking() {
	
		UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseIn, animations: {
	
			self.mouthTopConstraint.constant = 16
			self.mouthBotConstraint.constant = -16
			self.layoutIfNeeded()
			
		}, completion: nil)
		
		UIView.animate(withDuration: 0.2, delay: 0.4, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.6, options: .curveEaseOut, animations: {
		
			self.mouthTopConstraint.constant = 0
			self.mouthBotConstraint.constant = 0
			self.layoutIfNeeded()
		
		}, completion: { animated in
		
			if self.shouldTalk {
				self.animateTalking()
			}
		
		})
	
	}
	
}
