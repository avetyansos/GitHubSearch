//
//  RepositoryDetailsViewController.swift
//  TestFlatRockTech
//

import UIKit
import WebKit

protocol RepositoryDetailsDisplayLogic: AnyObject {
    func displayRepoDetails(viewModel: RepositoryDetails.UseCase.ViewModel)
    func displayError(viewModel: RepositoryDetails.UseCase.ViewModel)
}

class RepositoryDetailsViewController: UIViewController, RepositoryDetailsDisplayLogic, Storyboardable
{
    var interactor: RepositoryDetailsBusinessLogic?
    var router: (NSObjectProtocol & RepositoryDetailsRoutingLogic & RepositoryDetailsDataPassing)?
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var stareButton: UIButton!
    private var detailsViewModel: RepoDetailViewModel!
    var owner = ""
    var repoName = ""
    
    // MARK: Object lifecycle
    
    static var storyboardName: StringConvertible {
        return StoryboardType.details
    }
    
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
        let interactor = RepositoryDetailsInteractor()
        let presenter = RepositoryDetailsPresenter()
        let router = RepositoryDetailsRouter()
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
        loadDetails()
        
    }
    
    private func loadDetails() {
        var request = RepositoryDetails.UseCase.Request()
        request.repoName = repoName
        request.owner = owner
        interactor?.getRepoDetails(request: request)
    }
    
    func displayRepoDetails(viewModel: RepositoryDetails.UseCase.ViewModel) {
        DispatchQueue.main.async {
            self.createdAtLabel.text = viewModel.repoViewModel.createdAt
            self.languageLabel.text = viewModel.repoViewModel.language
            self.descriptionLabel.text = viewModel.repoViewModel.description
        }
    }
    
    func displayError(viewModel: RepositoryDetails.UseCase.ViewModel) {
        DispatchQueue.main.async {
            self.showErrorAlert(textString: viewModel.errosString)
        }
    }
    
    @IBAction func stareButtonAction(_ sender: UIButton) {
        
    }
    
    @IBAction func openBrowserAction(_ sender: Any) {
        
        UIApplication.shared.open(detailsViewModel.repoURL)
        
    }
    
}
