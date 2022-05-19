//
//  SearchViewController.swift
//  TestFlatRockTech
//

import UIKit

protocol SearchDisplayLogic: AnyObject {
    func displayUserRepos(viewModel: Search.UseCase.ViewModel)
    func displayError(viewModel: Search.UseCase.ViewModel)
}

class SearchViewController: UIViewController, SearchDisplayLogic, Storyboardable {
    var interactor: SearchBusinessLogic?
    var router: (NSObjectProtocol & SearchRoutingLogic & SearchDataPassing)?
    private var searchText: String = ""
    @IBOutlet weak var searchField: UITextField!
    private var reposList = [UserRepoViewModel]()
    
    static var storyboardName: StringConvertible {
        return StoryboardType.main
    }
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup()
    {
        let viewController = self
        let interactor = SearchInteractor()
        let presenter = SearchPresenter()
        let router = SearchRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reposList.removeAll()
    }
    
    @IBAction func searchButtonAction(_ sender: Any) {
        guard searchText != "" else { return }
        var request = Search.UseCase.Request()
        request.searchText = searchText
        interactor?.fetchUserRepository(request: request)
    }
    
    func displayUserRepos(viewModel: Search.UseCase.ViewModel) {
        DispatchQueue.main.async {
            self.router?.navigateToSearchList(viewModel: viewModel)
        }
    }
    
    func displayError(viewModel: Search.UseCase.ViewModel) {
        DispatchQueue.main.async {
            self.showErrorAlert(textString: viewModel.errosString)
        }
    }
    
}

extension SearchViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard textField.text != "" else {
            searchText = ""
            return true
        }
        searchText = "\(textField.text ?? "")\(string)"
        return true
    }
}
