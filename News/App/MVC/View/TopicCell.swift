import UIKit

protocol CellDelegate: AnyObject {
    func sendDetailsForPresenting(vc: UIActivityViewController, contentView: UIView)
}

final class TopicCell: UITableViewCell {
    static let id = "MyTableViewCell"
    
    weak var cellDelegate: CellDelegate?
    
    struct Layout {
        let contentInsets: UIEdgeInsets
        
        static var `default`: Layout {
            Layout(contentInsets: UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0))
        }
    }

    private lazy var layout: Layout = .default
    
    private lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.layer.cornerRadius = 16
        bgView.backgroundColor = .systemGray4.withAlphaComponent(0.5)
        bgView.translatesAutoresizingMaskIntoConstraints = false
        return bgView
    }()
    
    lazy var newsDate: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.font = .systemFont(ofSize: 17, weight: .light)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .systemGray
        return lbl
    }()
    
    lazy var newsSource: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .center
        lbl.font = .systemFont(ofSize: 17, weight: .light)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .systemGray
        return lbl
    }()
    
    lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.font = .systemFont(ofSize: 18, weight: .regular)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupShareGesture()
    }
    
    // MARK: Share
    private func setupShareGesture() {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(share))
        gesture.minimumPressDuration = 0.2
        contentView.addGestureRecognizer(gesture)
    }
    
    @objc private func share(with gesture: UILongPressGestureRecognizer) {
        bgView.animatePressing(gesture: gesture, completion: { [weak self] in
            guard let self else { return }
            let newsTopicInfo = "🔥 \(titleLabel.text ?? "") 🤖 \n\(DeveloperInfo.shareInfo.rawValue)"
            let activityVC = UIActivityViewController(activityItems: [newsTopicInfo], applicationActivities: nil)
            cellDelegate?.sendDetailsForPresenting(vc: activityVC, contentView: contentView)
        })
    }
    
    // MARK: Setup UI
    private func setupUI() {
        backgroundColor = .clear
        bgView.addSubview(newsDate)
        bgView.addSubview(titleLabel)
        bgView.addSubview(newsSource)
        contentView.addSubview(bgView)
        
        selectionStyle = .none
        
        NSLayoutConstraint.activate([
            
            bgView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: layout.contentInsets.top),
            bgView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: layout.contentInsets.left),
            bgView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: layout.contentInsets.right),
            bgView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: layout.contentInsets.bottom),
            
            titleLabel.topAnchor.constraint(equalTo: bgView.topAnchor, constant: Constants.plus16),
            titleLabel.leftAnchor.constraint(equalTo: bgView.leftAnchor, constant: Constants.plus16),
            titleLabel.rightAnchor.constraint(equalTo: bgView.rightAnchor, constant: Constants.minus16),
            
            newsDate.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.plus30),
            newsDate.bottomAnchor.constraint(equalTo: bgView.bottomAnchor, constant: Constants.minus16),
            newsDate.leftAnchor.constraint(equalTo: bgView.leftAnchor, constant: Constants.plus16),
            
            newsSource.leftAnchor.constraint(equalTo: newsDate.rightAnchor, constant: Constants.plus16),
            newsSource.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.plus30),
            newsSource.rightAnchor.constraint(equalTo: bgView.rightAnchor, constant: Constants.minus16),
            newsSource.bottomAnchor.constraint(equalTo: bgView.bottomAnchor, constant: Constants.minus16)
        ])
        newsDate.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        newsSource.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private enum Constants {
    static let plus30: CGFloat = 30
    static let plus16: CGFloat = 16
    static let minus16: CGFloat = -16
}
