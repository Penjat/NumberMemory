import UIKit
import RxSwift

class PITesterViewController: UIViewController {
	enum Constants {

	}
	let disposeBag = DisposeBag()
	let viewModel: PITesterViewModel

    //MARK: Views

	//MARK: Init
	init(viewModel: PITesterViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
		viewModel.viewState.subscribe(onNext: { viewState in
			self.process(state: viewState)
		}).disposed(by: disposeBag)

		viewModel.viewEffects.subscribe(onNext: { viewEffect in
			self.process(effect: viewEffect)
		}).disposed(by: disposeBag)

	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented on purpose. NO STORYBOARDS.")
	}

    //MARK: Set Up
	override func viewDidLoad() {
        super.viewDidLoad()
		setUpViews()
    }

	private func setUpViews() {
		view.backgroundColor = .systemPink
	}

    //MARK: Processing
    private func process(state: PITesterViewState) {

	}

	private func process(effect: PITesterViewEffect) {
		switch effect {

		}
	}
    //MARK: Private
}
