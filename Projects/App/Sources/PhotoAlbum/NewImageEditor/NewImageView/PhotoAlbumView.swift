//
//  PhotoAlbumView.swift
//  iosClubRadio
//

import UIKit
import SwiftyJSON
import RxCocoa
import RxSwift

class PhotoAlbumView : UIView, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var another_view: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var table_view_height_constant: NSLayoutConstraint!
    
    var didSelectAlbum: ((PLAlbum) -> Void)?
    var albums : [PLAlbum] = []
    var albumsManager: PLAlbumManager!
    var disposeBag = DisposeBag()
    
    var hView : UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
            initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialize(){
        setView()
        bind()
    }
    
    func setView(){
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        self.frame = CGRect(x: 0, y: hView.frame.height + statusBarHeight, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - hView.frame.height)
        
        setUpTableView()
        fetchAlbumsInBackground()
    }
    
    func setUpTableView() {
        tableView.isHidden = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "PLAlbumCell", bundle: nil), forCellReuseIdentifier: "PLAlbumCell")
    }
    
    func bind() {
        let without = UITapGestureRecognizer()
        another_view.addGestureRecognizer(without)
        
        without.rx.event
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind { _ in
                self.removeFromSuperview()
            }
            .disposed(by: disposeBag)
    }
    
    func fetchAlbumsInBackground() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.albums = self?.albumsManager.fetchAlbums() ?? []
            DispatchQueue.main.async {
                self?.tableView.isHidden = false
                /*
                var tableHeight = self!.tableView.contentSize.height + 20
                let statusBarHeight = UIApplication.shared.statusBarFrame.height
                if self!.tableView.contentSize.height >  UIScreen.main.bounds.height - self!.hView.frame.height {
                    tableHeight = UIScreen.main.bounds.height - self!.hView.frame.height - statusBarHeight
                }
                self?.table_view_height_constant.constant = tableHeight
                 */
                self?.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let album = albums[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PLAlbumCell", for: indexPath) as? PLAlbumCell {
            cell.thumbnail.backgroundColor = .gray
            cell.thumbnail.image = album.thumbnail
            cell.titleLabel.text = album.title
            cell.numberOfItems.text = "\(album.numberOfItems)장"
            return cell
        }
        return UITableViewCell()
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectAlbum?(albums[indexPath.row])
        self.removeFromSuperview()
    }
}
