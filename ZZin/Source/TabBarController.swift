import UIKit

class TabBarViewController: UITabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        let mainVC = MainViewController()
        let searchVC = MatchingVC()
        let postVC = PostViewController()
//        let storyVC = StoryViewController()
        let infoVC = InfoViewController()
        
        //각 tab bar의 viewcontroller 타이틀 설정
        
        mainVC.title = "홈"
        searchVC.title = "매칭"
//        storyVC.title = "소식"
        infoVC.title = "프로필"
        postVC.title = "리뷰 쓰기"
        
        mainVC.tabBarItem.image = UIImage.init(systemName: "house")
        searchVC.tabBarItem.image = UIImage.init(systemName: "rectangle.and.text.magnifyingglass")
//        let plusImage = UIImage.init(systemName: "plus")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 40, weight: .bold))
//        let yOffset: CGFloat = 30 // 아이콘과 텍스트를 아래로 이동시킬 값
//        let resizedImage = UIGraphicsImageRenderer(size: CGSize(width: (plusImage?.size.width)!, height: (plusImage?.size.height)! + yOffset)).image { _ in
//            plusImage?.draw(at: CGPoint(x: 0, y: yOffset))}
//        postVC.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: yOffset)
//        postVC.tabBarItem.image = resizedImage
        postVC.tabBarItem.image = UIImage.init(systemName: "pencil.line")
//        storyVC.tabBarItem.image = UIImage.init(systemName: "message")
        infoVC.tabBarItem.image = UIImage.init(systemName: "person")
        
        //self.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0);
        
        // 위에 타이틀 text를 항상 크게 보이게 설정
        mainVC.navigationItem.largeTitleDisplayMode = .always
        searchVC.navigationItem.largeTitleDisplayMode = .always
//        storyVC.navigationItem.largeTitleDisplayMode = .always
        infoVC.navigationItem.largeTitleDisplayMode = .always
        
        // navigationController의 root view 설정
        let navigationHome = UINavigationController(rootViewController: mainVC)
        let navigationSearch = UINavigationController(rootViewController: searchVC)
        let navigationPost = UINavigationController(rootViewController: postVC)
//        let navigationStory = UINavigationController(rootViewController: storyVC)
        let navigationInfo = UINavigationController(rootViewController: infoVC)
        
        // 검색탭 네비게이션 바 수정
        navigationSearch.navigationBar.isHidden = true
        //        navigationHome.navigationBar.prefersLargeTitles = true
        //        navigationSearch.navigationBar.prefersLargeTitles = true
        //        navigationPost.navigationBar.prefersLargeTitles = true
        //        navigationStory.navigationBar.prefersLargeTitles = true
        //        navigationInfo.navigationBar.prefersLargeTitles = true
        setViewControllers([navigationHome, navigationSearch, navigationPost, navigationInfo], animated: false)
//        setViewControllers([navigationHome, navigationSearch, navigationPost, navigationStory, navigationInfo], animated: false)
        
        // 선택된 탭 바 아이템의 색상을 설정합니다.
        UITabBar.appearance().tintColor = ColorGuide.main

        // 선택되지 않은 탭 바 아이템의 색상을 설정합니다.
        UITabBar.appearance().unselectedItemTintColor = UIColor.lightGray

        // 탭 바의 배경색을 설정합니다.
        UITabBar.appearance().barTintColor = .systemGray5

//        // 선택사항: 탭 바의 투명도 설정
//        UITabBar.appearance().isTranslucent = false
    }
    
    //탭바 height 커스터 마이징
    let HEIGHT_TAB_BAR:CGFloat = 90
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var tabFrame = self.tabBar.frame
        tabFrame.size.height = HEIGHT_TAB_BAR
        tabFrame.origin.y = self.view.frame.size.height - HEIGHT_TAB_BAR
        self.tabBar.frame = tabFrame
    }
    
}
