//
//  ViewModel.swift
//  MVVM-TableView
//
//  Created by 光光 on 7/24/19.
//  Copyright © 2019 feilei. All rights reserved.
//

import UIKit

struct CellViewModel {
    let titleText: String
    let descText: String
    let imageUrl: String
    let dateText: String
}
typealias Nothing = (()->())
class ViewModel: NSObject {
    //整体思路就是通过属性观察器和闭包实现数据的双向绑定，在viewModel中处理逻辑
    //使用闭包来控制交互过程
    var reloadTableViewClosure: Nothing?
    var showAlertClosure: Nothing?
    //外部需要用到的值，可读性属性
    var cellViewModels: [CellViewModel] = [CellViewModel]() {
        didSet {
            reloadTableViewClosure?()
        }
    }
    var alertMessage: String? {
        didSet {
            showAlertClosure?()
        }
    }
    
    //viewModel中数据处理方法，需要外部调用
    var numberCells: Int {
        return cellViewModels.count
    }
    
    func initData(api: APIService = APIService()) {
        api.fetchPopularPhoto { [weak self] (success, photos, error) in
            if let error = error {
                self?.alertMessage = error.rawValue
            } else {
                self?.processFetchedPhoto(photos: photos)
            }
        }
    }
    
    func dataViewModel(_ index: IndexPath) -> CellViewModel {
        return cellViewModels[index.row]
    }
    
    func promptMessage(_ index: IndexPath) {
        if index.row%2 == 0 {
            alertMessage = "点击\(index.row)"
        }
    }
    
    func processFetchedPhoto(photos: [Photo]) {
        var num = [CellViewModel]()
        for photo in photos {
            num.append(createCellViewModel(photo: photo))
        }
        //刷新tableview
        cellViewModels = num
    }
    
    //这样的处理是为了保证model不参与直接交互，而是采用viewmodel接管数据进行view层的交互
    func createCellViewModel( photo: Photo ) -> CellViewModel {
        
        //Wrap a description
        var descTextContainer: [String] = [String]()
        if let camera = photo.camera {
            descTextContainer.append(camera)
        }
        if let description = photo.description {
            descTextContainer.append( description )
        }
        let desc = descTextContainer.joined(separator: " - ")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return CellViewModel( titleText: photo.name,
                                       descText: desc,
                                       imageUrl: photo.image_url,
                                       dateText: dateFormatter.string(from: photo.created_at) )
    }
    
    
}

