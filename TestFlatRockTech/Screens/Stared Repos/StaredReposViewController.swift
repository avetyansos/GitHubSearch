//
//  StaredReposViewController.swift
//  TestFlatRockTech
//

import UIKit

protocol StaredReposDisplayLogic: AnyObject {
    func displayRepos(viewModel: StaredRepos.UseCase.ViewModel)
    func displayError(viewModel: StaredRepos.UseCase.ViewModel)
}

class StaredReposViewController: UIViewController, StaredReposDisplayLogic
{
    var interactor: StaredReposBusinessLogic?
    var router: (NSObjectProtocol & StaredReposRoutingLogic & StaredReposDataPassing)?
    @IBOutlet weak var tableView: UITableView!
    private var repos = [UserRepoViewModel]()
    
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
        let interactor = StaredReposInteractor()
        let presenter = StaredReposPresenter()
        let router = StaredReposRouter()
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
        RepoListTableViewCell.register(to: tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        interactor?.getElements()
    }
    
    func displayRepos(viewModel: StaredRepos.UseCase.ViewModel) {
        repos = viewModel.repos
        tableView.reloadData()
    }
    
    func displayError(viewModel: StaredRepos.UseCase.ViewModel) {
        self.showErrorAlert(textString: viewModel.errorString)
    }
    
}

extension StaredReposViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = RepoListTableViewCell.dequeue(from: tableView) else {
            fatalError("Could not dequeue cell with type: \(RepoListTableViewCell.self)")
        }
        cell.userRepo = repos[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        router?.navigateToDetails(owner: repos[indexPath.row].loginName, repoName: repos[indexPath.row].repoName, repoDetailsViewModel: repos[indexPath.row])
    }
}
