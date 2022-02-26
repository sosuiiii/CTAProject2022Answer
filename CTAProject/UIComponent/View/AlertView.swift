
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
        // String(describing: self)によってクラス名が変わっても対応してくれるようになる
        let view = Bundle.main.loadNibNamed(String(describing: self), owner: self, options: nil)?.first as! UIView
        view.frame = bounds
        addSubview(view)
    }

    private func setup(message: String) {
        self.message.text = message
        doneButton.setTitle(L10n.close, for: .normal)
        cancelButton.isHidden = true
        let dismiss = PublishRelay<Void>()

        doneButton.rx.tap
            .bind(to: dismiss)
            .disposed(by: disposeBag)

        cancelButton.rx.tap
            .bind(to: dismiss)
            .disposed(by: disposeBag)

        dismiss
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { me, _ in
                let transition = CATransition()
                transition.duration = 0.3
                transition.type = .fade
                me.window?.layer.add(transition, forKey: kCATransition)
                me.removeFromSuperview()
        }).disposed(by: disposeBag)
    }
}
