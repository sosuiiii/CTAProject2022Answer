
import UIKit
import RxSwift
import RxCocoa

class AlertView: UIView {

    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var popView: UIView!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    private var disposeBag = DisposeBag()

    init(message: String) {
        super.init(frame: UIScreen.main.bounds)
        initializeView()
        setup(message: message)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initializeView() {
        let view = Bundle.main.loadNibNamed("AlertView", owner: self, options: nil)?.first as! UIView
        view.frame = bounds
        addSubview(view)
    }

    private func setup(message: String) {
        self.message.text = message
        doneButton.setTitle("閉じる", for: .normal)
        cancelButton.isHidden = true

        doneButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss()
            }).disposed(by: disposeBag)

        cancelButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss()
            }).disposed(by: disposeBag)
    }

    private func dismiss() {
        let firstWindow = UIApplication.shared.windows.first { $0.isKeyWindow }
        guard let window = firstWindow else { return }
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = .fade
        window.layer.add(transition, forKey: kCATransition)
        removeFromSuperview()
    }
}
