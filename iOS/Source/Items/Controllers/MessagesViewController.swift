//
//  MessagesViewController.swift
//  BBMessages
//
//  Created by Robert-Hein Hooijmans on 01/05/2017.
//  Copyright © 2017 Bakken & Baeck. All rights reserved.
//

import UIKit
import TinyConstraints
import BouncyLayout

struct IndexPathSizes {
    var sizes:[IndexPath: CGSize] = [:]
    
    subscript(indexPath: IndexPath) -> CGSize? {
        get {
            return self.sizes[indexPath]
        } set {
            self.sizes[indexPath] = newValue
        }
    }
}

class MessagesViewController: UIViewController {
    
    
    var sizeFor = IndexPathSizes()
    
    lazy var messages = (0..<100).map { _ in Message.random() }
    
//    lazy var layout: UICollectionViewFlowLayout = {
//        let layout = UICollectionViewFlowLayout()
//        layout.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize
//        layout.minimumInteritemSpacing = 0
//        layout.minimumLineSpacing = 0
//        
//        return layout
//    }()
    
    lazy var layout: BouncyLayout = {
        let layout = BouncyLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 10
        
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
        view.register(MessageCell.self, forCellWithReuseIdentifier: MessageCell.reuseIdentifier)
        view.delegate = self
        view.dataSource = self
        view.prefetchDataSource = self
        view.backgroundColor = .white
        
        return view
    }()
    
    lazy var dummyCell: MessageCell = {
        return MessageCell()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "@hamsterdam"
        
        let margin: CGFloat = 500
        
        view.addSubview(collectionView)
        collectionView.edges(to: view, insets: UIEdgeInsets(top: -margin, left: 0, bottom: margin, right: 0))
        collectionView.contentInset = UIEdgeInsets(top: margin + 10, left: 0, bottom: margin + 10, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: margin, left: 0, bottom: margin, right: 0)
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        
//        collectionView.reloadData()
//    }
    
    func calculateSize(for indexPath: IndexPath) -> CGSize {
        
        dummyCell.message = messages[indexPath.item]
        return dummyCell.size(for: collectionView.bounds.width)
    }
}

extension MessagesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MessageCell.reuseIdentifier, for: indexPath)
        
        if var cell = cell as? MessageCellProtocol {
            let message = messages[indexPath.item]
            cell.message = message
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
}

extension MessagesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if sizeFor[indexPath] == nil {
            sizeFor[indexPath] = calculateSize(for: indexPath)
        }
        
        return sizeFor[indexPath]!
    }
}

extension MessagesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print("didSelectItemAt:\(indexPath)")
    }
}

extension MessagesViewController: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
//        print("prefetchItemsAt:\(indexPaths)")
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
//        print("cancelPrefetchingForItemsAt:\(indexPaths)")
    }
}
