import Foundation
import UIKit

final class ListHeroesProvider: NSObject, UITableViewDataSource {
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

    private let tableView: UITableView
    
    init(tableView: UITableView, heroes: [CharacterDataModel] = []) {
        self.tableView = tableView
        self.heroes = heroes
        super.init()
        self.tableView.dataSource = self
    }
    
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
    
    func resetFilter() {
        filteredHeroes = heroes
    }
    
    func searchHeroe(withText text: String) {
        filteredHeroes = heroes.filter {
            $0.name.lowercased().contains(text.lowercased())
        }
    }
}
