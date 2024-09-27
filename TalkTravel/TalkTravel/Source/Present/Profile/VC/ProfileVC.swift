import UIKit

class ProfileVC: UIViewController {
    var viewModel = ProfileViewModel()
    
    override func loadView() {
        super.loadView()
        self.view = profileView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        setData()
        updateToggleState()
    }
    
    private func setData() {
        profileView.themeSectionItem.bindData(section1: viewModel.profileViewData.themeSection1Data,
                                  section2: viewModel.profileViewData.themeSection2Data,
                                  section3: viewModel.profileViewData.themeSection3Data)
    }
    
    
    private func updateToggleState() {
        profileView.themeSectionItem.section1View.leftItem.selectCompletion = { [weak self] _ in
            guard let self else { return }
            viewModel.profileViewData.themeSection1Data[0].isSelected = true
            viewModel.profileViewData.themeSection1Data[1].isSelected = false
            profileView.themeSectionItem.section1View.bindData(types: viewModel.profileViewData.themeSection1Data)
        }
        
        profileView.themeSectionItem.section1View.rightItem.selectCompletion = { [weak self] _ in
            guard let self else { return }
            viewModel.profileViewData.themeSection1Data[0].isSelected = false
            viewModel.profileViewData.themeSection1Data[1].isSelected = true
            profileView.themeSectionItem.section1View.bindData(types: viewModel.profileViewData.themeSection1Data)
        }
        
        profileView.themeSectionItem.section2View.leftItem.selectCompletion = { [weak self] _ in
            guard let self else { return }
            viewModel.profileViewData.themeSection2Data[0].isSelected = true
            viewModel.profileViewData.themeSection2Data[1].isSelected = false
            profileView.themeSectionItem.section2View.bindData(types: viewModel.profileViewData.themeSection2Data)
        }
        
        profileView.themeSectionItem.section2View.rightItem.selectCompletion = { [weak self] _ in
            guard let self else { return }
            viewModel.profileViewData.themeSection2Data[0].isSelected = false
            viewModel.profileViewData.themeSection2Data[1].isSelected = true
            profileView.themeSectionItem.section2View.bindData(types: viewModel.profileViewData.themeSection2Data)
        }
        
        profileView.themeSectionItem.section3View.leftItem.selectCompletion = { [weak self] _ in
            guard let self else { return }
            viewModel.profileViewData.themeSection3Data[0].isSelected = true
            viewModel.profileViewData.themeSection3Data[1].isSelected = false
            profileView.themeSectionItem.section3View.bindData(types: viewModel.profileViewData.themeSection3Data)
        }
        
        profileView.themeSectionItem.section3View.rightItem.selectCompletion = { [weak self] _ in
            guard let self else { return }
            viewModel.profileViewData.themeSection3Data[0].isSelected = false
            viewModel.profileViewData.themeSection3Data[1].isSelected = true
            profileView.themeSectionItem.section3View.bindData(types: viewModel.profileViewData.themeSection3Data)
        }
    }
    
    private let profileView = ProfileView()
}
