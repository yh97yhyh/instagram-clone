# Instagram Clone

## 📱 View

### LazyVGrid

```swift
private let gridItems: [GridItem] = [
    .init(.flexible(), spacing: 1),
    .init(.flexible(), spacing: 1),
    .init(.flexible(), spacing: 1),
]
    
private let imageDimension: CGFloat = (UIScreen.main.bounds.width / 3) - 1

LazyVGrid(columns: gridItems, spacing: 1) {
    ForEach(viewModel.posts) { post in
        KFImage(URL(string: post.imageUrl))
            .resizable()
            .scaledToFill()
            .frame(width: imageDimension, height: imageDimension)
            .clipped()
    }
}
```

UIKit의 CollectionView에 해당

### PhotosUI

```swift
import PhotosUI

// View
PhotosPicker(selection: $viewModel.selectedImage) {
    VStack {
        if let image = viewModel.profileImage {
            image
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundColor(.white)
                .background(.gray)
                .clipShape(Circle())
        } else {
            CircularProfileImageView(user: viewModel.user, size: .large)
        }
        
        Text("Edit profile picture")
            .font(.footnote)
            .fontWeight(.semibold)
        
        Divider()
    }
}
.padding(.vertical, 8)

// ViewModel
@Published var selectedImage: PhotosPickerItem? {
    didSet { Task { await loadImage(fromItem: selectedImage) } }
}
@Published var profileImage: Image?

func loadImage(fromItem item: PhotosPickerItem?) async {
    guard let item = item else { return }
    
    guard let data = try? await item.loadTransferable(type: Data.self) else { return }
    guard let uiImage = UIImage(data: data) else { return }
    self.uiImage = uiImage
    self.profileImage = Image(uiImage: uiImage)
}
```

### .searchable

```swift
NavigationStack {
    ScrollView {
        LazyVStack(spacing: 12) {
            ForEach(viewModel.users) { user in
                NavigationLink(value: user) {
                // ...
                }
            }
        }
        .padding(.top, 8)
        .searchable(text: $searchText, prompt: "Search...") // 검색창 구현
    }
    .navigationDestination(for: User.self, destination: {user in
        ProfileView(user: user)
    })
    .navigationTitle("Explore")
    .navigationBarTitleDisplayMode(.inline)
}
```

NavigationStack 안에서 검색창 구현 가능

## 📖 Knowledge

### Combine

![Untitled](https://github.com/yh97yhyh/instagram-clone/assets/47898473/a5a29947-bdf2-44e7-b93c-82f7727dbb17)

Publihser와 Subscriber를 통해 비동기 프로그래밍을 간편하게 처리하기 위한 프레임워크

- 클로저 안에 클로저같은 보기 안좋은 코드 제거 가능
- Publisher
- Operator
- Subscriber

```swift
import Combine

class ContentViewModel: ObservableObject {
    private let service = AuthService.shared
    private var cancellables = Set<AnyCancellable>()
    
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    init() {
        setupSubscribers()
    }
    
    func setupSubscribers() {
        service.$userSession.sink { [weak self] userSession in
            self?.userSession = userSession
        }
        .store(in: &cancellables)
        
        service.$currentUser.sink { [weak self] currentUser in
            self?.currentUser = currentUser
        }
        .store(in: &cancellables)
    }
}
```

- Cancellable
    - Combine에서 Publisher를 구독하면 해당 구독을 관리하기 위해 cancellable 객체가 반환된다.
    - 위 코드에서는 `.store()` 함수를 사용하여 cancellables에 cancellable을 추가

### @MainActor

```swift
class SearchViewModel: ObservableObject {
    @Published var users: [User] = []
    
    init() {
        Task { try await fetchAllUsers() }
    }
    
    @MainActor
    func fetchAllUsers() async throws {
        self.users = try await UserService.fetchAllUsers()
    }
}
```

iOS에서 UI 업데이트에 관한 건 모두 메인 스레드에서 업데이트해야 한다. 

- `@MainActor` 가 정의되어 있는 영역 내의 코드는 필요할 때 메인스레드에서의 동작을 보장한다. 디스패치큐를 언제 사용할지 고민하지 않아도 된다.
- 함수, 클래스, 프로퍼티 등에서 사용 가능

### EnvironmentObject

```swift
class RegisterationViewModel: ObservableObject {
...
}
```

```swift
@StateObject var registerationViewModel = RegisterationViewModel()

LoginView()
    .environmentObject(registerationViewModel) // 모든 child view에 적용됨
```

최상위 App, Scene, View에서 `environmentObject` 를 주입하면 하위뷰 전체에 의존성이 전파된다.

### FirebaseAuthentication

```swift
struct ContentView: View {
    @StateObject var viewModel = ContentViewModel()
    @StateObject var registerationViewModel = RegisterationViewModel()
    
    var body: some View {
        Group {
            if viewModel.userSession == nil {
                LoginView()
                    .environmentObject(registerationViewModel) // 모든 child view에 적용됨
            } else if let currentUser = viewModel.currentUser {
                MainTabView(user: currentUser)
            }
        }
    }
}

#Preview {
    ContentView()
}
```

```swift
import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthService {
    static let shared = AuthService()

    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
        
    init() {
        Task { try await loadUserData() }
    }
    
    @MainActor
    func login(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            try await loadUserData()
        } catch {
            print("DEBUG: Failed to log in user with error \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func createuser(email: String, password: String, username: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            print("DEBUG: Did create user..")
            await uploadUserData(uid: result.user.uid, username: username, email: email)
        } catch {
            print("DEBUG: Failed to register user with error \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func loadUserData() async throws {
        self.userSession = Auth.auth().currentUser
        guard let currentUid = self.userSession?.uid else { return }
        self.currentUser = try await UserService.fetchUser(withUid: currentUid)
    }
     
    func signout() {
        try? Auth.auth().signOut()
        self.userSession = nil
        self.currentUser = nil
    }
    
    private func uploadUserData(uid: String, username: String, email: String) async {
        let user = User(id: uid, username: username, email: email)
        self.currentUser = user
        guard let encodedUser = try? Firestore.Encoder().encode(user) else { return } // encoding
        try? await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
    }
}
```

`Firebase.User` 을 통해 로그인, 로그아웃을 관리할 수 있다.

### FirebaseFirestore

```swift
// Encoding
private func uploadUserData(uid: String, username: String, email: String) async {
    let user = User(id: uid, username: username, email: email)
    self.currentUser = user
    guard let encodedUser = try? Firestore.Encoder().encode(user) else { return } // encoding
    try? await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
}
```

```swift
// Decoding
static func fetchUser(withUid uid: String) async throws -> User {
    let snapshot = try await Firestore.firestore().collection("users").document(uid).getDocument()
    return try snapshot.data(as: User.self) // decoding
}
```

### FirebaseStorage

```swift
import Foundation
import FirebaseStorage

class ImageUploader {
    static func uploadImage(image: UIImage) async throws -> String? {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return nil }
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/profile_images/\(filename)")
        
        do {
            let _ = try await ref.putDataAsync(imageData)
            let url = try await ref.downloadURL()
            return url.absoluteString
        } catch {
            print("DEBUG : Failed to upload image with error \(error.localizedDescription)")
            return nil
        }
    }
}
```

### KingFisher

```swift
import Kingfisher

if let imageUrl = user.profileImageUrl {
    KFImage(URL(string: imageUrl))
        .resizable()
        .scaledToFill()
        .frame(width: size.dimension, height: size.dimension)
        .clipShape(Circle())
} else {
    Image(systemName: "person.circle.fill")
        .resizable()
        .frame(width: size.dimension, height: size.dimension)
        .clipShape(Circle())
        .foregroundColor(Color(.systemGray4))
}
```

- 서버와 통신하여 이미지를 가지고 오고 싶을 때 사용한다.
- 이미지를 다운로드하여 캐시하기 때문에 비동기 호출에 걱정할 필요가 없다.
- 한 번 캐시된 이미지는 다음에 호출할 때 빠르게 보여진다.

### Class, Struct

Class는 참조 타입이고 ARC로 메로리를 관리한다. Struct는 값 타입이다.

- **Class**
    - 참조 타입
    - 상속 가능
    - 같은 클래스 인스턴스를 여러 변수에 할당하고 값을 변경하면 모든 변수에 영향을 준다. (메모리 복사)
    - deinit으로 인스턴스 메모리 할당을 해제할 수 있다.
- **Struct**
    - 값 타입
    - 상속 불가
    - 같은 구조체를 여러 변수에 할당하고 값을 변경해도 다른 변수에 영향을 주지 않는다. (값만 복사)

```swift
var obj1 = MyClass(property: 10)
var obj2 = obj1 // obj1과 obj2는 동일한 인스턴스를 참조

var st1 = MyStruct(property: 20)
var st2 = st1 // st1과 st2는 각자 복사된 독립적인 값
```

### [weak self]

![Untitled (1)](https://github.com/yh97yhyh/instagram-clone/assets/47898473/5ba7347a-877d-418b-9398-6d92b3509af4)

클로저에서 self를 캡쳐할 때 **강한 순환 참조(서로를 참조하는 두 객체 간 발생할 수 있는 메모리 누수)를 방지**하기 위해 사용한다.

클로저에서 약한 참조로 특정 인스턴스(ex. self)를 캡쳐하지 않으면 인스턴스가 해제될 때 까지 기다리고 인스턴스는 클로저가 해제될 때까지 기다리는 강한 순환 참조를 만들어낸다.
