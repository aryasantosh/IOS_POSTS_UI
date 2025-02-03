import UIKit

class PostDetailViewController: BaseViewController {
    private var post: Post
    private var comments: [Comment] = []
    private var expandedCommentIndex: Int?
    private var viewModel: PostDetailViewModel
    
    lazy private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(PostDetailHeaderCell.self, forCellReuseIdentifier: PostDetailHeaderCell.identifier) //tells the table view what type of cell to use.
        tableView.register(CommentTableViewCell.self, forCellReuseIdentifier: CommentTableViewCell.identifier) //Reusability is needed for performance optimization.
        return tableView
    }()
    
    init(post: Post, viewModel: PostDetailViewModel) { //allows creating an instance of the view controller
        self.post = post
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up the navigation bar
        setupNavigationBar(withTitle: "Post Details")
        view.backgroundColor = .white
        setupTableView()
        fetchComments()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func fetchComments() {
        viewModel.fetchComments(postId: post.id) { [weak self] comments in
            guard let self = self else{return} //prevents memory leaks
            self.comments = comments  //viewcontroller
            DispatchQueue.main.async {
                self.tableView.reloadSections(IndexSet(integer: 1), with: .automatic) //indicating sect 1 of table view (the num starts from 0).
            }
        } onError: { [weak self] errorMessage in  //network error, fetchdataerror
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.showErrorAlert(with: errorMessage)
            }
        }
    }
    
    private func showErrorAlert(with message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
}

extension PostDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2 // 1 for post details, 1 for comments
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : comments.count  //number of rows in all other sections will be equal to the number of comments in the comments array.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            // Post Details Section
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PostDetailHeaderCell.identifier, for: indexPath) as? PostDetailHeaderCell else {
                return UITableViewCell() //plain will show //Type Casting as "Is this cell actually of type PostDetailHeaderCell?"
            }
            cell.selectionStyle = .none
            cell.configure(with: post) //checks that correctly set up with the data it needs to display.
            return cell
        }
        // Comments Section
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.identifier, for: indexPath) as? CommentTableViewCell else {
            return UITableViewCell()
        }
        let comment = comments[indexPath.row]  //The cellForRowAt method ensures the correct expanded/collapsed state is maintained when the table reloads.
        let isExpanded = (indexPath.row == expandedCommentIndex)
        cell.configure(with: comment, isExpanded: isExpanded)
        cell.delegate = self
        
        //When indexPath.row == 1 (second row):
        //comments[indexPath.row] will be: "Here's the second comment."
        //isExpanded = (indexPath.row == expandedCommentIndex) will check if indexPath.row == 1 (since expandedCommentIndex = 1).
        //1 == 1 is true, so isExpanded will be true.
      
        return cell
    }
}

extension PostDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}
// MARK: - Handle "See More" Button Expansion
extension PostDetailViewController: CommentCellDelegate {
    func handleCommentExpansion(in cell: CommentTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        if expandedCommentIndex == indexPath.row {
            expandedCommentIndex = nil  // Collapse if already expanded
        } else {
            expandedCommentIndex = indexPath.row  // Expand the selected comment
        }
        
        // Reload only the affected row for a smooth animation
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    }
