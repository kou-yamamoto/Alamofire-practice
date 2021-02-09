//
//  ArticleListViewController.swift
//  AlamofirePractice
//
//  Created by kou yamamoto on 2021/02/09.
//

import UIKit
import Alamofire

class ArticleListViewController: UIViewController {
    
    //MARK: outlet接続
    @IBOutlet weak var articleListTableView: UITableView!
    
    //MARK: 変数
    let decoder: JSONDecoder = JSONDecoder()
    var articles = [Article]()
    
    let urlString = "https://qiita.com/api/v2/items" //APIのURL
    let method: HTTPMethod = .get //.get または .post
    let parameter = ["": ""] //辞書型
    let encoding: ParameterEncoding = URLEncoding.default //パラメーターがない場合は不要
    
    //MARK: setup
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        getQiitaArticles()
    }
    
    private func setup() {
        articleListTableView.delegate = self
        articleListTableView.dataSource = self
    }
    
    //MARK:- Alamofire
    private func getQiitaArticles() {
        AF.request(urlString, method: method, parameters: parameter).responseJSON { response in
            switch response.result {
            case .success:
                do { self.articles = try self.decoder.decode([Article].self, from: response.data!); self.articleListTableView.reloadData() } catch {print("デコードに失敗しました")}
            case .failure(let error):
                print("error", error)
            }
        }
    }
}

//MARK:- UITableViewDelegate
extension ArticleListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath)
        cell.textLabel?.text = articles[indexPath.row].title
        cell.detailTextLabel?.text = articles[indexPath.row].user.name
        return cell
    }
}
