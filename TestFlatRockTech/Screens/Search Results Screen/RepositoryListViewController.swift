//
//  RepositoryListViewController.swift
//  TestFlatRockTech
//

import UIKit

protocol RepositoryListDisplayLogic: AnyObject {
    func displayUserRepos(viewModel: RepositoryList.UseCase.ViewModel)
    func displayError(viewModel: RepositoryList.UseCase.ViewModel)
}

class RepositoryListViewController: UIViewController, RepositoryListDisplayLogic, Storyboardable {
    var interactor: RepositoryListBusinessLogic?
    var router: (NSObjectProtocol & RepositoryListRoutingLogic & RepositoryListDataPassing)?
    var reposViewModel: RepoViewModel! {
        didSet {
            reposViewModel.currentpage += 1
            repos = reposViewModel.userRepoViewModel
        }
    }
    private var repos = [UserRepoViewModel]()
    @IBOutlet weak var tableView: UITableView!
    
    static var storyboardName: StringConvertible {
        return StoryboardType.searchList
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
        let interactor = RepositoryListInteractor()
        let presenter = RepositoryListPresenter()
        let router = RepositoryListRouter()
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
        tableView.reloadData()
    }
    
    func displayUserRepos(viewModel: RepositoryList.UseCase.ViewModel) {
        DispatchQueue.main.async {
            self.reposViewModel = viewModel.userRpos
            self.tableView.reloadData()
        }
    }
    
    func displayError(viewModel: RepositoryList.UseCase.ViewModel) {
        DispatchQueue.main.async {
            self.showErrorAlert(textString: viewModel.errosString)
        }
    }
    
    private func reloadData() {
        if reposViewModel.needToReload {
            var request = RepositoryList.UseCase.Request()
            request.userRpos = reposViewModel
            interactor?.loadMoreRepos(request: request)
        }
    }
    
}


extension RepositoryListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = RepositoryListTableViewCell.dequeue(from: tableView) else {
            fatalError("Could not dequeue cell with type: \(RepositoryListTableViewCell.self)")
        }
        cell.userRepo = repos[indexPath.row]
        
        if indexPath.row == repos.count - 1 {
            reloadData()
        }
        
        return cell
    }
}
