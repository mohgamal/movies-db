import UIKit

class MovieCreditsView: UIView, UITableViewDataSource {
    private var credits: MovieCredits?
    private let tableView = UITableView()
    private var tableHeightConstraint: NSLayoutConstraint!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTableView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CreditCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isScrollEnabled = false // Disable internal scrolling so it can expand

        addSubview(tableView)

        // Set up constraints
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        // Add a height constraint for the table view
        tableHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 0)
        tableHeightConstraint.isActive = true
    }

    func configure(with credits: MovieCredits) {
        self.credits = credits
        tableView.reloadData()
        updateTableHeight() // Update height after reloading data
    }

    private func updateTableHeight() {
        // Calculate the content height of the table view
        tableHeightConstraint.constant = tableView.contentSize.height
        layoutIfNeeded() // Refresh the layout
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (credits?.cast.count ?? 0) + (credits?.crew.count ?? 0)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CreditCell", for: indexPath)
        cell.selectionStyle = .none
        if let cast = credits?.cast, indexPath.row < cast.count {
            let castMember = cast[indexPath.row]
            cell.textLabel?.text = "\(castMember.name) as \(castMember.character)"
        } else if let crew = credits?.crew {
            let crewIndex = indexPath.row - (credits?.cast.count ?? 0)
            let crewMember = crew[crewIndex]
            cell.textLabel?.text = "\(crewMember.name) - \(crewMember.job)"
        }
        return cell
    }
}
