import UIKit

class PostDetailViewController: UIViewController {
    private let post: Post
    private var comments: [Comment]
    private var expandedCommentIndex: Int?

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(PostDetailHeaderCell.self, forCellReuseIdentifier: PostDetailHeaderCell.identifier)
        tableView.register(CommentTableViewCell.self, forCellReuseIdentifier: CommentTableViewCell.identifier)
        return tableView
    }()

    init(post: Post, comments: [Comment]) {
        self.post = post
        self.comments = comments
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Post Details"
        view.backgroundColor = .white

        setupTableView()
        fetchComments() // Fetch comments when the view loads
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func fetchComments() {
        // Simulate API fetch with a delay (no activity indicator)
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) { [weak self] in
            // Simulated comments
            let fetchedComments = self?.comments ?? []
            DispatchQueue.main.async {
                self?.comments = fetchedComments
                self?.tableView.reloadData()
            }
        }
    }
}

extension PostDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2 // 1 for post details, 1 for comments
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : comments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            // Post Details Section
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PostDetailHeaderCell.identifier, for: indexPath) as? PostDetailHeaderCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            cell.configure(with: post)
            return cell
        } else {
            // Comments Section
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.identifier, for: indexPath) as? CommentTableViewCell else {
                return UITableViewCell()
            }
            let comment = comments[indexPath.row]
            let isExpanded = (indexPath.row == expandedCommentIndex)
            cell.configure(with: comment, isExpanded: isExpanded)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            // Trigger the fetch of comments when post is selected
            fetchComments()
        }
        if indexPath.section == 1 { // Comments section
            if expandedCommentIndex == indexPath.row {
                expandedCommentIndex = nil // Collapse the currently expanded comment
            } else {
                expandedCommentIndex = indexPath.row
            }
            tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableView.automaticDimension
        } else {
            return UITableView.automaticDimension
        }
    }
}
