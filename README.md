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
