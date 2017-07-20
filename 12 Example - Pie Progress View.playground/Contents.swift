import UIKit
import PlaygroundSupport

private final class ProgressLayer: CALayer {
	@NSManaged var progress: CGFloat

	private let fillBackgroundColor = UIColor(white: 0.9, alpha: 1).cgColor
	private let fillColor = UIColor.blue.cgColor

	override class func needsDisplay(forKey key: String) -> Bool {
		if key == "progress" {
			return true
		}

		return super.needsDisplay(forKey: key)
	}

	override func action(forKey key: String) -> CAAction? {
		if key == "progress" {
			let animation = CABasicAnimation(keyPath: key)
			animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
			animation.fromValue = presentation()?.value(forKey: key)
			return animation
		}

		return super.action(forKey: key)
	}

	override init() {
		super.init()
	}

	override init(layer: Any) {
		super.init(layer: layer)

		guard let progressLayer = layer as? ProgressLayer else { return }

		progress = progressLayer.progress
	}

	override func draw(in context: CGContext) {

		// Configure line drawing
		let lineWidth: CGFloat = 20
		context.setLineWidth(lineWidth)
		context.setLineCap(.round)

		// Calculate the rect
		let rect = bounds.insetBy(dx: lineWidth / 2, dy: lineWidth / 2)

		// Draw background
		context.setStrokeColor(fillBackgroundColor)
		context.strokeEllipse(in: rect)

		// Draw progress
		let progress = presentation()?.progress ?? 0
		let center = CGPoint(x: rect.midX, y: rect.midY)
		let offset: CGFloat = .pi / -2
		context.addArc(center: center, radius: rect.width / 2, startAngle: offset, endAngle: (.pi * 2 * progress) + offset, clockwise: false)

		context.setStrokeColor(fillColor)
		context.strokePath()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError()
	}
}

final class ProgressView: UIView {
	var progress: CGFloat {
		get {
			return progressLayer?.progress ?? 0
		}

		set {
			progressLayer?.progress = newValue
		}
	}

	override class var layerClass: AnyClass {
		return ProgressLayer.self
	}

	private var progressLayer: ProgressLayer? {
		return layer as? ProgressLayer
	}

	override var intrinsicContentSize: CGSize {
		return CGSize(width: 300, height: 300)
	}
}


final class ViewController: UIViewController {
	let progressView = ProgressView()

	override func viewDidLoad() {
		super.viewDidLoad()

		view.backgroundColor = .white

		progressView.progress = 0.31
		progressView.backgroundColor = .clear

		progressView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(progressView)

		NSLayoutConstraint.activate([
			progressView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			progressView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
		])

		let tap = UITapGestureRecognizer(target: self, action: #selector(increment))
		view.addGestureRecognizer(tap)
	}

	@objc private func increment() {
		progressView.progress += 0.1
	}
}

PlaygroundPage.current.liveView = ViewController()
