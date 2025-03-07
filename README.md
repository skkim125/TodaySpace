# 🏞️ 오늘의 공간 ReadMe

## 🏞️ 프로젝트 소개
> 유저가 머물렀던 감성적인 공간에 대한 이야기와 후기를 남기는 라이프스타일 앱

<img src="https://github.com/user-attachments/assets/7c965c3e-305e-4038-85ee-53f7cd07cef7" width="19%"/>
<img src="https://github.com/user-attachments/assets/440d9efe-abf9-4821-aaf8-2ea587c0892c" width="19%"/>
<img src="https://github.com/user-attachments/assets/d40415ca-a9cd-4476-b157-1a3056002922" width="19%"/>
<img src="https://github.com/user-attachments/assets/9208217b-25c1-4879-8c75-7fade47a4acb" width="19%"/>
<img src="https://github.com/user-attachments/assets/120ee9b3-cfd0-4bcc-967a-05cdf84f1f60" width="19%"/>

<br>

## 🏞️ 프로젝트 환경
- 인원: iOS 개발 1명, 서버 1명
- 기간: 2025.02.03 ~ 2024.03.03
- 개발 환경: Xcode 16
- 최소 버전: iOS 17.0
<br>

## 🏞️ 기술 스택
- iOS: Swift, SwiftUI
- Architecture: TCA
- Network: URLSession, Swift Concurrency
- Apple: MapKit for SwiftUI, NSCache, PhotosUI, WebKit
- UI: CustomFont, Optimistic UI
- Service: Kakao Local API
<br>

## 🏞️ 핵심 기능
- 사람들이 머무른 공간에 대한 게시물 확인 기능
- 오늘 추천하고 싶은 공간에 대해 게시물 작성 기능
- 지도를 기반으로 현재위치 및 특정 위치의 게시물 확인 기능
- 공간에 대한 게시물에 대한 상세 확인, 좋아요 및 댓글 기능
<br>

## 🏞️ 주요 기술
- TCA와 단방향 데이터 플로우 아키텍처
  - State와 Reducer를 통한 데이터 업데이트와 업데이트된 데이터를 View에 전달하는 단방향 데이터 플로우 아키텍처 구현
- TCA의 Navigation을 활용한 내비게이션 구현
  - Sheet, Alert 등의 pop-up 방식의 화면 전환에 트리 기반 Navigation 활용
  - NavigationStack을 통한 push-pop 방식의 화면 전환에 스택 기반의 Navigation 활용
- Access Token과 Refresh Token을 활용한 로그인 및 관련 기능 구현
  - UserDefaults를 활용하여 유저의 고유 id, Access & Refresh Token 등 저장
  - 재귀 함수를 통해 토큰 갱신 성공 시 기존 네트워크 재호출
- 게시물 상세뷰
  - ScrollViewReader를 활용하여 댓글 전송 시 자동 하단 스크롤 구현
  - scrollTargetLayout과 scrollTargetBehavior를 활용한 이미지 페이지네이션 구현
  - 라인 제한에 따라 늘어나거나 스크롤 되는 Dynamic TextField 구현
- 스크랩에 대한 Optimistic UI 구현
  - 스크랩 시 debounce를 통해 UI는 즉시 변경하는 동시에 1초 이후에 서버에 요청하도록 구현
  - 기존의 스크랩 상태와 토글된 상태에 따라 스크랩 요청을 조건부로 실행되도록 구현
  - 스크랩 동작 이후 바로 뒤로 이동하여도 스크랩 요청을 조건부로 실행되도록 구현
- NSCache를 사용한 메모리 캐싱 구현
  - 메모리 캐시의 최대 용량을 50MB 제한
  - 이미지 API 통신 시 저장하도록 구현
- Custom NavigationBar
  - Apple에서 제공하는 NavigationBar의 제한적인 기능을 개선한 Custom NavigationBar component를 생성하여 개발 유연성 및 재사용성 증가

<br>

## 🏞️ 트러블 슈팅
****1. SwiftUI에서의 MapKit과 TabBar**** 

#### `문제 발생`
   - SwiftUI의 MapKit을 활용하여 내주변 기능 개발을 진행하던 중 탭바의 배경색이 다르게 적용되어 있음을 확인
   - View Hierarchy로 확인한 결과 SwiftUI의 Map에 uivisualeffectbackdropview가 존재하여 TabView의 TabBar를 덮고 있음을 확인

#### `해결 방법`
   - TabView 숨기기, 앱 실행시 TabBar의 Appearance를 지정해주어도 현상이 해결되지 않음
   - Custom TabBar를 생성하여, 기존의 TabView의 TabBar 대신 사용하도록 구현

<img src="https://github.com/user-attachments/assets/e5574137-6818-4c18-8732-9ed1c10c3abf" width="19%" height="400"/>
<img src="https://github.com/user-attachments/assets/cc1ff3e1-9793-433e-bbd2-c92abb9c3275" width="19%" height="400"/>
<img src="https://github.com/user-attachments/assets/b4055542-3220-45c8-9ca3-af5991560540" width="35%" height="400"/>
<img src="https://github.com/user-attachments/assets/d40415ca-a9cd-4476-b157-1a3056002922" width="19%" height="400"/>

<br><br>

****2. Navigation Push 방식**** 
#### `문제 발생`
   - 내주변 탭에서 Navigation Push 진행 시 내주변 뷰에서 Navigation Push가 되어 탭바가 표시된 채로 게시물 상세뷰가 표시되어지는 문제 발생
   - NavigationStack을 내주변 탭의 MapListView가 가지고 있어 MapListView에서 Navigation Push가 진행되었음을 확인

#### `해결 방법`
   - NavigationStack에서 최상위뷰를 MainTabView가 담당하도록 수정
   - 게시물 상세뷰로 이동시 MainTabFeature에서 이벤트를 인지하여 MainTabView가 Navigation Push를 진행하도록 구현

<details><summary> 구현한 코드
</summary>

<br>
  
****- MainTabFeature**** 
 ```swift
@Reducer
struct MainTabFeature {

     @ObservableState
     struct State {
                ...
        var home = HomeFeature.State()
        var mapList = MapListFeature.State()
                ...
        var path = StackState<Path.State>()
     }

     enum Action: BindableAction {
        case binding(BindingAction<State>)
        case home(HomeFeature.Action)
        case mapList(MapListFeature.Action)
                ...
     }
        
     Reduce { state, action in
               ...
        case .home(.postDetail(let postID)):
                state.path.append(.postDetail(PostDetailFeature.State(postID: postID)))
                return .none
        case .mapList(.postDetail(let postID)):
                state.path.append(.postDetail(PostDetailFeature.State(postID: postID)))
                return .none
          ...
    }
    .forEach(\.path, action: \.path)
}
```

<br>

****- MainTabView**** 

```swift
struct MainTabView: View {
    @Bindable var store: StoreOf<MainTabFeature>
    
    var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            TabView(selection: $store.selectedTab) {
                HomeView(store: store.scope(state: \.home, action: \.home))
                    .tag(TabInfo.home)
                MapListView(store: store.scope(state: \.mapList, action: \.mapList))
                    .tag(TabInfo.map)

                ...

            }
                ...
        } destination: { store in
            switch store.case {
            case .postDetail(let store):
                PostDetailView(store: store)
            }
        }
    }
}
```
</details>
<br>
  
## 🏞️ 회고

### TCA를 사용하며 겪은 장단점
- 애플에서 지향하는 단방향 데이터 흐름을 TCA를 선택하여 구현함으로써 상태 흐름에 대한 관리 및 파악이 쉬웠으며, 일관된 구조로의 코드 작성이 가능했기에 코드의 가독성 및 유지보수성에서 효율성이 증가함을 느낄 수 있었습니다.
- 라이브러리에 대한 의존도가 높다는 점, 라이브러리 내부 캡슐화로 인해 에러의 정확한 사유를 알 수 없는 점, 앱의 최소 버전과 라이브러리의 버전에 따라 변경사항이 많아 최신 버전에 대해 참고할 수 있는 자료가 부족하다는 단점을 인지 할 수 있었습니다.
- 이러한 단점들이 있지만, 단방향 데이터 흐름으로 구현할 수 있는 동시에 일관성있는 구조로 앱 개발을 진행할 수 있기에, 협업에서도 강점이 될 수 있어 SwiftUI로 개발을 진행할 때 아키텍처를 선택할 때 좋은 옵션이 될 수 있을 것이라고 느꼈습니다.

### SwiftUI의 프레임워크를 활용한 개발에 대한 고찰
- SwiftUI의 MapKit로 개발을 진행하면서 예상치못했던 요소에 대해 개발속도가 늦어지는 상황이 발생하였습니다.
- SwiftUI의 대부분의 컴포넌트들은 UIKit을 래핑하여 제공하기 때문에 추후 개선될 가능성이 있지만, 현재 프로젝트의 경우 클러스터링 기능 부재와 uivisualeffectbackdropview로 인해 발생되는 탭바 UI 문제 등을 확인할 수 있었고 현재로서는 SwiftUI만으로는 앱의 UI/UX와 목적에 대해 완벽한 개발을 진행하기에는 어려움이 존재한다는 것을 느낄 수 있었습니다.
- UIKit과 SwiftUI를 잘 혼용하는 개발 능력의 향상을 위해 UIKit의 View와 ViewController를 래핑하는 방식에 대해 좀 더 학습을 진행해보려 합니다.
