import UIKit

public class Transcript: UIScrollView {

	public let transcriptLabel = UILabel(frame: CGRect.zero)
	
	public init() {
		super.init(frame: CGRect.zero)
	
		self.bounces = true
		self.clipsToBounds = true
		self.alwaysBounceHorizontal = false
		self.alwaysBounceVertical = false
	
		transcriptLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
		transcriptLabel.numberOfLines = 0
		transcriptLabel.textColor = #colorLiteral(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00)
		
		transcriptLabel.translatesAutoresizingMaskIntoConstraints = false
		
		self.addSubview(transcriptLabel)
		
		self.addConstraints([
		
			// Transcript Label
			NSLayoutConstraint(item: transcriptLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: transcriptLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: transcriptLabel, attribute: .trailing, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: transcriptLabel, attribute: .bottom, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: transcriptLabel, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1.0, constant: 0)
		
		])
		
	}
	
	public required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
