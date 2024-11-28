import UIKit

import RxSwift
import RxRelay
import RxCocoa

class ProfileVC: UIViewController {
    private var disposeBag: DisposeBag = .init()
    var viewModel = ProfileViewModel(userRepository: .init())
    
    let minValue: Float = 10
    let maxValue: Float = 100
    
    override func loadView() {
        super.loadView()
        self.view = profileView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        bindAction()
        viewModel.getProfileData(completion: { [weak self] in
            guard let self else { return }
            self.setData()
            self.setTotalBudget()
            self.updateToggleState()
        })
    }
    
    private func bindAction() {
        profileView.budgetSliderSectionItem.foodExpenseSliderView.slider.addTarget(self,
                                                                                   action: #selector(sliderTouchEnded(_:)), for: [.touchUpInside, .touchUpOutside])
        profileView.budgetSliderSectionItem.foodExpenseSliderView.slider.addTarget(self,
                                                                                   action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        profileView.budgetSliderSectionItem.hotelSliderView.slider.addTarget(self,
                                                                             action: #selector(sliderTouchEnded(_:)), for: [.touchUpInside, .touchUpOutside])
        profileView.budgetSliderSectionItem.hotelSliderView.slider.addTarget(self,
                                                                             action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        
        profileView.budgetSliderSectionItem.travelBudgetSliderView.slider.addTarget(self,
                                                                                    action: #selector(sliderTouchEnded(_:)), for: [.touchUpInside, .touchUpOutside])
        profileView.budgetSliderSectionItem.travelBudgetSliderView.slider.addTarget(self,
                                                                                    action: #selector(sliderValueChanged(_:)), for: .valueChanged)
    }
    
    @objc func sliderValueChanged(_ sender: UISlider) {
        if sender == profileView.budgetSliderSectionItem.foodExpenseSliderView.slider {
            viewModel.profileViewData.foodBudget = Float(minValue + (sender.value * (maxValue - minValue)))
        } else if sender == profileView.budgetSliderSectionItem.hotelSliderView.slider {
            viewModel.profileViewData.placeBudget = Float(minValue + (sender.value * (maxValue - minValue)))
        } else if sender == profileView.budgetSliderSectionItem.travelBudgetSliderView.slider {
            viewModel.profileViewData.travelBudget = Float(minValue + (sender.value * (maxValue - minValue)))
        }
        setTotalBudget()
    }
    
    @objc func sliderTouchEnded(_ sender: UISlider) {
        setTotalBudget()
        viewModel.updateProfileData(placeBudget: viewModel.profileViewData.placeBudget,
                                    foodBudget: viewModel.profileViewData.foodBudget,
                                    travelBudget: viewModel.profileViewData.travelBudget)
    }
    
    private func setTotalBudget() {
        let budget = Int(viewModel.profileViewData.foodBudget) + Int(viewModel.profileViewData.travelBudget) + Int(viewModel.profileViewData.placeBudget)
        self.profileView.budgetSliderSectionItem.titleLabel.text = "\(Int(budget))만원"
    }
    
    private func setData() {
        profileView.themeSectionItem.bindData(section1: viewModel.profileViewData.themeSection1Data,
                                              section2: viewModel.profileViewData.themeSection2Data,
                                              section3: viewModel.profileViewData.themeSection3Data)
        profileView.budgetSliderSectionItem.hotelSliderView.bindData(data: (viewModel.profileViewData.placeBudget - 10) / (90))
        profileView.budgetSliderSectionItem.foodExpenseSliderView.bindData(data: (viewModel.profileViewData.foodBudget - 10) / (90))
        profileView.budgetSliderSectionItem.travelBudgetSliderView.bindData(data: (viewModel.profileViewData.travelBudget - 10) / (90))
    }
    
    
    private func updateToggleState() {
        profileView.themeSectionItem.section1View.leftItem.selectCompletion = { [weak self] _ in
            guard let self else { return }
            viewModel.profileViewData.themeSection1Data[0].isSelected = true
            viewModel.profileViewData.themeSection1Data[1].isSelected = false
            profileView.themeSectionItem.section1View.bindData(types: viewModel.profileViewData.themeSection1Data)
            viewModel.updateUserData()
        }
        
        profileView.themeSectionItem.section1View.rightItem.selectCompletion = { [weak self] _ in
            guard let self else { return }
            viewModel.profileViewData.themeSection1Data[0].isSelected = false
            viewModel.profileViewData.themeSection1Data[1].isSelected = true
            profileView.themeSectionItem.section1View.bindData(types: viewModel.profileViewData.themeSection1Data)
            viewModel.updateUserData()
        }
        
        profileView.themeSectionItem.section2View.leftItem.selectCompletion = { [weak self] _ in
            guard let self else { return }
            viewModel.profileViewData.themeSection2Data[0].isSelected = true
            viewModel.profileViewData.themeSection2Data[1].isSelected = false
            profileView.themeSectionItem.section2View.bindData(types: viewModel.profileViewData.themeSection2Data)
            viewModel.updateUserData()
        }
        
        profileView.themeSectionItem.section2View.rightItem.selectCompletion = { [weak self] _ in
            guard let self else { return }
            viewModel.profileViewData.themeSection2Data[0].isSelected = false
            viewModel.profileViewData.themeSection2Data[1].isSelected = true
            profileView.themeSectionItem.section2View.bindData(types: viewModel.profileViewData.themeSection2Data)
            viewModel.updateUserData()
        }
        
        profileView.themeSectionItem.section3View.leftItem.selectCompletion = { [weak self] _ in
            guard let self else { return }
            viewModel.profileViewData.themeSection3Data[0].isSelected = true
            viewModel.profileViewData.themeSection3Data[1].isSelected = false
            profileView.themeSectionItem.section3View.bindData(types: viewModel.profileViewData.themeSection3Data)
            viewModel.updateUserData()
        }
        
        profileView.themeSectionItem.section3View.rightItem.selectCompletion = { [weak self] _ in
            guard let self else { return }
            viewModel.profileViewData.themeSection3Data[0].isSelected = false
            viewModel.profileViewData.themeSection3Data[1].isSelected = true
            profileView.themeSectionItem.section3View.bindData(types: viewModel.profileViewData.themeSection3Data)
            viewModel.updateUserData()
        }
        
    }
    
    private let profileView = ProfileView()
}
