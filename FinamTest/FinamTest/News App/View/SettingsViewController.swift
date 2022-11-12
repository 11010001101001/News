import UIKit

final class SettingsViewController: UIViewController {
    
    struct Layout {
        let contentInsets: UIEdgeInsets
        
        static var `default`: Layout {
            Layout(contentInsets: UIEdgeInsets(top: 40, left: 16, bottom: -40, right: -16))
        }
    }
    
    var closeCompletion: (() -> Void)?
    
    private lazy var layout = Layout.default
    
    private lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4.withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        return view
    }()
    
    // MARK: Sound
    private lazy var soundsSettingsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .natural
        label.text = SettingsKeys.soundWord.rawValue
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    // MARK: AppVersion label
    private lazy var appVersionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = SettingsKeys.appVerstion.rawValue + " " + AppVersion.current
        label.textColor = .systemGray4
        label.numberOfLines = .zero
        label.font = .preferredFont(forTextStyle: .caption1)
        label.adjustsFontSizeToFitWidth = true
        label.backgroundColor = .clear
        return label
    }()
    
    // MARK: Sound Switcher
    private lazy var soundSwitcher: UISwitch = {
        let switcher = UISwitch()
        switcher.addTarget(self, action: #selector(switcherValueDidChange), for: .valueChanged)
        switcher.translatesAutoresizingMaskIntoConstraints = false
        return switcher
    }()
    
    @objc private func switcherValueDidChange(sender: UISwitch) {
        soundSwitcher.setOn(sender.isOn, animated: true)
        StorageService.shared.saveData(with: sender.isOn, for: SettingsKeys.soundSettings.rawValue)
    }
    
    // MARK: Developer Switcher
    private lazy var developerInfoSwitcher: UISwitch = {
        let switcher = UISwitch()
        switcher.addTarget(self, action: #selector(showDeveloperInfo), for: .valueChanged)
        switcher.translatesAutoresizingMaskIntoConstraints = false
        return switcher
    }()
    
    // MARK: Developer info
    @objc private func showDeveloperInfo(sender: UISwitch) {
        if sender.isOn {
            let alertVC = UIAlertController(title: DeveloperInfo.title.rawValue, message: DeveloperInfo.message.rawValue, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
                alertVC.dismiss(animated: true, completion: nil)
                sender.setOn(!sender.isOn, animated: true)
            }))
            alertVC.prepairForIPad(withVCView: view, withVC: self)
            present(alertVC, animated: true, completion: nil)
        }
    }
    
    private lazy var developerInfoLabel: UILabel = {
        let label = UILabel()
        label.text = SettingsKeys.info.rawValue
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .natural
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private func getVerticalStack() -> UIStackView {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalCentering
        return stack
    }

    // MARK: Life - cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupUserSoundSettings()
        setNavBarPrefersLargeTitles()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavBarPrefersLargeTitles()
    }
    
    private func setNavBarPrefersLargeTitles() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.subviews.forEach {
            $0.isHidden = $0.tag == 0
            $0.isHidden = $0.tag == 1
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        closeCompletion?()
    }
    
    // MARK: SetupUI
    private func setupUI() {
        title = SettingsKeys.settings.rawValue
        view.backgroundColor = .systemBackground
        let soundStack = getVerticalStack()
        let infoStack = getVerticalStack()
        soundStack.addArrangedSubview(soundsSettingsLabel)
        soundStack.addArrangedSubview(soundSwitcher)
        infoStack.addArrangedSubview(developerInfoLabel)
        infoStack.addArrangedSubview(developerInfoSwitcher)
        bgView.addSubview(soundStack)
        bgView.addSubview(infoStack)
        view.addSubview(bgView)
        view.addSubview(appVersionLabel)
        let width: CGFloat = view.frame.width / 3
        let navBarHeight: CGFloat = 96
        
        NSLayoutConstraint.activate([
            appVersionLabel.widthAnchor.constraint(equalToConstant: width),
            appVersionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appVersionLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: layout.contentInsets.bottom),
            
            bgView.topAnchor.constraint(equalTo: view.topAnchor, constant: layout.contentInsets.top + view.safeAreaInsets.top + navBarHeight + layout.contentInsets.left),
            bgView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: layout.contentInsets.left),
            bgView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: layout.contentInsets.right),

            soundStack.topAnchor.constraint(equalTo: bgView.topAnchor, constant: 16),
            soundStack.leftAnchor.constraint(equalTo: bgView.leftAnchor, constant: 16),
            soundStack.rightAnchor.constraint(equalTo: bgView.rightAnchor, constant: -16),
            
            infoStack.topAnchor.constraint(equalTo: soundStack.bottomAnchor, constant: 16),
            infoStack.leftAnchor.constraint(equalTo: bgView.leftAnchor, constant: 16),
            infoStack.rightAnchor.constraint(equalTo: bgView.rightAnchor, constant: -16),
            infoStack.bottomAnchor.constraint(equalTo: bgView.bottomAnchor, constant: -16)
        ])
    }
    
    // MARK: SetupUser sound settings
    private func setupUserSoundSettings() {
        guard let soundOn = StorageService.shared.getData(for: SettingsKeys.soundSettings.rawValue) else { return }
        // SetUp initial state
        soundSwitcher.setOn(soundOn, animated: true)
    }
}

