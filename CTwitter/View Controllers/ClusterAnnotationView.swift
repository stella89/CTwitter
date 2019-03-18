import MapKit

class ClusterAnnotationView: MKAnnotationView {
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        collisionMode = .circle
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        
        if let cluster = annotation as? MKClusterAnnotation {
            let count = cluster.memberAnnotations.count
            
			image = drawCircle(count: count, color: .red)
			displayPriority = .defaultLow
        }
    }

    private func drawCircle(count: Int, color: UIColor?) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 40, height: 40))
		
		return renderer.image { _ in
			let attributes = [ NSAttributedString.Key.foregroundColor: UIColor.white,
							   NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
			let text = "\(count)"
			let size = text.size(withAttributes: attributes)
			let rect = CGRect(x: 20 - size.width / 2, y: 20 - size.height / 2, width: size.width, height: size.height)
			
            color?.setFill()
            UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 40, height: 40)).fill()
            text.draw(in: rect, withAttributes: attributes)
        }
    }
}
