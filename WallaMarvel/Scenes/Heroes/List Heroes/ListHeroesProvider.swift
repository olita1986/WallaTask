import Foundation
import UIKit

final class ListHeroesProvider: NSObject, UITableViewDataSource {
    // MARK: - Public Properties

    var heroes: [CharacterDataModel] {
        didSet {
            filteredHeroes = heroes
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var filteredHeroes: [CharacterDataModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Private Properties

    private let tableView: UITableView
    
    init(tableView: UITableView, heroes: [CharacterDataModel] = []) {
        self.tableView = tableView
        self.heroes = heroes
        super.init()
        self.tableView.dataSource = self
    }
    
    // MARK: - Delegate Methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredHeroes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListHeroesTableViewCell", for: indexPath) as? ListHeroesTableViewCell else {
            return UITableViewCell()
        }
        
        let model = filteredHeroes[indexPath.row]
        cell.configure(model: model)
        
        return cell
    }

    // MARK: - Public Methods
    
    func updateFoundHeroes(heroes: [CharacterDataModel]) {
        filteredHeroes = heroes
    }

    func resetFilter() {
        filteredHeroes = heroes
    }
}
