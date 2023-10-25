//
//  RegionSearchResultControllerTableViewController.swift
//  ZZin
//
//  Created by t2023-m0055 on 2023/10/24.
//

import UIKit
import Alamofire
import Foundation
import Then
import SnapKit

class RegionSearchResultController: UITableViewController, UISearchResultsUpdating {
    var resultArray: [Item] = []
    var query: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(RegionSearchResultTableViewCell.self, forCellReuseIdentifier: RegionSearchResultTableViewCell.identifier)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {1}

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch resultArray.count {
        case 0: return 1
        default: return resultArray.count
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {70}
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch resultArray.count {
        case 0 : return UITableViewCell()
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: RegionSearchResultTableViewCell.identifier, for: indexPath) as? RegionSearchResultTableViewCell
            
            cell?.regionLabel.text = resultArray[indexPath.row].title?.htmlEscaped
            cell?.descriptionLabel.text = resultArray[indexPath.row].roadAddress
            
            return cell ?? UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard resultArray.count > 0 else {return}
        
        let selectedPlace: Item = resultArray[indexPath.row]
        
        placeName = selectedPlace.title ?? ""
        address = selectedPlace.roadAddress ?? ""
        
        self.dismiss(animated: true)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        query = searchController.searchBar.text ?? ""
        requestPlace(query: query){
            self.tableView.reloadData()
        }
        print(resultArray)
    }
    
    func requestPlace(query: String,  completionHandler : @escaping () -> Void) {
        let url = "https://openapi.naver.com/v1/search/local.json"
        let params = ["query": query, "display": "5", "sort": "comment"]
        
        AF.request(url,
                   method: .get,
                   parameters: params,
                   encoding: URLEncoding.default,
                   headers: ["X-Naver-Client-Id":"MbygGZgdglRz_YPMzp2h", "X-Naver-Client-Secret":"UvefCbCrnT"])
        .responseJSON { response in
            
            /** 서버로부터 받은 데이터 활용 */
            switch response.result {
            case .success(let value):
                do{
                    let dataJSon = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                    let welcome = try JSONDecoder().decode(Response.self, from: dataJSon)
                    let items: [Item] = welcome.items
                    self.resultArray = items
                    completionHandler()
                } catch {
                    print("fail")
                }
                
            case .failure(let error):
                print("error : \(error)")
                
                break;
            }
        }
    }
}

// MARK: - Response
struct Response: Codable {
    let lastBuildDate: String
    let total, start, display: Int
    let items: [Item]
}

// MARK: - Item
struct Item: Codable {
    let title: String?
    let link: String?
    let category, description, telephone, address: String?
    let roadAddress, mapx, mapy: String?
}

extension String {
    // html 태그 제거 + html entity들 디코딩.
    var htmlEscaped: String {
        guard let encodedData = self.data(using: .utf8) else {
            return self
        }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        do {
            let attributed = try NSAttributedString(data: encodedData,
                                                    options: options,
                                                    documentAttributes: nil)
            return attributed.string
        } catch {
            return self
        }
    }
}
