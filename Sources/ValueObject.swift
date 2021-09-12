import Foundation

// バリューオブジェクト
struct UserName {
    let value: String
    
    // 失敗イニシャライザ
    init?(string: String) {
        // 0文字以上でなければ、インスタンス化できないようにする
        guard string.count > 0 else {
            return nil
        }
        
        self.value = string
    }
}

// エンティティ
struct LoginInfo {
    let id = UUID()
    let name: UserName
    
    init(name: UserName) {
        self.name = name
    }
}

protocol LoginRepositoryDelegate {
    func login(loginInfo: LoginInfo) -> Bool
}

// リポジトリ層
class LoginRepository: LoginRepositoryDelegate {
    static let shared = LoginRepository()
    
    func login(loginInfo: LoginInfo) -> Bool {
        // API通信処理
        print(loginInfo)
        
        return true
    }
}

// プレゼンテーション層
class LoginViewModel {
    private var loginRepository: LoginRepositoryDelegate
    
    @Published var userName = ""
    
    init(loginRepository: LoginRepository) {
        self.loginRepository = LoginRepository.shared
    }
    
    func login() -> Bool {
        // UserNameの初期化に失敗した場合は、ログインAPIは呼ばない
        if let userName = UserName(string: userName) {
            let loginInfo = LoginInfo(name: userName)
            return loginRepository.login(loginInfo: loginInfo)
        }
        return false
    }
}
