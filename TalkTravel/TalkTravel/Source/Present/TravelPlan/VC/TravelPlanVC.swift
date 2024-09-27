//
//  TravelPlanVC.swift
//  TalkTravel
//
//  Created by 박익범 on 6/7/24.
//

import UIKit

class TravelPlanVC: UIViewController {
    var viewModel = TravelPlanViewModel()
    
    override func loadView() {
        super.loadView()
        self.view = travelPlanView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        travelPlanView.planHistoryCollectionView.dataSource = self
    }
    
    private var travelPlanView = TravelPlanView()

}

extension TravelPlanVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.travelPlanHistoryData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TravelPlanCell.reuseIdentifier,
                                                            for: indexPath) as? TravelPlanCell else {
            return UICollectionViewCell()
        }
        
        cell.bindData(createdAt: viewModel.travelPlanHistoryData[indexPath.row].createdAt,
                      chattingTitle: viewModel.travelPlanHistoryData[indexPath.row].chatTitle)
        
        return cell
    }
    
    
}
