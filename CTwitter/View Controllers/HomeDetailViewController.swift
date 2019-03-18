import UIKit
import TwitterKit

class HomeDetailViewController: UIViewController {
	@IBOutlet weak var containerView: UIView!
	@IBOutlet weak var cstContainerHeight: NSLayoutConstraint!

	fileprivate var viewModel: HomeDetailViewModel!
	fileprivate var tweetView: TWTRTweetView!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		configure()
    }
	
	init(viewModel: HomeDetailViewModel) {
		super.init(nibName: "HomeDetailViewController", bundle: nil)
		self.viewModel = viewModel
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	@IBAction private func onRetweet(_ sender: Any) {
		viewModel.retweet()
	}
	
	private func configure() {
		var size = CGSize.zero
		
		title = NSLocalizedString("Detail", comment: "")
		tweetView = viewModel.generateTweetView()
		size = tweetView.sizeThatFits(containerView.frame.size)
		cstContainerHeight.constant = size.height
		containerView.addSubviewToFit(tweetView)
	}
}
